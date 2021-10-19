module WAGSI.Plumbing.Types where

import Prelude

import Data.Either (Either, either)
import Data.Function (on)
import Data.Generic.Rep (class Generic)
import Data.List.Types (NonEmptyList)
import Data.Map (Map)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Set (Set)
import Data.Show.Generic (genericShow)
import Data.Symbol (class IsSymbol)
import Data.Typelevel.Num (class Nat, class Succ, D0, D1, D8)
import Data.Vec as V
import Heterogeneous.Mapping (class MappingWithIndex)
import Prim.Row as Row
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))
import WAGS.Lib.BufferPool (AScoredBufferPool)
import WAGS.Lib.Score (CfNoteStream')
import WAGS.Tumult (Tumultuous)
import WAGS.WebAPI (BrowserAudioBuffer)

--
type IsFresh val = { isFresh :: Boolean, value :: val }

--

type ForwardBackwards = { forward :: BrowserAudioBuffer, backwards :: BrowserAudioBuffer }

newtype BufferUrl = BufferUrl String

derive instance newtypeBufferUrl :: Newtype BufferUrl _
derive instance eqBufferUrl :: Eq BufferUrl
derive instance ordBufferUrl :: Ord BufferUrl
instance showBufferUrl :: Show BufferUrl where
  show (BufferUrl s) = "BufferUrl <" <> s <> ">"

type SampleCache = Map Sample { url :: BufferUrl, buffer :: ForwardBackwards }

--- @@ ---

type RBuf event
  =
  { sampleFoT :: Either (UnsampledTimeIs event -> Sample) Sample
  , forward :: Boolean
  , rateFoT :: FoT event
  , bufferOffsetFoT :: FoT event
  , volumeFoT :: FoT event
  , cycleStartsAt :: Number
  , bigCycleDuration :: Number
  , littleCycleDuration :: Number
  , currentCycle :: Int
  , bigStartsAt :: Number
  , littleStartsAt :: Number
  , duration :: Number
  }

newtype NextCycle event = NextCycle
  { force :: Boolean
  , samples :: Set Sample
  , func ::
      { currentCount :: Number
      , prevCycleEnded :: Number
      , time :: Number
      , headroomInSeconds :: Number
      }
      -> CfNoteStream' (RBuf event) (Next event)
  }

derive instance newtypeNextCycle :: Newtype (NextCycle event) _

newtype Globals event = Globals
  { gain :: O'Past event
  , fx :: ClockTimeIs event -> Tumultuous D1 "output" (voice :: Unit)
  }

derive instance newtypeGlobals :: Newtype (Globals event) _

newtype Voice event = Voice { globals :: Globals event, next :: NextCycle event }

derive instance newtypeVoice :: Newtype (Voice event) _

type EWF' (v :: Type) r = (earth :: v, wind :: v, fire :: v | r)
type EWF (v :: Type) = EWF' v ()

type AH' (v :: Type) r = (air :: v, heart :: v | r)
type AH (v :: Type) = AH' v ()

newtype TheFuture event = TheFuture
  { | EWF' (Voice event)
      ( AH' (Maybe (DroneNote event))
          (sounds :: Map Sample BufferUrl, title :: String, preload :: Array Sample)
      )
  }

derive instance newtypeTheFuture :: Newtype (TheFuture event) _

--- @@ ---
newtype CycleDuration = CycleDuration Number

derive instance newtypeCycleDuration :: Newtype CycleDuration _
derive instance eqCycleDuration :: Eq CycleDuration
derive instance ordCycleDuration :: Ord CycleDuration

newtype NoteInTime note = NoteInTime
  { note :: note
  , startsAt :: Number
  , duration :: Number
  , cycleDuration :: Number
  , tag :: Maybe String
  }

derive instance newtypeNoteInTime :: Newtype (NoteInTime note) _
derive instance genericNoteInTime :: Generic (NoteInTime note) _
derive instance eqNoteInTime :: Eq note => Eq (NoteInTime note)
derive instance ordNoteInTime :: Ord note => Ord (NoteInTime note)
instance showNoteInTime :: Show note => Show (NoteInTime note) where
  show xx = genericShow xx

derive instance functorNoteInTime :: Functor NoteInTime

newtype NoteInFlattenedTime note = NoteInFlattenedTime
  { note :: note
  , bigStartsAt :: Number
  , littleStartsAt :: Number
  , currentCycle :: Int
  , positionInCycle :: Int
  , elementsInCycle :: Int
  , nCycles :: Int
  , duration :: Number
  , bigCycleDuration :: Number
  , littleCycleDuration :: Number
  , tag :: Maybe String
  }

derive instance newtypeNoteInFlattenedTime :: Newtype (NoteInFlattenedTime note) _
derive instance genericNoteInFlattenedTime :: Generic (NoteInFlattenedTime note) _
derive instance eqNoteInFlattenedTime :: Eq note => Eq (NoteInFlattenedTime note)
derive instance ordNoteInFlattenedTime :: Ord note => Ord (NoteInFlattenedTime note)
instance showNoteInFlattenedTime :: Show note => Show (NoteInFlattenedTime note) where
  show xx = genericShow xx

derive instance functorNoteInFlattenedTime :: Functor NoteInFlattenedTime

--
type AfterMatter = { asInternal :: Maybe (NonEmptyList Unit) }

--
type Tag = { tag :: Maybe String }

--

type NBuf
  = D8

type Next event = { next :: NextCycle event }

type Acc event
  =
  { buffers :: { | EWF (AScoredBufferPool (Next event) NBuf (RBuf event)) }
  , backToTheFuture :: TheFuture event
  , justInCaseTheLastEvent :: IsFresh event
  }

----------------

newtype ZipProps fns = ZipProps { | fns }

instance zipProps ::
  ( IsSymbol sym
  , Row.Cons sym (a -> b) x fns
  ) =>
  MappingWithIndex (ZipProps fns) (Proxy sym) a b where
  mappingWithIndex (ZipProps fns) prop = Record.get prop fns

---

class Nat n <= HomogenousToVec (rl :: RL.RowList Type) (r :: Row Type) (n :: Type) (a :: Type) | rl r -> n a where
  h2v' :: forall proxy. proxy rl -> { | r } -> V.Vec n a

instance h2vNil :: HomogenousToVec RL.Nil r D0 a where
  h2v' _ _ = V.empty

instance h2vCons ::
  ( IsSymbol key
  , Row.Lacks key r'
  , Row.Cons key a r' r
  , HomogenousToVec rest r n' a
  , Succ n' n
  ) =>
  HomogenousToVec (RL.Cons key a rest) r n a where
  h2v' _ r = V.cons (Record.get (Proxy :: _ key) r) (h2v' (Proxy :: _ rest) r)

---
data ICycle a
  = IBranching { nel :: NonEmptyList (ICycle a), env :: { weight :: Number, tag :: Maybe String } }
  | ISimultaneous { nel :: NonEmptyList (ICycle a), env :: { weight :: Number, tag :: Maybe String } }
  | ISequential { nel :: NonEmptyList (ICycle a), env :: { weight :: Number, tag :: Maybe String } }
  | IInternal { nel :: NonEmptyList (ICycle a), env :: { weight :: Number, tag :: Maybe String } }
  | ISingleNote { val :: a, env :: { weight :: Number, tag :: Maybe String } }

----
newtype DroneNote event = DroneNote
  { sample :: Sample
  , forward :: Boolean
  , rateFoT :: O'Past event
  , loopStartFoT :: O'Past event
  , loopEndFoT :: O'Past event
  , volumeFoT :: O'Past event
  , tumultFoT :: ClockTimeIs event -> Tumultuous D1 "output" (voice :: Unit)
  }

derive instance newtypeDroneNote :: Newtype (DroneNote event) _
derive instance genericDroneNote :: Generic (DroneNote event) _
instance eqDroneNote :: Eq (DroneNote event) where
  eq = eq `on` (unwrap >>> _.sample)

instance ordDroneNote :: Ord (DroneNote event) where
  compare = compare `on` (unwrap >>> _.sample)

instance showDroneNote :: Show (DroneNote event) where
  show (DroneNote { sample }) = "DroneNote <" <> show sample <> ">"

----

newtype Note event = Note
  { sampleFoT :: Either (UnsampledTimeIs event -> Sample) Sample
  , forward :: Boolean
  , rateFoT :: FoT event
  , bufferOffsetFoT :: FoT event
  , volumeFoT :: FoT event
  }

unlockSample :: forall event. event -> UnsampledTimeIs event
unlockSample event = UnsampledTimeIs
  { clockTime: 0.0
  , event: { isFresh: true, value: event }
  , bigCycleTime: 0.0
  , littleCycleTime: 0.0
  , normalizedClockTime: 0.0
  , normalizedBigCycleTime: 0.0
  , normalizedLittleCycleTime: 0.0
  , littleCycleDuration: 0.0
  , bigCycleDuration: 0.0
  , entropy: 0.0
  , initialEntropy: 0.0
  }

