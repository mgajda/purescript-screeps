module Screeps.RoomVisual where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Screeps.FFI (runThisEffectFn0, runThisEffectFn2, runThisEffectFn3, runThisEffectFn4, runThisEffectFn5, selectMaybes)
import Screeps.RoomObject (Room)
import Screeps.RoomPosition.Type (RoomPosition)

foreign import data RoomVisual :: Type

foreign import getRoomVisual :: Room → Effect RoomVisual

type RoomVisualStyle
  = { color :: Maybe String
    , font :: Maybe String
    , backgroundColor :: Maybe String
    , backgroundPadding :: Maybe Number
    , align :: Maybe String
    , radius :: Maybe Number
    , fill :: Maybe String
    , width :: Maybe Number
    , opacity :: Maybe Number
    , stroke :: Maybe String
    , strokeWidth :: Maybe Number
    , lineStyle :: Maybe String -- undefined means solid line
    }

defaultRoomVisualStyle :: RoomVisualStyle
defaultRoomVisualStyle =
  { color: Nothing
  , font: Nothing
  , backgroundColor: Nothing
  , backgroundPadding: Nothing
  , align: Nothing
  , radius: Nothing
  , fill: Nothing
  , width: Nothing
  , opacity: Nothing
  , stroke: Nothing
  , strokeWidth: Nothing
  , lineStyle: Nothing
  }

--TODO: support style
line :: RoomPosition → RoomPosition → RoomVisual → Effect RoomVisual
line = lineWithStyle defaultRoomVisualStyle

lineWithStyle :: RoomVisualStyle → RoomPosition → RoomPosition → RoomVisual → Effect RoomVisual
lineWithStyle style p1 p2 rv = runThisEffectFn3 "line" rv p1 p2 (selectMaybes style)

line' :: Number → Number → Number → Number → RoomVisual → Effect RoomVisual
line' = lineWithStyle' defaultRoomVisualStyle

lineWithStyle' :: RoomVisualStyle → Number → Number → Number → Number → RoomVisual → Effect RoomVisual
lineWithStyle' style x1 y1 x2 y2 rv = runThisEffectFn5 "line" rv x1 y1 x2 y2 (selectMaybes style)

circle :: RoomPosition → RoomVisual → Effect RoomVisual
circle = circleWithStyle defaultRoomVisualStyle

circleWithStyle :: RoomVisualStyle → RoomPosition → RoomVisual → Effect RoomVisual
circleWithStyle style p rv = runThisEffectFn2 "circle" rv p (selectMaybes style)

circle' :: Number → Number → RoomVisual → Effect RoomVisual
circle' = circleWithStyle' defaultRoomVisualStyle

circleWithStyle' :: RoomVisualStyle → Number → Number → RoomVisual → Effect RoomVisual
circleWithStyle' style x y rv = runThisEffectFn3 "circle" rv x y (selectMaybes style)

rect :: RoomPosition → Number → Number → RoomVisual → Effect RoomVisual
rect = rectWithStyle defaultRoomVisualStyle

rectWithStyle :: RoomVisualStyle → RoomPosition → Number → Number → RoomVisual → Effect RoomVisual
rectWithStyle style topLeft w h rv = runThisEffectFn4 "rect" rv topLeft w h (selectMaybes style)

rect' :: Number → Number → Number → Number → RoomVisual → Effect RoomVisual
rect' = rectWithStyle' defaultRoomVisualStyle

rectWithStyle' :: RoomVisualStyle → Number → Number → Number → Number → RoomVisual → Effect RoomVisual
rectWithStyle' style x y w h rv = runThisEffectFn5 "rect" rv x y w h (selectMaybes style)

-- TODO: poly' taking Array of Array of 2 numbers?
poly :: Array RoomPosition → RoomVisual → Effect RoomVisual
poly = polyWithStyle defaultRoomVisualStyle

polyWithStyle :: RoomVisualStyle → Array RoomPosition → RoomVisual → Effect RoomVisual
polyWithStyle style vertices rv = runThisEffectFn2 "poly" rv vertices (selectMaybes style)

text :: String → RoomPosition → RoomVisual → Effect RoomVisual
text = textWithStyle defaultRoomVisualStyle

textWithStyle :: RoomVisualStyle → String → RoomPosition → RoomVisual → Effect RoomVisual
textWithStyle style t p rv = runThisEffectFn3 "text" rv t p (selectMaybes style)

text' :: String → Number → Number → RoomVisual → Effect RoomVisual
text' = textWithStyle' defaultRoomVisualStyle

textWithStyle' :: RoomVisualStyle → String → Number → Number → RoomVisual → Effect RoomVisual
textWithStyle' style x y p rv = runThisEffectFn4 "text" rv x y p (selectMaybes style)

clear :: RoomVisual → Effect RoomVisual
clear rv = runThisEffectFn0 "clear" rv
 -- TODO: getSize