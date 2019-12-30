module Screeps.Stores where

import Prelude
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Array (fromFoldable)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Screeps.Destructible (class Destructible)
import Screeps.FFI (instanceOf, runThisFn0, runThisFn1, toMaybe, unsafeField, unsafeObjectToStrMap)
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

newtype Store
  = Store (Map.Map String Int)

derive newtype instance showCarry :: Show Store

store :: forall a. Stores a => a -> Store
store s = Store $ unsafeObjectToStrMap $ unsafeField "store" s

heldResources :: Store -> Array ResourceType
heldResources (Store c) = map ResourceType $ fromFoldable $ Map.keys c

amountHeld :: Store -> ResourceType -> Maybe Int
amountHeld (Store c) (ResourceType r) = Map.lookup r c

storeCapacity :: forall a. Stores a => a -> ResourceType -> Maybe Int
storeCapacity s (ResourceType res) = toMaybe $ runThisFn1 "getCapacity" (unsafeField "store" s) res

storeTotalCapacity :: forall a. Stores a => a -> Int
storeTotalCapacity s = runThisFn0 "getCapacity" $ unsafeField "store" s

storeUsed :: forall a. Stores a => a -> ResourceType -> Maybe Int
storeUsed s (ResourceType res) = toMaybe $ runThisFn1 "getUsedCapacity" (unsafeField "store" s) res

storeTotalUsed :: forall a. Stores a => a -> Int
storeTotalUsed s = runThisFn0 "getUsedCapacity" $ unsafeField "store" s

-- Due to how null - null = 0, this needs to be done differently
storeFree :: forall a. Stores a => a -> ResourceType -> Maybe Int
storeFree s r = (-) <$> (storeCapacity s r) <*> (storeUsed s r)

storeTotalFree :: forall a. Stores a => a -> Int
storeTotalFree s = runThisFn0 "getFreeCapacity" $ unsafeField "store" s
