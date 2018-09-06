-- | Corresponds to the Screeps API [StructureLink](http://support.screeps.com/hc/en-us/articles/208436275-StructureLink)
module Screeps.Link where

import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Effect
import Data.Maybe           (Maybe)
import Data.Show            (class Show,       show)

import Screeps.Constants  (link_cooldown)
import Screeps.Coolsdown  (class Coolsdown)
import Screeps.Destructible (class Destructible)
import Screeps.Decays     (class Decays)
import Screeps.Id
import Screeps.FFI        (runThisEffFn1, runThisEffFn2, instanceOf)
import Screeps.Structure
import Screeps.Types
import Screeps.Refillable (class Refillable)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)

foreign import data Link :: Type
instance objectLink      :: RoomObject Link
instance ownedLink       :: Owned      Link
instance structuralLink  :: Structural Link
instance linkDecays      :: Decays     Link
instance linkCoolsdown   :: Coolsdown  Link where
  expectedCooldown _ = link_cooldown
instance linkHasId       :: HasId Link      where
  validate = instanceOf "StructureLink"
instance refillableLink  :: Refillable Link
instance structureLink   :: Structure  Link where
  _structureType _ = structure_link
instance encodeLink      :: EncodeJson Link where encodeJson = encodeJsonWithId
instance decodeLink      :: DecodeJson Link where decodeJson = decodeJsonWithId
instance showLink        :: Show       Link where show       = showStructure
instance destructibleLink :: Destructible Link

transferEnergy :: forall e. Link -> Link -> Effect ReturnCode
transferEnergy = runThisEffFn1 "transferEnergy"

transferEnergyAmt :: forall e. Link -> Link -> Int -> Effect ReturnCode
transferEnergyAmt = runThisEffFn2 "transferEnergy"

toLink :: AnyStructure -> Maybe Link
toLink = fromAnyStructure
