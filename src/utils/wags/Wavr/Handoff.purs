module Wavr.Handoff where

import Prelude

import Control.Promise (Promise, fromAff, toAffE)
import Data.Either (Either(..))
import Data.List (fold)
import Data.Map (Map)
import Data.Map as Map
import Data.Traversable (traverse)
import Data.Tuple (snd)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff, bracket)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Event (EventIO, create, subscribe)
import Foreign (Foreign)
import WAGS.Interpret (close, constant0Hack, context, contextResume, contextState, defaultFFIAudio, makeUnitCache)
import WAGS.Lib.Learn (FullSceneBuilder(..))
import WAGS.Lib.Tidal.Engine (engine)
import WAGS.Lib.Tidal.Tidal (openFuture)
import WAGS.Lib.Tidal.Types (BufferUrl, Sample, ForwardBackwards)
import WAGS.Lib.Tidal.Util (r2b, doDownloads)
import WAGS.Run (run, Run)
import WAGS.WebAPI (AudioContext)
import Wavr.Example as Example
import Wavr.Harmonize (harmonize)
import Wavr.InfiniteGest (infiniteGest)
import Wavr.LoFi (loFi)
import Wavr.MusicWasNeverMeantToBeStaticOrFixed (musicWasNeverMeantToBeStaticOrFixed)
import Wavr.NewDirection (newDirection)
import Wavr.ChangeBeat (changeBeat)
import Wavr.Util (de2list, consoleDemoEvent, easingAlgorithm)
import Wavr.DemoEvent (DE'Beat_choice(..))

type DemoInitialized =
  { bufCache :: Ref.Ref (Map Sample { url :: BufferUrl, buffer :: ForwardBackwards })
  , interactivity :: EventIO Foreign
  }

type DemoStarted = { audioCtx :: AudioContext, unsubscribe :: Effect Unit }

initializeAndStart :: (String -> Effect Unit) -> Effect (Promise { demoInitialized :: DemoInitialized, demoStarted :: DemoStarted })
initializeAndStart logger = do
  ctx <- liftEffect context
  -- we void the canceler as we don't care about some 0.0s spewing
  _ <- liftEffect $ constant0Hack ctx
  fromAff do
    cstate <- liftEffect $ contextState ctx
    when (cstate /= "running") (toAffE $ contextResume ctx)
    demoInitialized <- initialize_ ctx
    demoStarted <- start_ ctx logger demoInitialized
    pure { demoInitialized, demoStarted }

initialize_ :: AudioContext -> Aff DemoInitialized
initialize_ ctx = do
  bufCache <- liftEffect $ Ref.new Map.empty
  interactivity <- liftEffect create
  -- todo: some of these may not be necessary
  map fold $ traverse (doDownloads ctx bufCache (const $ pure unit))
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
    ]
  pure { bufCache, interactivity }

initialize :: Effect (Promise DemoInitialized)
initialize = fromAff $ bracket (liftEffect context) (liftEffect <<< close) initialize_

start :: (String -> Effect Unit) -> DemoInitialized -> Effect (Promise DemoStarted)
start logger di = fromAff do
  audioCtx <- liftEffect context
  start_ audioCtx logger di

start_ :: AudioContext -> (String -> Effect Unit) -> DemoInitialized -> Aff DemoStarted
start_ audioCtx logger { bufCache, interactivity } = do
  let ohBehave = r2b bufCache
  cstate <- liftEffect $ contextState audioCtx
  when (cstate /= "running") (toAffE $ contextResume audioCtx)
  unitCache <- liftEffect makeUnitCache
  let
    ffiAudio = defaultFFIAudio audioCtx unitCache
  let
    FullSceneBuilder { triggerWorld, piece } =
      engine
        (de2list $ consoleDemoEvent logger interactivity.event)
        (pure Example.wag)
        (Left ohBehave)
  trigger /\ world <- snd $ triggerWorld (audioCtx /\ pure (pure {} /\ pure {}))
  doDownloads audioCtx bufCache (const $ pure unit) openFuture
  unsubscribe <- liftEffect $ subscribe
    (run trigger world { easingAlgorithm } ffiAudio piece)
    (\(_ :: Run Unit ()) -> pure unit) -- (Log.info <<< show)
  pure { audioCtx, unsubscribe }

send :: DemoInitialized -> Foreign -> Effect Unit
send = _.interactivity.push

stop :: DemoStarted -> Effect Unit
stop { audioCtx, unsubscribe } = unsubscribe *> close audioCtx