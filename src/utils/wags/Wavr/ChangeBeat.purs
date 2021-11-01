module Wavr.ChangeBeat where

import Prelude

import Data.Lens (_Just, set)
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import Math ((%))
import WAGS.Create.Optionals (highpass)
import WAGS.Lib.Tidal.Cycle (Cycle)
import Wavr.DemoEvent (DE'Beat_choice(..))
import Wavr.DemoTypes (Interactivity)
import WAGS.Lib.Tidal.FX (fx, goodbye, hello)
import WAGS.Lib.Tidal.Tidal (lnr, lnv, lvt, make, onTag, parse, s)
import WAGS.Lib.Tidal.Types (Note, TheFuture)

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

nparz :: String -> Cycle (Maybe (Note Interactivity))
nparz = parse

changeBeat :: DE'Beat_choice -> TheFuture Interactivity
changeBeat dbc = make (m2 * 2.0)
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
  , fire: s $ onTag "r1" (set (_Just <<< lnv) $ lcmap unwrap \_ -> 1.0) $ nparz
      ( case dbc of
          BC'C1 -> bt1
          BC'C2 -> bt2
          BC'C3 -> bt3
          BC'C4 -> bt4
          BC'C5 -> bt5
          BC'C6 -> bt6
      )
  , title: "lo fi"
  }

bt1 =
  """
  tabla:23;r1 lighter:13*2;r1 ~ lighter:1;r1 
  tabla2:41;r1 lighter:13;r1 [lighter:14*4;r1 ~] lighter:13;r1
        """ :: String

bt2 =
  """
  tabla:23;r1 [tabla:14 tabla:14] [~ tabla:15 tabla:15] lighter:1;r1
  tabla2:41;r1 [lighter:1 tabla:12] [lighter:14*4;r1 tabla:13] lighter:13;r1
        """ :: String

bt3 =
  """
  [tabla:23;r1 [tabla:14 tabla:14]] tabla:15*4 lighter:1;r1 tabla2:18
  tabla2:41;r1 [lighter:1 tabla:12*2] tabla:13*3 lighter:13;r1
        """ :: String

bt4 =
  """
  tabla:23;r1 ~ hh:2 ~
  tabla2:41;r1 ~ hh hh
        """ :: String

bt5 =
  """
 ~ [tabla:11 tabla:18 tabla:11 tabla:18]  [tabla:11 tabla:16 tabla2:21 tabla:11 tabla2:21 tabla:11] [tabla:11 tabla:18 tabla:11 tabla:18]
 ~ [tabla:11 tabla:18 tabla:11 tabla:18] [tabla:11 tabla:16 tabla2:13 tabla:11 tabla2:13 tabla:11] [tabla:11 tabla:18 tabla:11 tabla:18]
        """ :: String

bt6 =
  """
  [tabla:23;r1 tabla2:31 tabla2:32 tabla2:33]
  [tabla2:41 tabla2:31 tabla2:32 tabla2:33 tabla2:31 tabla2:32]
        """ :: String