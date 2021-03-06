## Module Screeps.Controller

Corresponds to the Screeps API [StructureController](http://support.screeps.com/hc/en-us/articles/207711889-StructureController)

#### `Controller`

``` purescript
data Controller :: Type
```

##### Instances
``` purescript
RoomObject Controller
Owned Controller
HasId Controller
EncodeJson Controller
DecodeJson Controller
Structural Controller
Eq Controller
Show Controller
Progress Controller
Structure Controller
Destructible Controller
```

#### `level`

``` purescript
level :: Controller -> Int
```

#### `Reservation`

``` purescript
type Reservation = { "username" :: String, "ticksToEnd" :: Int }
```

#### `reservation`

``` purescript
reservation :: Controller -> Maybe Reservation
```

#### `activateSafeMode`

``` purescript
activateSafeMode :: forall e. Controller -> Eff ("cmd" :: CMD | e) ReturnCode
```

#### `safeMode`

``` purescript
safeMode :: Controller -> Int
```

#### `safeModeAvailable`

``` purescript
safeModeAvailable :: Controller -> Int
```

#### `safeModeCooldown`

``` purescript
safeModeCooldown :: Controller -> Int
```

#### `ticksToDowngrade`

``` purescript
ticksToDowngrade :: Controller -> Int
```

#### `upgradeBlocked`

``` purescript
upgradeBlocked :: Controller -> Int
```

#### `unclaim`

``` purescript
unclaim :: forall e. Controller -> Eff ("cmd" :: CMD | e) ReturnCode
```

#### `toController`

``` purescript
toController :: AnyStructure -> Maybe Controller
```


