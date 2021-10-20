module WAGSI.Plumbing.Handoff where

import Prelude

import Control.Promise (Promise, fromAff, toAffE)
import Data.List (List(..))
import Data.Map (Map)
import Data.Map as Map
import Data.Tuple (snd)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Event (EventIO, create, subscribe)
import Foreign (Foreign)
import WAGS.Interpret (close, context, contextResume, contextState, defaultFFIAudio, makeUnitCache)
import WAGS.Lib.Learn (FullSceneBuilder(..))
import WAGS.Run (run, Run)
import WAGS.WebAPI (AudioContext)
import WAGSI.Plumbing.Engine (engine)
import WAGSI.Plumbing.Example as Example
import WAGSI.Plumbing.Tidal (openFuture)
import WAGSI.Plumbing.Types (BufferUrl, Sample, ForwardBackwards)
import WAGSI.Plumbing.Util (de2list, r2b, easingAlgorithm, consoleDemoEvent, doDownloads)

type DemoInitialized =
  { bufCache :: Ref.Ref (Map Sample { url :: BufferUrl, buffer :: ForwardBackwards })
  , interactivity :: EventIO Foreign
  }

type DemoStarted = { audioCtx :: AudioContext, unsubscribe :: Effect Unit }

initialize :: Effect (Promise DemoInitialized)
initialize = fromAff do
  ctx <- liftEffect context
  bufCache <- liftEffect $ Ref.new Map.empty
  interactivity <- liftEffect create
  doDownloads ctx bufCache (const $ pure unit) (Example.wag { isFresh: true, value: Nil })
  liftEffect $ close ctx
  pure { bufCache, interactivity }

start :: (String -> Effect Unit) -> DemoInitialized -> Effect (Promise DemoStarted)
start logger { bufCache, interactivity } = fromAff do
  let ohBehave = r2b bufCache
  audioCtx <- liftEffect context
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
        ohBehave
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