-- | Corresponds to the Screeps API [StructureController](http://support.screeps.com/hc/en-us/articles/207711889-StructureController)
module Screeps.Controller where

import Screeps.Structure
import Effect (Effect)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (runThisEffectFn0, unsafeField, unsafeOptField, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.Progress (class Progress)
import Screeps.RoomObject (class RoomObject)
import Screeps.Types (class Owned)
import Screeps.ReturnCode (ReturnCode)

foreign import data Controller :: Type

instance objectController :: RoomObject Controller

instance ownedController :: Owned Controller

instance controllerHasId :: HasId Controller where
  validate = instanceOf "StructureController"

instance encodeController :: EncodeJson Controller where
  encodeJson = encodeJsonWithId

instance decodeController :: DecodeJson Controller where
  decodeJson = decodeJsonWithId

instance structuralController :: Structural Controller

instance eqController :: Eq Controller where
  eq = eqById

instance showController :: Show Controller where
  show = showStructure

instance progressController :: Progress Controller

instance structureController :: Structure Controller where
  _structureType _ = structure_controller

instance destructibleController :: Destructible Controller

level :: Controller -> Int
level = unsafeField "level"

type Reservation
  = { username :: String
    , ticksToEnd :: Int
    }

reservation :: Controller -> Maybe Reservation
reservation = unsafeOptField "reservation"

activateSafeMode :: Controller -> Effect ReturnCode
activateSafeMode = runThisEffectFn0 "activateSafeMode"

safeMode :: Controller -> Int
safeMode = unsafeField "safeMode"

safeModeAvailable :: Controller -> Int
safeModeAvailable = unsafeField "safeModeAvailable"

safeModeCooldown :: Controller -> Int
safeModeCooldown = unsafeField "safeModeCooldown"

ticksToDowngrade :: Controller -> Int
ticksToDowngrade = unsafeField "ticksToDowngrade"

upgradeBlocked :: Controller -> Int
upgradeBlocked = unsafeField "upgradeBlocked"

unclaim :: Controller -> Effect ReturnCode
unclaim = runThisEffectFn0 "unclaim"

toController :: AnyStructure -> Maybe Controller
toController = fromAnyStructure
