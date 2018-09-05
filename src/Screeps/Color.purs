module Screeps.Color where

import Data.Eq(class Eq)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Generic.Rep.Eq (genericEq)
import Data.Show(class Show)
import Data.Semigroup

newtype Color = Color Int
derive instance genericColor :: Generic Color
instance eqColor :: Eq Color where eq (Color a) (Color b) = eq a b

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

instance showColor :: Show Color where
  show (Color i) | i == color_red    = "red"
  show (Color i) | i == color_purple = "purple"
  show (Color i) | i == color_blue   = "blue"
  show (Color i) | i == color_cyan   = "cyan"
  show (Color i) | i == color_green  = "green"
  show (Color i) | i == color_yellow = "yellow"
  show (Color i) | i == color_orange = "orange"
  show (Color i) | i == color_brown  = "brown"
  show (Color i) | i == color_grey   = "grey"
  show (Color i) | i == color_white  = "white"
  show (Color i)                     = "Color "<> show i


