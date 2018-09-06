-- | Corresponds to the Screeps API [StructureLab](http://support.screeps.com/hc/en-us/articles/208436195-StructureLab)
module Screeps.Lab where

import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Effect
import Data.Eq(class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show, show)

import Screeps.Constants  (lab_cooldown)
import Screeps.Coolsdown  (class Coolsdown)
import Screeps.Destructible (class Destructible)
import Screeps.FFI        (runThisEffFn1, runThisEffFn2, unsafeField, instanceOf)
import Screeps.Refillable (class Refillable)
import Screeps.Structure
import Screeps.Types(class Owned, Creep)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)

foreign import data Lab :: Type
instance objectLab      :: RoomObject Lab
instance ownedLab       :: Owned      Lab
instance structuralLab  :: Structural Lab
instance refillableLab  :: Refillable Lab
instance labHasId       :: HasId      Lab where
  validate = instanceOf "StructureLab"
instance eqLab          :: Eq        Lab where eq = eqById
instance coolsdownLab   :: Coolsdown Lab where
  expectedCooldown _ = lab_cooldown
instance structureLab   :: Structure Lab where
  _structureType _ = structure_lab
instance encodeLab      :: EncodeJson Lab where encodeJson = encodeJsonWithId
instance decodeLab      :: DecodeJson Lab where decodeJson = decodeJsonWithId
instance showLab        :: Show       Lab where show = showStructure
instance destructibleLab :: Destructible Lab

mineralAmount :: Lab -> Int
mineralAmount = unsafeField "mineralAmount"

mineralType :: Lab -> String
mineralType = unsafeField "mineralType"

mineralCapacity :: Lab -> Int
mineralCapacity = unsafeField "mineralCapacity"

boostCreep :: Lab -> Creep -> Effect ReturnCode
boostCreep = runThisEffFn1 "boostCreep"

boostCreep' :: Lab -> Creep -> Int -> Effect ReturnCode
boostCreep' lab creep bodyPartsCount = runThisEffFn2 "boostCreep" lab creep bodyPartsCount

runReaction :: Lab -> Lab -> Lab -> Effect ReturnCode
runReaction lab lab1 lab2 = runThisEffFn2 "runReaction" lab lab1 lab2

toLab :: AnyStructure -> Maybe Lab
toLab = fromAnyStructure
