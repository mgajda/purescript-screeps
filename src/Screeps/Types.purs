-- | Defines the main types used in the library and the relationships between them.
module Screeps.Types where

import Screeps.RoomObject

import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Generic.Rep (class Generic, Argument(..), Constructor(..))
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Prelude (class Eq, class Show, show, ($), (<>))
import Screeps.Destructible (class Destructible)
import Screeps.FFI (instanceOf, unsafeField)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.RoomPosition.Type (RoomPosition)

foreign import data WorldMap :: Type

class Owned          a -- my, owned

foreign import data Creep  :: Type
instance creepIsRoomObject :: RoomObject   Creep
instance creepIsOwned      :: Owned        Creep
instance creepEq           :: Eq           Creep where eq = eqById
instance showCreepEq       :: Show         Creep where show c = unsafeField "name" c <> "@" <> show (pos c)
instance creepHasId        :: HasId        Creep where
  validate = instanceOf "Creep"
instance encodeCreep       :: EncodeJson   Creep where encodeJson = encodeJsonWithId
instance decodeCreep       :: DecodeJson   Creep where decodeJson = decodeJsonWithId
instance destructibleCreep :: Destructible Creep

newtype TerrainMask = TerrainMask Int
instance genericTerrainMask :: Generic TerrainMask (Constructor "TerrainMask" (Argument Int)) where
  from (TerrainMask x) = Constructor $ Argument x
  to (Constructor (Argument x)) = TerrainMask x
instance eqTerrainMask :: Eq TerrainMask where eq = genericEq
instance showTerrainMask :: Show TerrainMask where show = genericShow

newtype Terrain = Terrain String
instance genericTerrain :: Generic Terrain (Constructor "Terrain" (Argument String)) where
  from (Terrain x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Terrain x
instance eqTerrain :: Eq Terrain where eq = genericEq
instance showTerrain :: Show Terrain
  where show (Terrain s) = s

newtype Mode = Mode String
instance genericMode :: Generic Mode (Constructor "Mode" (Argument String)) where
  from (Mode x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Mode x
instance eqMode :: Eq Mode where eq = genericEq
instance showMode :: Show Mode where show = genericShow

--------------------------------
-- Helper types and functions --
--------------------------------

type FilterFn a = a -> Boolean

data TargetPosition a =
  TargetPt  Int Int |
  TargetObj a      | -- RoomObject a
  TargetPos RoomPosition

