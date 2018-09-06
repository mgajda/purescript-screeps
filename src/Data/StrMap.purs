module Data.StrMap(StrMap, insert, lookup, keys, empty, toUnfoldable) where

import Data.Maybe(Maybe(..))
import Data.Show(class Show)
import Data.Tuple
import Data.Array

foreign import data StrMap :: Type -> Type

foreign import empty :: forall a. StrMap a

foreign import lookup_ :: forall a. (a -> Maybe a) -> Maybe a -> String -> StrMap a -> Maybe a

lookup :: forall a. String -> StrMap a -> Maybe a
lookup = lookup_ Just Nothing

-- | This function is unsafe!!!
foreign import insert :: forall a. String -> a -> StrMap a -> StrMap a

foreign import keys :: forall a. StrMap a -> Array String

foreign import showStrMap :: forall a. StrMap a -> String

foreign import toUnfoldable_ :: forall a. (String -> a -> Tuple String a) -> StrMap a -> Array (Tuple String a)

toUnfoldable = toUnfoldable_ Tuple

instance debugStrMap :: Show (StrMap a) where show = showStrMap
