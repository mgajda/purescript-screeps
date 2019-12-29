-- | Corresponds to the Screeps API [StructureRampart](http://support.screeps.com/hc/en-us/articles/207712959-StructureRampart)
module Screeps.Rampart where

import Screeps.Structure
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Effect (Effect)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Decays (class Decays)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (unsafeField, instanceOf)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, eqById)
import Screeps.Types (class Owned)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)

foreign import data Rampart :: Type

instance objectRampart :: RoomObject Rampart

instance ownedRampart :: Owned Rampart

instance rampartHasId :: HasId Rampart where
  validate = instanceOf "StructureRampart"

instance encodeRampart :: EncodeJson Rampart where
  encodeJson = encodeJsonWithId

instance decodeRampart :: DecodeJson Rampart where
  decodeJson = decodeJsonWithId

instance structuralRampart :: Structural Rampart

instance decaysRampart :: Decays Rampart

instance structureRampart :: Structure Rampart where
  _structureType _ = structure_rampart

instance eqRampart :: Eq Rampart where
  eq = eqById

instance showRampart :: Show Rampart where
  show = showStructure

instance destructibleRampart :: Destructible Rampart

isPublic :: Rampart -> Boolean
isPublic = unsafeField "isPublic"

setPublic :: Rampart -> Boolean -> Effect ReturnCode
setPublic = unsafeField "setPublic"

toRampart :: AnyStructure -> Maybe Rampart
toRampart = fromAnyStructure
