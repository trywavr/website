module Wavr.AddNewSounds where

import Prelude

import Data.Lens (_Just, set, traversed)
import Data.List ((:))
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Math ((%))
import WAGS.Create.Optionals (highpass, pan)
import WAGS.Lib.Tidal.Cycle (Cycle)
import Wavr.DemoEvent (DE'Add_new_sounds, DemoEvent(..))
import Wavr.DemoTypes (Interactivity)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture, IsFresh)
import Wags.Learn.Oscillator (lfo)

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

unevent :: IsFresh Interactivity -> DE'Add_new_sounds
unevent { value: ({ value: DE'The_possibility_to_add_new_sounds ottf } : _) } = ottf
unevent _ = { one: false, two: false, three: false, four: false }

dsk fue = set (_Just <<< lnv) (lcmap unwrap \{ event } -> let ue = unevent event in (if fue ue then 1.0 else 0.0))

addNewSounds :: TheFuture Interactivity
addNewSounds = make (m2 * 2.0)
  { earth: s
      $ onTag "tk" (dsk _.one)
      $ onTag "nn" (dsk _.four)
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
        ) $ s $ onTag "ph" (dsk _.two) $ onTag "comp" (dsk _.two) $ onTag "print" (dsk _.three) $ onTag "kt" (dsk _.three)
        $ onTag "ph" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.2 (1.0 + t * 0.3))
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

