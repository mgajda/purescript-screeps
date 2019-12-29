-- | Defines the main types used in the library and the relationships between them.
module Screeps.Types where

import Prelude
import Data.Generic.Rep (class Generic, Argument(..), Constructor(..))
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Screeps.RoomPosition.Type (RoomPosition)

foreign import data WorldMap :: Type

class Owned a -- my, owned

newtype TerrainMask
  = TerrainMask Int

instance genericTerrainMask :: Generic TerrainMask (Constructor "TerrainMask" (Argument Int)) where
  from (TerrainMask x) = Constructor $ Argument x
  to (Constructor (Argument x)) = TerrainMask x

instance eqTerrainMask :: Eq TerrainMask where
  eq = genericEq

instance showTerrainMask :: Show TerrainMask where
  show = genericShow

newtype Terrain
  = Terrain String

instance genericTerrain :: Generic Terrain (Constructor "Terrain" (Argument String)) where
  from (Terrain x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Terrain x

instance eqTerrain :: Eq Terrain where
  eq = genericEq

instance showTerrain :: Show Terrain where
  show (Terrain s) = s

newtype Mode
  = Mode String

instance genericMode :: Generic Mode (Constructor "Mode" (Argument String)) where
  from (Mode x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Mode x

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
