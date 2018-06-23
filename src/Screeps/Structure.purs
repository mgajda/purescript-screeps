-- | Corresponds to the Screeps API [Structure](http://support.screeps.com/hc/en-us/articles/203079221-Structure)
module Screeps.Structure where

import Prelude
import Screeps.RoomObject (class RoomObject, AnyRoomObject, pos)
import Type.Proxy (Proxy(..))

import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Generic.Rep (class Generic, Argument(..), Constructor(..))
import Data.Maybe (Maybe(Just, Nothing))
import Effect
import Screeps.Destructible (class Destructible)
import Screeps.FFI (instanceOf, runThisEffectFn0, unsafeField)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById, validate)
import Screeps.ReturnCode (ReturnCode)
import Unsafe.Coerce (unsafeCoerce)

class Structural     a -- has `structureType` - Structure or ConstructionSite

class ( RoomObject a
      , Structural a
      , HasId      a ) <= Structure a where
    _structureType     :: Proxy     a -> StructureType

--  where myStructureType :: StructureType
-- | This class fixes an omission in original hierarchy class,
--   where both Structure and ConstructionSite share the field `structureType`
newtype StructureType = StructureType String
instance genericStructureType :: Generic StructureType (Constructor "StructureType" (Argument String)) where
  from (StructureType x) = Constructor $ Argument x
  to (Constructor (Argument x)) = StructureType x
derive newtype instance eqStructureType      :: Eq      StructureType
instance                showStructureType    :: Show    StructureType where show (StructureType strTy) = strTy

foreign import structure_spawn       :: StructureType
foreign import structure_extension   :: StructureType
foreign import structure_road        :: StructureType
foreign import structure_wall        :: StructureType
foreign import structure_rampart     :: StructureType
foreign import structure_keeper_lair :: StructureType
foreign import structure_portal      :: StructureType
foreign import structure_controller  :: StructureType
foreign import structure_link        :: StructureType
foreign import structure_storage     :: StructureType
foreign import structure_tower       :: StructureType
foreign import structure_observer    :: StructureType
foreign import structure_power_bank  :: StructureType
foreign import structure_power_spawn :: StructureType
foreign import structure_extractor   :: StructureType
foreign import structure_lab         :: StructureType
foreign import structure_terminal    :: StructureType
foreign import structure_container   :: StructureType
foreign import structure_nuker       :: StructureType

showStructure  :: forall s. Structure s
               => s -> String
showStructure s = show (structureType s) <> "@" <> show (pos s)

foreign import data AnyStructure  :: Type

instance anyStructureHasId        :: HasId      AnyStructure
  where
    validate = instanceOf "Structure"
instance encodeAnyStructure       :: EncodeJson AnyStructure where encodeJson = encodeJsonWithId
instance decodeAnyStructure       :: DecodeJson AnyStructure where decodeJson = decodeJsonWithId
instance eqAnyStructure           :: Eq         AnyStructure where eq         = eqById
instance anyStructureIsRoomObject :: RoomObject AnyStructure
instance anyStructureIsStructural :: Structural AnyStructure
instance anyStructure             :: Structure  AnyStructure where
  _structureType _ = StructureType "<unknown>"
instance showAnyStructure         :: Show       AnyStructure where show       = showStructure
instance destructibleAnyStructure :: Destructible AnyStructure

structureType :: forall a. Structural a => a -> StructureType
structureType = unsafeField "structureType"

destroy :: forall a. Structure a => a -> Effect ReturnCode
destroy = runThisEffectFn0 "destroy"

isActive :: forall a. Structure a => a -> Effect Boolean
isActive = runThisEffectFn0 "isActive"

unsafeCast :: forall a. Structure a => StructureType -> AnyStructure -> Maybe a
unsafeCast t struc
  | structureType struc == t = Just $ unsafeCoerce struc
  | otherwise = Nothing

toAnyStructure :: forall a. Structure a => a -> AnyStructure
toAnyStructure  = unsafeCoerce

fromRoomObject   :: AnyRoomObject -> Maybe AnyStructure
fromRoomObject ro = if validate  stru
                       then Just stru
                       else Nothing
  where
    stru :: AnyStructure
    stru  = unsafeCoerce ro

fromAnyStructure :: forall a. Structure a => AnyStructure -> Maybe a
fromAnyStructure = from' Proxy
  where
    from'      :: Structure a => Proxy a -> AnyStructure -> Maybe a
    from' proxy = unsafeCast $ _structureType proxy

asAnyStructure :: forall a. Structure a => a -> AnyStructure
asAnyStructure = unsafeCoerce

foreign import numStructures :: StructureType -> Int -> Int

