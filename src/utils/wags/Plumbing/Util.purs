module WAGSI.Plumbing.Util where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree (Cofree, (:<))
import Control.Monad.Except (runExcept)
import Data.Compactable (compact)
import Data.DateTime.Instant (unInstant)
import Data.Either (Either(..))
import Data.Lens (over)
import Data.Lens.Record (prop)
import Data.List (List(..), fold, (:))
import Data.Map as Map
import Data.Newtype (unwrap)
import Data.Set as Set
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Behavior (Behavior, behavior)
import FRP.Event (makeEvent, subscribe)
import FRP.Event as Event
import FRP.Event.Time (withTime)
import Foreign (Foreign)
import Foreign.Object as O
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))
import WAGS.WebAPI (AudioContext)
import WAGSI.Plumbing.DemoEvent (DemoEvent)
import WAGSI.Plumbing.Download (getBuffersUsingCache)
import WAGSI.Plumbing.Samples (nameToSampleO, sampleToUrls)
import WAGSI.Plumbing.Types (DroneNote(..), NextCycle(..), Sample(..), SampleCache, TheFuture(..), Voice(..))

r2b :: Ref.Ref ~> Behavior
r2b r = behavior \e -> Event.makeEvent \f -> Event.subscribe e \v -> Ref.read r >>= f <<< v

bindToN :: Int -> (List ~> List)
bindToN n
  | n <= 0 = const Nil
  | otherwise = case _ of
      Nil -> Nil
      (a : b) -> a : bindToN (n - 1) b

de2list
  :: Event.Event DemoEvent
  -> Event.Event (List { time :: Number, value :: DemoEvent })
de2list i = mapped
  where
  stamped = map (over (prop (Proxy :: _ "time")) (unInstant >>> unwrap)) (withTime i)
  folded = Event.fold Cons stamped Nil
  mapped = map (bindToN 20) folded

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

doDownloads :: forall event. AudioContext -> Ref.Ref SampleCache -> (TheFuture event -> Effect Unit) -> TheFuture event -> Aff Unit
doDownloads audioContext cacheRef push future@(TheFuture { earth, wind, fire, air, heart, sounds, preload }) = do
  cache <- liftEffect $ Ref.read cacheRef
  let
    sets = Set.fromFoldable preload
      <> fold (map v2s [ earth, wind, fire ])
      <> (Set.fromFoldable $ compact ((map <<< map) d2s [ air, heart ]))
    samplesToUrl = Set.toMap sets # Map.mapMaybeWithKey \samp@(Sample k) _ -> Map.lookup samp sounds <|> do
      nm <- O.lookup k nameToSampleO
      url <- Map.lookup nm sampleToUrls
      pure url
  newMap <- getBuffersUsingCache samplesToUrl audioContext cache
  liftEffect do
    Ref.write newMap cacheRef
    push future

consoleDemoEvent :: (String -> Effect Unit) -> Event.Event Foreign -> Event.Event DemoEvent
consoleDemoEvent loggr x = makeEvent \f -> subscribe x \a -> do
  case runExcept $ JSON.readImpl a of
    Left sadness -> do
      -- we can't pass the event along
      -- so we just note the error
      loggr ("ERR: " <> show (JSON.writeJSON a) <> " " <> (show sadness))
    Right happiness -> f happiness