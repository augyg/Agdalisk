{-# LANGUAGE PatternSynonyms #-}

-- | Verified subscription state machine for the Ace platform.
--
-- Every state transition is total. Invalid transitions are
-- unrepresentable — the type system IS the state diagram.
--
-- Source: agda/Ace/Subscription.agda
module Agdalisk.Subscription
  ( -- * Subscription states
    SubState
  , pattern Free
  , pattern Trial
  , pattern Paid
  , pattern Cancelled
  , pattern Expired
    -- * Actions
  , Action
  , pattern StartTrial
  , pattern Subscribe
  , pattern CancelSub
  , pattern ExpireTrial
  , pattern ExpireSub
  , pattern Resubscribe
    -- * Valid transitions
  , ValidTransition
  , pattern FreeToTrial
  , pattern FreeToPaid
  , pattern TrialToPaid
  , pattern TrialToExpired
  , pattern PaidToCancelled
  , pattern PaidToExpired
  , pattern CancelledToPaid
  , pattern ExpiredToPaid
    -- * Transition function
  , transition
    -- * Paths (multi-step transitions)
  , Path
  , pattern Done
  , pattern Step
    -- * Features
  , Feature
  , pattern BasicChat
  , pattern VideoInterview
  , pattern CodeChallenges
  , pattern AdminDashboard
    -- * Feature gating
  , HasFeature
  , pattern FreeChat
  , pattern TrialChat
  , pattern PaidChat
  , pattern TrialVideo
  , pattern PaidVideo
  , pattern PaidCode
  ) where

import qualified MAlonzo.Code.Ace.Subscription as S

-- ── Subscription states ──────────────────────────────────────

type SubState = S.T_SubState_10

pattern Free :: SubState
pattern Free = S.C_Free_12

pattern Trial :: SubState
pattern Trial = S.C_Trial_14

pattern Paid :: SubState
pattern Paid = S.C_Paid_16

pattern Cancelled :: SubState
pattern Cancelled = S.C_Cancelled_18

pattern Expired :: SubState
pattern Expired = S.C_Expired_20

{-# COMPLETE Free, Trial, Paid, Cancelled, Expired #-}


-- ── Actions ──────────────────────────────────────────────────

type Action = S.T_Action_22

pattern StartTrial :: Action
pattern StartTrial = S.C_StartTrial_24

pattern Subscribe :: Action
pattern Subscribe = S.C_Subscribe_26

pattern CancelSub :: Action
pattern CancelSub = S.C_CancelSub_28

pattern ExpireTrial :: Action
pattern ExpireTrial = S.C_ExpireTrial_30

pattern ExpireSub :: Action
pattern ExpireSub = S.C_ExpireSub_32

pattern Resubscribe :: Action
pattern Resubscribe = S.C_Resubscribe_34

{-# COMPLETE StartTrial, Subscribe, CancelSub, ExpireTrial, ExpireSub, Resubscribe #-}


-- ── Valid transitions ────────────────────────────────────────

type ValidTransition = S.T_ValidTransition_36

pattern FreeToTrial :: ValidTransition
pattern FreeToTrial = S.C_free'45'to'45'trial_38

pattern FreeToPaid :: ValidTransition
pattern FreeToPaid = S.C_free'45'to'45'paid_40

pattern TrialToPaid :: ValidTransition
pattern TrialToPaid = S.C_trial'45'to'45'paid_42

pattern TrialToExpired :: ValidTransition
pattern TrialToExpired = S.C_trial'45'to'45'expired_44

pattern PaidToCancelled :: ValidTransition
pattern PaidToCancelled = S.C_paid'45'to'45'cancelled_46

pattern PaidToExpired :: ValidTransition
pattern PaidToExpired = S.C_paid'45'to'45'expired_48

pattern CancelledToPaid :: ValidTransition
pattern CancelledToPaid = S.C_cancelled'45'to'45'paid_50

pattern ExpiredToPaid :: ValidTransition
pattern ExpiredToPaid = S.C_expired'45'to'45'paid_52

{-# COMPLETE FreeToTrial, FreeToPaid, TrialToPaid, TrialToExpired,
             PaidToCancelled, PaidToExpired, CancelledToPaid, ExpiredToPaid #-}


-- ── Transition function ──────────────────────────────────────

-- | Apply a valid transition to get the resulting state.
-- The transition proof has already been verified by Agda.
transition :: SubState -> SubState
transition = S.du_transition_60


-- ── Paths ────────────────────────────────────────────────────

type Path = S.T_Path_92

pattern Done :: Path
pattern Done = S.C_done_96

pattern Step :: SubState -> Action -> ValidTransition -> Path -> Path
pattern Step s a t p = S.C_step_106 s a t p

{-# COMPLETE Done, Step #-}


-- ── Features ─────────────────────────────────────────────────

type Feature = S.T_Feature_116

pattern BasicChat :: Feature
pattern BasicChat = S.C_BasicChat_118

pattern VideoInterview :: Feature
pattern VideoInterview = S.C_VideoInterview_120

pattern CodeChallenges :: Feature
pattern CodeChallenges = S.C_CodeChallenges_122

pattern AdminDashboard :: Feature
pattern AdminDashboard = S.C_AdminDashboard_124

{-# COMPLETE BasicChat, VideoInterview, CodeChallenges, AdminDashboard #-}


-- ── Feature gating ───────────────────────────────────────────

type HasFeature = S.T_HasFeature_126

pattern FreeChat :: HasFeature
pattern FreeChat = S.C_free'45'chat_128

pattern TrialChat :: HasFeature
pattern TrialChat = S.C_trial'45'chat_130

pattern PaidChat :: HasFeature
pattern PaidChat = S.C_paid'45'chat_132

pattern TrialVideo :: HasFeature
pattern TrialVideo = S.C_trial'45'video_134

pattern PaidVideo :: HasFeature
pattern PaidVideo = S.C_paid'45'video_136

pattern PaidCode :: HasFeature
pattern PaidCode = S.C_paid'45'code_138

{-# COMPLETE FreeChat, TrialChat, PaidChat, TrialVideo, PaidVideo, PaidCode #-}
