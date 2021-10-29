module Wavr.DemoTypes where

import Prelude

import Data.List (List)
import Data.Monoid.Endo (Endo)
import Data.Newtype (class Newtype)
import Data.Set (Set)
import Wavr.DemoEvent (DE'Harmonize, DemoEvent)

type RawInteractivity = List { time :: Number, value :: DemoEvent }

newtype Interactivity = Interactivity
  { raw :: RawInteractivity
  , harmony :: Set DE'Harmonize
  , crackle :: Endo (->) Number
  }

derive instance newtypeInteractivity :: Newtype Interactivity _
derive newtype instance semigroupInteractivity :: Semigroup Interactivity
derive newtype instance monoidInteractivity :: Monoid Interactivity