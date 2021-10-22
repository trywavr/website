module WAGSI.Plumbing.DemoEvent where

import Prelude

import Control.Alt ((<|>))
import Control.Monad.Error.Class (throwError)
import Data.List (List(..))
import Data.List.NonEmpty (NonEmptyList(..))
import Data.Map (fromFoldable)
import Data.NonEmpty ((:|))
import Data.Tuple.Nested ((/\))
import Foreign (Foreign, ForeignError(..), F)
import Simple.JSON as JSON
import WAGSI.Plumbing.JSON (readVariant)

type DE'Add_new_sounds = { one :: Boolean, two :: Boolean, three :: Boolean, four :: Boolean }

data DE'New_dir_choice = NDC'C1 | NDC'C2 | NDC'C3

derive instance eqDENDC :: Eq DE'New_dir_choice
derive instance ordDENDC :: Ord DE'New_dir_choice
instance readJSONDC :: JSON.ReadForeign DE'New_dir_choice where
  readImpl = readVariant "DE'New_dir_choice"
    ( fromFoldable
        [ "NDC'C1" /\ NDC'C1
        , "NDC'C2" /\ NDC'C2
        , "NDC'C3" /\ NDC'C3
        ]
    )

data DE'Beat_choice = BC'C1 | BC'C2 | BC'C3 | BC'C4 | BC'C5 | BC'C6 | BC'C7 | BC'C8

derive instance eqDEBC :: Eq DE'Beat_choice
derive instance ordDEBC :: Ord DE'Beat_choice
instance readJSONBC :: JSON.ReadForeign DE'Beat_choice where
  readImpl = readVariant "DE'New_dir_choice"
    ( fromFoldable
        [ "BC'C1" /\ BC'C1
        , "BC'C2" /\ BC'C2
        , "BC'C3" /\ BC'C3
        , "BC'C4" /\ BC'C4
        , "BC'C5" /\ BC'C5
        , "BC'C6" /\ BC'C6
        , "BC'C7" /\ BC'C7
        , "BC'C8" /\ BC'C8
        ]
    )

data DE'Harmonize = H'Add_one | H'Add_two | H'Add_three | H'Add_four

derive instance eqDEH :: Eq DE'Harmonize
derive instance ordDEH :: Ord DE'Harmonize
instance readJSONH :: JSON.ReadForeign DE'Harmonize where
  readImpl = readVariant "DE'Harmonize"
    ( fromFoldable
        [ "H'Add_one" /\ H'Add_one
        , "H'Add_two" /\ H'Add_two
        , "H'Add_three" /\ H'Add_three
        , "H'Add_four" /\ H'Add_four
        ]
    )

data DE'Tree = DE'Leaf { left :: DE'Tree, right :: DE'Tree } | DE'End

derive instance eqDEL :: Eq DE'Tree
derive instance ordDEL :: Ord DE'Tree
instance readJSONTree :: JSON.ReadForeign DE'Tree where
  readImpl i = DE'Leaf <$> JSON.readImpl i <|> do
    e <- JSON.readImpl i
    if e == "end" then pure DE'End else throwError (NonEmptyList ((ForeignError $ "Could not parse jsonTree: " <> e) :| Nil))

type NewDir =
  { check :: Boolean
  , choice :: DE'New_dir_choice
  , slider :: Number
  }

type Pt = { x :: Number, y :: Number }

data DemoEvent
  = DE'Music_was_never_meant_to_be_static_or_fixed
  | DE'Music_must_explode_with_possibilities
  | DE'The_possibility_to_add_new_sounds DE'Add_new_sounds
  | DE'The_possibility_to_take_a_sound_in_a_new_direction NewDir
  | DE'The_possibility_to_change_a_beat DE'Beat_choice
  | DE'The_possibility_to_harmonize DE'Harmonize
  | DE'The_possibility_to_glitch_crackle_and_shimmer Boolean
  | DE'The_possibility_to_shape_it_with_a_gesture Pt
  | DE'The_possibility_to_bring_listeners_to_uncharted_musical_territory DE'Tree
  | DE'And_the_possibility_to_bring_them_back_again
  | DE'Music_must_explode_with_possibilities_2
  | DE'And_that's_why_we're_building_wavr

type WithTag = { tag :: String }

type Prs a = Foreign -> F { event :: a }

derive instance eqDE :: Eq DemoEvent
derive instance ordDE :: Ord DemoEvent
instance readJSONDE :: JSON.ReadForeign DemoEvent where
  readImpl i = do
    { tag } :: WithTag <- JSON.readImpl i
    case tag of
      "DE'Music_was_never_meant_to_be_static_or_fixed" ->
        pure DE'Music_was_never_meant_to_be_static_or_fixed
      "DE'Music_must_explode_with_possibilities" ->
        pure DE'Music_must_explode_with_possibilities
      "DE'The_possibility_to_add_new_sounds" ->
        DE'The_possibility_to_add_new_sounds <$> (_.event <$> (JSON.readImpl :: Prs DE'Add_new_sounds) i)
      "DE'The_possibility_to_take_a_sound_in_a_new_direction" ->
        DE'The_possibility_to_take_a_sound_in_a_new_direction <$> (_.event <$> (JSON.readImpl :: Prs NewDir) i)
      "DE'The_possibility_to_change_a_beat" ->
        DE'The_possibility_to_change_a_beat <$> (_.event <$> (JSON.readImpl :: Prs DE'Beat_choice) i)
      "DE'The_possibility_to_harmonize" ->
        DE'The_possibility_to_harmonize <$> (_.event <$> (JSON.readImpl :: Prs DE'Harmonize) i)
      "DE'The_possibility_to_glitch_crackle_and_shimmer" ->
        DE'The_possibility_to_glitch_crackle_and_shimmer <$> (_.event <$> (JSON.readImpl :: Prs Boolean) i)
      "DE'The_possibility_to_shape_it_with_a_gesture" ->
        DE'The_possibility_to_shape_it_with_a_gesture <$> (_.event <$> (JSON.readImpl :: Prs Pt) i)
      "DE'The_possibility_to_bring_listeners_to_uncharted_musical_territory" ->
        DE'The_possibility_to_bring_listeners_to_uncharted_musical_territory <$> (_.event <$> (JSON.readImpl :: Prs DE'Tree) i)
      "DE'And_the_possibility_to_bring_them_back_again" ->
        pure DE'And_the_possibility_to_bring_them_back_again
      "DE'Music_must_explode_with_possibilities_2" ->
        pure DE'Music_must_explode_with_possibilities_2
      "DE'And_that's_why_we're_building_wavr" ->
        pure DE'And_that's_why_we're_building_wavr
      _ -> throwError (NonEmptyList ((ForeignError $ "Could not parse demo event: " <> tag) :| Nil))