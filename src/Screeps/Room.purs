-- | Corresponds to the Screeps API [Room](http://support.screeps.com/hc/en-us/articles/203079011-Room)
module Screeps.Room where

import Prelude

import Data.Argonaut.Core (Json, toArray)
import Data.Either (Either(Left, Right))
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Screeps.Color (Color)
import Screeps.Controller (Controller)
import Screeps.FFI (runThisEffectFn1, runThisEffectFn2, runThisEffectFn3, runThisEffectFn4, runThisEffectFn5, runThisFn1, runThisFn2, runThisFn3, runThisFn6, selectMaybes, toMaybe, unsafeField, unsafeOptField)
import Screeps.FindType (FindType, LookType)
import Screeps.Names (RoomName)
import Screeps.Path (Path, PathOptions)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (Room)
import Screeps.RoomPosition.Type (RoomPosition, x, y, mkRoomPosition)
import Screeps.Storage (Storage)
import Screeps.Structure (StructureType)
import Screeps.Terminal (Terminal)
import Screeps.Types (FilterFn, Mode, TargetPosition(..), Terrain)


controller :: Room -> Maybe Controller
controller room = toMaybe $ unsafeField "controller" room

energyAvailable :: Room -> Int
energyAvailable = unsafeField "energyAvailable"

energyCapacityAvailable :: Room -> Int
energyCapacityAvailable = unsafeField "energyCapacityAvailable"

memory :: forall props. Room -> { | props }
memory = unsafeField "memory"

mode :: Room -> Mode
mode = unsafeField "mode"

storage :: Room -> Maybe Storage
storage room = toMaybe $ unsafeField "storage" room

terminal :: Room -> Maybe Terminal
terminal room = toMaybe $ unsafeField "terminal" room

foreign import roomGlobal :: {}

serializePath :: Path -> String
serializePath = runThisFn1 "serializePath" roomGlobal

deserializePath :: String -> Path
deserializePath = runThisFn1 "deserializePath" roomGlobal

createConstructionSite :: forall a. Room -> TargetPosition a -> StructureType -> Effect ReturnCode
createConstructionSite room (TargetPt x' y') strucType = runThisEffectFn3 "createConstructionSite" room x' y' strucType

createConstructionSite room (TargetPos pos) strucType = runThisEffectFn2 "createConstructionSite" room pos strucType

createConstructionSite room (TargetObj obj) strucType = runThisEffectFn2 "createConstructionSite" room obj strucType

createFlag :: forall a. Room -> TargetPosition a -> Effect ReturnCode
createFlag room (TargetPt x' y') = runThisEffectFn2 "createFlag" room x' y'

createFlag room (TargetPos pos) = runThisEffectFn1 "createFlag" room pos

createFlag room (TargetObj obj) = runThisEffectFn1 "createFlag" room obj

createFlagWithName :: forall a. Room -> TargetPosition a -> String -> Effect ReturnCode
createFlagWithName room (TargetPt x' y') name' = runThisEffectFn3 "createFlag" room x' y' name'

createFlagWithName room (TargetPos pos) name' = runThisEffectFn2 "createFlag" room pos name'

createFlagWithName room (TargetObj obj) name' = runThisEffectFn2 "createFlag" room obj name'

createFlagWithColor :: forall a. Room -> TargetPosition a -> String -> Color -> Effect ReturnCode
createFlagWithColor room (TargetPt x' y') name' color = runThisEffectFn4 "createFlag" room x' y' name' color

createFlagWithColor room (TargetPos pos) name' color = runThisEffectFn3 "createFlag" room pos name' color

createFlagWithColor room (TargetObj obj) name' color = runThisEffectFn3 "createFlag" room obj name' color

createFlagWithColors :: forall a. Room -> TargetPosition a -> String -> Color -> Color -> Effect ReturnCode
createFlagWithColors room (TargetPt x' y') name' color color2 = runThisEffectFn5 "createFlag" room x' y' name' color color2

createFlagWithColors room (TargetPos pos) name' color color2 = runThisEffectFn4 "createFlag" room pos name' color color2

createFlagWithColors room (TargetObj obj) name' color color2 = runThisEffectFn4 "createFlag" room obj name' color color2

find :: forall a. Room -> FindType a -> Array a
find = runThisFn1 "find"

find' :: forall a. Room -> FindType a -> FilterFn a -> Array a
find' room findType filter = runThisFn2 "find" room findType { filter }

foreign import findExitToImpl ::
  Room ->
  RoomName ->
  (ReturnCode -> Either ReturnCode (FindType RoomPosition)) ->
  (FindType RoomPosition -> Either ReturnCode (FindType RoomPosition)) ->
  Either ReturnCode (FindType RoomPosition)

findExitTo :: Room -> RoomName -> Either ReturnCode (FindType RoomPosition)
findExitTo room otherRoomName = findExitToImpl room otherRoomName Left Right

findPath :: Room -> RoomPosition -> RoomPosition -> Path
findPath = runThisFn2 "findPath"

findPath' :: forall o. Room -> RoomPosition -> RoomPosition -> PathOptions o -> Path
findPath' room pos1 pos2 opts = runThisFn3 "findPath" room pos1 pos2 (selectMaybes opts)

getPositionAt :: Room -> Int -> Int -> RoomPosition
getPositionAt = runThisFn2 "getPositionAt"

-- lookAt omitted - use lookForAt
-- lookAtArea omitted - use lookForAtArea
data LookResult a
  = LookResult
    { resultType :: LookType a
    , terrain :: Maybe Terrain
    , structureType :: Maybe StructureType
    , x :: Int
    , y :: Int
    }

decodeLookResults ::
  forall a.
  Json ->
  Either String
    (Array (LookResult a))
decodeLookResults =
  maybe (Left "Top object is not an array")
    (Right <<< map decodeIt)
    <<< toArray

decodeIt :: forall a. Json -> LookResult a
decodeIt o = LookResult { resultType, terrain, structureType, x, y }
  where
  resultType = unsafeField "type" o

  terrain = unsafeOptField "terrain" o

  structureType = unsafeOptField "structureType" o

  x = unsafeField "x" o

  y = unsafeField "y" o

lookForAt ::
  forall a.
  Room ->
  LookType a ->
  TargetPosition a ->
  (Array a)
lookForAt room lookType (TargetPt x' y') = runThisFn3 "lookForAt" room lookType x' y'

lookForAt room lookType (TargetPos pos) = runThisFn2 "lookForAt" room lookType pos

lookForAt room lookType (TargetObj obj) = runThisFn2 "lookForAt" room lookType obj

-- TODO: Make obsolete, since this function is buggy
-- TODO: Make it nicer, by selecting x/y from two positions.
lookForAtArea :: forall a. Room -> LookType a -> Int -> Int -> Int -> Int -> Either String (Array (LookResult a))
lookForAtArea r ty top left bot right =
  decodeLookResults
    -- $ debugIt "result"
    
    $ runThisFn6 "lookForAtArea" r ty top left bot right true

lookForInRange :: forall a. Room -> LookType a -> RoomPosition -> Int -> Either String (Array (LookResult a))
lookForInRange r ty p range =
  lookForAtArea r ty (y p - range)
    (x p - range)
    (y p + range)
    (x p + range)

-- | Geographic centre of a room with a given name.
geoCentre :: RoomName -> RoomPosition
geoCentre rn = mkRoomPosition 24 24 rn
