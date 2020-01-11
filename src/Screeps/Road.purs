-- | Corresponds to the Screeps API [StructureRoad](http://support.screeps.com/hc/en-us/articles/207713089-StructureRoad)
module Screeps.Road where

import Screeps.Structure
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.FFI (instanceOf)
import Screeps.Decays (class Decays)
import Screeps.Destructible (class Destructible)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, eqById)
import Screeps.RoomObject (class RoomObject)

foreign import data Road :: Type

instance objectRoad :: RoomObject Road

instance structuralRoad :: Structural Road

instance roadHasId :: HasId Road where
  validate = instanceOf "StructureRoad"

instance eqRoad :: Eq Road where
  eq = eqById

instance roadDecays :: Decays Road

instance structureRoad :: Structure Road where
  _structureType _ = structure_road

instance showRoad :: Show Road where
  show = showStructure

instance decodeRoad :: DecodeJson Road where
  decodeJson = decodeJsonWithId

instance encodeRoad :: EncodeJson Road where
  encodeJson = encodeJsonWithId

instance destructibleRoad :: Destructible Road

toRoad :: AnyStructure -> Maybe Road
toRoad = fromAnyStructure
