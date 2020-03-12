{-# LANGUAGE RankNTypes #-}
module Control.Algebra.Internal
( Handler
) where

-- | Handlers take an action in @m@ bundled up with some state in some context functor @ctx@, and return an action in @n@ producing a derived state in @ctx@.
--
-- These are expected to be well-behaved /distributive laws/, and are required to adhere to the following laws:
--
-- @
-- handler '.' 'fmap' 'pure' = 'pure'
-- @
-- @
-- handler '.' 'fmap' (k '=<<') = handler '.' 'fmap' k 'Control.Monad.<=<' handler
-- @
--
-- respectively expressing that the handler does not alter the context of pure computations, and that the handler distributes over monadic composition.
--
-- Handlers compose with handlers, using e.g. "Data.Functor.Compose".'Compose' to ensure that the result is itself well-typed as a 'Handler':
--
-- @
-- 'fmap' 'Compose' '.' handler1 '.' 'fmap' handler2 '.' 'getCompose'
-- @
--
-- with monad homomorphisms on the left and right:
--
-- @
-- hom '.' handler
-- @
-- @
-- handler '.' 'fmap' hom
-- @
type Handler ctx m n = forall x . ctx (m x) -> n (ctx x)
