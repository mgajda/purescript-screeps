module Screeps.RoomVisual where

import Effect (Effect)
import Screeps.FFI (runThisEffectFn0, runThisEffectFn1, runThisEffectFn2, runThisEffectFn3, runThisEffectFn4)
import Screeps.RoomObject (Room)
import Screeps.RoomPosition.Type (RoomPosition)

foreign import data RoomVisual :: Type

foreign import getRoomVisual :: Room → Effect RoomVisual

--TODO: support style
line :: RoomPosition → RoomPosition → RoomVisual → Effect RoomVisual
line p1 p2 rv = runThisEffectFn2 "line" rv p1 p2

line' :: Number → Number → Number → Number → RoomVisual → Effect RoomVisual
line' x1 y1 x2 y2 rv = runThisEffectFn4 "line" rv x1 y1 x2 y2

circle :: RoomPosition → RoomVisual → Effect RoomVisual
circle p rv = runThisEffectFn1 "circle" rv p

circle' :: Number → Number → RoomVisual → Effect RoomVisual
circle' x y rv = runThisEffectFn2 "circle" rv x y

rect :: RoomPosition → Number → Number → RoomVisual → Effect RoomVisual
rect topLeft w h rv = runThisEffectFn3 "rect" rv topLeft w h

rect' :: Number → Number → Number → Number → RoomVisual → Effect RoomVisual
rect' x y w h rv = runThisEffectFn4 "rect" rv x y w h

poly :: Array RoomPosition → RoomVisual → Effect RoomVisual
poly vertices rv = runThisEffectFn1 "poly" rv vertices

-- TODO: poly' taking Array of Array of 2 numbers?

text :: String → RoomPosition → RoomVisual → Effect RoomVisual
text t p rv = runThisEffectFn2 "text" rv t p

text' :: String → Number → Number → RoomVisual → Effect RoomVisual
text' x y p rv = runThisEffectFn3 "text" rv x y p

clear :: RoomVisual → Effect RoomVisual
clear rv = runThisEffectFn0 "clear" rv

-- TODO: getSize