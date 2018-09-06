-- | This module facilitates caching of the PathFinder's `RoomCallback`.
module Screeps.Path.Cache where --(Cache, cached, newCache) where

import Data.Maybe (Maybe(..))
import Effect
import Effect.Ref (Ref, modify, new, read)
import Prelude (bind, flip, pure, show, ($), (<$>))

import Data.Map as Map
import Screeps.Path as PF

newtype Cache = Cache (Ref (Map.Map String PF.CostMatrix))

cached :: Cache
       -> PF.RoomCallback -- RoomName -> Effect CostMatrix
       -> PF.RoomCallback -- RoomName -> Effect CostMatrix
cached (Cache cache) act roomName = do
    r <- Map.lookup key <$> read cache
    case r of
         Nothing -> do
           v <- act roomName
           _ <- flip modify cache $ Map.insert key v
           pure v
         Just   v ->
           pure v
  where
    key = show roomName

newCache :: Effect Cache
newCache =  Cache <$> new Map.empty

