# purescript-screeps-classy

PureScript bindings for the [Screeps API](https://docs.screeps.com/api/).

This package is typeclass guided approach, which diverged from the original [purescript-screeps](https://github.com/hoodunit/purescript-screeps) too far to be considered the same package or fork.

## Installation

Install:

```
bower install --save purescript-screeps-classy
```

To deploy your code you need to expose it to Screeps from the exported CommonJS "loop" function and push it to the Screeps servers. If you are using NodeJS and pulp and running the Screeps game from Steam locally, deployment can be done automatically on changes by running `npm run watch:deploy` with the following scripts in your `package.json`:

```
# package.json
{
  # ...
  "scripts": {
    "deploy": "cp output/screepsMain.js ~/.config/Screeps/scripts/screeps.com/default/main.js",
    "watch:deploy": "npm run clean && pulp --watch --then \"npm run wrapMain && npm run deploy\" build --to output/main.js",
    "wrapMain": "echo 'module.exports.loop = function(){' > output/screepsMain.js && cat output/main.js >> output/screepsMain.js && echo '}' >> output/screepsMain.js"
  }
}
```

I will soon add description of how to make unit tests with `screeps-server-mockup`.

## Usage

Module documentation is [here](https://github.com/mgajda/purescript-screeps/tree/master/docs).

In most cases you will import `Screeps`, which contains all of the major types, and then one or more of the other modules. Most modules correspond directly to a Screeps API object.
Methods that repeat between objects have gained their own classes that have different names from original Screeps classes: `Refillable`, `Deposit`, `Owned`, `Decays`, and `Progress`.
Additionally there are generic `AnyStructure`, `AnyRefillable` objects that can be used to target any object of specific class, and keep them in a single list.

## Status

Pull requests welcome!
Please note that I mainly come to this game in-between projects, but you may report issues in this repo.

* Not yet implemented:
  - Market API still not implemented
  - Portals not implemented
  - RawMemory interface
* `Data.StrMap` should be broken into readonly `Data.StrMap` (for FFI queries), and `Data.MutableStrMap` for cache maintenance
* Errors do not throw exceptions consistently.

