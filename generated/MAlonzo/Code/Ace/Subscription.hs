{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

{-# OPTIONS_GHC -Wno-overlapping-patterns #-}

module MAlonzo.Code.Ace.Subscription where

import MAlonzo.RTE (coe, erased, AgdaAny, addInt, subInt, mulInt,
                    quotInt, remInt, geqInt, ltInt, eqInt, add64, sub64, mul64, quot64,
                    rem64, lt64, eq64, word64FromNat, word64ToNat)
import qualified MAlonzo.RTE
import qualified Data.Text

-- Ace.Subscription.⊥
d_'8869'_4 = ()
data T_'8869'_4
-- Ace.Subscription.¬_
d_'172'__6 :: () -> ()
d_'172'__6 = erased
-- Ace.Subscription.SubState
d_SubState_10 = ()
data T_SubState_10
  = C_Free_12 | C_Trial_14 | C_Paid_16 | C_Cancelled_18 |
    C_Expired_20
-- Ace.Subscription.Action
d_Action_22 = ()
data T_Action_22
  = C_StartTrial_24 | C_Subscribe_26 | C_CancelSub_28 |
    C_ExpireTrial_30 | C_ExpireSub_32 | C_Resubscribe_34
-- Ace.Subscription.ValidTransition
d_ValidTransition_36 a0 a1 a2 = ()
data T_ValidTransition_36
  = C_free'45'to'45'trial_38 | C_free'45'to'45'paid_40 |
    C_trial'45'to'45'paid_42 | C_trial'45'to'45'expired_44 |
    C_paid'45'to'45'cancelled_46 | C_paid'45'to'45'expired_48 |
    C_cancelled'45'to'45'paid_50 | C_expired'45'to'45'paid_52
-- Ace.Subscription.transition
d_transition_60 ::
  T_SubState_10 ->
  T_SubState_10 ->
  T_Action_22 -> T_ValidTransition_36 -> T_SubState_10
d_transition_60 ~v0 v1 ~v2 ~v3 = du_transition_60 v1
du_transition_60 :: T_SubState_10 -> T_SubState_10
du_transition_60 v0 = coe v0
-- Ace.Subscription.cannot-cancel-free
d_cannot'45'cancel'45'free_66 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'cancel'45'free_66 = erased
-- Ace.Subscription.cannot-cancel-cancelled
d_cannot'45'cancel'45'cancelled_70 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'cancel'45'cancelled_70 = erased
-- Ace.Subscription.cannot-double-trial
d_cannot'45'double'45'trial_74 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'double'45'trial_74 = erased
-- Ace.Subscription.cannot-trial-when-paid
d_cannot'45'trial'45'when'45'paid_78 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'trial'45'when'45'paid_78 = erased
-- Ace.Subscription.cannot-trial-when-expired
d_cannot'45'trial'45'when'45'expired_82 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'trial'45'when'45'expired_82 = erased
-- Ace.Subscription.cannot-expire-free
d_cannot'45'expire'45'free_86 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'expire'45'free_86 = erased
-- Ace.Subscription.cannot-expire-free-sub
d_cannot'45'expire'45'free'45'sub_90 ::
  T_SubState_10 -> T_ValidTransition_36 -> T_'8869'_4
d_cannot'45'expire'45'free'45'sub_90 = erased
-- Ace.Subscription.Path
d_Path_92 a0 a1 = ()
data T_Path_92
  = C_done_96 |
    C_step_106 T_SubState_10 T_Action_22 T_ValidTransition_36 T_Path_92
-- Ace.Subscription.free-to-paid-path
d_free'45'to'45'paid'45'path_108 :: T_Path_92
d_free'45'to'45'paid'45'path_108
  = coe
      C_step_106 (coe C_Paid_16) (coe C_Subscribe_26)
      (coe C_free'45'to'45'paid_40) (coe C_done_96)
-- Ace.Subscription.free-trial-paid-path
d_free'45'trial'45'paid'45'path_110 :: T_Path_92
d_free'45'trial'45'paid'45'path_110
  = coe
      C_step_106 (coe C_Trial_14) (coe C_StartTrial_24)
      (coe C_free'45'to'45'trial_38)
      (coe
         C_step_106 (coe C_Paid_16) (coe C_Subscribe_26)
         (coe C_trial'45'to'45'paid_42) (coe C_done_96))
-- Ace.Subscription.full-lifecycle
d_full'45'lifecycle_112 :: T_Path_92
d_full'45'lifecycle_112
  = coe
      C_step_106 (coe C_Trial_14) (coe C_StartTrial_24)
      (coe C_free'45'to'45'trial_38)
      (coe
         C_step_106 (coe C_Paid_16) (coe C_Subscribe_26)
         (coe C_trial'45'to'45'paid_42)
         (coe
            C_step_106 (coe C_Cancelled_18) (coe C_CancelSub_28)
            (coe C_paid'45'to'45'cancelled_46)
            (coe
               C_step_106 (coe C_Paid_16) (coe C_Resubscribe_34)
               (coe C_cancelled'45'to'45'paid_50) (coe C_done_96))))
-- Ace.Subscription.recovery-path
d_recovery'45'path_114 :: T_Path_92
d_recovery'45'path_114
  = coe
      C_step_106 (coe C_Paid_16) (coe C_Resubscribe_34)
      (coe C_expired'45'to'45'paid_52) (coe C_done_96)
-- Ace.Subscription.Feature
d_Feature_116 = ()
data T_Feature_116
  = C_BasicChat_118 | C_VideoInterview_120 | C_CodeChallenges_122 |
    C_AdminDashboard_124
-- Ace.Subscription.HasFeature
d_HasFeature_126 a0 a1 = ()
data T_HasFeature_126
  = C_free'45'chat_128 | C_trial'45'chat_130 | C_paid'45'chat_132 |
    C_trial'45'video_134 | C_paid'45'video_136 | C_paid'45'code_138
-- Ace.Subscription.free-no-video
d_free'45'no'45'video_140 :: T_HasFeature_126 -> T_'8869'_4
d_free'45'no'45'video_140 = erased
-- Ace.Subscription.free-no-code
d_free'45'no'45'code_142 :: T_HasFeature_126 -> T_'8869'_4
d_free'45'no'45'code_142 = erased
-- Ace.Subscription.trial-no-code
d_trial'45'no'45'code_144 :: T_HasFeature_126 -> T_'8869'_4
d_trial'45'no'45'code_144 = erased
-- Ace.Subscription.cancelled-no-chat
d_cancelled'45'no'45'chat_146 :: T_HasFeature_126 -> T_'8869'_4
d_cancelled'45'no'45'chat_146 = erased
-- Ace.Subscription.cancelled-no-video
d_cancelled'45'no'45'video_148 :: T_HasFeature_126 -> T_'8869'_4
d_cancelled'45'no'45'video_148 = erased
-- Ace.Subscription.expired-no-video
d_expired'45'no'45'video_150 :: T_HasFeature_126 -> T_'8869'_4
d_expired'45'no'45'video_150 = erased
