-- | Corresponds to the Screeps API [StructureKeeperLair](http://support.screeps.com/hc/en-us/articles/207712119-StructureKeeperLair)
module Screeps.KeeperLair where

import Screeps.Structure
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (unsafeField, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.RoomObject (class RoomObject)
import Screeps.Types (class Owned)

foreign import data KeeperLair :: Type

instance objectKeeperLair :: RoomObject KeeperLair

instance keeperLairHasId :: HasId KeeperLair where
  validate = instanceOf "StructureKeeperLair"

instance eqKeeperLair :: Eq KeeperLair where
  eq = eqById

instance ownedKeeperLair :: Owned KeeperLair -- TODO: check itEffectect

instance structuralKeeperLair :: Structural KeeperLair

instance structureKeeperLair :: Structure KeeperLair where
  _structureType _ = structure_keeper_lair

instance encodeKeeperLair :: EncodeJson KeeperLair where
  encodeJson = encodeJsonWithId

instance decodeKeeperLair :: DecodeJson KeeperLair where
  decodeJson = decodeJsonWithId

instance showKeeperLair :: Show KeeperLair where
  show = showStructure

instance destructibleKeeperLair :: Destructible KeeperLair

ticksToSpawn :: KeeperLair -> Int
ticksToSpawn = unsafeField "ticksToSpawn"

toKeeperLair :: AnyStructure -> Maybe KeeperLair
toKeeperLair = fromAnyStructure
