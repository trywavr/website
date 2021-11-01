module Wavr.DemoTypes where

import Prelude

import Data.List (List)
import Data.Monoid.Additive (Additive)
import Data.Monoid.Endo (Endo)
import Data.Newtype (class Newtype)
import Data.Set (Set)
import Wavr.DemoEvent (DE'Harmonize, DemoEvent)

type RawInteractivity' = { time :: Number, value :: DemoEvent }
type RawInteractivity = List RawInteractivity'

newtype Interactivity = Interactivity
  { raw :: RawInteractivity
  , harmony :: Set DE'Harmonize
  , crackle :: Endo (->) Number
  , sectionStartsAt :: Additive Number
  }

derive instance newtypeInteractivity :: Newtype Interactivity _
derive newtype instance semigroupInteractivity :: Semigroup Interactivity
derive newtype instance monoidInteractivity :: Monoid Interactivity