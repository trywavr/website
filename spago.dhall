{ name = "wavr-website"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "arrays"
  , "behaviors"
  , "canvas"
  , "cartesian"
  , "catenable-lists"
  , "colors"
  , "console"
  , "control"
  , "convertable-options"
  , "css"
  , "datetime"
  , "debug"
  , "effect"
  , "either"
  , "event"
  , "filterable"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "free"
  , "halogen"
  , "halogen-css"
  , "halogen-subscriptions"
  , "heterogeneous"
  , "identity"
  , "indexed-monad"
  , "integers"
  , "js-date"
  , "lcg"
  , "lists"
  , "math"
  , "maybe"
  , "mezgeb"
  , "newtype"
  , "nonempty"
  , "numbers"
  , "ordered-collections"
  , "painting"
  , "prelude"
  , "profunctor"
  , "profunctor-lenses"
  , "psci-support"
  , "quickcheck"
  , "random"
  , "record"
  , "refs"
  , "safe-coerce"
  , "simple-json"
  , "sized-vectors"
  , "string-parsers"
  , "strings"
  , "transformers"
  , "tuples"
  , "typelevel"
  , "typelevel-peano"
  , "unfoldable"
  , "unsafe-coerce"
  , "variant"
  , "wags"
  , "wags-lib"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "wags/**/*.purs" ]
}