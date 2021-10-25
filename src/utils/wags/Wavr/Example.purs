module Wavr.Example where

import Prelude

import Data.List (List(..), (:))
import Wavr.AddNewSounds (addNewSounds)
import Wavr.ChangeBeat (changeBeat)
import Wavr.DemoEvent (DemoEvent(..))
import Wavr.DemoTypes (Interactivity)
import Wavr.MusicWasNeverMeantToBeStaticOrFixed (musicWasNeverMeantToBeStaticOrFixed)
import Wavr.NewDirection (newDirection)
import WAGS.Lib.Tidal.Samples as S
import WAGS.Lib.Tidal.Tidal (make, s)
import WAGS.Lib.Tidal.Types (TheFuture, IsFresh, Sample)

--- API
--- when we get the note to advance, we advance at the next possible juncture (this is how it currently works)
--- in terms of the input parameters, we pass in a list in reverse chronological order of input

preload :: Array Sample
preload = [ S.bassdm_0__Sample, S.tabla_0__Sample, S.hh_0__Sample ]

wag :: IsFresh Interactivity -> TheFuture Interactivity
wag ifi@{ value } = case value of
  Nil -> make 1.0 { earth: s $ " ", preload }
  ({ value: v } : _) -> case v of
    DE'Music_was_never_meant_to_be_static_or_fixed -> musicWasNeverMeantToBeStaticOrFixed ifi
    DE'Music_must_explode_with_possibilities -> musicWasNeverMeantToBeStaticOrFixed ifi
    DE'The_possibility_to_add_new_sounds _ -> addNewSounds
    DE'The_possibility_to_take_a_sound_in_a_new_direction _ -> newDirection
    DE'The_possibility_to_change_a_beat cb -> changeBeat cb
    DE'The_possibility_to_harmonize _ -> make 1.0 { earth: s $ "hh ", preload }
    DE'The_possibility_to_glitch_crackle_and_shimmer _ -> make 1.0 { earth: s $ "bassdm ", preload }
    DE'The_possibility_to_shape_it_with_a_gesture _ -> make 1.0 { earth: s $ "tabla ", preload }
    DE'The_possibility_to_bring_listeners_to_uncharted_musical_territory _ -> make 1.0 { earth: s $ "hh ", preload }
    DE'And_the_possibility_to_bring_them_back_again -> make 1.0 { earth: s $ "bassdm ", preload }
    DE'Music_must_explode_with_possibilities_2 -> make 1.0 { earth: s $ "tabla ", preload }
    DE'And_that's_why_we're_building_wavr -> make 1.0 { earth: s $ "hh ", preload }