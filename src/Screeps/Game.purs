-- | Corresponds to the Screeps API [Game](http://support.screeps.com/hc/en-us/articles/203016382-Game)
module Screeps.Game where

import Prelude
import Effect
import Data.StrMap as StrMap

import Screeps.ConstructionSite (ConstructionSite)
import Screeps.Types
import Screeps.Flag       (Flag)
import Screeps.Market     (Market)
import Screeps.RoomObject (Room, class RoomObject)
import Screeps.Spawn      (Spawn)
import Screeps.Structure

foreign import unsafeGameField :: forall a e. String -> Effect a

type Gcl =
  { level         :: Int
  , progress      :: Int
  , progressTotal :: Int }

type Cpu =
  { limit     :: Int
  , tickLimit :: Int
  , bucket    :: Int }

constructionSites :: forall e. Effect (StrMap.StrMap ConstructionSite)
constructionSites = unsafeGameField "constructionSites"

cpu :: forall e. Effect Cpu
cpu = unsafeGameField "cpu"

creeps :: forall e. Effect (StrMap.StrMap Creep)
creeps = unsafeGameField "creeps"

flags :: forall e. Effect (StrMap.StrMap Flag)
flags = unsafeGameField "flags"


foreign import gcl :: Gcl

foreign import map :: WorldMap

market :: forall e. Effect Market
market = unsafeGameField "market"

rooms :: forall e. Effect (StrMap.StrMap Room)
rooms = unsafeGameField "rooms"

spawns :: forall e. Effect (StrMap.StrMap Spawn)
spawns = unsafeGameField "spawns"

structures :: forall e. Effect (StrMap.StrMap AnyStructure)
structures = unsafeGameField "structures"

time :: forall e. Effect Int
time = unsafeGameField "time"

foreign import getUsedCpu :: forall e. Effect Number

foreign import notify :: forall e. String -> Effect Unit

foreign import notify_ :: forall e. String -> Int -> Effect Unit
