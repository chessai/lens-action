{-# LANGUAGE CPP #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
#ifdef TRUSTWORTHY
{-# LANGUAGE Trustworthy #-}
#endif
-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Lens.Action.Type
-- Copyright   :  (C) 2012-14 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  experimental
-- Portability :  non-portable
--
----------------------------------------------------------------------------
module Control.Lens.Action.Type
  ( -- * Getters and Folds
    Action
  , MonadicFold
  , RelevantMonadicFold
    -- * Indexed
  , IndexedAction
  , IndexedMonadicFold
  , IndexedRelevantMonadicFold
    -- * Index-Preserving
  , IndexPreservingAction
  , IndexPreservingMonadicFold
  , IndexPreservingRelevantMonadicFold
  ) where

import Control.Applicative (Applicative)
import Control.Lens (Conjoined, Indexable)
import Data.Functor.Semiapplicative (Semiapplicative)
import Prelude ()

import Control.Lens.Action.Internal (Effective)

-------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------

-- | An 'Action' is a 'Getter' enriched with access to a 'Monad' for side-effects.
--
-- Every 'Getter' can be used as an 'Action'.
--
-- You can compose an 'Action' with another 'Action' using ('Prelude..') from the @Prelude@.
type Action m s a = forall f r. Effective m r f => (a -> f a) -> s -> f s

-- | An 'IndexedAction' is an 'IndexedGetter' enriched with access to a 'Monad' for side-effects.
--
-- Every 'Getter' can be used as an 'Action'.
--
-- You can compose an 'Action' with another 'Action' using ('Prelude..') from the @Prelude@.
type IndexedAction i m s a = forall p f r. (Indexable i p, Effective m r f) => p a (f a) -> s -> f s

-- | An 'IndexPreservingAction' can be used as a 'Action', but when composed with an 'IndexedTraversal',
-- 'IndexedFold', or 'IndexedLens' yields an 'IndexedMonadicFold', 'IndexedMonadicFold' or 'IndexedAction' respectively.
type IndexPreservingAction m s a = forall p f r. (Conjoined p, Effective m r f) => p a (f a) -> p s (f s)

-------------------------------------------------------------------------------
-- MonadicFolds
-------------------------------------------------------------------------------

-- | A 'MonadicFold' is a 'Fold' enriched with access to a 'Monad' for side-effects.
--
-- A 'MonadicFold' can use side-effects to produce parts of the structure being folded (e.g. reading them from file).
--
-- Every 'Fold' can be used as a 'MonadicFold', that simply ignores the access to the 'Monad'.
--
-- You can compose a 'MonadicFold' with another 'MonadicFold' using ('Prelude..') from the @Prelude@.
type MonadicFold m s a = forall f r. (Effective m r f, Applicative f) => (a -> f a) -> s -> f s
type RelevantMonadicFold m s a = forall f r. (Effective m r f, Semiapplicative f) => (a -> f a) -> s -> f s

-- | An 'IndexedMonadicFold' is an 'IndexedFold' enriched with access to a 'Monad' for side-effects.
--
-- Every 'IndexedFold' can be used as an 'IndexedMonadicFold', that simply ignores the access to the 'Monad'.
--
-- You can compose an 'IndexedMonadicFold' with another 'IndexedMonadicFold' using ('Prelude..') from the @Prelude@.
type IndexedMonadicFold i m s a = forall p f r. (Indexable i p, Effective m r f, Applicative f) => p a (f a) -> s -> f s
type IndexedRelevantMonadicFold i m s a = forall p f r. (Indexable i p, Effective m r f, Semiapplicative f) => p a (f a) -> s -> f s

-- | An 'IndexPreservingFold' can be used as a 'Fold', but when composed with an 'IndexedTraversal',
-- 'IndexedFold', or 'IndexedLens' yields an 'IndexedFold' respectively.
type IndexPreservingMonadicFold m s a = forall p f r. (Conjoined p, Effective m r f, Applicative f) => p a (f a) -> p s (f s)
type IndexPreservingRelevantMonadicFold m s a = forall p f r. (Conjoined p, Effective m r f, Semiapplicative f) => p a (f a) -> p s (f s)
