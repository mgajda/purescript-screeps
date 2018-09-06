-- | Internal helper module for JavaScript FFI
module Screeps.FFI where

import Prelude
import Effect
import Data.Maybe (Maybe(Just, Nothing), isJust, fromJust, maybe)
import Data.Function.Uncurried (Fn3, runFn3)
import Partial.Unsafe (unsafePartial)

unsafeOptField :: forall obj val. String -> obj -> Maybe val
unsafeOptField = unsafeOptField_helper Nothing Just

foreign import unsafeIntField        :: forall obj.       String -> obj -> Int
foreign import unsafeField           :: forall obj val.   String -> obj -> val
foreign import unsafeOptField_helper :: forall obj val r. r      -> (val -> r) -> String -> obj -> r
foreign import unsafeGetFieldEff     :: forall obj val.   String -> obj -> Effect val
foreign import unsafeSetFieldEff     :: forall obj val.   String -> obj -> val -> Effect Unit
foreign import unsafeDeleteFieldEff  :: forall obj.       String -> obj -> Effect Unit

foreign import runThisEffFn0 :: forall this a. String -> this -> Effect a
foreign import runThisEffFn1 :: forall this a b. String -> this -> a -> Effect b
foreign import runThisEffFn2 :: forall this a b c. String -> this -> a -> b -> Effect c
foreign import runThisEffFn3 :: forall this a b c d. String -> this -> a -> b -> c -> Effect d
foreign import runThisEffFn4 :: forall this a b c d e. String -> this -> a -> b -> c -> d -> Effect e
foreign import runThisEffFn5 :: forall this a b c d e f. String -> this -> a -> b -> c -> d -> e -> Effect f
foreign import runThisEffFn6 :: forall this a b c d e f g. String -> this -> a -> b -> c -> d -> e -> f -> Effect g
foreign import runThisFn0 :: forall this a. String -> this -> a
foreign import runThisFn1 :: forall this a b. String -> this -> a -> b
foreign import runThisFn2 :: forall this a b c. String -> this -> a -> b -> c
foreign import runThisFn3 :: forall this a b c d. String -> this -> a -> b -> c -> d
foreign import runThisFn4 :: forall this a b c d e. String -> this -> a -> b -> c -> d -> e
foreign import runThisFn5 :: forall this a b c d e f. String -> this -> a -> b -> c -> d -> e -> f
foreign import runThisFn6 :: forall this a b c d e f g. String -> this -> a -> b -> c -> d -> e -> f -> g

foreign import data NullOrUndefined :: Type -> Type
foreign import null :: forall a. NullOrUndefined a
foreign import undefined :: forall a. NullOrUndefined a
foreign import notNullOrUndefined :: forall a. a -> NullOrUndefined a
foreign import isNull :: forall a. NullOrUndefined a -> Boolean
foreign import isUndefined :: forall a. NullOrUndefined a -> Boolean
foreign import toMaybeImpl :: forall a m. Fn3 (NullOrUndefined a) m (a -> m) m

toMaybe :: forall a. NullOrUndefined a -> Maybe a
toMaybe n = runFn3 toMaybeImpl n Nothing Just

toNullable :: forall a. Maybe a -> NullOrUndefined a
toNullable = maybe null notNullOrUndefined

toUndefinable :: forall a. Maybe a -> NullOrUndefined a
toUndefinable = maybe undefined notNullOrUndefined

foreign import data JsObject :: Type
foreign import selectMaybesImpl :: forall a. (Maybe a -> Boolean) -> (Maybe a -> a) -> a -> JsObject

selectMaybes :: forall a. a -> JsObject
selectMaybes obj = unsafePartial $ selectMaybesImpl isJust fromJust obj

foreign import instanceOf :: forall a. String -> a -> Boolean

