-- | Corresponds to the Screeps API [StructureTerminal](http://support.screeps.com/hc/en-us/articles/207713399-StructureTerminal)
module Screeps.Terminal where

import Screeps.Structure
import Effect (Effect)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (runThisEffectFn3, runThisEffectFn4, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.Stores (class Stores)
import Screeps.Types (class Owned)
import Screeps.Resource (ResourceType)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)

foreign import data Terminal :: Type

instance objectTerminal :: RoomObject Terminal

instance ownedTerminal :: Owned Terminal

instance terminalHasId :: HasId Terminal where
  validate = instanceOf "StructureTerminal"

instance eqTerminal :: Eq Terminal where
  eq = eqById

instance encodeTerminal :: EncodeJson Terminal where
  encodeJson = encodeJsonWithId

instance decodeTerminal :: DecodeJson Terminal where
  decodeJson = decodeJsonWithId

instance structuralTerminal :: Structural Terminal

instance terminalStores :: Stores Terminal

instance structureTerminal :: Structure Terminal where
  _structureType _ = structure_terminal

instance showTerminal :: Show Terminal where
  show = showStructure

instance destructibleTerminal :: Destructible Terminal

send :: Terminal -> ResourceType -> Int -> String -> Effect ReturnCode
send term res amount destRoomName = runThisEffectFn3 "send" term res amount destRoomName

send' :: Terminal -> ResourceType -> Int -> String -> String -> Effect ReturnCode
send' term res amount destRoomName description = runThisEffectFn4 "send" term res amount destRoomName description

toTerminal :: AnyStructure -> Maybe Terminal
toTerminal = fromAnyStructure
