{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "screeps-classy"
, dependencies =
    [ "argonaut-codecs"
    , "argonaut-core"
    , "console"
    , "effect"
    , "exceptions"
    , "foreign"
    , "functions"
    , "generics-rep"
    , "lists"
    , "maybe"
    , "partial"
    , "proxy"
    , "psci-support"
    , "refs"
    , "unsafe-coerce"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
