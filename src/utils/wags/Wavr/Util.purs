module Wavr.Util where

import Prelude

import Control.Comonad.Cofree (Cofree, (:<))
import Control.Monad.Except (runExcept)
import Data.DateTime.Instant (unInstant)
import Data.Either (Either(..))
import Data.Function (on)
import Data.Lens (over)
import Data.Lens.Record (prop)
import Data.List (List(..), foldl, (:))
import Data.List.NonEmpty (NonEmptyList(..))
import Data.List.NonEmpty as NEL
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)
import Data.Monoid.Additive (Additive(..))
import Data.Monoid.Endo (Endo(..))
import Data.Newtype (unwrap)
import Data.NonEmpty ((:|))
import Data.Set (Set)
import Data.Set as Set
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Behavior (Behavior, behavior)
import FRP.Event (makeEvent, subscribe)
import FRP.Event as Event
import FRP.Event.Time (withTime)
import Foreign (Foreign)
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))
import WAGS.Lib.Tidal.Types (DroneNote(..), NextCycle(..), Sample, Voice(..))
import Wavr.DemoEvent (DE'Harmonize, DemoEvent(..), ceq)
import Wavr.DemoTypes (Interactivity(..), RawInteractivity, RawInteractivity')

r2b :: Ref.Ref ~> Behavior
r2b r = behavior \e -> Event.makeEvent \f -> Event.subscribe e \v -> Ref.read r >>= f <<< v

bindToN :: Int -> (List ~> List)
bindToN n
  | n <= 0 = const Nil
  | otherwise = case _ of
      Nil -> Nil
      (a : b) -> a : bindToN (n - 1) b

toHarm :: RawInteractivity -> Set DE'Harmonize
toHarm = Set.fromFoldable <<< go
  where
  go ({ value: DE'The_possibility_to_harmonize h } : b) = h : go b
  go _ = Nil

b01 :: Number -> Number
b01 n = if n < 0.0 then 0.0 else if n > 1.0 then 1.0 else n

toCrackle :: Number -> RawInteractivity -> Endo (->) Number
toCrackle fktr il = il # go >>> NEL.fromList >>> case _ of
  Nothing -> Endo $ \_ -> 0.0
  Just l@(NonEmptyList (hd :| _)) -> Endo $
    let
      vv = val $ sorted l
    in
      \tm -> b01 ((max 0.0 (tm - hd.time)) * fktr * (if hd.oo then 1.0 else 0.0) + vv)
  where
  go ({ value: DE'The_possibility_to_glitch_crackle_and_shimmer oo, time } : b) = { time, oo } : go b
  go _ = Nil
  sorted = NEL.sortBy (compare `on` _.time)
  val (NonEmptyList (b :| fa)) =
    ( foldl
        ( \{ v, acc } too ->
            { v: too
            , acc:
                b01 $ acc + ((too.time - v.time) * fktr * (if too.oo then 1.0 else 0.0))
            }
        )
        { v: b, acc: 0.0 }
        fa
    ).acc

sst :: RawInteractivity' -> RawInteractivity -> Maybe (Additive Number)
sst ri =
  let
    rv = Just (Additive ri.time)
  in
    case _ of
      Nil -> rv
      (a : _) -> guard (not $ ceq ri.value a.value) rv

de2list
  :: Number
  -> Event.Event DemoEvent
  -> Event.Event Interactivity
de2list corrective i = mapped1
  where
  stamped = map
    ( over (prop (Proxy :: _ "time"))
        ( unInstant
            >>> unwrap
            >>> (_ / 1000.0) -- to seconds
            >>> (_ - corrective) -- sync to audio clock
        )
    )
    (withTime i)
  folded = Event.fold
    ( \a b ->
        { sectionStartsAt: fromMaybe b.sectionStartsAt (sst a b.raw)
        , raw: a : b.raw
        }
    )
    stamped
    { sectionStartsAt: Additive 0.0, raw: Nil }
  mapped1 = folded <#> \{ raw, sectionStartsAt } ->
    Interactivity { raw, harmony: toHarm raw, crackle: toCrackle 0.1 raw, sectionStartsAt }

easingAlgorithm :: Cofree ((->) Int) Int
easingAlgorithm =
  let
    fOf initialTime = initialTime :< \adj -> fOf $ max 15 (initialTime - adj)
  in
    fOf 15

v2s :: forall event. Voice event -> Set.Set Sample
v2s (Voice { next: NextCycle { samples } }) = samples

d2s :: forall event. DroneNote event -> Sample
d2s (DroneNote { sample }) = sample

consoleDemoEvent :: (String -> Effect Unit) -> Event.Event Foreign -> Event.Event DemoEvent
consoleDemoEvent loggr x = makeEvent \f -> subscribe x \a -> do
  case runExcept $ JSON.readImpl a of
    Left sadness -> do
      -- we can't pass the event along
      -- so we just note the error
      loggr ("ERR: " <> show (JSON.writeJSON a) <> " " <> (show sadness))
    Right happiness -> f happiness