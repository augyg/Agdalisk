module Main where

-- Import all verified modules to trigger GHC backend compilation
open import Ace.Access
open import Ace.Subscription
open import Ace.Protocol
open import Ace.Route

open import Agda.Builtin.IO
open import Agda.Builtin.Unit

postulate dummyMain : IO ⊤

{-# COMPILE GHC dummyMain = return () #-}

main : IO ⊤
main = dummyMain
