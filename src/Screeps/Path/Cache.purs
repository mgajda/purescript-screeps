-- | This module facilitates caching of the PathFinder's `RoomCallback`.
module Screeps.Path.Cache where --(Cache, cached, newCache) where

import Prelude

import Effect
import Effect.Ref as Ref
import Data.Maybe(Maybe(..))
import Data.StrMap as StrMap

import Screeps.Path as PF

-- | TODO: Change into reasonable `MutStrMap`
newtype Cache = Cache (Ref.Ref (StrMap.StrMap PF.CostMatrix))

cached :: Cache
       -> PF.RoomCallback
       -> PF.RoomCallback
cached (Cache cache) act roomName = do
    r <- StrMap.lookup key <$> Ref.read cache
    case r of
         Nothing -> do
           v <- act roomName
           StrMap.insert key v `Ref.modify_` cache
           pure v
         Just   v ->
           pure v
  where
    key = show roomName

newCache :: Effect Cache
newCache  = Cache <$> Ref.new StrMap.empty

