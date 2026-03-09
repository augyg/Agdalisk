{-# LANGUAGE PatternSynonyms #-}

-- | Verified access control for the Ace platform.
--
-- Authorization is proven at compile time via Agda's type system.
-- All proofs are erased at runtime — zero overhead.
--
-- Source: agda/Ace/Access.agda
module Agdalisk.Access
  ( -- * Roles
    Role
  , pattern Admin
  , pattern Member
    -- * Admin proof
  , IsAdmin
  , pattern AdminProof
    -- * Chatroom kinds
  , ChatroomKind
  , pattern Public
  , pattern DM
  , pattern Group
    -- * List membership
  , Membership
  , pattern Here
  , pattern There
    -- * Authorization proof
  , CanAccess
  , pattern PublicAccess
  , pattern DmAccessA
  , pattern DmAccessB
  , pattern GroupAccess
  , pattern AdminOverride
    -- * Operations
  , MessageResult
  , pattern Sent
  , pattern Failed
  , sendMessage
  , clearMessages
  ) where

import qualified MAlonzo.Code.Ace.Access as A

-- ── Roles ─────────────────────────────────────────────────────

type Role = A.T_Role_12

pattern Admin :: Role
pattern Admin = A.C_Admin_14

pattern Member :: Role
pattern Member = A.C_Member_16

{-# COMPLETE Admin, Member #-}


-- ── Admin proof ───────────────────────────────────────────────

type IsAdmin = A.T_IsAdmin_18

pattern AdminProof :: IsAdmin
pattern AdminProof = A.C_admin'45'proof_20

{-# COMPLETE AdminProof #-}


-- ── Chatroom kinds ────────────────────────────────────────────

type ChatroomKind = A.T_ChatroomKind_24

pattern Public :: ChatroomKind
pattern Public = A.C_Public_26

pattern DM :: Integer -> Integer -> ChatroomKind
pattern DM a b = A.C_DM_28 a b

pattern Group :: [Integer] -> ChatroomKind
pattern Group members = A.C_Group_30 members

{-# COMPLETE Public, DM, Group #-}


-- ── List membership ──────────────────────────────────────────

type Membership = A.T__'8712'__44

pattern Here :: Membership
pattern Here = A.C_here_50

pattern There :: Membership -> Membership
pattern There proof = A.C_there_58 proof

{-# COMPLETE Here, There #-}


-- ── Authorization proof ──────────────────────────────────────

type CanAccess = A.T_CanAccess_60

pattern PublicAccess :: CanAccess
pattern PublicAccess = A.C_public'45'access_64

pattern DmAccessA :: CanAccess
pattern DmAccessA = A.C_dm'45'access'45'a_70

pattern DmAccessB :: CanAccess
pattern DmAccessB = A.C_dm'45'access'45'b_76

pattern GroupAccess :: Membership -> CanAccess
pattern GroupAccess proof = A.C_group'45'access_82 proof

pattern AdminOverride :: Role -> CanAccess
pattern AdminOverride role = A.C_admin'45'override_90 role

{-# COMPLETE PublicAccess, DmAccessA, DmAccessB, GroupAccess, AdminOverride #-}


-- ── Message result ───────────────────────────────────────────

type MessageResult = A.T_MessageResult_96

pattern Sent :: MessageResult
pattern Sent = A.C_sent_98

pattern Failed :: MessageResult
pattern Failed = A.C_failed_100

{-# COMPLETE Sent, Failed #-}


-- ── Operations ───────────────────────────────────────────────

sendMessage :: CanAccess -> MessageResult
sendMessage _ = A.du_sendMessage_106

clearMessages :: IsAdmin -> MessageResult
clearMessages _ = A.du_clearMessages_110