derive instance newtypeNote :: Newtype (Note event) _
derive instance genericNote :: Generic (Note event) _
instance eqNote :: Monoid event => Eq (Note event) where
  eq = eq `on` (unwrap >>> _.sampleFoT >>> either ((#) (unlockSample mempty)) identity)

instance ordNote :: Monoid event => Ord (Note event) where
  compare = compare `on` (unwrap >>> _.sampleFoT >>> (either ((#) (unlockSample mempty)) identity))

instance showNote :: Monoid event => Show (Note event) where
  show (Note { sampleFoT }) = "Note <" <> show (either ((#) (unlockSample mempty)) identity sampleFoT) <> ">"

----------------------------------

newtype Sample = Sample String

derive instance sampleNewtype :: Newtype Sample _
derive instance sampleEq :: Eq Sample
derive instance sampleOrd :: Ord Sample
instance sampleShow :: Show Sample where
  show (Sample i) = "Sample <" <> show i <> ">"

newtype ClockTimeIs event = ClockTimeIs
  { clockTime :: Number
  , event :: IsFresh event
  , entropy :: Number
  }

derive instance newtypeClockTimeIs :: Newtype (ClockTimeIs event) _

newtype UnsampledTimeIs event =
  UnsampledTimeIs
    { event :: IsFresh event
    , clockTime :: Number
    , bigCycleTime :: Number
    , littleCycleTime :: Number
    , normalizedClockTime :: Number
    , normalizedBigCycleTime :: Number
    , normalizedLittleCycleTime :: Number
    , littleCycleDuration :: Number
    , bigCycleDuration :: Number
    , entropy :: Number
    , initialEntropy :: Number
    }

derive instance newtypeUnsampledTimeIs :: Newtype (UnsampledTimeIs event) _

newtype TimeIs event =
  TimeIs
    { event :: IsFresh event
    , clockTime :: Number
    , sampleTime :: Number
    , bigCycleTime :: Number
    , littleCycleTime :: Number
    , normalizedClockTime :: Number
    , normalizedSampleTime :: Number
    , normalizedBigCycleTime :: Number
    , normalizedLittleCycleTime :: Number
    , littleCycleDuration :: Number
    , bigCycleDuration :: Number
    , bufferDuration :: Number
    , entropy :: Number
    , initialEntropy :: Number
    }

derive instance newtypeTimeIs :: Newtype (TimeIs event) _

newtype TimeIsAndWas time = TimeIsAndWas
  { timeIs :: time
  , valWas :: Maybe Number
  , timeWas :: Maybe time
  }

derive instance newtypeTimeIsAndWas :: Newtype (TimeIsAndWas time) _

type O'Clock event = ClockTimeIs event -> Number
type O'Past event = TimeIsAndWas (ClockTimeIs event) -> Number
type FoT event = TimeIs event -> Number
type FoP event = TimeIsAndWas (TimeIs event) -> Number

---------------------------------- samples
newtype Samples a = Samples { | Samples' a }

derive instance newtypeSamples :: Newtype (Samples a) _

type Samples' (a :: Type) =
  ( intentionalSilenceForInternalUseOnly :: a
  , "kicklinn:0" :: a
  , "msg:0" :: a
  , "msg:1" :: a
  , "msg:2" :: a
  , "msg:3" :: a
  , "msg:4" :: a
  , "msg:5" :: a
  , "msg:6" :: a
  , "msg:7" :: a
  , "msg:8" :: a
  , "gabbalouder:0" :: a
  , "gabbalouder:1" :: a
  , "gabbalouder:2" :: a
  , "gabbalouder:3" :: a
  , "kurt:0" :: a
  , "kurt:1" :: a
  , "kurt:2" :: a
  , "kurt:3" :: a
  , "kurt:4" :: a
  , "kurt:5" :: a
  , "kurt:6" :: a
  , "bassdm:0" :: a
  , "bassdm:1" :: a
  , "bassdm:2" :: a
  , "bassdm:3" :: a
  , "bassdm:4" :: a
  , "bassdm:5" :: a
  , "bassdm:6" :: a
  , "bassdm:7" :: a
  , "bassdm:8" :: a
  , "bassdm:9" :: a
  , "bassdm:10" :: a
  , "bassdm:11" :: a
  , "bassdm:12" :: a
  , "bassdm:13" :: a
  , "bassdm:14" :: a
  , "bassdm:15" :: a
  , "bassdm:16" :: a
  , "bassdm:17" :: a
  , "bassdm:18" :: a
  , "bassdm:19" :: a
  , "bassdm:20" :: a
  , "bassdm:21" :: a
  , "bassdm:22" :: a
  , "bassdm:23" :: a
  , "tabla2:0" :: a
  , "tabla2:1" :: a
  , "tabla2:2" :: a
  , "tabla2:3" :: a
  , "tabla2:4" :: a
  , "tabla2:5" :: a
  , "tabla2:6" :: a
  , "tabla2:7" :: a
  , "tabla2:8" :: a
  , "tabla2:9" :: a
  , "tabla2:10" :: a
  , "tabla2:11" :: a
  , "tabla2:12" :: a
  , "tabla2:13" :: a
  , "tabla2:14" :: a
  , "tabla2:15" :: a
  , "tabla2:16" :: a
  , "tabla2:17" :: a
  , "tabla2:18" :: a
  , "tabla2:19" :: a
  , "tabla2:20" :: a
  , "tabla2:21" :: a
  , "tabla2:22" :: a
  , "tabla2:23" :: a
  , "tabla2:24" :: a
  , "tabla2:25" :: a
  , "tabla2:26" :: a
  , "tabla2:27" :: a
  , "tabla2:28" :: a
  , "tabla2:29" :: a
  , "tabla2:30" :: a
  , "tabla2:31" :: a
  , "tabla2:32" :: a
  , "tabla2:33" :: a
  , "tabla2:34" :: a
  , "tabla2:35" :: a
  , "tabla2:36" :: a
  , "tabla2:37" :: a
  , "tabla2:38" :: a
  , "tabla2:39" :: a
  , "tabla2:40" :: a
  , "tabla2:41" :: a
  , "tabla2:42" :: a
  , "tabla2:43" :: a
  , "tabla2:44" :: a
  , "tabla2:45" :: a
  , "chin:0" :: a
  , "chin:1" :: a
  , "chin:2" :: a
  , "chin:3" :: a
  , "mp3:0" :: a
  , "mp3:1" :: a
  , "mp3:2" :: a
  , "mp3:3" :: a
  , "tablex:0" :: a
  , "tablex:1" :: a
  , "tablex:2" :: a
  , "sf:0" :: a
  , "sf:1" :: a
  , "sf:2" :: a
  , "sf:3" :: a
  , "sf:4" :: a
  , "sf:5" :: a
  , "sf:6" :: a
  , "sf:7" :: a
  , "sf:8" :: a
  , "sf:9" :: a
  , "sf:10" :: a
  , "sf:11" :: a
  , "sf:12" :: a
  , "sf:13" :: a
  , "sf:14" :: a
  , "sf:15" :: a
  , "sf:16" :: a
  , "sf:17" :: a
  , "speakspell:0" :: a
  , "speakspell:1" :: a
  , "speakspell:2" :: a
  , "speakspell:3" :: a
  , "speakspell:4" :: a
  , "speakspell:5" :: a
  , "speakspell:6" :: a
  , "speakspell:7" :: a
  , "speakspell:8" :: a
  , "speakspell:9" :: a
  , "speakspell:10" :: a
  , "speakspell:11" :: a
  , "cc:0" :: a
  , "cc:1" :: a
  , "cc:2" :: a
  , "cc:3" :: a
  , "cc:4" :: a
  , "cc:5" :: a
  , "gabbaloud:0" :: a
  , "gabbaloud:1" :: a
  , "gabbaloud:2" :: a
  , "gabbaloud:3" :: a
  , "ades2:0" :: a
  , "ades2:1" :: a
  , "ades2:2" :: a
  , "ades2:3" :: a
  , "ades2:4" :: a
  , "ades2:5" :: a
  , "ades2:6" :: a
  , "ades2:7" :: a
  , "ades2:8" :: a
  , "space:0" :: a
  , "space:1" :: a
  , "space:2" :: a
  , "space:3" :: a
  , "space:4" :: a
  , "space:5" :: a
  , "space:6" :: a
  , "space:7" :: a
  , "space:8" :: a
  , "space:9" :: a
  , "space:10" :: a
  , "space:11" :: a
  , "space:12" :: a
  , "space:13" :: a
  , "space:14" :: a
  , "space:15" :: a
  , "space:16" :: a
  , "space:17" :: a
  , "battles:0" :: a
  , "battles:1" :: a
  , "voodoo:0" :: a
  , "voodoo:1" :: a
  , "voodoo:2" :: a
  , "voodoo:3" :: a
  , "voodoo:4" :: a
  , "ravemono:0" :: a
  , "ravemono:1" :: a
  , "psr:0" :: a
  , "psr:1" :: a
  , "psr:2" :: a
  , "psr:3" :: a
  , "psr:4" :: a
  , "psr:5" :: a
  , "psr:6" :: a
  , "psr:7" :: a
  , "psr:8" :: a
  , "psr:9" :: a
  , "psr:10" :: a
  , "psr:11" :: a
  , "psr:12" :: a
  , "psr:13" :: a
  , "psr:14" :: a
  , "psr:15" :: a
  , "psr:16" :: a
  , "psr:17" :: a
  , "psr:18" :: a
  , "psr:19" :: a
  , "psr:20" :: a
  , "psr:21" :: a
  , "psr:22" :: a
  , "psr:23" :: a
  , "psr:24" :: a
  , "psr:25" :: a
  , "psr:26" :: a
  , "psr:27" :: a
  , "psr:28" :: a
  , "psr:29" :: a
  , "metal:0" :: a
  , "metal:1" :: a
  , "metal:2" :: a
  , "metal:3" :: a
  , "metal:4" :: a
  , "metal:5" :: a
  , "metal:6" :: a
  , "metal:7" :: a
  , "metal:8" :: a
  , "metal:9" :: a
  , "hardcore:0" :: a
  , "hardcore:1" :: a
  , "hardcore:2" :: a
  , "hardcore:3" :: a
  , "hardcore:4" :: a
  , "hardcore:5" :: a
  , "hardcore:6" :: a
  , "hardcore:7" :: a
  , "hardcore:8" :: a
  , "hardcore:9" :: a
  , "hardcore:10" :: a
  , "hardcore:11" :: a
  , "mouth:0" :: a
  , "mouth:1" :: a
  , "mouth:2" :: a
  , "mouth:3" :: a
  , "mouth:4" :: a
  , "mouth:5" :: a
  , "mouth:6" :: a
  , "mouth:7" :: a
  , "mouth:8" :: a
  , "mouth:9" :: a
  , "mouth:10" :: a
  , "mouth:11" :: a
  , "mouth:12" :: a
  , "mouth:13" :: a
  , "mouth:14" :: a
  , "sugar:0" :: a
  , "sugar:1" :: a
  , "odx:0" :: a
  , "odx:1" :: a
  , "odx:2" :: a
  , "odx:3" :: a
  , "odx:4" :: a
  , "odx:5" :: a
  , "odx:6" :: a
  , "odx:7" :: a
  , "odx:8" :: a
  , "odx:9" :: a
  , "odx:10" :: a
  , "odx:11" :: a
  , "odx:12" :: a
  , "odx:13" :: a
  , "odx:14" :: a
  , "x_808lc:0" :: a
  , "x_808lc:1" :: a
  , "x_808lc:2" :: a
  , "x_808lc:3" :: a
  , "x_808lc:4" :: a
  , "mt:0" :: a
  , "mt:1" :: a
  , "mt:2" :: a
  , "mt:3" :: a
  , "mt:4" :: a
  , "mt:5" :: a
  , "mt:6" :: a
  , "mt:7" :: a
  , "mt:8" :: a
  , "mt:9" :: a
  , "mt:10" :: a
  , "mt:11" :: a
  , "mt:12" :: a
  , "mt:13" :: a
  , "mt:14" :: a
  , "mt:15" :: a
  , "drumtraks:0" :: a
  , "drumtraks:1" :: a
  , "drumtraks:2" :: a
  , "drumtraks:3" :: a
  , "drumtraks:4" :: a
  , "drumtraks:5" :: a
  , "drumtraks:6" :: a
  , "drumtraks:7" :: a
  , "drumtraks:8" :: a
  , "drumtraks:9" :: a
  , "drumtraks:10" :: a
  , "drumtraks:11" :: a
  , "drumtraks:12" :: a
  , "print:0" :: a
  , "print:1" :: a
  , "print:2" :: a
  , "print:3" :: a
  , "print:4" :: a
  , "print:5" :: a
  , "print:6" :: a
  , "print:7" :: a
  , "print:8" :: a
  , "print:9" :: a
  , "print:10" :: a
  , "blip:0" :: a
  , "blip:1" :: a
  , "wobble:0" :: a
  , "made:0" :: a
  , "made:1" :: a
  , "made:2" :: a
  , "made:3" :: a
  , "made:4" :: a
  , "made:5" :: a
  , "made:6" :: a
  , "bass3:0" :: a
  , "bass3:1" :: a
  , "bass3:2" :: a
  , "bass3:3" :: a
  , "bass3:4" :: a
  , "bass3:5" :: a
  , "bass3:6" :: a
  , "bass3:7" :: a
  , "bass3:8" :: a
  , "bass3:9" :: a
  , "bass3:10" :: a
  , "speechless:0" :: a
  , "speechless:1" :: a
  , "speechless:2" :: a
  , "speechless:3" :: a
  , "speechless:4" :: a
  , "speechless:5" :: a
  , "speechless:6" :: a
  , "speechless:7" :: a
  , "speechless:8" :: a
  , "speechless:9" :: a
  , "sine:0" :: a
  , "sine:1" :: a
  , "sine:2" :: a
  , "sine:3" :: a
  , "sine:4" :: a
  , "sine:5" :: a
  , "noise:0" :: a
  , "x_808lt:0" :: a
  , "x_808lt:1" :: a
  , "x_808lt:2" :: a
  , "x_808lt:3" :: a
  , "x_808lt:4" :: a
  , "sd:0" :: a
  , "sd:1" :: a
  , "alphabet:0" :: a
  , "alphabet:1" :: a
  , "alphabet:2" :: a
  , "alphabet:3" :: a
  , "alphabet:4" :: a
  , "alphabet:5" :: a
  , "alphabet:6" :: a
  , "alphabet:7" :: a
  , "alphabet:8" :: a
  , "alphabet:9" :: a
  , "alphabet:10" :: a
  , "alphabet:11" :: a
  , "alphabet:12" :: a
  , "alphabet:13" :: a
  , "alphabet:14" :: a
  , "alphabet:15" :: a
  , "alphabet:16" :: a
  , "alphabet:17" :: a
  , "alphabet:18" :: a
  , "alphabet:19" :: a
  , "alphabet:20" :: a
  , "alphabet:21" :: a
  , "alphabet:22" :: a
  , "alphabet:23" :: a
  , "alphabet:24" :: a
  , "alphabet:25" :: a
  , "baa2:0" :: a
  , "baa2:1" :: a
  , "baa2:2" :: a
  , "baa2:3" :: a
  , "baa2:4" :: a
  , "baa2:5" :: a
  , "baa2:6" :: a
  , "tok:0" :: a
  , "tok:1" :: a
  , "tok:2" :: a
  , "tok:3" :: a
  , "ades3:0" :: a
  , "ades3:1" :: a
  , "ades3:2" :: a
  , "ades3:3" :: a
  , "ades3:4" :: a
  , "ades3:5" :: a
  , "ades3:6" :: a
  , "x_909:0" :: a
  , "sid:0" :: a
  , "sid:1" :: a
  , "sid:2" :: a
  , "sid:3" :: a
  , "sid:4" :: a
  , "sid:5" :: a
  , "sid:6" :: a
  , "sid:7" :: a
  , "sid:8" :: a
  , "sid:9" :: a
  , "sid:10" :: a
  , "sid:11" :: a
  , "jungbass:0" :: a
  , "jungbass:1" :: a
  , "jungbass:2" :: a
  , "jungbass:3" :: a
  , "jungbass:4" :: a
  , "jungbass:5" :: a
  , "jungbass:6" :: a
  , "jungbass:7" :: a
  , "jungbass:8" :: a
  , "jungbass:9" :: a
  , "jungbass:10" :: a
  , "jungbass:11" :: a
  , "jungbass:12" :: a
  , "jungbass:13" :: a
  , "jungbass:14" :: a
  , "jungbass:15" :: a
  , "jungbass:16" :: a
  , "jungbass:17" :: a
  , "jungbass:18" :: a
  , "jungbass:19" :: a
  , "gabba:0" :: a
  , "gabba:1" :: a
  , "gabba:2" :: a
  , "gabba:3" :: a
  , "crow:0" :: a
  , "crow:1" :: a
  , "crow:2" :: a
  , "crow:3" :: a
  , "birds3:0" :: a
  , "birds3:1" :: a
  , "birds3:2" :: a
  , "birds3:3" :: a
  , "birds3:4" :: a
  , "birds3:5" :: a
  , "birds3:6" :: a
  , "birds3:7" :: a
  , "birds3:8" :: a
  , "birds3:9" :: a
  , "birds3:10" :: a
  , "birds3:11" :: a
  , "birds3:12" :: a
  , "birds3:13" :: a
  , "birds3:14" :: a
  , "birds3:15" :: a
  , "birds3:16" :: a
  , "birds3:17" :: a
  , "birds3:18" :: a
  , "auto:0" :: a
  , "auto:1" :: a
  , "auto:2" :: a
  , "auto:3" :: a
  , "auto:4" :: a
  , "auto:5" :: a
  , "auto:6" :: a
  , "auto:7" :: a
  , "auto:8" :: a
  , "auto:9" :: a
  , "auto:10" :: a
  , "mute:0" :: a
  , "mute:1" :: a
  , "mute:2" :: a
  , "mute:3" :: a
  , "mute:4" :: a
  , "mute:5" :: a
  , "mute:6" :: a
  , "mute:7" :: a
  , "mute:8" :: a
  , "mute:9" :: a
  , "mute:10" :: a
  , "mute:11" :: a
  , "mute:12" :: a
  , "mute:13" :: a
  , "mute:14" :: a
  , "mute:15" :: a
  , "mute:16" :: a
  , "mute:17" :: a
  , "mute:18" :: a
  , "mute:19" :: a
  , "mute:20" :: a
  , "mute:21" :: a
  , "mute:22" :: a
  , "mute:23" :: a
  , "mute:24" :: a
  , "mute:25" :: a
  , "mute:26" :: a
  , "mute:27" :: a
  , "sheffield:0" :: a
  , "casio:0" :: a
  , "casio:1" :: a
  , "casio:2" :: a
  , "sax:0" :: a
  , "sax:1" :: a
  , "sax:2" :: a
  , "sax:3" :: a
  , "sax:4" :: a
  , "sax:5" :: a
  , "sax:6" :: a
  , "sax:7" :: a
  , "sax:8" :: a
  , "sax:9" :: a
  , "sax:10" :: a
  , "sax:11" :: a
  , "sax:12" :: a
  , "sax:13" :: a
  , "sax:14" :: a
  , "sax:15" :: a
  , "sax:16" :: a
  , "sax:17" :: a
  , "sax:18" :: a
  , "sax:19" :: a
  , "sax:20" :: a
  , "sax:21" :: a
  , "circus:0" :: a
  , "circus:1" :: a
  , "circus:2" :: a
  , "yeah:0" :: a
  , "yeah:1" :: a
  , "yeah:2" :: a
  , "yeah:3" :: a
  , "yeah:4" :: a
  , "yeah:5" :: a
  , "yeah:6" :: a
  , "yeah:7" :: a
  , "yeah:8" :: a
  , "yeah:9" :: a
  , "yeah:10" :: a
  , "yeah:11" :: a
  , "yeah:12" :: a
  , "yeah:13" :: a
  , "yeah:14" :: a
  , "yeah:15" :: a
  , "yeah:16" :: a
  , "yeah:17" :: a
  , "yeah:18" :: a
  , "yeah:19" :: a
  , "yeah:20" :: a
  , "yeah:21" :: a
  , "yeah:22" :: a
  , "yeah:23" :: a
  , "yeah:24" :: a
  , "yeah:25" :: a
  , "yeah:26" :: a
  , "yeah:27" :: a
  , "yeah:28" :: a
  , "yeah:29" :: a
  , "yeah:30" :: a
  , "oc:0" :: a
  , "oc:1" :: a
  , "oc:2" :: a
  , "oc:3" :: a
  , "alex:0" :: a
  , "alex:1" :: a
  , "can:0" :: a
  , "can:1" :: a
  , "can:2" :: a
  , "can:3" :: a
  , "can:4" :: a
  , "can:5" :: a
  , "can:6" :: a
  , "can:7" :: a
  , "can:8" :: a
  , "can:9" :: a
  , "can:10" :: a
  , "can:11" :: a
  , "can:12" :: a
  , "can:13" :: a
  , "jungle:0" :: a
  , "jungle:1" :: a
  , "jungle:2" :: a
  , "jungle:3" :: a
  , "jungle:4" :: a
  , "jungle:5" :: a
  , "jungle:6" :: a
  , "jungle:7" :: a
  , "jungle:8" :: a
  , "jungle:9" :: a
  , "jungle:10" :: a
  , "jungle:11" :: a
  , "jungle:12" :: a
  , "moog:0" :: a
  , "moog:1" :: a
  , "moog:2" :: a
  , "moog:3" :: a
  , "moog:4" :: a
  , "moog:5" :: a
  , "moog:6" :: a
  , "h:0" :: a
  , "h:1" :: a
  , "h:2" :: a
  , "h:3" :: a
  , "h:4" :: a
  , "h:5" :: a
  , "h:6" :: a
  , "wind:0" :: a
  , "wind:1" :: a
  , "wind:2" :: a
  , "wind:3" :: a
  , "wind:4" :: a
  , "wind:5" :: a
  , "wind:6" :: a
  , "wind:7" :: a
  , "wind:8" :: a
  , "wind:9" :: a
  , "rs:0" :: a
  , "em2:0" :: a
  , "em2:1" :: a
  , "em2:2" :: a
  , "em2:3" :: a
  , "em2:4" :: a
  , "em2:5" :: a
  , "noise2:0" :: a
  , "noise2:1" :: a
  , "noise2:2" :: a
  , "noise2:3" :: a
  , "noise2:4" :: a
  , "noise2:5" :: a
  , "noise2:6" :: a
  , "noise2:7" :: a
  , "foo:0" :: a
  , "foo:1" :: a
  , "foo:2" :: a
  , "foo:3" :: a
  , "foo:4" :: a
  , "foo:5" :: a
  , "foo:6" :: a
  , "foo:7" :: a
  , "foo:8" :: a
  , "foo:9" :: a
  , "foo:10" :: a
  , "foo:11" :: a
  , "foo:12" :: a
  , "foo:13" :: a
  , "foo:14" :: a
  , "foo:15" :: a
  , "foo:16" :: a
  , "foo:17" :: a
  , "foo:18" :: a
  , "foo:19" :: a
  , "foo:20" :: a
  , "foo:21" :: a
  , "foo:22" :: a
  , "foo:23" :: a
  , "foo:24" :: a
  , "foo:25" :: a
  , "foo:26" :: a
  , "armora:0" :: a
  , "armora:1" :: a
  , "armora:2" :: a
  , "armora:3" :: a
  , "armora:4" :: a
  , "armora:5" :: a
  , "armora:6" :: a
  , "bend:0" :: a
  , "bend:1" :: a
  , "bend:2" :: a
  , "bend:3" :: a
  , "newnotes:0" :: a
  , "newnotes:1" :: a
  , "newnotes:2" :: a
  , "newnotes:3" :: a
  , "newnotes:4" :: a
  , "newnotes:5" :: a
  , "newnotes:6" :: a
  , "newnotes:7" :: a
  , "newnotes:8" :: a
  , "newnotes:9" :: a
  , "newnotes:10" :: a
  , "newnotes:11" :: a
  , "newnotes:12" :: a
  , "newnotes:13" :: a
  , "newnotes:14" :: a
  , "pebbles:0" :: a
  , "mash2:0" :: a
  , "mash2:1" :: a
  , "mash2:2" :: a
  , "mash2:3" :: a
  , "diphone2:0" :: a
  , "diphone2:1" :: a
  , "diphone2:2" :: a
  , "diphone2:3" :: a
  , "diphone2:4" :: a
  , "diphone2:5" :: a
  , "diphone2:6" :: a
  , "diphone2:7" :: a
  , "diphone2:8" :: a
  , "diphone2:9" :: a
  , "diphone2:10" :: a
  , "diphone2:11" :: a
  , "e:0" :: a
  , "e:1" :: a
  , "e:2" :: a
  , "e:3" :: a
  , "e:4" :: a
  , "e:5" :: a
  , "e:6" :: a
  , "e:7" :: a
  , "bubble:0" :: a
  , "bubble:1" :: a
  , "bubble:2" :: a
  , "bubble:3" :: a
  , "bubble:4" :: a
  , "bubble:5" :: a
  , "bubble:6" :: a
  , "bubble:7" :: a
  , "insect:0" :: a
  , "insect:1" :: a
  , "insect:2" :: a
  , "ade:0" :: a
  , "ade:1" :: a
  , "ade:2" :: a
  , "ade:3" :: a
  , "ade:4" :: a
  , "ade:5" :: a
  , "ade:6" :: a
  , "ade:7" :: a
  , "ade:8" :: a
  , "ade:9" :: a
  , "glitch:0" :: a
  , "glitch:1" :: a
  , "glitch:2" :: a
  , "glitch:3" :: a
  , "glitch:4" :: a
  , "glitch:5" :: a
  , "glitch:6" :: a
  , "glitch:7" :: a
  , "haw:0" :: a
  , "haw:1" :: a
  , "haw:2" :: a
  , "haw:3" :: a
  , "haw:4" :: a
  , "haw:5" :: a
  , "popkick:0" :: a
  , "popkick:1" :: a
  , "popkick:2" :: a
  , "popkick:3" :: a
  , "popkick:4" :: a
  , "popkick:5" :: a
  , "popkick:6" :: a
  , "popkick:7" :: a
  , "popkick:8" :: a
  , "popkick:9" :: a
  , "breaks157:0" :: a
  , "gtr:0" :: a
  , "gtr:1" :: a
  , "gtr:2" :: a
  , "clubkick:0" :: a
  , "clubkick:1" :: a
  , "clubkick:2" :: a
  , "clubkick:3" :: a
  , "clubkick:4" :: a
  , "breaks152:0" :: a
  , "x_808bd:0" :: a
  , "x_808bd:1" :: a
  , "x_808bd:2" :: a
  , "x_808bd:3" :: a
  , "x_808bd:4" :: a
  , "x_808bd:5" :: a
  , "x_808bd:6" :: a
  , "x_808bd:7" :: a
  , "x_808bd:8" :: a
  , "x_808bd:9" :: a
  , "x_808bd:10" :: a
  , "x_808bd:11" :: a
  , "x_808bd:12" :: a
  , "x_808bd:13" :: a
  , "x_808bd:14" :: a
  , "x_808bd:15" :: a
  , "x_808bd:16" :: a
  , "x_808bd:17" :: a
  , "x_808bd:18" :: a
  , "x_808bd:19" :: a
  , "x_808bd:20" :: a
  , "x_808bd:21" :: a
  , "x_808bd:22" :: a
  , "x_808bd:23" :: a
  , "x_808bd:24" :: a
  , "miniyeah:0" :: a
  , "miniyeah:1" :: a
  , "miniyeah:2" :: a
  , "miniyeah:3" :: a
  , "if:0" :: a
  , "if:1" :: a
  , "if:2" :: a
  , "if:3" :: a
  , "if:4" :: a
  , "x_808oh:0" :: a
  , "x_808oh:1" :: a
  , "x_808oh:2" :: a
  , "x_808oh:3" :: a
  , "x_808oh:4" :: a
  , "house:0" :: a
  , "house:1" :: a
  , "house:2" :: a
  , "house:3" :: a
  , "house:4" :: a
  , "house:5" :: a
  , "house:6" :: a
  , "house:7" :: a
  , "dr:0" :: a
  , "dr:1" :: a
  , "dr:2" :: a
  , "dr:3" :: a
  , "dr:4" :: a
  , "dr:5" :: a
  , "dr:6" :: a
  , "dr:7" :: a
  , "dr:8" :: a
  , "dr:9" :: a
  , "dr:10" :: a
  , "dr:11" :: a
  , "dr:12" :: a
  , "dr:13" :: a
  , "dr:14" :: a
  , "dr:15" :: a
  , "dr:16" :: a
  , "dr:17" :: a
  , "dr:18" :: a
  , "dr:19" :: a
  , "dr:20" :: a
  , "dr:21" :: a
  , "dr:22" :: a
  , "dr:23" :: a
  , "dr:24" :: a
  , "dr:25" :: a
  , "dr:26" :: a
  , "dr:27" :: a
  , "dr:28" :: a
  , "dr:29" :: a
  , "dr:30" :: a
  , "dr:31" :: a
  , "dr:32" :: a
  , "dr:33" :: a
  , "dr:34" :: a
  , "dr:35" :: a
  , "dr:36" :: a
  , "dr:37" :: a
  , "dr:38" :: a
  , "dr:39" :: a
  , "dr:40" :: a
  , "dr:41" :: a
  , "dr55:0" :: a
  , "dr55:1" :: a
  , "dr55:2" :: a
  , "dr55:3" :: a
  , "bass:0" :: a
  , "bass:1" :: a
  , "bass:2" :: a
  , "bass:3" :: a
  , "ho:0" :: a
  , "ho:1" :: a
  , "ho:2" :: a
  , "ho:3" :: a
  , "ho:4" :: a
  , "ho:5" :: a
  , "hardkick:0" :: a
  , "hardkick:1" :: a
  , "hardkick:2" :: a
  , "hardkick:3" :: a
  , "hardkick:4" :: a
  , "hardkick:5" :: a
  , "x_808hc:0" :: a
  , "x_808hc:1" :: a
  , "x_808hc:2" :: a
  , "x_808hc:3" :: a
  , "x_808hc:4" :: a
  , "hit:0" :: a
  , "hit:1" :: a
  , "hit:2" :: a
  , "hit:3" :: a
  , "hit:4" :: a
  , "hit:5" :: a
  , "breaks165:0" :: a
  , "dr2:0" :: a
  , "dr2:1" :: a
  , "dr2:2" :: a
  , "dr2:3" :: a
  , "dr2:4" :: a
  , "dr2:5" :: a
  , "tabla:0" :: a
  , "tabla:1" :: a
  , "tabla:2" :: a
  , "tabla:3" :: a
  , "tabla:4" :: a
  , "tabla:5" :: a
  , "tabla:6" :: a
  , "tabla:7" :: a
  , "tabla:8" :: a
  , "tabla:9" :: a
  , "tabla:10" :: a
  , "tabla:11" :: a
  , "tabla:12" :: a
  , "tabla:13" :: a
  , "tabla:14" :: a
  , "tabla:15" :: a
  , "tabla:16" :: a
  , "tabla:17" :: a
  , "tabla:18" :: a
  , "tabla:19" :: a
  , "tabla:20" :: a
  , "tabla:21" :: a
  , "tabla:22" :: a
  , "tabla:23" :: a
  , "tabla:24" :: a
  , "tabla:25" :: a
  , "dork2:0" :: a
  , "dork2:1" :: a
  , "dork2:2" :: a
  , "dork2:3" :: a
  , "hc:0" :: a
  , "hc:1" :: a
  , "hc:2" :: a
  , "hc:3" :: a
  , "hc:4" :: a
  , "hc:5" :: a
  , "bassfoo:0" :: a
  , "bassfoo:1" :: a
  , "bassfoo:2" :: a
  , "seawolf:0" :: a
  , "seawolf:1" :: a
  , "seawolf:2" :: a
  , "cp:0" :: a
  , "cp:1" :: a
  , "jazz:0" :: a
  , "jazz:1" :: a
  , "jazz:2" :: a
  , "jazz:3" :: a
  , "jazz:4" :: a
  , "jazz:5" :: a
  , "jazz:6" :: a
  , "jazz:7" :: a
  , "juno:0" :: a
  , "juno:1" :: a
  , "juno:2" :: a
  , "juno:3" :: a
  , "juno:4" :: a
  , "juno:5" :: a
  , "juno:6" :: a
  , "juno:7" :: a
  , "juno:8" :: a
  , "juno:9" :: a
  , "juno:10" :: a
  , "juno:11" :: a
  , "birds:0" :: a
  , "birds:1" :: a
  , "birds:2" :: a
  , "birds:3" :: a
  , "birds:4" :: a
  , "birds:5" :: a
  , "birds:6" :: a
  , "birds:7" :: a
  , "birds:8" :: a
  , "birds:9" :: a
  , "glasstap:0" :: a
  , "glasstap:1" :: a
  , "glasstap:2" :: a
  , "bass1:0" :: a
  , "bass1:1" :: a
  , "bass1:2" :: a
  , "bass1:3" :: a
  , "bass1:4" :: a
  , "bass1:5" :: a
  , "bass1:6" :: a
  , "bass1:7" :: a
  , "bass1:8" :: a
  , "bass1:9" :: a
  , "bass1:10" :: a
  , "bass1:11" :: a
  , "bass1:12" :: a
  , "bass1:13" :: a
  , "bass1:14" :: a
  , "bass1:15" :: a
  , "bass1:16" :: a
  , "bass1:17" :: a
  , "bass1:18" :: a
  , "bass1:19" :: a
  , "bass1:20" :: a
  , "bass1:21" :: a
  , "bass1:22" :: a
  , "bass1:23" :: a
  , "bass1:24" :: a
  , "bass1:25" :: a
  , "bass1:26" :: a
  , "bass1:27" :: a
  , "bass1:28" :: a
  , "bass1:29" :: a
  , "hh27:0" :: a
  , "hh27:1" :: a
  , "hh27:2" :: a
  , "hh27:3" :: a
  , "hh27:4" :: a
  , "hh27:5" :: a
  , "hh27:6" :: a
  , "hh27:7" :: a
  , "hh27:8" :: a
  , "hh27:9" :: a
  , "hh27:10" :: a
  , "hh27:11" :: a
  , "hh27:12" :: a
  , "x_808:0" :: a
  , "x_808:1" :: a
  , "x_808:2" :: a
  , "x_808:3" :: a
  , "x_808:4" :: a
  , "x_808:5" :: a
  , "notes:0" :: a
  , "notes:1" :: a
  , "notes:2" :: a
  , "notes:3" :: a
  , "notes:4" :: a
  , "notes:5" :: a
  , "notes:6" :: a
  , "notes:7" :: a
  , "notes:8" :: a
  , "notes:9" :: a
  , "notes:10" :: a
  , "notes:11" :: a
  , "notes:12" :: a
  , "notes:13" :: a
  , "notes:14" :: a
  , "xmas:0" :: a
  , "erk:0" :: a
  , "x_808mt:0" :: a
  , "x_808mt:1" :: a
  , "x_808mt:2" :: a
  , "x_808mt:3" :: a
  , "x_808mt:4" :: a
  , "lighter:0" :: a
  , "lighter:1" :: a
  , "lighter:2" :: a
  , "lighter:3" :: a
  , "lighter:4" :: a
  , "lighter:5" :: a
  , "lighter:6" :: a
  , "lighter:7" :: a
  , "lighter:8" :: a
  , "lighter:9" :: a
  , "lighter:10" :: a
  , "lighter:11" :: a
  , "lighter:12" :: a
  , "lighter:13" :: a
  , "lighter:14" :: a
  , "lighter:15" :: a
  , "lighter:16" :: a
  , "lighter:17" :: a
  , "lighter:18" :: a
  , "lighter:19" :: a
  , "lighter:20" :: a
  , "lighter:21" :: a
  , "lighter:22" :: a
  , "lighter:23" :: a
  , "lighter:24" :: a
  , "lighter:25" :: a
  , "lighter:26" :: a
  , "lighter:27" :: a
  , "lighter:28" :: a
  , "lighter:29" :: a
  , "lighter:30" :: a
  , "lighter:31" :: a
  , "lighter:32" :: a
  , "cb:0" :: a
  , "subroc3d:0" :: a
  , "subroc3d:1" :: a
  , "subroc3d:2" :: a
  , "subroc3d:3" :: a
  , "subroc3d:4" :: a
  , "subroc3d:5" :: a
  , "subroc3d:6" :: a
  , "subroc3d:7" :: a
  , "subroc3d:8" :: a
  , "subroc3d:9" :: a
  , "subroc3d:10" :: a
  , "ul:0" :: a
  , "ul:1" :: a
  , "ul:2" :: a
  , "ul:3" :: a
  , "ul:4" :: a
  , "ul:5" :: a
  , "ul:6" :: a
  , "ul:7" :: a
  , "ul:8" :: a
  , "ul:9" :: a
  , "gab:0" :: a
  , "gab:1" :: a
  , "gab:2" :: a
  , "gab:3" :: a
  , "gab:4" :: a
  , "gab:5" :: a
  , "gab:6" :: a
  , "gab:7" :: a
  , "gab:8" :: a
  , "gab:9" :: a
  , "monsterb:0" :: a
  , "monsterb:1" :: a
  , "monsterb:2" :: a
  , "monsterb:3" :: a
  , "monsterb:4" :: a
  , "monsterb:5" :: a
  , "diphone:0" :: a
  , "diphone:1" :: a
  , "diphone:2" :: a
  , "diphone:3" :: a
  , "diphone:4" :: a
  , "diphone:5" :: a
  , "diphone:6" :: a
  , "diphone:7" :: a
  , "diphone:8" :: a
  , "diphone:9" :: a
  , "diphone:10" :: a
  , "diphone:11" :: a
  , "diphone:12" :: a
  , "diphone:13" :: a
  , "diphone:14" :: a
  , "diphone:15" :: a
  , "diphone:16" :: a
  , "diphone:17" :: a
  , "diphone:18" :: a
  , "diphone:19" :: a
  , "diphone:20" :: a
  , "diphone:21" :: a
  , "diphone:22" :: a
  , "diphone:23" :: a
  , "diphone:24" :: a
  , "diphone:25" :: a
  , "diphone:26" :: a
  , "diphone:27" :: a
  , "diphone:28" :: a
  , "diphone:29" :: a
  , "diphone:30" :: a
  , "diphone:31" :: a
  , "diphone:32" :: a
  , "diphone:33" :: a
  , "diphone:34" :: a
  , "diphone:35" :: a
  , "diphone:36" :: a
  , "diphone:37" :: a
  , "clak:0" :: a
  , "clak:1" :: a
  , "sitar:0" :: a
  , "sitar:1" :: a
  , "sitar:2" :: a
  , "sitar:3" :: a
  , "sitar:4" :: a
  , "sitar:5" :: a
  , "sitar:6" :: a
  , "sitar:7" :: a
  , "ab:0" :: a
  , "ab:1" :: a
  , "ab:2" :: a
  , "ab:3" :: a
  , "ab:4" :: a
  , "ab:5" :: a
  , "ab:6" :: a
  , "ab:7" :: a
  , "ab:8" :: a
  , "ab:9" :: a
  , "ab:10" :: a
  , "ab:11" :: a
  , "cr:0" :: a
  , "cr:1" :: a
  , "cr:2" :: a
  , "cr:3" :: a
  , "cr:4" :: a
  , "cr:5" :: a
  , "tacscan:0" :: a
  , "tacscan:1" :: a
  , "tacscan:2" :: a
  , "tacscan:3" :: a
  , "tacscan:4" :: a
  , "tacscan:5" :: a
  , "tacscan:6" :: a
  , "tacscan:7" :: a
  , "tacscan:8" :: a
  , "tacscan:9" :: a
  , "tacscan:10" :: a
  , "tacscan:11" :: a
  , "tacscan:12" :: a
  , "tacscan:13" :: a
  , "tacscan:14" :: a
  , "tacscan:15" :: a
  , "tacscan:16" :: a
  , "tacscan:17" :: a
  , "tacscan:18" :: a
  , "tacscan:19" :: a
  , "tacscan:20" :: a
  , "tacscan:21" :: a
  , "v:0" :: a
  , "v:1" :: a
  , "v:2" :: a
  , "v:3" :: a
  , "v:4" :: a
  , "v:5" :: a
  , "bd:0" :: a
  , "bd:1" :: a
  , "bd:2" :: a
  , "bd:3" :: a
  , "bd:4" :: a
  , "bd:5" :: a
  , "bd:6" :: a
  , "bd:7" :: a
  , "bd:8" :: a
  , "bd:9" :: a
  , "bd:10" :: a
  , "bd:11" :: a
  , "bd:12" :: a
  , "bd:13" :: a
  , "bd:14" :: a
  , "bd:15" :: a
  , "bd:16" :: a
  , "bd:17" :: a
  , "bd:18" :: a
  , "bd:19" :: a
  , "bd:20" :: a
  , "bd:21" :: a
  , "bd:22" :: a
  , "bd:23" :: a
  , "rm:0" :: a
  , "rm:1" :: a
  , "blue:0" :: a
  , "blue:1" :: a
  , "latibro:0" :: a
  , "latibro:1" :: a
  , "latibro:2" :: a
  , "latibro:3" :: a
  , "latibro:4" :: a
  , "latibro:5" :: a
  , "latibro:6" :: a
  , "latibro:7" :: a
  , "dr_few:0" :: a
  , "dr_few:1" :: a
  , "dr_few:2" :: a
  , "dr_few:3" :: a
  , "dr_few:4" :: a
  , "dr_few:5" :: a
  , "dr_few:6" :: a
  , "dr_few:7" :: a
  , "rave2:0" :: a
  , "rave2:1" :: a
  , "rave2:2" :: a
  , "rave2:3" :: a
  , "rave2:4" :: a
  , "rave2:5" :: a
  , "koy:0" :: a
  , "koy:1" :: a
  , "glitch2:0" :: a
  , "glitch2:1" :: a
  , "glitch2:2" :: a
  , "glitch2:3" :: a
  , "glitch2:4" :: a
  , "glitch2:5" :: a
  , "glitch2:6" :: a
  , "glitch2:7" :: a
  , "hmm:0" :: a
  , "arp:0" :: a
  , "arp:1" :: a
  , "made2:0" :: a
  , "uxay:0" :: a
  , "uxay:1" :: a
  , "uxay:2" :: a
  , "stomp:0" :: a
  , "stomp:1" :: a
  , "stomp:2" :: a
  , "stomp:3" :: a
  , "stomp:4" :: a
  , "stomp:5" :: a
  , "stomp:6" :: a
  , "stomp:7" :: a
  , "stomp:8" :: a
  , "stomp:9" :: a
  , "tech:0" :: a
  , "tech:1" :: a
  , "tech:2" :: a
  , "tech:3" :: a
  , "tech:4" :: a
  , "tech:5" :: a
  , "tech:6" :: a
  , "tech:7" :: a
  , "tech:8" :: a
  , "tech:9" :: a
  , "tech:10" :: a
  , "tech:11" :: a
  , "tech:12" :: a
  , "sn:0" :: a
  , "sn:1" :: a
  , "sn:2" :: a
  , "sn:3" :: a
  , "sn:4" :: a
  , "sn:5" :: a
  , "sn:6" :: a
  , "sn:7" :: a
  , "sn:8" :: a
  , "sn:9" :: a
  , "sn:10" :: a
  , "sn:11" :: a
  , "sn:12" :: a
  , "sn:13" :: a
  , "sn:14" :: a
  , "sn:15" :: a
  , "sn:16" :: a
  , "sn:17" :: a
  , "sn:18" :: a
  , "sn:19" :: a
  , "sn:20" :: a
  , "sn:21" :: a
  , "sn:22" :: a
  , "sn:23" :: a
  , "sn:24" :: a
  , "sn:25" :: a
  , "sn:26" :: a
  , "sn:27" :: a
  , "sn:28" :: a
  , "sn:29" :: a
  , "sn:30" :: a
  , "sn:31" :: a
  , "sn:32" :: a
  , "sn:33" :: a
  , "sn:34" :: a
  , "sn:35" :: a
  , "sn:36" :: a
  , "sn:37" :: a
  , "sn:38" :: a
  , "sn:39" :: a
  , "sn:40" :: a
  , "sn:41" :: a
  , "sn:42" :: a
  , "sn:43" :: a
  , "sn:44" :: a
  , "sn:45" :: a
  , "sn:46" :: a
  , "sn:47" :: a
  , "sn:48" :: a
  , "sn:49" :: a
  , "sn:50" :: a
  , "sn:51" :: a
  , "less:0" :: a
  , "less:1" :: a
  , "less:2" :: a
  , "less:3" :: a
  , "off:0" :: a
  , "x_808sd:0" :: a
  , "x_808sd:1" :: a
  , "x_808sd:2" :: a
  , "x_808sd:3" :: a
  , "x_808sd:4" :: a
  , "x_808sd:5" :: a
  , "x_808sd:6" :: a
  , "x_808sd:7" :: a
  , "x_808sd:8" :: a
  , "x_808sd:9" :: a
  , "x_808sd:10" :: a
  , "x_808sd:11" :: a
  , "x_808sd:12" :: a
  , "x_808sd:13" :: a
  , "x_808sd:14" :: a
  , "x_808sd:15" :: a
  , "x_808sd:16" :: a
  , "x_808sd:17" :: a
  , "x_808sd:18" :: a
  , "x_808sd:19" :: a
  , "x_808sd:20" :: a
  , "x_808sd:21" :: a
  , "x_808sd:22" :: a
  , "x_808sd:23" :: a
  , "x_808sd:24" :: a
  , "trump:0" :: a
  , "trump:1" :: a
  , "trump:2" :: a
  , "trump:3" :: a
  , "trump:4" :: a
  , "trump:5" :: a
  , "trump:6" :: a
  , "trump:7" :: a
  , "trump:8" :: a
  , "trump:9" :: a
  , "trump:10" :: a
  , "bev:0" :: a
  , "bev:1" :: a
  , "pad:0" :: a
  , "pad:1" :: a
  , "pad:2" :: a
  , "led:0" :: a
  , "perc:0" :: a
  , "perc:1" :: a
  , "perc:2" :: a
  , "perc:3" :: a
  , "perc:4" :: a
  , "perc:5" :: a
  , "pluck:0" :: a
  , "pluck:1" :: a
  , "pluck:2" :: a
  , "pluck:3" :: a
  , "pluck:4" :: a
  , "pluck:5" :: a
  , "pluck:6" :: a
  , "pluck:7" :: a
  , "pluck:8" :: a
  , "pluck:9" :: a
  , "pluck:10" :: a
  , "pluck:11" :: a
  , "pluck:12" :: a
  , "pluck:13" :: a
  , "pluck:14" :: a
  , "pluck:15" :: a
  , "pluck:16" :: a
  , "bleep:0" :: a
  , "bleep:1" :: a
  , "bleep:2" :: a
  , "bleep:3" :: a
  , "bleep:4" :: a
  , "bleep:5" :: a
  , "bleep:6" :: a
  , "bleep:7" :: a
  , "bleep:8" :: a
  , "bleep:9" :: a
  , "bleep:10" :: a
  , "bleep:11" :: a
  , "bleep:12" :: a
  , "ht:0" :: a
  , "ht:1" :: a
  , "ht:2" :: a
  , "ht:3" :: a
  , "ht:4" :: a
  , "ht:5" :: a
  , "ht:6" :: a
  , "ht:7" :: a
  , "ht:8" :: a
  , "ht:9" :: a
  , "ht:10" :: a
  , "ht:11" :: a
  , "ht:12" :: a
  , "ht:13" :: a
  , "ht:14" :: a
  , "ht:15" :: a
  , "ades4:0" :: a
  , "ades4:1" :: a
  , "ades4:2" :: a
  , "ades4:3" :: a
  , "ades4:4" :: a
  , "ades4:5" :: a
  , "proc:0" :: a
  , "proc:1" :: a
  , "gretsch:0" :: a
  , "gretsch:1" :: a
  , "gretsch:2" :: a
  , "gretsch:3" :: a
  , "gretsch:4" :: a
  , "gretsch:5" :: a
  , "gretsch:6" :: a
  , "gretsch:7" :: a
  , "gretsch:8" :: a
  , "gretsch:9" :: a
  , "gretsch:10" :: a
  , "gretsch:11" :: a
  , "gretsch:12" :: a
  , "gretsch:13" :: a
  , "gretsch:14" :: a
  , "gretsch:15" :: a
  , "gretsch:16" :: a
  , "gretsch:17" :: a
  , "gretsch:18" :: a
  , "gretsch:19" :: a
  , "gretsch:20" :: a
  , "gretsch:21" :: a
  , "gretsch:22" :: a
  , "gretsch:23" :: a
  , "outdoor:0" :: a
  , "outdoor:1" :: a
  , "outdoor:2" :: a
  , "outdoor:3" :: a
  , "outdoor:4" :: a
  , "outdoor:5" :: a
  , "techno:0" :: a
  , "techno:1" :: a
  , "techno:2" :: a
  , "techno:3" :: a
  , "techno:4" :: a
  , "techno:5" :: a
  , "techno:6" :: a
  , "ulgab:0" :: a
  , "ulgab:1" :: a
  , "ulgab:2" :: a
  , "ulgab:3" :: a
  , "ulgab:4" :: a
  , "breaks125:0" :: a
  , "breaks125:1" :: a
  , "bin:0" :: a
  , "bin:1" :: a
  , "x_808mc:0" :: a
  , "x_808mc:1" :: a
  , "x_808mc:2" :: a
  , "x_808mc:3" :: a
  , "x_808mc:4" :: a
  , "lt:0" :: a
  , "lt:1" :: a
  , "lt:2" :: a
  , "lt:3" :: a
  , "lt:4" :: a
  , "lt:5" :: a
  , "lt:6" :: a
  , "lt:7" :: a
  , "lt:8" :: a
  , "lt:9" :: a
  , "lt:10" :: a
  , "lt:11" :: a
  , "lt:12" :: a
  , "lt:13" :: a
  , "lt:14" :: a
  , "lt:15" :: a
  , "amencutup:0" :: a
  , "amencutup:1" :: a
  , "amencutup:2" :: a
  , "amencutup:3" :: a
  , "amencutup:4" :: a
  , "amencutup:5" :: a
  , "amencutup:6" :: a
  , "amencutup:7" :: a
  , "amencutup:8" :: a
  , "amencutup:9" :: a
  , "amencutup:10" :: a
  , "amencutup:11" :: a
  , "amencutup:12" :: a
  , "amencutup:13" :: a
  , "amencutup:14" :: a
  , "amencutup:15" :: a
  , "amencutup:16" :: a
  , "amencutup:17" :: a
  , "amencutup:18" :: a
  , "amencutup:19" :: a
  , "amencutup:20" :: a
  , "amencutup:21" :: a
  , "amencutup:22" :: a
  , "amencutup:23" :: a
  , "amencutup:24" :: a
  , "amencutup:25" :: a
  , "amencutup:26" :: a
  , "amencutup:27" :: a
  , "amencutup:28" :: a
  , "amencutup:29" :: a
  , "amencutup:30" :: a
  , "amencutup:31" :: a
  , "drum:0" :: a
  , "drum:1" :: a
  , "drum:2" :: a
  , "drum:3" :: a
  , "drum:4" :: a
  , "drum:5" :: a
  , "coins:0" :: a
  , "industrial:0" :: a
  , "industrial:1" :: a
  , "industrial:2" :: a
  , "industrial:3" :: a
  , "industrial:4" :: a
  , "industrial:5" :: a
  , "industrial:6" :: a
  , "industrial:7" :: a
  , "industrial:8" :: a
  , "industrial:9" :: a
  , "industrial:10" :: a
  , "industrial:11" :: a
  , "industrial:12" :: a
  , "industrial:13" :: a
  , "industrial:14" :: a
  , "industrial:15" :: a
  , "industrial:16" :: a
  , "industrial:17" :: a
  , "industrial:18" :: a
  , "industrial:19" :: a
  , "industrial:20" :: a
  , "industrial:21" :: a
  , "industrial:22" :: a
  , "industrial:23" :: a
  , "industrial:24" :: a
  , "industrial:25" :: a
  , "industrial:26" :: a
  , "industrial:27" :: a
  , "industrial:28" :: a
  , "industrial:29" :: a
  , "industrial:30" :: a
  , "industrial:31" :: a
  , "tink:0" :: a
  , "tink:1" :: a
  , "tink:2" :: a
  , "tink:3" :: a
  , "tink:4" :: a
  , "co:0" :: a
  , "co:1" :: a
  , "co:2" :: a
  , "co:3" :: a
  , "fest:0" :: a
  , "feelfx:0" :: a
  , "feelfx:1" :: a
  , "feelfx:2" :: a
  , "feelfx:3" :: a
  , "feelfx:4" :: a
  , "feelfx:5" :: a
  , "feelfx:6" :: a
  , "feelfx:7" :: a
  , "x_808cy:0" :: a
  , "x_808cy:1" :: a
  , "x_808cy:2" :: a
  , "x_808cy:3" :: a
  , "x_808cy:4" :: a
  , "x_808cy:5" :: a
  , "x_808cy:6" :: a
  , "x_808cy:7" :: a
  , "x_808cy:8" :: a
  , "x_808cy:9" :: a
  , "x_808cy:10" :: a
  , "x_808cy:11" :: a
  , "x_808cy:12" :: a
  , "x_808cy:13" :: a
  , "x_808cy:14" :: a
  , "x_808cy:15" :: a
  , "x_808cy:16" :: a
  , "x_808cy:17" :: a
  , "x_808cy:18" :: a
  , "x_808cy:19" :: a
  , "x_808cy:20" :: a
  , "x_808cy:21" :: a
  , "x_808cy:22" :: a
  , "x_808cy:23" :: a
  , "x_808cy:24" :: a
  , "world:0" :: a
  , "world:1" :: a
  , "world:2" :: a
  , "f:0" :: a
  , "numbers:0" :: a
  , "numbers:1" :: a
  , "numbers:2" :: a
  , "numbers:3" :: a
  , "numbers:4" :: a
  , "numbers:5" :: a
  , "numbers:6" :: a
  , "numbers:7" :: a
  , "numbers:8" :: a
  , "d:0" :: a
  , "d:1" :: a
  , "d:2" :: a
  , "d:3" :: a
  , "padlong:0" :: a
  , "sequential:0" :: a
  , "sequential:1" :: a
  , "sequential:2" :: a
  , "sequential:3" :: a
  , "sequential:4" :: a
  , "sequential:5" :: a
  , "sequential:6" :: a
  , "sequential:7" :: a
  , "stab:0" :: a
  , "stab:1" :: a
  , "stab:2" :: a
  , "stab:3" :: a
  , "stab:4" :: a
  , "stab:5" :: a
  , "stab:6" :: a
  , "stab:7" :: a
  , "stab:8" :: a
  , "stab:9" :: a
  , "stab:10" :: a
  , "stab:11" :: a
  , "stab:12" :: a
  , "stab:13" :: a
  , "stab:14" :: a
  , "stab:15" :: a
  , "stab:16" :: a
  , "stab:17" :: a
  , "stab:18" :: a
  , "stab:19" :: a
  , "stab:20" :: a
  , "stab:21" :: a
  , "stab:22" :: a
  , "electro1:0" :: a
  , "electro1:1" :: a
  , "electro1:2" :: a
  , "electro1:3" :: a
  , "electro1:4" :: a
  , "electro1:5" :: a
  , "electro1:6" :: a
  , "electro1:7" :: a
  , "electro1:8" :: a
  , "electro1:9" :: a
  , "electro1:10" :: a
  , "electro1:11" :: a
  , "electro1:12" :: a
  , "ifdrums:0" :: a
  , "ifdrums:1" :: a
  , "ifdrums:2" :: a
  , "invaders:0" :: a
  , "invaders:1" :: a
  , "invaders:2" :: a
  , "invaders:3" :: a
  , "invaders:4" :: a
  , "invaders:5" :: a
  , "invaders:6" :: a
  , "invaders:7" :: a
  , "invaders:8" :: a
  , "invaders:9" :: a
  , "invaders:10" :: a
  , "invaders:11" :: a
  , "invaders:12" :: a
  , "invaders:13" :: a
  , "invaders:14" :: a
  , "invaders:15" :: a
  , "invaders:16" :: a
  , "invaders:17" :: a
  , "dist:0" :: a
  , "dist:1" :: a
  , "dist:2" :: a
  , "dist:3" :: a
  , "dist:4" :: a
  , "dist:5" :: a
  , "dist:6" :: a
  , "dist:7" :: a
  , "dist:8" :: a
  , "dist:9" :: a
  , "dist:10" :: a
  , "dist:11" :: a
  , "dist:12" :: a
  , "dist:13" :: a
  , "dist:14" :: a
  , "dist:15" :: a
  , "sundance:0" :: a
  , "sundance:1" :: a
  , "sundance:2" :: a
  , "sundance:3" :: a
  , "sundance:4" :: a
  , "sundance:5" :: a
  , "speech:0" :: a
  , "speech:1" :: a
  , "speech:2" :: a
  , "speech:3" :: a
  , "speech:4" :: a
  , "speech:5" :: a
  , "speech:6" :: a
  , "toys:0" :: a
  , "toys:1" :: a
  , "toys:2" :: a
  , "toys:3" :: a
  , "toys:4" :: a
  , "toys:5" :: a
  , "toys:6" :: a
  , "toys:7" :: a
  , "toys:8" :: a
  , "toys:9" :: a
  , "toys:10" :: a
  , "toys:11" :: a
  , "toys:12" :: a
  , "bass0:0" :: a
  , "bass0:1" :: a
  , "bass0:2" :: a
  , "realclaps:0" :: a
  , "realclaps:1" :: a
  , "realclaps:2" :: a
  , "realclaps:3" :: a
  , "dorkbot:0" :: a
  , "dorkbot:1" :: a
  , "arpy:0" :: a
  , "arpy:1" :: a
  , "arpy:2" :: a
  , "arpy:3" :: a
  , "arpy:4" :: a
  , "arpy:5" :: a
  , "arpy:6" :: a
  , "arpy:7" :: a
  , "arpy:8" :: a
  , "arpy:9" :: a
  , "arpy:10" :: a
  , "fire:0" :: a
  , "hoover:0" :: a
  , "hoover:1" :: a
  , "hoover:2" :: a
  , "hoover:3" :: a
  , "hoover:4" :: a
  , "hoover:5" :: a
  , "breath:0" :: a
  , "rave:0" :: a
  , "rave:1" :: a
  , "rave:2" :: a
  , "rave:3" :: a
  , "rave:4" :: a
  , "rave:5" :: a
  , "rave:6" :: a
  , "rave:7" :: a
  , "bottle:0" :: a
  , "bottle:1" :: a
  , "bottle:2" :: a
  , "bottle:3" :: a
  , "bottle:4" :: a
  , "bottle:5" :: a
  , "bottle:6" :: a
  , "bottle:7" :: a
  , "bottle:8" :: a
  , "bottle:9" :: a
  , "bottle:10" :: a
  , "bottle:11" :: a
  , "bottle:12" :: a
  , "east:0" :: a
  , "east:1" :: a
  , "east:2" :: a
  , "east:3" :: a
  , "east:4" :: a
  , "east:5" :: a
  , "east:6" :: a
  , "east:7" :: a
  , "east:8" :: a
  , "linnhats:0" :: a
  , "linnhats:1" :: a
  , "linnhats:2" :: a
  , "linnhats:3" :: a
  , "linnhats:4" :: a
  , "linnhats:5" :: a
  , "speedupdown:0" :: a
  , "speedupdown:1" :: a
  , "speedupdown:2" :: a
  , "speedupdown:3" :: a
  , "speedupdown:4" :: a
  , "speedupdown:5" :: a
  , "speedupdown:6" :: a
  , "speedupdown:7" :: a
  , "speedupdown:8" :: a
  , "cosmicg:0" :: a
  , "cosmicg:1" :: a
  , "cosmicg:2" :: a
  , "cosmicg:3" :: a
  , "cosmicg:4" :: a
  , "cosmicg:5" :: a
  , "cosmicg:6" :: a
  , "cosmicg:7" :: a
  , "cosmicg:8" :: a
  , "cosmicg:9" :: a
  , "cosmicg:10" :: a
  , "cosmicg:11" :: a
  , "cosmicg:12" :: a
  , "cosmicg:13" :: a
  , "cosmicg:14" :: a
  , "jvbass:0" :: a
  , "jvbass:1" :: a
  , "jvbass:2" :: a
  , "jvbass:3" :: a
  , "jvbass:4" :: a
  , "jvbass:5" :: a
  , "jvbass:6" :: a
  , "jvbass:7" :: a
  , "jvbass:8" :: a
  , "jvbass:9" :: a
  , "jvbass:10" :: a
  , "jvbass:11" :: a
  , "jvbass:12" :: a
  , "mash:0" :: a
  , "mash:1" :: a
  , "feel:0" :: a
  , "feel:1" :: a
  , "feel:2" :: a
  , "feel:3" :: a
  , "feel:4" :: a
  , "feel:5" :: a
  , "feel:6" :: a
  , "short:0" :: a
  , "short:1" :: a
  , "short:2" :: a
  , "short:3" :: a
  , "short:4" :: a
  , "incoming:0" :: a
  , "incoming:1" :: a
  , "incoming:2" :: a
  , "incoming:3" :: a
  , "incoming:4" :: a
  , "incoming:5" :: a
  , "incoming:6" :: a
  , "incoming:7" :: a
  , "flick:0" :: a
  , "flick:1" :: a
  , "flick:2" :: a
  , "flick:3" :: a
  , "flick:4" :: a
  , "flick:5" :: a
  , "flick:6" :: a
  , "flick:7" :: a
  , "flick:8" :: a
  , "flick:9" :: a
  , "flick:10" :: a
  , "flick:11" :: a
  , "flick:12" :: a
  , "flick:13" :: a
  , "flick:14" :: a
  , "flick:15" :: a
  , "flick:16" :: a
  , "reverbkick:0" :: a
  , "bass2:0" :: a
  , "bass2:1" :: a
  , "bass2:2" :: a
  , "bass2:3" :: a
  , "bass2:4" :: a
  , "baa:0" :: a
  , "baa:1" :: a
  , "baa:2" :: a
  , "baa:3" :: a
  , "baa:4" :: a
  , "baa:5" :: a
  , "baa:6" :: a
  , "fm:0" :: a
  , "fm:1" :: a
  , "fm:2" :: a
  , "fm:3" :: a
  , "fm:4" :: a
  , "fm:5" :: a
  , "fm:6" :: a
  , "fm:7" :: a
  , "fm:8" :: a
  , "fm:9" :: a
  , "fm:10" :: a
  , "fm:11" :: a
  , "fm:12" :: a
  , "fm:13" :: a
  , "fm:14" :: a
  , "fm:15" :: a
  , "fm:16" :: a
  , "click:0" :: a
  , "click:1" :: a
  , "click:2" :: a
  , "click:3" :: a
  , "control:0" :: a
  , "control:1" :: a
  , "peri:0" :: a
  , "peri:1" :: a
  , "peri:2" :: a
  , "peri:3" :: a
  , "peri:4" :: a
  , "peri:5" :: a
  , "peri:6" :: a
  , "peri:7" :: a
  , "peri:8" :: a
  , "peri:9" :: a
  , "peri:10" :: a
  , "peri:11" :: a
  , "peri:12" :: a
  , "peri:13" :: a
  , "peri:14" :: a
  , "procshort:0" :: a
  , "procshort:1" :: a
  , "procshort:2" :: a
  , "procshort:3" :: a
  , "procshort:4" :: a
  , "procshort:5" :: a
  , "procshort:6" :: a
  , "procshort:7" :: a
  , "hand:0" :: a
  , "hand:1" :: a
  , "hand:2" :: a
  , "hand:3" :: a
  , "hand:4" :: a
  , "hand:5" :: a
  , "hand:6" :: a
  , "hand:7" :: a
  , "hand:8" :: a
  , "hand:9" :: a
  , "hand:10" :: a
  , "hand:11" :: a
  , "hand:12" :: a
  , "hand:13" :: a
  , "hand:14" :: a
  , "hand:15" :: a
  , "hand:16" :: a
  , "future:0" :: a
  , "future:1" :: a
  , "future:2" :: a
  , "future:3" :: a
  , "future:4" :: a
  , "future:5" :: a
  , "future:6" :: a
  , "future:7" :: a
  , "future:8" :: a
  , "future:9" :: a
  , "future:10" :: a
  , "future:11" :: a
  , "future:12" :: a
  , "future:13" :: a
  , "future:14" :: a
  , "future:15" :: a
  , "future:16" :: a
  , "hh:0" :: a
  , "hh:1" :: a
  , "hh:2" :: a
  , "hh:3" :: a
  , "hh:4" :: a
  , "hh:5" :: a
  , "hh:6" :: a
  , "hh:7" :: a
  , "hh:8" :: a
  , "hh:9" :: a
  , "hh:10" :: a
  , "hh:11" :: a
  , "hh:12" :: a
  , "x_808ht:0" :: a
  , "x_808ht:1" :: a
  , "x_808ht:2" :: a
  , "x_808ht:3" :: a
  , "x_808ht:4" :: a
  , "db:0" :: a
  , "db:1" :: a
  , "db:2" :: a
  , "db:3" :: a
  , "db:4" :: a
  , "db:5" :: a
  , "db:6" :: a
  , "db:7" :: a
  , "db:8" :: a
  , "db:9" :: a
  , "db:10" :: a
  , "db:11" :: a
  , "db:12" :: a
  ---- drones
  , "spacewind:0" :: a
  , "ambienta:0" :: a
  , "lowdark:0" :: a
  , "harmonium:0" :: a
  , "hollowair:0" :: a
  , "digeridoo:0" :: a
  )
