-- | This module implements PathFinder API.
-- |
-- | WARNING: While PathFinder accepts any number of target objects,
-- |          excessive GC may occur if there are too many.
-- |          API author advises to sort targets by uniform distance [Screeps.Coord],
-- |          and use only first 10 or so.
module Screeps.Path where

import Effect

import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Either (Either(..))
import Data.Function (($))
import Data.Maybe (Maybe(..))
import Data.Show (class Show, show)
import Data.Unit (Unit)
import Effect.Exception (try)
import Effect.Unsafe (unsafePerformEffect)
import Screeps.Direction (Direction)
import Screeps.FFI (runThisEffectFn0, runThisEffectFn2, runThisEffectFn3, runThisFn0)
import Screeps.Names (RoomName)
import Screeps.RoomPosition.Type (RoomPosition)

-- | Derived markers
type Path
  = Array PathStep

type PathStep
  = { x :: Int
    , y :: Int
    , dx :: Number
    , dy :: Number
    , direction :: Direction
    }

-- Type Tile cost
type TileCost
  = Int

defaultTerrainCost :: TileCost
defaultTerrainCost = 0

-- | Indicates an unwalkable tile.
unwalkable :: TileCost
unwalkable = 255

newtype PathFinderResult
  = PathFinderResult
  { path :: Array RoomPosition
  , opts :: Int
  , cost :: Int
  , incomplete :: Boolean
  }

newtype PathFinderTarget
  = PathFinderTarget
  { pos :: RoomPosition
  , range :: Int
  }

target ::
  RoomPosition ->
  PathFinderTarget
target aPos =
  PathFinderTarget
    { pos: aPos
    , range: 0
    }

inRange ::
  Int ->
  RoomPosition ->
  PathFinderTarget
inRange range aPos =
  PathFinderTarget
    { pos: aPos
    , range: range
    }

foreign import usePathFinder :: Effect Unit

foreign import data CostMatrix :: Type

foreign import search ::
  RoomPosition ->
  Array PathFinderTarget ->
  PathFinderOpts ->
  Effect PathFinderResult

foreign import newCostMatrix :: Effect CostMatrix

foreign import infinity :: Number

defaultPathFinderOpts :: PathFinderOpts
defaultPathFinderOpts =
  PathFinderOpts
    { roomCallback: allDefaultCosts
    , plainCost: 1
    , swampCost: 5
    , flee: false
    , maxOps: 2000
    , maxRooms: 16
    , maxCost: infinity
    , heuristicWeight: 1.2
    }

type RoomCallback
  = RoomName ->
    Effect CostMatrix

-- | Empty callback - just use default terrain cost.
allDefaultCosts :: RoomCallback
allDefaultCosts _roomName = newCostMatrix

newtype PathFinderOpts
  = PathFinderOpts
  { roomCallback :: RoomCallback
  , plainCost :: TileCost
  , swampCost :: TileCost
  , flee :: Boolean
  , maxOps :: Int
  , maxRooms :: Int
  , maxCost :: Number
  , heuristicWeight :: Number
  }

-- Type Cost matrix
-- | Set a given coordinate to any cost.
set ::
  CostMatrix ->
  Int ->
  Int ->
  TileCost ->
  Effect Unit
set = runThisEffectFn3 "set"

-- | Get current cost of any coordinate.
-- | Zero indicates default terrain cost.
get ::
  CostMatrix ->
  Int ->
  Int ->
  Effect TileCost
get = runThisEffectFn2 "get"

-- | Clone cost matrix.
clone ::
  CostMatrix ->
  Effect CostMatrix
clone = runThisEffectFn0 "clone"

-- | Serialized cost matrix, suitable for `JSON.stringify`.
newtype SerializedCostMatrix
  = SerializedCostMatrix Json

instance showSerializedCostMatrix :: Show SerializedCostMatrix where
  show (SerializedCostMatrix x) = stringify x

-- | Serialize cost matrix for storage in `Memory`.
serialize ::
  CostMatrix ->
  SerializedCostMatrix
serialize = runThisFn0 "serialize"

foreign import deserialize ::
  SerializedCostMatrix ->
  Effect CostMatrix

instance encodeCostMatrix :: EncodeJson CostMatrix where
  encodeJson cm = case serialize cm of
    SerializedCostMatrix scm -> scm

instance decodeCostMatrix :: DecodeJson CostMatrix where
  decodeJson json = do
    case unsafePerformEffect $ try $ deserialize $ SerializedCostMatrix json of
      Left err -> Left $ show err
      Right r -> Right r

-- TODO: costCallback option
type PathOptions o
  = { ignoreCreeps :: Maybe Boolean
    , ignoreDestructibleStructures :: Maybe Boolean
    , ignoreRoads :: Maybe Boolean
    , ignore :: Maybe (Array RoomPosition)
    , avoid :: Maybe (Array RoomPosition)
    , maxOps :: Maybe Int
    , heuristicWeight :: Maybe Number
    , serialize :: Maybe Boolean
    , maxRooms :: Maybe Int
    | o
    }

pathOpts :: PathOptions ()
pathOpts =
  { ignoreCreeps: Nothing
  , ignoreDestructibleStructures: Nothing
  , ignoreRoads: Nothing
  , ignore: Nothing
  , avoid: Nothing
  , maxOps: Nothing
  , heuristicWeight: Nothing
  , serialize: Nothing
  , maxRooms: Nothing
  }
