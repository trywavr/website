module Wavr.DemoTypes where

import Data.List (List)
import Wavr.DemoEvent (DemoEvent)

type Interactivity = List { time :: Number, value :: DemoEvent }
