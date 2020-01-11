-- | Corresponds to the Screeps API [Creep](http://support.screeps.com/hc/en-us/articles/203013212-Creep)
module Screeps.Creep where

import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (Either)
import Data.Map (Map)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Prelude (class Eq, class Show, Unit, show, ($), (<$>), (<>))
import Screeps.BodyPartType (BodyPartType)
import Screeps.ConstructionSite (ConstructionSite)
import Screeps.Controller (Controller)
import Screeps.Destructible (class Destructible)
import Screeps.Direction (Direction)
import Screeps.FFI (instanceOf, runThisEffectFn0, runThisEffectFn1, runThisEffectFn2, runThisEffectFn3, runThisFn1, selectMaybes, toMaybe, unsafeField, unsafeGetFieldEffect, unsafeOptField, unsafeSetFieldEffect)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, eqById)
import Screeps.Mineral (Mineral)
import Screeps.Names (CreepName, asCreepName)
import Screeps.Owned (owner)
import Screeps.Path (Path, PathOptions)
import Screeps.Refillable (class Refillable)
import Screeps.Resource (Resource, ResourceType, resource_energy)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject, pos)
import Screeps.Source (Source)
import Screeps.Stores (class Stores, Store)
import Screeps.Structure (class Structure)
import Screeps.Types (class Owned, TargetPosition(..))

foreign import data Creep :: Type

instance creepIsRoomObject :: RoomObject Creep

instance creepIsOwned :: Owned Creep

instance creepEq :: Eq Creep where
  eq = eqById

instance showCreepEq :: Show Creep where
  show c = unsafeField "name" c <> "@" <> show (pos c)

instance creepHasId :: HasId Creep where
  validate = instanceOf "Creep"

instance encodeCreep :: EncodeJson Creep where
  encodeJson = encodeJsonWithId

instance decodeCreep :: DecodeJson Creep where
  decodeJson = decodeJsonWithId

instance destructibleCreep :: Destructible Creep

instance creepStores :: Stores Creep

--foreign import data CreepCargo :: Type
type CreepCargo
  = Map String Int

type BodyPart
  = { boost :: Maybe String
    , type :: BodyPartType
    , hits :: Int
    }

-- TODO: elaborate visualizePathStyle
type MoveOptions
  = PathOptions
      ( reusePath :: Maybe Int
      , serializeMemory :: Maybe Boolean
      , noPathFinding :: Maybe Boolean
      , visualizePathStyle :: Maybe {}
      )

moveOpts :: MoveOptions
moveOpts =
  { ignoreCreeps: Nothing
  , ignoreDestructibleStructures: Nothing
  , ignoreRoads: Nothing
  , ignore: Nothing
  , avoid: Nothing
  , maxOps: Nothing
  , heuristicWeight: Nothing
  , serialize: Nothing
  , maxRooms: Nothing
  , reusePath: Nothing
  , serializeMemory: Nothing
  , noPathFinding: Nothing
  , visualizePathStyle: Nothing
  }

body :: Creep -> Array BodyPart
body creep = unsafeField "body" creep

carry :: Creep -> Store
carry = unsafeField "carry"

amtCarrying :: Creep -> ResourceType -> Int
amtCarrying creep res = unsafeField (show res) $ carry creep

foreign import totalAmtCarrying :: Creep -> Int

carryCapacity :: Creep -> Int
carryCapacity = unsafeField "carryCapacity"

fatigue :: Creep -> Int
fatigue = unsafeField "fatigue"

name :: Creep -> CreepName
name c = case unsafeOptField "name" c of
  Nothing -> asCreepName $ showOwner $ owner c
  Just n -> n
  where
  showOwner Nothing = "<unowned creep>"

  showOwner (Just { username }) = "<" <> username <> ">"

saying :: Creep -> Maybe String
saying c = toMaybe $ unsafeField "saying" c

spawning :: Creep -> Boolean
spawning = unsafeField "spawning"

ticksToLive :: Creep -> Int
ticksToLive = unsafeField "ticksToLive"

attackCreep :: Creep -> Creep -> Effect ReturnCode
attackCreep = runThisEffectFn1 "attack"

attackStructure :: forall a. Structure a => Creep -> a -> Effect ReturnCode
attackStructure = runThisEffectFn1 "attack"

attackController :: forall a. Structure a => Creep -> a -> Effect ReturnCode
attackController = runThisEffectFn1 "attackController"

build :: Creep -> ConstructionSite -> Effect ReturnCode
build = runThisEffectFn1 "build"

cancelOrder :: Creep -> String -> Effect ReturnCode
cancelOrder = runThisEffectFn1 "cancelOrder"

claimController :: Creep -> Controller -> Effect ReturnCode
claimController = runThisEffectFn1 "claimController"

dismantle :: forall a. Structure a => Creep -> a -> Effect ReturnCode
dismantle = runThisEffectFn1 "dismantle"

