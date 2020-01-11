-- | Defines the main types used in the library and the relationships between them.
module Screeps.Types where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Screeps.RoomPosition.Type (RoomPosition)

foreign import data WorldMap :: Type

class Owned a -- my, owned

newtype TerrainMask
  = TerrainMask Int

derive instance genericTerrainMask :: Generic TerrainMask _

instance eqTerrainMask :: Eq TerrainMask where
  eq = genericEq

instance showTerrainMask :: Show TerrainMask where
  show = genericShow

newtype Terrain
  = Terrain String

derive instance genericTerrain :: Generic Terrain _

instance eqTerrain :: Eq Terrain where
  eq = genericEq

instance showTerrain :: Show Terrain where
  show (Terrain s) = s

newtype Mode
  = Mode String

derive instance genericMode :: Generic Mode _

instance eqMode :: Eq Mode where
  eq = genericEq

instance showMode :: Show Mode where
  show = genericShow

--------------------------------
-- Helper types and functions --
--------------------------------
type FilterFn a
  = a -> Boolean

data TargetPosition a
  = TargetPt Int Int
  | TargetObj a -- RoomObject a
  | TargetPos RoomPosition
