-- | Corresponds to the Screeps API [Resource](http://support.screeps.com/hc/en-us/articles/203016362-Resource)
module Screeps.Resource where

import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Eq              (class Eq,         (==))
import Data.Generic.Rep     (class Generic)
import Data.Monoid          ((<>))
import Data.Show            (class Show,       show)
--import Data.StrMap

import Screeps.FFI (unsafeField, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.RoomObject (class RoomObject, pos)

-- Type Resource types
newtype ResourceType = ResourceType String
derive instance genericResourceType    :: Generic ResourceType _
derive newtype instance eqResourceType :: Eq      ResourceType
instance        showResourceType       :: Show    ResourceType where show (ResourceType s) = s

foreign import resource_energy :: ResourceType
foreign import resource_power  :: ResourceType

-- Type Dropped resources
foreign import data Resource :: Type
instance objectResource      :: RoomObject Resource
instance resourceHasId       :: HasId      Resource
  where
    validate = instanceOf "Resource"
instance eqResource          :: Eq         Resource where eq = eqById
instance encodeResource      :: EncodeJson Resource where encodeJson = encodeJsonWithId
instance decodeResource      :: DecodeJson Resource where decodeJson = decodeJsonWithId
instance showResource        :: Show       Resource where
  show re = show (amount re) <> " " <> show (resourceType re) <> "@" <> show (pos re)

amount :: Resource -> Int
amount = unsafeField "amount"

resourceType :: Resource -> ResourceType
resourceType = unsafeField "resourceType"
