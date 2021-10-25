module Wavr.NewDirection where

import Prelude

import Data.Lens (_Just, set, traversed)
import Data.List ((:))
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Math ((%))
import WAGS.Create.Optionals (highpass, pan)
import WAGS.Lib.Tidal.Cycle (Cycle)
import Wavr.DemoEvent (DE'Add_new_sounds, DE'New_dir_choice(..), DemoEvent(..), NewDir)
import Wavr.DemoTypes (Interactivity)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture, IsFresh)
import Wags.Learn.Oscillator (lfo)

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

unevent :: IsFresh Interactivity -> NewDir
unevent { value: ({ value: DE'The_possibility_to_take_a_sound_in_a_new_direction ndc } : _) } = ndc
unevent _ =
  { check: false
  , choice: NDC'C1
  , slider: 0.0
  }

newDirection :: TheFuture Interactivity
newDirection = make (m2 * 2.0)
  { earth: s
      $ onTag "tk" (set (_Just <<< lnr) (lcmap unwrap \{ normalizedLittleCycleTime: t } -> 1.0 + t * 0.1))
      $ onTag "nn"
          ( set (_Just <<< lnr)
              ( lcmap unwrap \{ event } ->
                  let ue = unevent event in 1.0 + ue.slider
              )
          )
      $ onTag "nn"
          ( set (_Just <<< lnv)
              ( lcmap unwrap \{ event, clockTime } ->
                  let
                    ue = unevent event
                  in
                    case ue.choice of
                      NDC'C1 -> 1.0
                      NDC'C2 -> lfo { phase: 0.0, amp: 0.5, freq: 10.0 } clockTime + 0.5
                      NDC'C3 -> lfo { phase: 0.0, amp: 0.5, freq: 20.0 } clockTime + 0.5
              )
          )
      $ onTag "nnc" (set (_Just <<< lnv) (lcmap unwrap \{ event } -> let ue = unevent event in if ue.check then 0.6 else 0.0))
      $ nparz "tink:1;tk tink:2;tk tink:3;tk tink:0;tk tink:4;tk tink:2;tk tink:3;tk tink:1;tk tink:2;k tink:0;tk tink:3;tk , [newnotes;nn newnotes:1;nn newnotes:2;nn newnotes:3;nn ~] [newnotes;nn newnotes:1;nn newnotes:2;nn ~ newnotes:4;nn newnotes:5;nn] , ~ newnotes:6;nnc ~ newnotes:7;nnc ~ newnotes:8;nnc ~ newnotes:9;nnc ~ newnotes:10;nnc ~ newnotes:11;nnc ~ newnotes:12;nnc ~ newnotes:13;nnc ~ newnotes:9;nnc"
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
  , title: "lo fi"
  }