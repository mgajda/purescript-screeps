-- | Corresponds to the Screeps API [Creep](http://support.screeps.com/hc/en-us/articles/203013212-Creep)
module Screeps.Creep where

import Prelude                     (Unit, show, ($), (<$>), (<>))
import Effect(Effect)
import Data.Argonaut.Decode        (class DecodeJson, decodeJson)
import Data.Argonaut.Encode        (class EncodeJson, encodeJson)
import Data.Either                 (Either)
import Data.Maybe                  (Maybe(..))
import Data.StrMap                 (StrMap)

import Screeps.BodyPartType     (BodyPartType)
import Screeps.ConstructionSite (ConstructionSite)
import Screeps.Controller       (Controller)
import Screeps.Direction        (Direction)
import Screeps.FFI              (runThisEffFn0, runThisEffFn1, runThisEffFn2, runThisEffFn3, runThisFn1,
                                 selectMaybes, toMaybe,
                                 unsafeGetFieldEff, unsafeField, unsafeOptField, unsafeSetFieldEff)
import Screeps.FindType         (Path)
import Screeps.Mineral          (Mineral)
import Screeps.Names            (CreepName, asCreepName)
import Screeps.Owned            (owner)
import Screeps.Refillable       (class Refillable)
import Screeps.Resource         (Resource, ResourceType, resource_energy)
import Screeps.ReturnCode       (ReturnCode)
import Screeps.Room             (PathOptions)
import Screeps.Source           (Source)
import Screeps.Stores           (Store)
import Screeps.Structure        (class Structure)
import Screeps.Types            (Creep, TargetPosition(..))

--foreign import data CreepCargo :: Type
type CreepCargo = StrMap Int

type BodyPart =
  { boost :: Maybe String
  , type :: BodyPartType
  , hits :: Int }

type MoveOptions = PathOptions
  ( reusePath :: Maybe Int
  , serializeMemory :: Maybe Boolean
  , noPathFinding :: Maybe Boolean )

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
  , noPathFinding: Nothing }

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

name  :: Creep -> CreepName
name c = case unsafeOptField "name" c of
              Nothing -> asCreepName $ showOwner $ owner c
              Just n  -> n
  where
    showOwner  Nothing          = "<unowned creep>"
    showOwner (Just {username}) = "<" <> username <> ">"

saying :: Creep -> Maybe String
saying c = toMaybe $ unsafeField "saying" c

spawning :: Creep -> Boolean
spawning = unsafeField "spawning"

ticksToLive :: Creep -> Int
ticksToLive = unsafeField "ticksToLive"

attackCreep :: Creep -> Creep -> Effect ReturnCode
attackCreep = runThisEffFn1 "attack"

attackStructure :: forall a. Structure a => Creep -> a -> Effect ReturnCode
attackStructure = runThisEffFn1 "attack"

attackController :: forall a. Structure a => Creep -> a -> Effect ReturnCode
attackController = runThisEffFn1 "attackController"

build :: Creep -> ConstructionSite -> Effect ReturnCode
build = runThisEffFn1 "build"

cancelOrder :: Creep -> String -> Effect ReturnCode
cancelOrder = runThisEffFn1 "cancelOrder"

claimController :: Creep -> Controller -> Effect ReturnCode
claimController = runThisEffFn1 "claimController"

dismantle :: forall a. Structure a => Creep -> a -> Effect ReturnCode
dismantle = runThisEffFn1 "dismantle"

drop :: Creep -> ResourceType -> Effect ReturnCode
drop = runThisEffFn1 "drop"

dropAmt :: Creep -> ResourceType -> Int -> Effect ReturnCode
dropAmt = runThisEffFn2 "drop"

getActiveBodyparts :: Creep -> BodyPartType -> Int
getActiveBodyparts = runThisFn1 "getActiveBodyparts"

harvestSource :: Creep -> Source -> Effect ReturnCode
harvestSource = runThisEffFn1 "harvest"

harvestMineral :: Creep -> Mineral -> Effect ReturnCode
harvestMineral = runThisEffFn1 "harvest"

