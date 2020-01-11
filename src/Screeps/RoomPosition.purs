-- | Corresponds to the Screeps API [RoomPosition](http://support.screeps.com/hc/en-us/articles/203079201-RoomPosition)
module Screeps.RoomPosition where

import Effect
import Data.Either (Either)
import Data.Maybe (Maybe(Nothing))
import Effect.Exception (Error, try)
import Effect.Unsafe (unsafePerformEffect)
import Prelude ((<$>), (<<<))
import Screeps.Color (Color)
import Screeps.Direction (Direction)
import Screeps.FFI (runThisEffectFn0, runThisEffectFn1, runThisEffectFn2, runThisEffectFn3, runThisFn1, runThisFn2, runThisFn3, selectMaybes, toMaybe)
import Screeps.FindType (FindType, LookType)
import Screeps.ReturnCode (ReturnCode)
import Screeps.Path (Path, PathOptions)
import Screeps.RoomPosition.Type (RoomPosition)
import Screeps.Structure (StructureType)
import Screeps.Types (FilterFn, TargetPosition(..))
import Unsafe.Coerce (unsafeCoerce)

data FindContext a
  = OfType (FindType a)
  | OfObj (Array a)
  | OfPos (Array RoomPosition)

-- should be RoomObject a 
-- Type safety lost by dropping effect rows in PureScript 0.12. For use only
-- with exception effects.
tryPure :: forall a. Effect a -> Either Error a
tryPure = unsafePerformEffect <<< try

type ClosestPathOptions
  = PathOptions
      ( filter :: Maybe (forall a. a -> Boolean)
      , algorithm :: Maybe FindAlgorithm
      )

newtype FindAlgorithm
  = FindAlgorithm String

algorithmAstar :: FindAlgorithm
algorithmAstar = FindAlgorithm "astar"

algorithmDijkstra :: FindAlgorithm
algorithmDijkstra = FindAlgorithm "dijkstra"

closestPathOpts :: ClosestPathOptions
closestPathOpts =
  { ignoreCreeps: Nothing
  , ignoreDestructibleStructures: Nothing
  , ignoreRoads: Nothing
  , ignore: Nothing
  , avoid: Nothing
  , maxOps: Nothing
  , heuristicWeight: Nothing
  , serialize: Nothing
  , maxRooms: Nothing
  , filter: Nothing
  , algorithm: Nothing
  }

unwrapContext :: forall a b. FindContext a -> b
unwrapContext (OfType findType) = unsafeCoerce findType

unwrapContext (OfObj objects) = unsafeCoerce objects

unwrapContext (OfPos positions) = unsafeCoerce positions

createConstructionSite ::
  RoomPosition ->
  StructureType ->
  Effect ReturnCode
createConstructionSite = runThisEffectFn1 "createConstructionSite"

createFlag ::
  RoomPosition ->
  Effect ReturnCode
createFlag = runThisEffectFn0 "createFlag"

createFlagWithName ::
  RoomPosition ->
  String ->
  Effect ReturnCode
createFlagWithName pos name = runThisEffectFn1 "createFlag" pos name

createFlagWithColor ::
  RoomPosition ->
  String ->
  Color ->
  Effect ReturnCode
createFlagWithColor pos name color = runThisEffectFn2 "createFlag" pos name color

createFlagWithColors ::
  RoomPosition ->
  String ->
  Color ->
  Color ->
  Effect ReturnCode
createFlagWithColors pos name color secondaryColor = runThisEffectFn3 "createFlag" pos name color secondaryColor

findClosestByPath :: forall a. RoomPosition -> FindContext a -> Either Error (Maybe a)
findClosestByPath pos ctx = tryPure (toMaybe <$> runThisEffectFn1 "findClosestByPath" pos (unwrapContext ctx))

findClosestByPath' :: forall a. RoomPosition -> FindContext a -> ClosestPathOptions -> Either Error (Maybe a)
findClosestByPath' pos ctx opts = tryPure (toMaybe <$> runThisEffectFn2 "findClosestByPath" pos ctx' options)
  where
  ctx' = unwrapContext ctx

  options = selectMaybes opts

