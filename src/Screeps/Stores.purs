module Screeps.Stores where

import Data.Show
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Array (fromFoldable)
import Data.Eq (class Eq)
import Data.Function (($))
import Data.HeytingAlgebra ((||))
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Prelude (map)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (unsafeField, unsafeIntField, instanceOf)
import Screeps.Id (class HasId, eqById, validate, encodeJsonWithId, decodeJsonWithId)
import Screeps.Resource (ResourceType(ResourceType))
import Screeps.RoomObject (class RoomObject)
import Screeps.Structure (class Structure, class Structural, showStructure, StructureType(..))
import Screeps.Types (class Owned)
import Unsafe.Coerce (unsafeCoerce)

class Stores a

foreign import data AnyStore :: Type

instance objectAnyStore :: RoomObject AnyStore

instance ownedAnyStore :: Owned AnyStore

instance anyStoreHasId :: HasId AnyStore where
  validate o =
    instanceOf "StructureStorage" o
      || instanceOf "StructureContainer" o
      || instanceOf "StructureTerminal" o

instance encodeAnyStore :: EncodeJson AnyStore where
  encodeJson = encodeJsonWithId

instance decodeAnyStore :: DecodeJson AnyStore where
  decodeJson = decodeJsonWithId

instance eqAnyStore :: Eq AnyStore where
  eq = eqById

instance anyStoreIsStructural :: Structural AnyStore

instance anyStoreIsStructure :: Structure AnyStore where
  _structureType _ = StructureType "<unknown>"

instance showAnyStore :: Show AnyStore where
  show = showStructure

instance anyStoreStores :: Stores AnyStore

instance destructibleAnyStore :: Destructible AnyStore

toAnyStore ::
  forall s.
  Structure s =>
  s ->
  Maybe AnyStore
toAnyStore s =
  if validate s' then
    Just s'
  else
    Nothing
  where
  s' :: AnyStore
  s' = unsafeCoerce s

asAnyStore ::
  forall s.
  Stores s =>
  s -> AnyStore
asAnyStore = unsafeCoerce

store :: forall a. Stores a => a -> Store
store = unsafeField "store"

storeGet :: forall a. Stores a => a -> ResourceType -> Int
storeGet s (ResourceType res) = unsafeIntField res $ store s

storeCapacity :: forall a. Stores a => a -> Int
storeCapacity = unsafeField "storeCapacity"

newtype Store
  = Store (Map.Map String Int)

derive newtype instance showCarry :: Show Store

heldResources :: Store -> Array ResourceType
heldResources (Store c) = map ResourceType $ fromFoldable $ Map.keys c

amountHeld :: Store -> ResourceType -> Maybe Int
amountHeld (Store c) (ResourceType r) = Map.lookup r c
