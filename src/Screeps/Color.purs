module Screeps.Color where

import Data.Eq(class Eq, eq, (==))
import Data.Generic.Rep (class Generic)
import Data.Show(class Show, show)
import Data.Semigroup

newtype Color = Color Int
derive instance genericColor :: Generic Color _
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
  show c | c == color_red    = "red"
  show c | c == color_purple = "purple"
  show c | c == color_blue   = "blue"
  show c | c == color_cyan   = "cyan"
  show c | c == color_green  = "green"
  show c | c == color_yellow = "yellow"
  show c | c == color_orange = "orange"
  show c | c == color_brown  = "brown"
  show c | c == color_grey   = "grey"
  show c | c == color_white  = "white"
  show (Color i)             = "Color "<> show i