heal :: Creep -> Creep -> Effect ReturnCode
heal = runThisEffFn1 "heal"

getMemory :: forall a. (DecodeJson a) => Creep -> String -> Effect (Either String a)
getMemory creep key = decodeJson <$> unsafeGetFieldEff key creepMemory
  where creepMemory = unsafeField "memory" creep

setMemory :: forall a. (EncodeJson a) => Creep -> String -> a -> Effect Unit
setMemory creep key val = unsafeSetFieldEff key creepMemory (encodeJson val)
  where creepMemory = unsafeField "memory" creep

move :: Creep -> Direction -> Effect ReturnCode
move = runThisEffFn1 "move"

moveByPath :: Creep -> Path -> Effect ReturnCode
moveByPath = runThisEffFn1 "moveByPath"

moveTo :: forall a. Creep -> TargetPosition a -> Effect ReturnCode
moveTo creep (TargetPt x y) = runThisEffFn2 "moveTo" creep x y
moveTo creep (TargetPos pos) = runThisEffFn1 "moveTo" creep pos
moveTo creep (TargetObj obj) = runThisEffFn1 "moveTo" creep obj

moveTo' :: forall a. Creep -> TargetPosition a -> MoveOptions -> Effect ReturnCode
moveTo' creep (TargetPt x y) opts = runThisEffFn3 "moveTo" creep x y (selectMaybes opts)
moveTo' creep (TargetPos pos) opts = runThisEffFn2 "moveTo" creep pos (selectMaybes opts)
moveTo' creep (TargetObj obj) opts = runThisEffFn2 "moveTo" creep obj (selectMaybes opts)

pickup :: Creep -> Resource -> Effect ReturnCode
pickup = runThisEffFn1 "pickup"

rangedAttackCreep :: Creep -> Creep -> Effect ReturnCode
rangedAttackCreep = runThisEffFn1 "rangedAttack"

rangedAttackStructure :: forall a. Structure a => Creep -> a -> Effect ReturnCode
rangedAttackStructure = runThisEffFn1 "rangedAttack"

rangedHeal :: Creep -> Creep -> Effect ReturnCode
rangedHeal = runThisEffFn1 "rangedHeal"

rangedMassAttack :: Creep -> Effect ReturnCode
rangedMassAttack = runThisEffFn0 "rangedMassAttack"

repair :: forall a. Structure a => Creep -> a -> Effect ReturnCode
repair = runThisEffFn1 "repair"

reserveController :: Creep -> Controller -> Effect ReturnCode
reserveController = runThisEffFn1 "reserveController"

say :: Creep -> String -> Effect ReturnCode
say creep msg = runThisEffFn1 "say" creep msg

sayPublic :: Creep -> String -> Effect ReturnCode
sayPublic creep msg = runThisEffFn2 "say" creep msg true

suicide :: Creep -> Effect ReturnCode
suicide = runThisEffFn0 "suicide"

transferToCreep :: Creep -> Creep -> ResourceType -> Int -> Effect ReturnCode
transferToCreep = runThisEffFn3 "transfer"

transferToStructure :: forall a. Structure a => Creep -> a -> ResourceType -> Effect ReturnCode
transferToStructure = runThisEffFn2 "transfer"

transferAmtToStructure :: forall a. Structure a => Creep -> a -> ResourceType -> Int -> Effect ReturnCode
transferAmtToStructure = runThisEffFn3 "transfer"

-- | Refill a structure that is refillable.
refill :: forall a. Refillable a
       =>           Structure  a
       => Creep
       ->        a
       -> Effect ReturnCode
refill creep structure = transferToStructure creep structure resource_energy

upgradeController :: Creep -> Controller -> Effect ReturnCode
upgradeController = runThisEffFn1 "upgradeController"

withdraw :: forall a. Structure a => Creep -> a -> ResourceType -> Effect ReturnCode
withdraw = runThisEffFn2 "withdraw"

withdrawAmt :: forall a. Structure a => Creep -> a -> ResourceType -> Int -> Effect ReturnCode
withdrawAmt = runThisEffFn3 "withdraw"
