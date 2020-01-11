-- | Corresponds to the Screeps API [StructureObserver](http://support.screeps.com/hc/en-us/articles/208436365-StructureObserver)
module Screeps.Observer where

import Screeps.Structure
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Effect (Effect)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Show (class Show)
import Screeps.Destructible (class Destructible)
import Screeps.FFI (runThisEffectFn1, instanceOf)
import Screeps.Id (class HasId, encodeJsonWithId, decodeJsonWithId, eqById)
import Screeps.Types (class Owned)
import Screeps.ReturnCode (ReturnCode)
import Screeps.RoomObject (class RoomObject)

foreign import data Observer :: Type

instance objectObserver :: RoomObject Observer

instance ownedObserver :: Owned Observer

instance observerHasId :: HasId Observer where
  validate = instanceOf "StructureObserver"

instance encodeObserver :: EncodeJson Observer where
  encodeJson = encodeJsonWithId

instance decodeObserver :: DecodeJson Observer where
  decodeJson = decodeJsonWithId

instance structuralObserver :: Structural Observer

instance structureObserver :: Structure Observer where
  _structureType _ = structure_observer

instance eqObserver :: Eq Observer where
  eq = eqById

instance showObserver :: Show Observer where
  show = showStructure

instance destructibleObserver :: Destructible Observer

observeRoom :: Observer -> String -> Effect ReturnCode
observeRoom obs roomName = runThisEffectFn1 "observeRoom" obs roomName

toObserver :: AnyStructure -> Maybe Observer
toObserver = fromAnyStructure
