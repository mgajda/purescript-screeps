-- | Corresponds to the Screeps API [StructureExtension](http://support.screeps.com/hc/en-us/articles/207711949-StructureExtension)
module Screeps.Deposit(
    class Deposit
  , AnyDeposit
  , harvestDeposit
  , depositLeft
  , depositType
  , toAnyDeposit
  , asAnyDeposit
  , caseDeposit
  , module Screeps.Regenerates
  ) where

import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Eq
import Data.Function (($))
import Data.HeytingAlgebra ((||))
import Data.Maybe (Maybe(..))
import Data.Show (class Show, show)
import Unsafe.Coerce (unsafeCoerce)
import Effect (Effect)
import Effect.Exception.Unsafe as U

import Screeps.FFI (instanceOf, runThisEffectFn1)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, eqById, validate)
import Screeps.Mineral as Mineral
import Screeps.Resource (ResourceType, resource_energy)
import Screeps.Regenerates (class Regenerates, ticksToRegeneration)
import Screeps.RoomObject (class RoomObject)
import Screeps.Source as Source
import Screeps.Types (Creep)

class Regenerates a <= Deposit a

foreign import data AnyDeposit :: Type
instance anyDepositIsRoomObject :: RoomObject AnyDeposit
instance anyDepositHasId        :: HasId      AnyDeposit
  where
    validate o = instanceOf "Mineral" o
              || instanceOf "Source"  o
instance encodeDeposit          :: EncodeJson  AnyDeposit where encodeJson = encodeJsonWithId
instance decodeDeposit          :: DecodeJson  AnyDeposit where decodeJson = decodeJsonWithId
instance showDeposit            :: Show        AnyDeposit where show       = caseDeposit show show
instance eqDeposit              :: Eq          AnyDeposit where eq         = eqById
instance anyDepositRegenerates  :: Regenerates AnyDeposit
instance anyDeposit             :: Deposit     AnyDeposit
instance mineralIsDeposit       :: Deposit     Mineral.Mineral
instance sourceIsDeposit        :: Deposit     Source.Source

caseDeposit ::  forall  d          a.
                Deposit d
            => (Source.Source   -> a)
            -> (Mineral.Mineral -> a)
            ->          d
            ->                     a
caseDeposit srcCase _       ad | instanceOf "Source"  ad = srcCase $ unsafeCoerce ad
caseDeposit _       minCase ad | instanceOf "Mineral" ad = minCase $ unsafeCoerce ad
caseDeposit _       _       _                            = U.unsafeThrow "This is not a depositEffectect"

harvestDeposit :: forall     a.
                  Creep
               -> AnyDeposit
               -> Effect     a
harvestDeposit  = runThisEffectFn1 "harvest"

depositLeft :: forall  a.
               Deposit a
            =>         a
            -> Int
depositLeft  = caseDeposit Source.energy Mineral.mineralAmount

depositType :: forall  d.
               Deposit d
            =>         d
            -> ResourceType
depositType  = caseDeposit (\_ -> resource_energy)
                            Mineral.mineralType

toAnyDeposit :: forall r. RoomObject r => r -> Maybe AnyDeposit
toAnyDeposit r = if validate s
                    then Just s
                    else Nothing
  where
    s :: AnyDeposit
    s  = unsafeCoerce r

asAnyDeposit :: forall s.
                Deposit s
             => s -> AnyDeposit
asAnyDeposit  = unsafeCoerce
