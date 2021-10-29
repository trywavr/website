module Wavr.EndBuild where

import Prelude

import Data.Lens (_Just, set, traversed)
import Data.List (List(..), (:))
import Data.Maybe (Maybe)
import Data.Monoid.Additive (Additive(..))
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Math ((%))
import WAGS.Create.Optionals (highpass)
import WAGS.Lib.Tidal.Cycle (Cycle)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (betwixt, lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture)
import WAGS.Math (calcSlope)
import Wavr.DemoEvent (DE'Add_new_sounds, DemoEvent(..))
import Wavr.DemoTypes (Interactivity(..))

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

endBuild :: TheFuture Interactivity
endBuild = make (m2 * 2.0)
  { earth: s
      $ onTag "tk" (set (_Just <<< lnr) (lcmap unwrap \{ normalizedLittleCycleTime: t } -> 1.0 + t * 0.1))
      $ nparz "tink:1;tk tink:2;tk tink:3;tk tink:0;tk tink:4;tk tink:2;tk tink:3;tk tink:1;tk tink:2;k tink:0;tk tink:3;tk , [newnotes;nn newnotes:1;nn newnotes:2;nn newnotes:3;nn ~] [newnotes;nn newnotes:1;nn newnotes:2;nn ~ newnotes:4;nn newnotes:5;nn] , ~ newnotes:6;nnc ~ newnotes:7;nnc ~ newnotes:8;nnc ~ newnotes:9;nnc ~ newnotes:10;nnc ~ newnotes:11;nnc ~ newnotes:12;nnc ~ newnotes:13;nnc ~ newnotes:9;nnc"
  , wind:
      map
        ( set lvt
            ( lcmap unwrap \{ clockTime } ->
                let
                  mody = clockTime % (m2 * 2.0)
                in
                  fx (goodbye $ highpass (200.0 + mody * 100.0) hello)
            )
        ) $ s $ onTag "ph" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.2 (1.0 + t * 0.3))
        $ onTag "print" (set (_Just <<< lnv) $ lcmap unwrap \{ normalizedSampleTime: _ } -> 0.2)
        $ onTag "pk" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> 0.7 - t * 0.2)
        $ onTag "kt" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.0 (0.6 + t * 0.8))
        $ nparz "psr:3;comp ~ [~ chin*4] ~ ~ [psr:3;ph psr:3;ph ~ ] _ _ , [~ ~ ~ <psr:1;print kurt:0;print> ] kurt:5;kt , ~ ~ pluck:1;pk ~ ~ ~ ~ ~ "
  , fire: s
      $ set (traversed <<< _Just <<< lnv)
          ( lcmap unwrap \{ clockTime, event: { value: Interactivity { sectionStartsAt: Additive ssa, raw } } } -> case raw of
              Nil -> 0.0
              { value: DE'Music_must_explode_with_possibilities_2 } : _ ->
                betwixt 0.0 1.0 $ calcSlope ssa 0.0 (ssa + 10.0) 1.0 clockTime
              _ -> 0.0
          )
      $ nparz "gretsch:0 gretsch:1 gretsch:2 gretsch:3 gretsch:4 gretsch:5 gretsch:6 gretsch:7 gretsch:8 gretsch:9 gretsch:10 gretsch:11 gretsch:12 gretsch:13 gretsch:14 gretsch:15 gretsch:16 gretsch:17 gretsch:18 gretsch:19 gretsch:20 gretsch:21 gretsch:22 gretsch:23 gretsch:0 gretsch:1 gretsch:2 gretsch:3 gretsch:4 gretsch:5 gretsch:6 gretsch:7 gretsch:8 gretsch:9 gretsch:10 gretsch:11 gretsch:12 gretsch:13 gretsch:14 gretsch:15 gretsch:16 gretsch:17 gretsch:18 gretsch:19 gretsch:20 gretsch:21 gretsch:22 gretsch:23 gretsch:0 gretsch:1 gretsch:2 gretsch:3 gretsch:4 gretsch:5 gretsch:6 gretsch:7 gretsch:8 gretsch:9 gretsch:10 gretsch:11 gretsch:12 gretsch:13 gretsch:14 gretsch:15 gretsch:16 gretsch:17 gretsch:18 gretsch:19 gretsch:20 gretsch:21 gretsch:22 gretsch:23"
  , title: "lo fi"
  }