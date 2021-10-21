module WAGSI.Plumbing.DemoTypes where

import Data.List (List)
import WAGSI.Plumbing.DemoEvent (DemoEvent)

type Interactivity = List { time :: Number, value :: DemoEvent }
