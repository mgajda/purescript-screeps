-- | Corresponds to the Screeps API [StructureTower](http://support.screeps.com/hc/en-us/articles/208437105-StructureTower)
module Screeps.Tower where

import Screeps.Structure
import Effect (Effect)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (runThisEffectFn1, runThisEffectFn2, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.Refillable (class Refillable)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)
import Screeps.Types (class Owned)
import Screeps.Creep (Creep)

foreign import data Tower :: Type

instance objectTower :: RoomObject Tower

instance ownedTower :: Owned Tower

instance towerHasId :: HasId Tower where
  validate = instanceOf "StructureTower"

instance encodeTower :: EncodeJson Tower where
  encodeJson = encodeJsonWithId

instance decodeTower :: DecodeJson Tower where
  decodeJson = decodeJsonWithId

instance structuralTower :: Structural Tower

instance refillableTower :: Refillable Tower

instance structureTower :: Structure Tower where
  _structureType _ = structure_tower

instance eqTower :: Eq Tower where
  eq = eqById

instance showTower :: Show Tower where
  show = showStructure

instance destructibleTower :: Destructible Tower

attack :: Tower -> Creep -> Effect ReturnCode
attack = runThisEffectFn1 "attack"

heal :: Tower -> Creep -> Effect ReturnCode
heal = runThisEffectFn1 "heal"

repair :: forall a. Structure a => Tower -> a -> Effect ReturnCode
repair = runThisEffectFn1 "repair"

transferEnergy :: Tower -> Creep -> Effect ReturnCode
transferEnergy = runThisEffectFn1 "transferEnergy"

transferEnergyAmt :: Tower -> Creep -> Int -> Effect ReturnCode
transferEnergyAmt = runThisEffectFn2 "transferEnergy"

toTower :: AnyStructure -> Maybe Tower
toTower = fromAnyStructure
