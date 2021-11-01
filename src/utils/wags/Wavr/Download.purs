module Wavr.Download where

import Prelude

import Control.Alt ((<|>))
import Control.Promise (toAffE)
import Data.Array as A
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Compactable (compact)
import Data.Either (Either(..))
import Data.Foldable (fold)
import Data.Int (toNumber)
import Data.Map (Map)
import Data.Map as Map
import Data.Set as Set
import Data.Traversable (traverse)
import Data.Tuple.Nested ((/\), type (/\))
import Effect.Aff (Aff, Milliseconds(..), ParAff, delay, error, parallel, sequential, throwError, try)
import Effect.Class (liftEffect)
import Effect.Class.Console as Log
import Foreign.Object as O
import WAGS.Interpret (fetchArrayBuffer, decodeAudioDataFromArrayBuffer)
import WAGS.Lib.Tidal.Download (reverseAudioBuffer)
import WAGS.Lib.Tidal.Samples (nameToSampleO, sampleToUrls)
import WAGS.Lib.Tidal.Types (BufferUrl(..), Sample(..), TheFuture(..), ForwardBackwards)
import WAGS.WebAPI (AudioContext)
import Wavr.Util (d2s, v2s)

chunks :: forall a. Int -> Array a -> Array (Array a)
chunks _ [] = []
chunks n xs = pure (A.take n xs) <> (chunks n $ A.drop n xs)

fab :: BufferUrl -> Aff ArrayBuffer
fab (BufferUrl bf) = backoff do
  toAffE $ fetchArrayBuffer bf

getBuffers
  :: Map Sample BufferUrl
  -> Aff (Map Sample { url :: BufferUrl, buffer :: ArrayBuffer })
getBuffers nameToUrl = do
  res <- newBuffers
  pure res
  where
  toDownload :: Map Sample BufferUrl
  toDownload = nameToUrl

  toDownloadArr :: Array (Sample /\ BufferUrl)
  toDownloadArr = Map.toUnfoldable toDownload

  traversed :: Array (Sample /\ BufferUrl) -> ParAff (Array (Sample /\ { url :: BufferUrl, buffer :: ArrayBuffer }))
  traversed = traverse \(k /\ v) -> parallel ((/\) k <<< { url: v, buffer: _ } <$> fab v)
  newBuffers = map (Map.fromFoldable <<< join) $ (traverse (sequential <<< traversed) (chunks 100 toDownloadArr))

prepAudio :: AudioContext -> { url :: BufferUrl, buffer :: ArrayBuffer } -> Aff { url :: BufferUrl, buffer :: ForwardBackwards }
prepAudio ctx { url, buffer } = do
  forward <- toAffE $ decodeAudioDataFromArrayBuffer ctx buffer
  backwards <- liftEffect $ reverseAudioBuffer ctx forward
  pure { url, buffer: { forward, backwards } }

getBuffersFromPrefetched
  :: Map Sample { url :: BufferUrl, buffer :: ArrayBuffer }
  -> AudioContext
  -> Aff (Map Sample { url :: BufferUrl, buffer :: ForwardBackwards })
getBuffersFromPrefetched nameToArr audioCtx = Map.fromFoldable <$> traversed toMuxArr
  where

  toMuxArr :: Array (Sample /\ { url :: BufferUrl, buffer :: ArrayBuffer })
  toMuxArr = Map.toUnfoldable nameToArr

  traversed :: Array (Sample /\ { url :: BufferUrl, buffer :: ArrayBuffer }) -> Aff (Array (Sample /\ { url :: BufferUrl, buffer :: ForwardBackwards }))
  traversed = traverse \(k /\ v) -> ((/\) k <$> prepAudio audioCtx v)

backoff :: Aff ~> Aff
backoff aff = go 0
  where
  go n
    | n >= 3 = throwError $ error "Maximum download tries exceeded"
    | otherwise = try aff >>= case _ of
        Left err -> Log.error (show err) *> delay (Milliseconds (toNumber (n + 1) * 1000.0)) *> go (n + 1)
        Right val -> pure val

prefetchStuff :: forall event. TheFuture event -> Map Sample BufferUrl
prefetchStuff (TheFuture { earth, wind, fire, air, heart, sounds, preload }) = samplesToUrl
  where
  sets = Set.fromFoldable preload
    <> fold (map v2s [ earth, wind, fire ])
    <> (Set.fromFoldable $ compact ((map <<< map) d2s [ air, heart ]))
  samplesToUrl = Set.toMap sets # Map.mapMaybeWithKey \samp@(Sample k) _ -> Map.lookup samp sounds <|> do
    nm <- O.lookup k nameToSampleO
    url <- Map.lookup nm sampleToUrls
    pure url
