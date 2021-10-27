let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.1-20210419/packages.dhall sha256:d9a082ffb5c0fabf689574f0680e901ca6f924e01acdbece5eeedd951731375a

let overrides = {=}

let additions =
      { typelevel-peano =
        { dependencies =
          [ "arrays"
          , "console"
          , "effect"
          , "prelude"
          , "psci-support"
          , "typelevel-prelude"
          , "unsafe-coerce"
          ]
        , repo = "https://github.com/csicar/purescript-typelevel-peano.git"
        , version = "v1.0.1"
        }
      , mezgeb =
        { dependencies =
          [ "heterogeneous", "prelude", "psci-support", "record", "tuples" ]
        , repo = "https://github.com/meeshkan/purescript-mezgeb.git"
        , version = "v0.0.1"
        }
      , barlow-lens =
        { dependencies =
          [ "aff"
          , "effect"
          , "either"
          , "foldable-traversable"
          , "lists"
          , "maybe"
          , "newtype"
          , "prelude"
          , "profunctor"
          , "profunctor-lenses"
          , "psci-support"
          , "spec"
          , "spec-discovery"
          , "strings"
          , "tuples"
          , "typelevel-prelude"
          ]
        , version = "v0.8.0"
        , repo = "https://github.com/sigma-andex/purescript-barlow-lens.git"
        }
      , halogen-css =
        { dependencies = [ "css", "halogen" ]
        , version = "v9.0.0"
        , repo =
            "https://github.com/purescript-halogen/purescript-halogen-css.git"
        }
      , event =
        { dependencies =
          [ "console"
          , "effect"
          , "filterable"
          , "nullable"
          , "unsafe-reference"
          , "js-timers"
          , "now"
          ]
        , repo = "https://github.com/mikesol/purescript-event.git"
        , version = "v1.4.2"
        }
      , behaviors =
        { dependencies =
          [ "psci-support"
          , "effect"
          , "ordered-collections"
          , "filterable"
          , "nullable"
          , "event"
          , "web-html"
          , "web-events"
          , "web-uievents"
          ]
        , repo = "https://github.com/mikesol/purescript-behaviors.git"
        , version = "v8.1.0"
        }
      , wags =
        { dependencies =
          [ "aff-promise"
          , "arraybuffer-types"
          , "behaviors"
          , "console"
          , "convertable-options"
          , "debug"
          , "effect"
          , "event"
          , "free"
          , "heterogeneous"
          , "indexed-monad"
          , "maybe"
          , "ordered-collections"
          , "profunctor-lenses"
          , "psci-support"
          , "record"
          , "sized-vectors"
          , "transformers"
          , "tuples"
          , "typelevel"
          , "typelevel-peano"
          , "typelevel-prelude"
          ]
        , repo = "https://github.com/mikesol/purescript-wags.git"
        , version = "v0.5.6"
        }
      , free =
        { dependencies =
          [ "catenable-lists"
          , "control"
          , "distributive"
          , "either"
          , "exists"
          , "foldable-traversable"
          , "invariant"
          , "lazy"
          , "maybe"
          , "prelude"
          , "tailrec"
          , "transformers"
          , "tuples"
          , "unsafe-coerce"
          ]
        , repo = "https://github.com/mikesol/purescript-free.git"
        , version = "master"
        }
      , wags-lib =
        { dependencies = [ "wags", "run", "string-parsers", "halogen" ]
        , repo = "https://github.com/mikesol/purescript-wags-lib.git"
        , version = "v0.0.35"
        }
      , painting =
        { dependencies =
          [ "canvas"
          , "colors"
          , "console"
          , "effect"
          , "foldable-traversable"
          , "foreign-object"
          , "psci-support"
          , "web-html"
          ]
        , repo = "https://github.com/mikesol/purescript-painting.git"
        , version = "v0.0.0"
        }
      , convertable-options =
        { dependencies = [ "console", "effect", "maybe", "record" ]
        , repo =
            "https://github.com/natefaubion/purescript-convertable-options.git"
        , version = "v1.0.0"
        }
      }

in  upstream // overrides // additions
