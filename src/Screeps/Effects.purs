module Screeps.Effects where

import Effect(kind Effect)

-- | Tag for functions which execute a Screeps command as a side effect e.g. to move a creep.
foreign import data CMD :: Effect

-- | Memory accesses are tagged with this effect.
foreign import data MEMORY :: Effect

-- | Global scope is cleared periodically, so values depending on global variables like Game and Memory need to be fetched dynamically. This effect enforces this.
foreign import data TICK :: Effect

-- | For time-dependent functions where the output changes depending on when it is called.
foreign import data TIME :: Effect