drop :: Creep -> ResourceType -> Effect ReturnCode
drop = runThisEffectFn1 "drop"

dropAmt :: Creep -> ResourceType -> Int -> Effect ReturnCode
dropAmt = runThisEffectFn2 "drop"

getActiveBodyparts :: Creep -> BodyPartType -> Int
getActiveBodyparts = runThisFn1 "getActiveBodyparts"

harvestSource :: Creep -> Source -> Effect ReturnCode
harvestSource = runThisEffectFn1 "harvest"

harvestMineral :: Creep -> Mineral -> Effect ReturnCode
harvestMineral = runThisEffectFn1 "harvest"

heal :: Creep -> Creep -> Effect ReturnCode
heal = runThisEffectFn1 "heal"

getMemory :: forall a. (DecodeJson a) => Creep -> String -> Effect (Either String a)
getMemory creep key = decodeJson <$> unsafeGetFieldEffect key creepMemory
  where
  creepMemory = unsafeField "memory" creep

setMemory :: forall a. (EncodeJson a) => Creep -> String -> a -> Effect Unit
setMemory creep key val = unsafeSetFieldEffect key creepMemory (encodeJson val)
  where
  creepMemory = unsafeField "memory" creep

move :: Creep -> Direction -> Effect ReturnCode
move = runThisEffectFn1 "move"

moveByPath :: Creep -> Path -> Effect ReturnCode
moveByPath = runThisEffectFn1 "moveByPath"

moveTo :: forall a. Creep -> TargetPosition a -> Effect ReturnCode
moveTo creep (TargetPt x y) = runThisEffectFn2 "moveTo" creep x y

moveTo creep (TargetPos pos) = runThisEffectFn1 "moveTo" creep pos

moveTo creep (TargetObj obj) = runThisEffectFn1 "moveTo" creep obj

moveTo' :: forall a. Creep -> TargetPosition a -> MoveOptions -> Effect ReturnCode
moveTo' creep (TargetPt x y) opts = runThisEffectFn3 "moveTo" creep x y (selectMaybes opts)

moveTo' creep (TargetPos pos) opts = runThisEffectFn2 "moveTo" creep pos (selectMaybes opts)

moveTo' creep (TargetObj obj) opts = runThisEffectFn2 "moveTo" creep obj (selectMaybes opts)

pickup :: Creep -> Resource -> Effect ReturnCode
pickup = runThisEffectFn1 "pickup"

rangedAttackCreep :: Creep -> Creep -> Effect ReturnCode
rangedAttackCreep = runThisEffectFn1 "rangedAttack"

rangedAttackStructure :: forall a. Structure a => Creep -> a -> Effect ReturnCode
rangedAttackStructure = runThisEffectFn1 "rangedAttack"

rangedHeal :: Creep -> Creep -> Effect ReturnCode
rangedHeal = runThisEffectFn1 "rangedHeal"

rangedMassAttack :: Creep -> Effect ReturnCode
rangedMassAttack = runThisEffectFn0 "rangedMassAttack"

repair :: forall a. Structure a => Creep -> a -> Effect ReturnCode
repair = runThisEffectFn1 "repair"

reserveController :: Creep -> Controller -> Effect ReturnCode
reserveController = runThisEffectFn1 "reserveController"

say :: Creep -> String -> Effect ReturnCode
say creep msg = runThisEffectFn1 "say" creep msg

sayPublic :: Creep -> String -> Effect ReturnCode
sayPublic creep msg = runThisEffectFn2 "say" creep msg true

suicide :: Creep -> Effect ReturnCode
suicide = runThisEffectFn0 "suicide"

transferToCreep :: Creep -> Creep -> ResourceType -> Int -> Effect ReturnCode
transferToCreep = runThisEffectFn3 "transfer"

transferToStructure :: forall a. Structure a => Creep -> a -> ResourceType -> Effect ReturnCode
transferToStructure = runThisEffectFn2 "transfer"

transferAmtToStructure :: forall a. Structure a => Creep -> a -> ResourceType -> Int -> Effect ReturnCode
transferAmtToStructure = runThisEffectFn3 "transfer"

-- | Refill a structure that is refillable.
refill ::
  forall a.
  Refillable a =>
  Structure a =>
  Creep ->
  a ->
  Effect ReturnCode
refill creep structure = transferToStructure creep structure resource_energy

upgradeController :: Creep -> Controller -> Effect ReturnCode
upgradeController = runThisEffectFn1 "upgradeController"

withdraw :: forall a. Structure a => Creep -> a -> ResourceType -> Effect ReturnCode
withdraw = runThisEffectFn2 "withdraw"

withdrawAmt :: forall a. Structure a => Creep -> a -> ResourceType -> Int -> Effect ReturnCode
withdrawAmt = runThisEffectFn3 "withdraw"
