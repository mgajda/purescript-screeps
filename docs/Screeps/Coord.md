## Module Screeps.Coord

#### `Coord`

``` purescript
data Coord
  = Coord Int Int
```

#### `distance`

``` purescript
distance :: RoomPosition -> RoomPosition -> Int
```

Measure straight-line distance between rooms.

#### `coord`

``` purescript
coord :: RoomPosition -> Coord
```

#### `roomCoord`

``` purescript
roomCoord :: RoomName -> Coord
```


