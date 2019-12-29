-- | Defines the main types used in the library and the relationships between them.
module Screeps.Direction where

import Prelude hiding (bottom, top)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Generic.Rep (class Generic, Argument(..), Constructor(..))
import Data.Generic.Rep.Eq (genericEq)

newtype Direction
  = Direction Int

instance genericDirection :: Generic Direction (Constructor "Direction" (Argument Int)) where
  from (Direction x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Direction x

foreign import top :: Direction

foreign import top_right :: Direction

foreign import right :: Direction

foreign import bottom_right :: Direction

foreign import bottom :: Direction

foreign import bottom_left :: Direction

foreign import left :: Direction

foreign import top_left :: Direction

instance eqDirection :: Eq Direction where
  eq = genericEq

instance showDirection :: Show Direction where
  show d
    | d == top = "top"
  show d
    | d == bottom = "bottom"
  show d
    | d == left = "left"
  show d
    | d == right = "right"
  show d
    | d == top_left = "top_left"
  show d
    | d == top_right = "top_right"
  show d
    | d == bottom_left = "bottom_left"
  show d
    | d == bottom_right = "bottom_right"
  show (Direction d) = "Direction " <> show d

instance encodeDirection :: EncodeJson Direction where
  encodeJson (Direction i) = encodeJson i

instance decodeDirection :: DecodeJson Direction where
  decodeJson json = Direction <$> decodeJson json
