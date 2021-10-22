module WAGSI.Plumbing.MusicWasNeverMeantToBeStaticOrFixed where

import Prelude

import Data.Lens (_Just, set, traversed)
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Profunctor (lcmap)
import WAGSI.Plumbing.Cycle (Cycle)
import WAGSI.Plumbing.DemoTypes (Interactivity)
import WAGSI.Plumbing.Tidal (lnr, make, parse, s)
import WAGSI.Plumbing.Types (TheFuture, IsFresh, Note)

--import Wags.Learn.Oscillator (lfo)

m2 = 4.0 * 1.0 * 60.0 / 111.0 :: Number

parseX :: String -> Cycle (Maybe (Note Interactivity))
parseX = parse

musicWasNeverMeantToBeStaticOrFixed :: IsFresh Interactivity -> TheFuture Interactivity
musicWasNeverMeantToBeStaticOrFixed _ =
  make (m2 * 1.0)
    { earth: s $ set (traversed <<< _Just <<< lnr) (lcmap unwrap \{ normalizedLittleCycleTime: t } -> 1.0 + t * 0.1) $ parseX "tink:1;t0 tink:2;t1 tink:3;t2 tink:0;t3 tink:4;t4  " -- tink:2;t5 tink:3;t6 tink:1;t7 tink:2;t8 tink:0;t9 tink:3;t10
    -- doesn't really work
    --, wind:  s $ onTag "bow" (set (_Just <<< lnv) (lcmap unwrap \{ sampleTime: t } -> betwixt 0.0 1.0 $ (1.0 - t*0.4) * (lfo {phase:0.0,amp:1.0,freq:5.0} t) )) $ onTag "bow" (set (_Just <<< lnr) (lcmap unwrap \{ sampleTime: t } -> betwixt 0.0 1.0 $ 1.0 - t*0.7 )) $ parseX "gretsch:11 hh gretsch:8;bow hh , ~ ~ gretsch:10 ~"  -- 10 nice
    , title: "lo fi"
    }

