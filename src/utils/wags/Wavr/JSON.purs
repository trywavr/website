module Wavr.JSON where

import Prelude

import Control.Monad.Error.Class (throwError)
import Data.List.NonEmpty (NonEmptyList(..))
import Data.List (List(..))
import Data.Map (Map, lookup)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Foreign (F, Foreign, ForeignError(..))
import Simple.JSON as JSON

readVariant :: forall v. String -> Map String v -> Foreign -> F v
readVariant name mp i =
  JSON.readImpl i
    >>= \s -> case lookup s mp of
      Just x -> pure x
      Nothing -> throwError (NonEmptyList ((ForeignError $ "Could not parse " <> name <> ": " <> s) :| Nil))