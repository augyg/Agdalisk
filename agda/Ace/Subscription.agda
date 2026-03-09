module Ace.Subscription where

open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool
open import Agda.Builtin.Equality

-- ═══════════════════════════════════════════════════════════
--
--  VERIFIED SUBSCRIPTION STATE MACHINE
--
--  Every state transition is total. There are no invalid
--  transitions because invalid transitions are not
--  representable. The type system IS the state diagram.
--
--  States:
--    Free ──► Trial ──► Paid ──► Cancelled
--                │        │
--                ▼        ▼
--             Expired   Expired
--
-- ═══════════════════════════════════════════════════════════


data ⊥ : Set where

¬_ : Set → Set
¬ A = A → ⊥

infixr 3 ¬_


-- ─── Subscription states ───────────────────────────────────

data SubState : Set where
  Free      : SubState
  Trial     : SubState
  Paid      : SubState
  Cancelled : SubState
  Expired   : SubState



-- ─── Actions ───────────────────────────────────────────────

data Action : Set where
  StartTrial     : Action
  Subscribe      : Action
  CancelSub      : Action
  ExpireTrial    : Action
  ExpireSub      : Action
  Resubscribe    : Action



-- ─── Valid transitions ─────────────────────────────────────
--
-- ValidTransition s a s' means: in state s, action a
-- leads to state s'. Only constructors listed here are valid.
-- Everything else is a type error.

data ValidTransition : SubState → Action → SubState → Set where
  -- Free users can start a trial
  free-to-trial
    : ValidTransition Free StartTrial Trial

  -- Free users can subscribe directly
  free-to-paid
    : ValidTransition Free Subscribe Paid

  -- Trial users can subscribe (upgrade)
  trial-to-paid
    : ValidTransition Trial Subscribe Paid

  -- Trial can expire
  trial-to-expired
    : ValidTransition Trial ExpireTrial Expired

  -- Paid users can cancel
  paid-to-cancelled
    : ValidTransition Paid CancelSub Cancelled

  -- Paid subscriptions can expire (payment failed)
  paid-to-expired
    : ValidTransition Paid ExpireSub Expired

  -- Cancelled users can resubscribe
  cancelled-to-paid
    : ValidTransition Cancelled Resubscribe Paid

  -- Expired users can resubscribe
  expired-to-paid
    : ValidTransition Expired Resubscribe Paid


-- ─── The transition function requires a proof ──────────────

transition : {s s' : SubState} {a : Action}
           → ValidTransition s a s'
           → SubState
transition {s' = s'} _ = s'


-- ═══════════════════════════════════════════════════════════
--  IMPOSSIBILITY THEOREMS
--
--  These are NOT runtime checks. These are PROOFS that
--  certain transitions cannot be constructed.
-- ═══════════════════════════════════════════════════════════

-- You cannot cancel a free account.
-- There is no ValidTransition Free CancelSub _ constructor.
cannot-cancel-free : {s' : SubState} → ¬ (ValidTransition Free CancelSub s')
cannot-cancel-free ()

-- You cannot cancel an already cancelled account.
cannot-cancel-cancelled : {s' : SubState} → ¬ (ValidTransition Cancelled CancelSub s')
cannot-cancel-cancelled ()

-- You cannot start a trial if already on trial.
cannot-double-trial : {s' : SubState} → ¬ (ValidTransition Trial StartTrial s')
cannot-double-trial ()

-- You cannot start a trial if already paid.
cannot-trial-when-paid : {s' : SubState} → ¬ (ValidTransition Paid StartTrial s')
cannot-trial-when-paid ()

-- Expired accounts cannot start a trial (must resubscribe).
cannot-trial-when-expired : {s' : SubState} → ¬ (ValidTransition Expired StartTrial s')
cannot-trial-when-expired ()

-- Free accounts cannot expire (nothing to expire).
cannot-expire-free : {s' : SubState} → ¬ (ValidTransition Free ExpireTrial s')
cannot-expire-free ()

cannot-expire-free-sub : {s' : SubState} → ¬ (ValidTransition Free ExpireSub s')
cannot-expire-free-sub ()


-- ═══════════════════════════════════════════════════════════
--  REACHABILITY THEOREMS
-- ═══════════════════════════════════════════════════════════

-- A sequence of transitions (path through the state machine)
data Path : SubState → SubState → Set where
  done : {s : SubState} → Path s s
  step : {s s' s'' : SubState} {a : Action}
       → ValidTransition s a s'
       → Path s' s''
       → Path s s''

-- Every user starts Free. Paid is reachable from Free.
free-to-paid-path : Path Free Paid
free-to-paid-path = step free-to-paid done

-- Free to Paid via trial
free-trial-paid-path : Path Free Paid
free-trial-paid-path = step free-to-trial (step trial-to-paid done)

-- Full lifecycle: Free → Trial → Paid → Cancelled → Paid again
full-lifecycle : Path Free Paid
full-lifecycle =
  step free-to-trial
    (step trial-to-paid
      (step paid-to-cancelled
        (step cancelled-to-paid done)))

-- Recovery: Expired → Paid (resubscribe)
recovery-path : Path Expired Paid
recovery-path = step expired-to-paid done


-- ═══════════════════════════════════════════════════════════
--  FEATURE GATING
--
--  Functions that require a specific subscription level.
--  The proof parameter enforces the requirement at compile time.
-- ═══════════════════════════════════════════════════════════

data Feature : Set where
  BasicChat       : Feature
  VideoInterview  : Feature
  CodeChallenges  : Feature
  AdminDashboard  : Feature


-- Which states grant access to features
data HasFeature : SubState → Feature → Set where
  -- Everyone gets basic chat
  free-chat      : HasFeature Free BasicChat
  trial-chat     : HasFeature Trial BasicChat
  paid-chat      : HasFeature Paid BasicChat

  -- Trial and paid get video interviews
  trial-video    : HasFeature Trial VideoInterview
  paid-video     : HasFeature Paid VideoInterview

  -- Only paid gets code challenges
  paid-code      : HasFeature Paid CodeChallenges

-- THEOREM: Free users cannot access video interviews
free-no-video : ¬ (HasFeature Free VideoInterview)
free-no-video ()

-- THEOREM: Free users cannot access code challenges
free-no-code : ¬ (HasFeature Free CodeChallenges)
free-no-code ()

-- THEOREM: Trial users cannot access code challenges
trial-no-code : ¬ (HasFeature Trial CodeChallenges)
trial-no-code ()

-- THEOREM: Cancelled users have no features
cancelled-no-chat : ¬ (HasFeature Cancelled BasicChat)
cancelled-no-chat ()

cancelled-no-video : ¬ (HasFeature Cancelled VideoInterview)
cancelled-no-video ()

expired-no-video : ¬ (HasFeature Expired VideoInterview)
expired-no-video ()


-- ═══════════════════════════════════════════════════════════
--  COMPILE-TIME VERIFIED EXAMPLES
-- ═══════════════════════════════════════════════════════════

-- Paid user accessing code challenges: compiles
_ : HasFeature Paid CodeChallenges
_ = paid-code

-- Trial user accessing video: compiles
_ : HasFeature Trial VideoInterview
_ = trial-video

-- Transition: Free → Trial via StartTrial: compiles
_ : SubState
_ = transition free-to-trial  -- evaluates to Trial

-- Transition: Paid → Cancelled via CancelSub: compiles
_ : SubState
_ = transition paid-to-cancelled  -- evaluates to Cancelled

-- These would NOT compile:
-- _ : HasFeature Free CodeChallenges
-- _ = ???  -- no constructor exists
