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

module MAlonzo.Code.Ace.Access where

import MAlonzo.RTE (coe, erased, AgdaAny, addInt, subInt, mulInt,
                    quotInt, remInt, geqInt, ltInt, eqInt, add64, sub64, mul64, quot64,
                    rem64, lt64, eq64, word64FromNat, word64ToNat)
import qualified MAlonzo.RTE
import qualified Data.Text
import qualified MAlonzo.Code.Agda.Builtin.Bool
import qualified MAlonzo.Code.Agda.Builtin.Equality
import qualified MAlonzo.Code.Agda.Builtin.String

-- Ace.Access.⊥
d_'8869'_4 = ()
data T_'8869'_4
-- Ace.Access.¬_
d_'172'__6 :: () -> ()
d_'172'__6 = erased
-- Ace.Access.AccountId
d_AccountId_10 :: ()
d_AccountId_10 = erased
-- Ace.Access.Role
d_Role_12 = ()
data T_Role_12 = C_Admin_14 | C_Member_16
-- Ace.Access.IsAdmin
d_IsAdmin_18 a0 = ()
data T_IsAdmin_18 = C_admin'45'proof_20
-- Ace.Access.member-cannot-admin
d_member'45'cannot'45'admin_22 :: T_IsAdmin_18 -> T_'8869'_4
d_member'45'cannot'45'admin_22 = erased
-- Ace.Access.ChatroomKind
d_ChatroomKind_24 = ()
data T_ChatroomKind_24
  = C_Public_26 | C_DM_28 Integer Integer | C_Group_30 [Integer]
-- Ace.Access._==ℕ_
d__'61''61'ℕ__32 :: Integer -> Integer -> Bool
d__'61''61'ℕ__32 v0 v1
  = let v2 = coe MAlonzo.Code.Agda.Builtin.Bool.C_false_8 in
    coe
      (case coe v0 of
         0 -> case coe v1 of
                0 -> coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10
                _ -> coe v2
         _ -> let v3 = subInt (coe v0) (coe (1 :: Integer)) in
              coe
                (case coe v1 of
                   _ | coe geqInt (coe v1) (coe (1 :: Integer)) ->
                       let v4 = subInt (coe v1) (coe (1 :: Integer)) in
                       coe (coe d__'61''61'ℕ__32 (coe v3) (coe v4))
                   _ -> coe v2))
-- Ace.Access.==ℕ-refl
d_'61''61'ℕ'45'refl_40 ::
  Integer -> MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_'61''61'ℕ'45'refl_40 = erased
-- Ace.Access._∈_
d__'8712'__44 a0 a1 = ()
data T__'8712'__44 = C_here_50 | C_there_58 T__'8712'__44
-- Ace.Access.CanAccess
d_CanAccess_60 a0 a1 = ()
data T_CanAccess_60
  = C_public'45'access_64 | C_dm'45'access'45'a_70 |
    C_dm'45'access'45'b_76 | C_group'45'access_82 T__'8712'__44 |
    C_admin'45'override_90 T_Role_12
-- Ace.Access.not-in-empty
d_not'45'in'45'empty_94 :: Integer -> T__'8712'__44 -> T_'8869'_4
d_not'45'in'45'empty_94 = erased
-- Ace.Access.MessageResult
d_MessageResult_96 = ()
data T_MessageResult_96 = C_sent_98 | C_failed_100
-- Ace.Access.sendMessage
d_sendMessage_106 ::
  T_CanAccess_60 ->
  MAlonzo.Code.Agda.Builtin.String.T_String_6 -> T_MessageResult_96
d_sendMessage_106 ~v0 ~v1 = du_sendMessage_106
du_sendMessage_106 :: T_MessageResult_96
du_sendMessage_106 = coe C_sent_98
-- Ace.Access.clearMessages
d_clearMessages_110 ::
  T_Role_12 -> T_IsAdmin_18 -> T_MessageResult_96
d_clearMessages_110 ~v0 ~v1 = du_clearMessages_110
du_clearMessages_110 :: T_MessageResult_96
du_clearMessages_110 = coe C_sent_98
