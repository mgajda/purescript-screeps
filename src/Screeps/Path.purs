-- | This module implements PathFinder API.
-- |
-- | WARNING: While PathFinder accepts any number of target objects,
-- |          excessive GC may occur if there are too many.
-- |          API author advises to sort targets by uniform distance [Screeps.Coord],
-- |          and use only first 10 or so.
module Screeps.Path where

import Effect
import Effect.Unsafe
import Effect.Exception
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Encode.Class
import Data.Argonaut.Decode.Class
import Data.Generic.Rep.Show
import Data.Generic.Rep
import Data.Either
import Data.Function (($))
import Data.Show
import Data.Unit

import Screeps.FFI
import Screeps.RoomPosition.Type
import Screeps.Names (RoomName)

-- Type Tile cost
type TileCost = Int

defaultTerrainCost :: TileCost
defaultTerrainCost  = 0

-- | Indicates an unwalkable tile.
unwalkable :: TileCost
unwalkable  = 255

newtype PathFinderResult = PathFinderResult {
    path       :: Array RoomPosition
  , opts       :: Int
  , cost       :: Int
  , incomplete :: Boolean
  }

newtype PathFinderTarget = PathFinderTarget {
    pos   :: RoomPosition
  , range :: Int
  }

target     :: RoomPosition
           -> PathFinderTarget
target aPos = PathFinderTarget {
                pos  : aPos
              , range: 0
              }

inRange           :: Int
                  -> RoomPosition
                  -> PathFinderTarget
inRange range aPos = PathFinderTarget {
                       pos  : aPos
                     , range: range
                     }

foreign import usePathFinder :: forall              e.
                                Effect Unit

foreign import data CostMatrix :: Type

foreign import search :: forall              e.
                               RoomPosition
                      -> Array PathFinderTarget
                      ->     (PathFinderOpts e)
                      -> Effect PathFinderResult

foreign import newCostMatrix :: forall              e.
                                Effect CostMatrix

foreign import infinity :: Number

defaultPathFinderOpts :: forall a. PathFinderOpts a
defaultPathFinderOpts  = PathFinderOpts {
      roomCallback:    allDefaultCosts
    , plainCost:       1
    , swampCost:       5
    , flee:            false
    , maxOps:          2000
    , maxRooms:        16
    , maxCost:         infinity
    , heuristicWeight: 1.2
    }

type RoomCallback = RoomName -- ^ Room name
                 -> Effect CostMatrix

-- | Empty callback - just use default terrain cost.
allDefaultCosts          :: RoomCallback
allDefaultCosts _roomName = newCostMatrix

newtype PathFinderOpts e = PathFinderOpts {
    roomCallback    :: RoomCallback
  , plainCost       :: TileCost
  , swampCost       :: TileCost
  , flee            :: Boolean
  , maxOps          :: Int
  , maxRooms        :: Int
  , maxCost         :: Number
  , heuristicWeight :: Number
  }

-- Type Cost matrix
-- | Set a given coordinate to any cost.
set :: forall              e.
       CostMatrix
    -> Int
    -> Int
    -> TileCost
    -> Effect Unit
set  = runThisEffFn3 "set"

-- | Get current cost of any coordinate.
-- | Zero indicates default terrain cost.
get :: forall              e.
       CostMatrix
    -> Int
    -> Int
    -> Effect TileCost
get  = runThisEffFn2 "get"

-- | Clone cost matrix.
clone :: forall              e.
                                CostMatrix
      -> Effect CostMatrix
clone  = runThisEffFn0 "clone"

-- | Serialized cost matrix, suitable for `JSON.stringify`.
newtype SerializedCostMatrix = SerializedCostMatrix Json

derive instance genericSerializedCostMatrix :: Generic SerializedCostMatrix _

instance showSerializedCostMatrix :: Show SerializedCostMatrix where
  show (SerializedCostMatrix json) = stringify json

-- | Serialize cost matrix for storage in `Memory`.
serialize :: CostMatrix
          -> SerializedCostMatrix
serialize  = runThisFn0 "serialize"

foreign import deserialize :: SerializedCostMatrix
                           -> Effect           CostMatrix

instance encodeCostMatrix :: EncodeJson CostMatrix where
  encodeJson cm = case serialize cm of
                       SerializedCostMatrix scm -> scm

instance decodeCostMatrix :: DecodeJson CostMatrix where
  decodeJson json = do
    case unsafePerformEffect $ try $ deserialize $ SerializedCostMatrix json of
         Left  err -> Left  $ show err
         Right r   -> Right   r

