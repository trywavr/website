module Wavr.Handoff where

import Prelude

import Control.Promise (Promise, fromAff, toAffE)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.JSDate (now, getTime)
import Data.Map (Map)
import Data.Map as Map
import Data.Tuple (snd)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff, Fiber, joinFiber, launchAff)
import Effect.Class (liftEffect)
import FRP.Event (EventIO, create, subscribe)
import Foreign (Foreign)
import WAGS.Interpret (close, constant0Hack, context, contextResume, contextState, defaultFFIAudio, makeUnitCache, getAudioClockTime)
import WAGS.Lib.Learn (FullSceneBuilder(..))
import WAGS.Lib.Tidal.Engine (engine)
import WAGS.Lib.Tidal.Types (BufferUrl, Sample, ForwardBackwards, TheFuture)
import WAGS.Run (run, Run)
import WAGS.WebAPI (AudioContext)
import Wavr.ChangeBeat (changeBeat)
import Wavr.DemoEvent (DE'Beat_choice(..))
import Wavr.DemoTypes (Interactivity)
import Wavr.Download (getBuffers, getBuffersFromPrefetched, prefetchStuff)
import Wavr.EndBuild (endBuild)
import Wavr.Example as Example
import Wavr.Harmonize (harmonize)
import Wavr.InfiniteGest (infiniteGest)
import Wavr.LoFi (loFi)
import Wavr.MusicWasNeverMeantToBeStaticOrFixed (musicWasNeverMeantToBeStaticOrFixed)
import Wavr.NewDirection (newDirection)
import Wavr.Util (de2list, consoleDemoEvent, easingAlgorithm)

---- API
type BuffersPrefetched = Fiber (Map Sample { url :: BufferUrl, buffer :: ArrayBuffer })

type DemoInitialized = { interactivity :: EventIO Foreign }

type DemoStarted = { audioCtx :: AudioContext, unsubscribe :: Effect Unit }

prefetch :: Effect BuffersPrefetched
prefetch = launchAff $ getBuffers (foldl Map.union Map.empty (map (prefetchStuff) futures))

startUsingPrefetch
  :: (String -> Effect Unit)
  -> BuffersPrefetched
  -> Effect (Promise { demoInitialized :: DemoInitialized, demoStarted :: DemoStarted })
startUsingPrefetch logger bpf' = do
  ctx <- liftEffect context
  -- we void the canceler as we don't care about some 0.0s spewing
  _ <- liftEffect $ constant0Hack ctx
  fromAff do
    cstate <- liftEffect $ contextState ctx
    when (cstate /= "running") (toAffE $ contextResume ctx)
    bpf <- joinFiber bpf'
    bufz <- getBuffersFromPrefetched bpf ctx
    interactivity <- liftEffect create
    demoStarted <- start_ ctx logger bufz interactivity
    pure { demoInitialized: { interactivity }, demoStarted }

send :: DemoInitialized -> Foreign -> Effect Unit
send = _.interactivity.push

stop :: DemoStarted -> Effect Unit
stop { audioCtx, unsubscribe } = unsubscribe *> close audioCtx

--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------

futures :: Array (TheFuture Interactivity)
futures =
  [ loFi { isFresh: true, value: mempty }
  , musicWasNeverMeantToBeStaticOrFixed { isFresh: true, value: mempty }
  , changeBeat BC'C1
  , changeBeat BC'C2
  , changeBeat BC'C3
  , changeBeat BC'C4
  , changeBeat BC'C5
  , newDirection
  , harmonize
  , infiniteGest
  , endBuild
  ]

start_
  :: AudioContext
  -> (String -> Effect Unit)
  -> Map Sample { url :: BufferUrl, buffer :: ForwardBackwards }
  -> EventIO Foreign
  -> Aff DemoStarted
start_ audioCtx logger bufCache interactivity = do
  let ohBehave = pure bufCache
  cstate <- liftEffect $ contextState audioCtx
  when (cstate /= "running") (toAffE $ contextResume audioCtx)
  unitCache <- liftEffect makeUnitCache
  ct <- liftEffect $ getAudioClockTime audioCtx
  tn <- ((_ / 1000.0) <<< getTime) <$> liftEffect now
  let corrective = tn - ct
  let
    ffiAudio = defaultFFIAudio audioCtx unitCache
  let
    FullSceneBuilder { triggerWorld, piece } =
      engine
        (de2list corrective $ consoleDemoEvent logger interactivity.event)
        (pure Example.wag)
        (Left ohBehave)
  trigger /\ world <- snd $ triggerWorld (audioCtx /\ pure (pure {} /\ pure {}))
  unsubscribe <- liftEffect $ subscribe
    (run trigger world { easingAlgorithm } ffiAudio piece)
    (\(_ :: Run Unit ()) -> pure unit) -- (Log.info <<< show)
  pure { audioCtx, unsubscribe }
