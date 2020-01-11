-- | Corresponds to the Screeps API [StructurePowerBank](http://support.screeps.com/hc/en-us/articles/207712729-StructurePowerBank)
module Screeps.PowerBank where

import Screeps.Structure
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Decays (class Decays)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (unsafeField, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.Types (class Owned)
import Screeps.RoomObject (class RoomObject)

foreign import data PowerBank :: Type

instance objectPowerBank :: RoomObject PowerBank

instance ownedPowerBank :: Owned PowerBank

instance structuralPowerBank :: Structural PowerBank

instance powerBankHasId :: HasId PowerBank where
  validate = instanceOf "StructurePowerBank"

instance encodePowerBank :: EncodeJson PowerBank where
  encodeJson = encodeJsonWithId

instance decodePowerBank :: DecodeJson PowerBank where
  decodeJson = decodeJsonWithId

instance structurePowerBank :: Structure PowerBank where
  _structureType _ = structure_power_bank

instance decaysPowerBank :: Decays PowerBank

instance eqPowerBank :: Eq PowerBank where
  eq = eqById

instance showPowerBank :: Show PowerBank where
  show = showStructure

instance destructiblePowerBank :: Destructible PowerBank

power :: PowerBank -> Int
power = unsafeField "power"

toPowerBank :: AnyStructure -> Maybe PowerBank
toPowerBank a = fromAnyStructure a
