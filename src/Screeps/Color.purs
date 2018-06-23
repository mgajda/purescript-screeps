module Screeps.Color where

import Data.Eq (class Eq)
import Data.Generic.Rep (class Generic, Argument(..), Constructor(..))
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Show (class Show)
import Prelude (($))

newtype Color = Color Int

instance genericColor :: Generic Color (Constructor "Color" (Argument Int)) where
  from (Color x) = Constructor $ Argument x
  to (Constructor (Argument x)) = Color x

instance eqColor :: Eq Color where eq = genericEq
instance showColor :: Show Color where show = genericShow

foreign import color_red :: Color
foreign import color_purple :: Color
foreign import color_blue :: Color
foreign import color_cyan :: Color
foreign import color_green :: Color
foreign import color_yellow :: Color
foreign import color_orange :: Color
foreign import color_brown :: Color
foreign import color_grey :: Color
foreign import color_white :: Color

