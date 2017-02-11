## Module Screeps.Path

This module implements PathFinder API.

WARNING: While PathFinder accepts any number of target objects,
         excessive GC may occur if there are too many.
         API author advises to sort targets by uniform distance [Screeps.Coord],
         and use only first 10 or so.

#### `TileCost`

``` purescript
type TileCost = Int
```

#### `defaultTerrainCost`

``` purescript
defaultTerrainCost :: TileCost
```

#### `unwalkable`

``` purescript
unwalkable :: TileCost
```

Indicates an unwalkable tile.

#### `PATH`

``` purescript
data PATH :: Effect
```

#### `PathFinderResult`

``` purescript
newtype PathFinderResult
  = PathFinderResult { "path" :: Array RoomPosition, "opts" :: Int, "cost" :: Int, "incomplete" :: Boolean }
```

#### `PathFinderTarget`

``` purescript
newtype PathFinderTarget
  = PathFinderTarget { "pos" :: RoomPosition, "range" :: Int }
```

#### `target`

``` purescript
target :: RoomPosition -> PathFinderTarget
```

#### `inRange`

``` purescript
inRange :: Int -> RoomPosition -> PathFinderTarget
```

#### `usePathFinder`

``` purescript
usePathFinder :: forall e. Eff ("path" :: PATH | e) Unit
```

#### `CostMatrix`

``` purescript
data CostMatrix :: Type
```

##### Instances
``` purescript
EncodeJson CostMatrix
DecodeJson CostMatrix
```

#### `search`

``` purescript
search :: forall e. RoomPosition -> Array PathFinderTarget -> (PathFinderOpts e) -> Eff ("path" :: PATH | e) PathFinderResult
```

#### `newCostMatrix`

``` purescript
newCostMatrix :: forall e. Eff ("path" :: PATH | e) CostMatrix
```

#### `infinity`

``` purescript
infinity :: Number
```

#### `defaultPathFinderOpts`

``` purescript
defaultPathFinderOpts :: forall a. PathFinderOpts a
```

#### `RoomCallback`

``` purescript
type RoomCallback e = RoomName -> Eff ("path" :: PATH | e) CostMatrix
```

#### `allDefaultCosts`

``` purescript
allDefaultCosts :: forall e. RoomCallback e
```

Empty callback - just use default terrain cost.

#### `PathFinderOpts`

``` purescript
newtype PathFinderOpts e
  = PathFinderOpts { "roomCallback" :: RoomCallback e, "plainCost" :: TileCost, "swampCost" :: TileCost, "flee" :: Boolean, "maxOps" :: Int, "maxRooms" :: Int, "maxCost" :: Number, "heuristicWeight" :: Number }
```

#### `set`

``` purescript
set :: forall e. CostMatrix -> Int -> Int -> TileCost -> Eff ("path" :: PATH | e) Unit
```

Set a given coordinate to any cost.

#### `get`

``` purescript
get :: forall e. CostMatrix -> Int -> Int -> Eff ("path" :: PATH | e) TileCost
```

Get current cost of any coordinate.
Zero indicates default terrain cost.

#### `clone`

``` purescript
clone :: forall e. CostMatrix -> Eff ("path" :: PATH | e) CostMatrix
```

Clone cost matrix.

#### `SerializedCostMatrix`

``` purescript
newtype SerializedCostMatrix
  = SerializedCostMatrix Json
```

Serialized cost matrix, suitable for `JSON.stringify`.

##### Instances
``` purescript
Show SerializedCostMatrix
```

#### `serialize`

``` purescript
serialize :: CostMatrix -> SerializedCostMatrix
```

Serialize cost matrix for storage in `Memory`.

#### `deserialize`

``` purescript
deserialize :: forall e. SerializedCostMatrix -> Eff ("err" :: EXCEPTION | e) CostMatrix
```


