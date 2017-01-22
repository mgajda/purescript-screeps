## Module Screeps.Destructible

#### `Destructible`

``` purescript
class Destructible o 
```

#### `hits`

``` purescript
hits :: forall d. Destructible d => d -> Int
```

#### `hitsMax`

``` purescript
hitsMax :: forall d. Destructible d => d -> Int
```

#### `notifyWhenAttacked`

``` purescript
notifyWhenAttacked :: forall o e. Destructible o => o -> Boolean -> Eff (cmd :: CMD | e) ReturnCode
```


