module Screeps.Coolsdown where

import Type.Proxy (Proxy)
import Screeps.FFI (unsafeField)
import Screeps.Structure (class Structure)

class
  Structure a <= Coolsdown a where
  expectedCooldown :: Proxy a -> Int

cooldown :: forall a. Coolsdown a => a -> Int
cooldown = unsafeField "cooldown"
