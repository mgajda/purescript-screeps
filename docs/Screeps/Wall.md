## Module Screeps.Wall

Corresponds to the Screeps API [StructureWall](http://support.screeps.com/hc/en-us/articles/208437125-StructureWall)

#### `Wall`

``` purescript
data Wall :: Type
```

##### Instances
``` purescript
RoomObject Wall
HasId Wall
EncodeJson Wall
DecodeJson Wall
Structural Wall
Structure Wall
Eq Wall
Show Wall
Destructible Wall
```

#### `ticksToLive`

``` purescript
ticksToLive :: Wall -> Int
```

#### `toWall`

``` purescript
toWall :: AnyStructure -> Maybe Wall
```


