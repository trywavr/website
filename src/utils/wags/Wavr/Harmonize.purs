module Wavr.Harmonize where

import Prelude

import Data.Lens (_Just, set)
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Data.Set (Set)
import Data.Set as Set
import Math ((%))
import WAGS.Create.Optionals (highpass)
import WAGS.Lib.Tidal.Cycle (Cycle)
import WAGS.Lib.Tidal.Download (sounds)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture, IsFresh)
import Wavr.DemoEvent (DE'Add_new_sounds, DE'Harmonize(..))
import Wavr.DemoTypes (Interactivity)

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

type ANS = DE'Add_new_sounds

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

unevent :: IsFresh Interactivity -> Set DE'Harmonize
unevent = _.harmony <<< unwrap <<< _.value

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
        $ onTag "pk" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> 0.7 - t * 0.2)
        $ onTag "kt" (set (_Just <<< lnr) $ lcmap unwrap \{ normalizedSampleTime: t } -> min 1.0 (0.6 + t * 0.8))
        $ nparz "psr:3;comp ~ [~ chin*4] ~ ~ [psr:3;ph psr:3;ph ~ ] _ _ , [~ ~ ~ <psr:1;print kurt:0;print> ] kurt:5;kt , ~ ~ pluck:1;pk ~ ~ ~ ~ ~ "
  , fire: s
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