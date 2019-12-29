-- | Corresponds to the Screeps API [StructureSpawn](http://support.screeps.com/hc/en-us/articles/205990342-StructureSpawn)
module Screeps.Spawn where

import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Either (Either(Left, Right))
import Data.Maybe (Maybe)
import Effect (Effect)
import Prelude (class Eq, class Show, ($))
import Screeps.BodyPartType (BodyPartType)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (NullOrUndefined, runThisEffectFn1, runThisEffectFn2, runThisFn1, toMaybe, toNullable, unsafeField, instanceOf)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, eqById)
import Screeps.Refillable (class Refillable)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)
import Screeps.Structure (class Structural, class Structure, AnyStructure, fromAnyStructure, showStructure, structure_spawn)
import Screeps.Types (class Owned)
import Screeps.Creep (Creep)

type CreepInfo
  = { name :: String
    , needTime :: Int
    , remainingTime :: Int
    }

foreign import data Spawn :: Type

instance objectSpawn :: RoomObject Spawn

instance ownedSpawn :: Owned Spawn

instance spawnHasId :: HasId Spawn where
  validate = instanceOf "StructureSpawn"

instance eqSpawn :: Eq Spawn where
  eq = eqById

instance encodeSpawn :: EncodeJson Spawn where
  encodeJson = encodeJsonWithId

instance decodeSpawn :: DecodeJson Spawn where
  decodeJson = decodeJsonWithId

instance structuralSpawn :: Structural Spawn

instance refillableSpawn :: Refillable Spawn

instance structureSpawn :: Structure Spawn where
  _structureType _ = structure_spawn

instance showSpawn :: Show Spawn where
  show = showStructure

instance destructibleSpawn :: Destructible Spawn

memory :: forall props. Spawn -> { | props }
memory = unsafeField "memory"

name :: Spawn -> String
name = unsafeField "name"

spawning :: Spawn -> Maybe CreepInfo
spawning spawn = toMaybe $ unsafeField "spawning" spawn

canCreateCreep :: Spawn -> Array BodyPartType -> ReturnCode
canCreateCreep spawn parts = runThisFn1 "canCreateCreep" spawn parts

canCreateCreep' :: Spawn -> Array BodyPartType -> String -> Effect ReturnCode
canCreateCreep' spawn parts name' = runThisEffectFn2 "canCreateCreep" spawn parts name'

foreign import createCreepImpl ::
  Spawn ->
  Array BodyPartType ->
  (ReturnCode -> Either ReturnCode String) ->
  (String -> Either ReturnCode String) ->
  Effect (Either ReturnCode String)

foreign import createCreepPrimeImpl ::
  forall mem.
  Spawn ->
  Array BodyPartType ->
  NullOrUndefined String ->
  mem ->
  (ReturnCode -> Either ReturnCode String) ->
  (String -> Either ReturnCode String) ->
  Effect (Either ReturnCode String)

createCreep :: Spawn -> Array BodyPartType -> Effect (Either ReturnCode String)
createCreep spawn parts = createCreepImpl spawn parts Left Right

createCreep' :: forall mem. (EncodeJson mem) => Spawn -> Array BodyPartType -> Maybe String -> mem -> Effect (Either ReturnCode String)
createCreep' spawn parts name' mem = createCreepPrimeImpl spawn parts (toNullable name') (encodeJson mem) Left Right

recycleCreep :: Spawn -> Creep -> Effect ReturnCode
recycleCreep = runThisEffectFn1 "recycleCreep"

renewCreep :: Spawn -> Creep -> Effect ReturnCode
renewCreep = runThisEffectFn1 "renewCreep"

toSpawn :: AnyStructure -> Maybe Spawn
toSpawn = fromAnyStructure
