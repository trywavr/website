module Wavr.Harmonize where

import Prelude

import Data.Lens (_Just, set)
import Data.List (List(..), (:))
import Data.Maybe (Maybe)
import Data.Monoid.Additive (Additive(..))
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Data.Set (Set)
import Data.Set as Set
import Math ((%), pi)
import WAGS.Create.Optionals (highpass)
import WAGS.Lib.Tidal.Cycle (Cycle)
import WAGS.Lib.Tidal.Download (sounds)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (betwixt, lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture, IsFresh)
import WAGS.Math (calcSlope)
import Wags.Learn.Oscillator (lfo)
import Wavr.DemoEvent (DE'Add_new_sounds, DE'Harmonize(..), DemoEvent(..))
import Wavr.DemoTypes (Interactivity(..))

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

unevent :: IsFresh Interactivity -> Set DE'Harmonize
unevent = _.harmony <<< unwrap <<< _.value

data N1234 = N1 | N2 | N3 | N4

makeLfo :: DE'Harmonize -> N1234 -> { phase :: Number, amp :: Number, freq :: Number }
makeLfo = case _, _ of
  H'Add_one, N1 -> { phase: 0.0 * pi, amp: 0.2, freq: 0.3 }
  H'Add_one, N2 -> { phase: 0.2 * pi, amp: 0.2, freq: 0.3 }
  H'Add_one, N3 -> { phase: 0.4 * pi, amp: 0.2, freq: 0.3 }
  H'Add_one, N4 -> { phase: 0.6 * pi, amp: 0.2, freq: 0.3 }
  H'Add_two, N1 -> { phase: 0.8 * pi, amp: 0.15, freq: 0.3 }
  H'Add_two, N2 -> { phase: 1.0 * pi, amp: 0.2, freq: 0.3 }
  H'Add_two, N3 -> { phase: 1.2 * pi, amp: 0.25, freq: 0.3 }
  H'Add_two, N4 -> { phase: 1.4 * pi, amp: 0.3, freq: 0.3 }
  H'Add_three, N1 -> { phase: 1.6 * pi, amp: 0.2, freq: 1.0 }
  H'Add_three, N2 -> { phase: 1.8 * pi, amp: 0.25, freq: 2.0 }
  H'Add_three, N3 -> { phase: 2.0 * pi, amp: 0.35, freq: 3.0 }
  H'Add_three, N4 -> { phase: 2.2 * pi, amp: 0.2, freq: 4.0 }
  H'Add_four, N1 -> { phase: 2.4 * pi, amp: 0.1, freq: 2.0 }
  H'Add_four, N2 -> { phase: 2.6 * pi, amp: 0.2, freq: 4.0 }
  H'Add_four, N3 -> { phase: 2.8 * pi, amp: 0.35, freq: 8.0 }
  H'Add_four, N4 -> { phase: 3.0 * pi, amp: 0.2, freq: 16.0 }

voly :: forall a. Number -> DE'Harmonize -> Set a -> Number
voly clockTime hm = Set.size >>> case _ of
  0 -> 1.0
  1 -> 1.0 + lfo (makeLfo hm N1) clockTime
  2 -> 0.5 + lfo (makeLfo hm N2) clockTime
  3 -> 0.5 + lfo (makeLfo hm N3) clockTime
  4 -> 0.5 + lfo (makeLfo hm N4) clockTime
  _ -> 0.5 + lfo (makeLfo hm N4) clockTime

adjv :: Number -> IsFresh Interactivity -> DE'Harmonize -> Number
adjv clockTime event@{ value: Interactivity { sectionStartsAt: Additive ssa, raw } } hm =
  let
    fade = case raw of
      Nil -> 0.0
      { value: DE'The_possibility_to_harmonize _ } : _ ->
        let
          o = betwixt 0.0 1.0 $ calcSlope ssa 0.0 (ssa + 5.0) 1.0 clockTime
        in
          o
      _ -> 0.0

    ue = unevent event
  in
    if Set.member hm ue then fade * voly clockTime hm ue else 0.0

harmonize :: TheFuture Interactivity
harmonize = make (m2 * 2.0)
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
        $ onTag "kt0" (set (_Just <<< lnv) $ lcmap unwrap \{ normalizedSampleTime: _ } -> 0.05)
        $ onTag "pk" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> 0.7 - t * 0.2)
        $ onTag "kt" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.0 (0.6 + t * 0.8))
        $ nparz "psr:3;comp ~ [~ chin*4] ~ ~ [psr:3;ph psr:3;ph ~ ] _ _ , [~ ~ ~ <psr:1;print kurt:0;kt0> ] kurt:5;kt , ~ ~ pluck:1;pk ~ ~ ~ ~ ~ "
  , fire: s
      $ onTag "h0"
          ( set (_Just <<< lnv) $ lcmap unwrap \{ event, clockTime } -> adjv clockTime event H'Add_one
          )
      $ onTag "h1"
          ( set (_Just <<< lnv) $ lcmap unwrap \{ event, clockTime } -> adjv clockTime event H'Add_two
          )
      $ onTag "h2"
          ( set (_Just <<< lnv) $ lcmap unwrap \{ event, clockTime } -> adjv clockTime event H'Add_three
          )
      $ onTag "h3"
          ( set (_Just <<< lnv) $ lcmap unwrap \{ event, clockTime } -> adjv clockTime event H'Add_four
          )
      $ nparz "harmy:0;h0 , harmy:1;h1 , harmy:2;h2 , harmy:3;h3"
  , title: "lo fi"
  , sounds: sounds
      { "harmy:0": "https://media.graphcms.com/ONHn50sOT92InvzGYxwo"
      , "harmy:1": "https://media.graphcms.com/nb5XUbTuTbO3qxQLXh6r"
      , "harmy:2": "https://media.graphcms.com/hIrd54WR0KpOCSNM8lw9"
      , "harmy:3": "https://media.graphcms.com/MAYMuqV2SEeFXxxtrQSN"
      }
  }