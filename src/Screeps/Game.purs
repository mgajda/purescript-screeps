-- | Corresponds to the Screeps API [Game](http://support.screeps.com/hc/en-us/articles/203016382-Game)
module Screeps.Game where

import Screeps.Structure
import Data.Map as Map
import Effect (Effect)
import Prelude (Unit, ($))
import Screeps.ConstructionSite (ConstructionSite)
import Screeps.FFI (unsafeObjectToStrMap)
import Screeps.Flag (Flag)
import Screeps.Market (Market)
import Screeps.RoomObject (Room)
import Screeps.Spawn (Spawn)
import Screeps.Creep (Creep)
import Screeps.Types (WorldMap)

foreign import unsafeGameField :: forall a. String -> a

type Gcl
  = { level :: Int
    , progress :: Int
    , progressTotal :: Int
    }

type Cpu
  = { limit :: Int
    , tickLimit :: Int
    , bucket :: Int
    }

constructionSites :: Map.Map String ConstructionSite
constructionSites = unsafeGameField "constructionSites"

cpu :: Cpu
cpu = unsafeGameField "cpu"

creeps :: Map.Map String Creep
creeps = unsafeObjectToStrMap $ unsafeGameField "creeps"

flags :: Map.Map String Flag
flags = unsafeObjectToStrMap $ unsafeGameField "flags"

foreign import gcl :: Gcl

foreign import map :: WorldMap

market :: Market
market = unsafeGameField "market"

rooms :: Map.Map String Room
rooms = unsafeObjectToStrMap $ unsafeGameField "rooms"

spawns :: Map.Map String Spawn
spawns = unsafeObjectToStrMap $ unsafeGameField "spawns"

structures :: Map.Map String AnyStructure
structures = unsafeObjectToStrMap $ unsafeGameField "structures"

time :: Int
time = unsafeGameField "time"

foreign import getUsedCpu :: Number

foreign import notify :: String -> Effect Unit

foreign import notify_ :: String -> Int -> Effect Unit
