module Wavr.InfiniteGest where

import Prelude

import Data.Lens (_Just, set)
import Data.List ((:))
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Math ((%))
import WAGS.Create.Optionals (highpass, pan)
import WAGS.Lib.Tidal.Cycle (Cycle)
import WAGS.Lib.Tidal.Download (sounds)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Samples as S
import WAGS.Lib.Tidal.Tidal (ldr, ldv, lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (ClockTimeIs(..), IsFresh, Note, Sample(..), TheFuture, TimeIsAndWas(..))
import Wags.Learn.Oscillator (lfo)
import Wavr.DemoEvent (DE'Add_new_sounds, DemoEvent(..))
import Wavr.DemoTypes (Interactivity(..))

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

toXY :: IsFresh Interactivity -> { x :: Number, y :: Number }
toXY { value: Interactivity { raw: { value: DE'The_possibility_to_shape_it_with_a_gesture xy } : _ } } = xy
toXY _ = { x: 0.0, y: 0.0 }

infiniteGest :: TheFuture Interactivity
infiniteGest = make (m2 * 2.0)
  { earth: s
      $ onTag "tk" (set (_Just <<< lnr) (lcmap unwrap \{ normalizedLittleCycleTime: t } -> 1.0 + t * 0.1))
      $ nparz "tink:1;tk tink:2;tk tink:3;tk tink:0;tk tink:4;tk tink:2;tk tink:3;tk tink:1;tk tink:2;k tink:0;tk tink:3;tk , [newnotes;nn newnotes:1;nn newnotes:2;nn newnotes:3;nn ~] [newnotes;nn newnotes:1;nn newnotes:2;nn ~ newnotes:4;nn newnotes:5;nn]"
  , wind:
      map
        ( set lvt
            ( lcmap unwrap \{ clockTime } ->
                let
                  mody = clockTime % (m2 * 2.0)
                in
                  fx
                    ( goodbye $ highpass (200.0 + mody * 100.0) hello
                    )
            )
        ) $ s $ onTag "ph" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.2 (1.0 + t * 0.3))
        $ onTag "print" (set (_Just <<< lnv) $ lcmap unwrap \{ normalizedSampleTime: _ } -> 0.2)
        $ onTag "pk" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> 0.7 - t * 0.2)
        $ onTag "kt" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.0 (0.6 + t * 0.8))
        $ nparz "psr:3;comp ~ [~ chin*4] ~ ~ [psr:3;ph psr:3;ph ~ ] _ _ , [~ ~ ~ <psr:1;print kurt:0;print> ] kurt:5;kt , ~ ~ pluck:1;pk ~ ~ ~ ~ ~ "
  , fire:
      map
        ( set lvt
            ( lcmap unwrap \{ clockTime } -> fx
                ( goodbye $ pan (lfo { phase: 0.0, amp: 1.0, freq: 0.2 } clockTime + 0.0) { myhp: highpass (lfo { phase: 0.0, amp: 2000.0, freq: 0.4 } clockTime + 2000.0) hello }
                )
            )
        ) $ s "~ ~ ~ ~ ~ ~ speechless:2 ~"
  , heart: Just
      $ set ldv (\(TimeIsAndWas { timeIs: ClockTimeIs { event } }) -> (toXY event).x)
      $ set ldr (\(TimeIsAndWas { timeIs: ClockTimeIs { event } }) -> (toXY event).y + 0.5)
      $ S.sample2drone (Sample "chimpro:0")
  , title: "lo fi"
  , sounds: sounds
      { "chimpro:0": "https://media.graphcms.com/ApbEdMWwTimLNM4aAEvG"
      }
  }