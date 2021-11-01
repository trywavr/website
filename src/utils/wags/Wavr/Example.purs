module Wavr.Example where

import Prelude

--import Debug (spy)
import Data.List (List(..), (:))
import WAGS.Lib.Tidal.Samples as S
import WAGS.Lib.Tidal.Tidal (make, s)
import WAGS.Lib.Tidal.Types (TheFuture, IsFresh, Sample)
import Wavr.AddNewSounds (addNewSounds)
import Wavr.ChangeBeat (changeBeat)
import Wavr.Crackle (crackle)
import Wavr.DemoEvent (DemoEvent(..))
import Wavr.DemoTypes (Interactivity(..))
import Wavr.EndBuild (endBuild)
import Wavr.Harmonize (harmonize)
import Wavr.InfiniteGest (infiniteGest)
import Wavr.MusicWasNeverMeantToBeStaticOrFixed (musicWasNeverMeantToBeStaticOrFixed)
import Wavr.NewDirection (newDirection)

--- API
--- when we get the note to advance, we advance at the next possible juncture (this is how it currently works)
--- in terms of the input parameters, we pass in a list in reverse chronological order of input

preload :: Array Sample
preload = [ S.bassdm_0__Sample, S.tabla_0__Sample, S.hh_0__Sample ]

wag :: IsFresh Interactivity -> TheFuture Interactivity
wag ifi@{ value: Interactivity { raw } } = case raw of
  Nil -> make 1.0 { earth: s $ " ", preload }
  ({ value: v } : _) -> case v of
    DE'Music_was_never_meant_to_be_static_or_fixed -> musicWasNeverMeantToBeStaticOrFixed ifi
    DE'Music_must_explode_with_possibilities -> musicWasNeverMeantToBeStaticOrFixed ifi
    DE'The_possibility_to_add_new_sounds _ -> addNewSounds
    DE'The_possibility_to_take_a_sound_in_a_new_direction _ -> newDirection
    DE'The_possibility_to_change_a_beat cb -> changeBeat cb
    DE'The_possibility_to_harmonize _ -> harmonize
    DE'The_possibility_to_glitch_crackle_and_shimmer _ -> crackle
    DE'The_possibility_to_shape_it_with_a_gesture _ -> infiniteGest
    DE'Music_must_explode_with_possibilities_2 -> endBuild
    DE'And_that's_why_we're_building_wavr -> endBuild
