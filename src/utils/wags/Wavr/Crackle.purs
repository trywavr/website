module Wavr.Crackle where

import Prelude

import Data.Lens (_Just, set)
import Data.List (List(..), (:))
import Data.Maybe (Maybe)
import Data.Monoid.Endo (Endo(..))
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Data.Set (Set)
import Data.Set as Set
import Data.Tuple.Nested ((/\))
import Data.Vec ((+>))
import Data.Vec as V
import Math ((%))
import WAGS.Create.Optionals (gain, highpass)
import WAGS.Graph.AudioUnit (OnOff(..))
import WAGS.Graph.AudioUnit as CTOR
import WAGS.Graph.Parameter (AudioParameter)
import WAGS.Lib.Learn.Pitch (midiToCps)
import WAGS.Lib.Piecewise (APFofT)
import WAGS.Lib.Tidal.Cycle (Cycle)
import WAGS.Lib.Tidal.Download (sounds)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture, IsFresh)
import Wavr.CracklePW as CPW
import Wavr.DemoEvent (DE'Add_new_sounds, DE'Harmonize(..), DemoEvent(..))
import Wavr.DemoTypes (Interactivity(..))

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

unevent :: IsFresh Interactivity -> Set DE'Harmonize
unevent = Set.fromFoldable <<< go <<< _.raw <<< unwrap <<< _.value
  where
  go ({ value: DE'The_possibility_to_harmonize h } : b) = h : go b
  go _ = Nil

voly :: forall a. Set a -> Number
voly = Set.size >>> case _ of
  0 -> 1.0
  1 -> 1.0
  2 -> 0.5
  3 -> 0.25
  4 -> 0.15
  _ -> 0.15

adjv :: IsFresh Interactivity -> DE'Harmonize -> Number
adjv event hm =
  let
    ue = unevent event
  in
    if Set.member hm ue then voly ue else 0.0

gis5 = pure $ midiToCps 80 :: AudioParameter
e5 = pure $ midiToCps 76 :: AudioParameter
cis5 = pure $ midiToCps 73 :: AudioParameter
a4 = pure $ midiToCps 69 :: AudioParameter
fis4 = pure $ midiToCps 66 :: AudioParameter
cis4 = pure $ midiToCps 61 :: AudioParameter
fis3 = pure $ midiToCps 54 :: AudioParameter
fis2 = pure $ midiToCps 42 :: AudioParameter

cpo :: forall w o f. w -> o -> f -> CTOR.PeriodicOsc w o f
cpo = CTOR.PeriodicOsc

ipw :: APFofT Number -> Number -> AudioParameter
ipw f clockTime = (f { time: clockTime, headroomInSeconds: 0.3 })

crackle :: TheFuture Interactivity
crackle = make (m2 * 2.0)
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
            ( lcmap unwrap \{ clockTime, event: { value: Interactivity { crackle: Endo f } } } ->
                let
                  cknow = f clockTime
                  gateE gtd = pure $ max 0.0 (cknow - gtd)
                in
                  fx
                    ( goodbye $ gain 1.0
                        { gfis2: gain (ipw CPW.pw'fis2 clockTime * gateE 1.0)
                            { fis2: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On fis2 }
                        , gfis3: gain (ipw CPW.pw'fis3 clockTime * gateE 0.9)
                            { fis3: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On fis3 }
                        , gcis4: gain (ipw CPW.pw'cis4 clockTime * gateE 0.6)
                            { cis4: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On cis4 }
                        , gfis4: gain (ipw CPW.pw'fis4 clockTime * gateE 0.0)
                            { fis4: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On fis4 }
                        , ga4: gain (ipw CPW.pw'a4 clockTime * gateE 0.5)
                            { a4: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On a4 }
                        , gcis5: gain (ipw CPW.pw'cis5 clockTime * gateE 0.3)
                            { cis5: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On cis5 }
                        , ge5: gain (ipw CPW.pw'e5 clockTime * gateE 0.4)
                            { e5: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On e5 }
                        , ggis5: gain (ipw CPW.pw'gis5 clockTime * gateE 0.9)
                            { gis5: cpo ((1.0 +> V.empty) /\ (0.0 +> V.empty)) On gis5 }
                        , passthrough: hello
                        }
                    )
            )
        ) $ s
        $ onTag "h0"
            ( set (_Just <<< lnv) $ lcmap unwrap \{ event } -> adjv event H'Add_one
            )
        $ onTag "h1"
            ( set (_Just <<< lnv) $ lcmap unwrap \{ event } -> adjv event H'Add_two
            )
        $ onTag "h2"
            ( set (_Just <<< lnv) $ lcmap unwrap \{ event } -> adjv event H'Add_three
            )
        $ onTag "h3"
            ( set (_Just <<< lnv) $ lcmap unwrap \{ event } -> adjv event H'Add_four
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