findClosestByRange :: forall a. RoomPosition -> FindContext a -> Either Error (Maybe a)
findClosestByRange pos ctx = tryPure (toMaybe <$> runThisEffectFn1 "findClosestByRange" pos (unwrapContext ctx))

findClosestByRange' :: forall a. RoomPosition -> FindContext a -> FilterFn a -> Either Error (Maybe a)
findClosestByRange' pos ctx filter = tryPure (toMaybe <$> runThisEffectFn2 "findClosestByRange" pos (unwrapContext ctx) { filter })

findInRange :: forall a. RoomPosition -> FindContext a -> Int -> Either Error (Array a)
findInRange pos ctx range = tryPure (runThisEffectFn2 "findInRange" pos (unwrapContext ctx) range)

findInRange' :: forall a. RoomPosition -> FindContext a -> Int -> FilterFn a -> Either Error (Array a)
findInRange' pos ctx range filter = tryPure (runThisEffectFn3 "findInRange" pos (unwrapContext ctx) range { filter })

findPathTo :: forall a. RoomPosition -> TargetPosition a -> Either Error Path
findPathTo pos (TargetPt x' y') = tryPure (runThisEffectFn2 "findPathTo" pos x' y')

findPathTo pos (TargetPos destPos) = tryPure (runThisEffectFn1 "findPathTo" pos destPos)

findPathTo pos (TargetObj obj) = tryPure (runThisEffectFn1 "findPathTo" pos obj)

findPathTo' :: forall a. RoomPosition -> TargetPosition a -> PathOptions () -> Either Error Path
findPathTo' pos (TargetPt x' y') opts = tryPure (runThisEffectFn3 "findPathTo" pos x' y' (selectMaybes opts))

findPathTo' pos (TargetPos destPos) opts = tryPure (runThisEffectFn2 "findPathTo" pos destPos (selectMaybes opts))

findPathTo' pos (TargetObj obj) opts = tryPure (runThisEffectFn2 "findPathTo" pos obj (selectMaybes opts))

getDirectionTo :: forall a. RoomPosition -> TargetPosition a -> Direction
getDirectionTo pos (TargetPt x' y') = runThisFn2 "getDirectionTo" pos x' y'

getDirectionTo pos (TargetPos otherPos) = runThisFn1 "getDirectionTo" pos otherPos

getDirectionTo pos (TargetObj obj) = runThisFn1 "getDirectionTo" pos obj

-- | May return Infinity
getRangeTo :: forall a. RoomPosition -> TargetPosition a -> Int
getRangeTo pos (TargetPt x' y') = runThisFn2 "getRangeTo" pos x' y'

getRangeTo pos (TargetPos destPos) = runThisFn1 "getRangeTo" pos destPos

getRangeTo pos (TargetObj obj) = runThisFn1 "getRangeTo" pos obj

inRangeTo :: forall a. RoomPosition -> TargetPosition a -> Int -> Boolean
inRangeTo pos (TargetPt x' y') range = runThisFn3 "inRangeTo" pos x' y' range

inRangeTo pos (TargetPos destPos) range = runThisFn2 "inRangeTo" pos destPos range

inRangeTo pos (TargetObj obj) range = runThisFn2 "inRangeTo" pos obj range

isEqualTo :: forall a. RoomPosition -> TargetPosition a -> Boolean
isEqualTo pos (TargetPt x' y') = runThisFn2 "isEqualTo" pos x' y'

isEqualTo pos (TargetPos otherPos) = runThisFn1 "isEqualTo" pos otherPos

isEqualTo pos (TargetObj obj) = runThisFn1 "isEqualTo" pos obj

isNearTo :: forall a. RoomPosition -> TargetPosition a -> Boolean
isNearTo pos (TargetPt x' y') = runThisFn2 "isNearTo" pos x' y'

isNearTo pos (TargetPos otherPos) = runThisFn1 "isNearTo" pos otherPos

isNearTo pos (TargetObj obj) = runThisFn1 "isNearTo" pos obj

-- look function omitted - use lookFor
lookFor :: forall a. RoomPosition -> LookType a -> Either Error (Array a)
lookFor pos lookType = tryPure (runThisEffectFn1 "lookFor" pos lookType)
