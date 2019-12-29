-- | This module facilitates caching of the PathFinder's `RoomCallback`.
module Screeps.Path.Cache where  --(Cache, cached, newCache) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Ref (Ref, modify, new, read)
import Data.Map as Map
import Screeps.Path as PF

newtype Cache
  = Cache (Ref (Map.Map String PF.CostMatrix))

cached ::
  Cache ->
  PF.RoomCallback ->
  PF.RoomCallback
cached (Cache cache) act roomName = do
  r <- Map.lookup key <$> read cache
  case r of
    Nothing -> do
      v <- act roomName
      _ <- flip modify cache $ Map.insert key v
      pure v
    Just v -> pure v
  where
  key = show roomName

newCache :: Effect Cache
newCache = Cache <$> new Map.empty
