{-# LANGUAGE PatternSynonyms #-}

-- | Verified request-response protocol for the Ace platform.
--
-- Response types are COMPUTED from request types via dependent types.
-- The dispatch function is total — Agda's coverage checker
-- guarantees every action is handled.
--
-- Source: agda/Ace/Protocol.agda
module Agdalisk.Protocol
  ( -- * API actions
    ApiAction
  , pattern GetProfile
  , pattern SendMessage
  , pattern ListChannels
  , pattern ToggleComplete
  , pattern GetSubscription
  , pattern StartTrial
  , pattern CancelSub
    -- * Error codes
  , ErrorCode
  , pattern NotFound
  , pattern Unauthorized
  , pattern InvalidInput
  , pattern ServerError
    -- * Request / Response
  , Request
  , pattern MkReq
  , Response
  , pattern Ok
  , pattern Err
    -- * Dispatch
  , dispatch
  , processRequest
  ) where

import MAlonzo.RTE (AgdaAny)
import qualified MAlonzo.Code.Ace.Protocol as P

-- ── API actions ──────────────────────────────────────────────

type ApiAction = P.T_ApiAction_30

pattern GetProfile :: ApiAction
pattern GetProfile = P.C_GetProfile_32

pattern SendMessage :: ApiAction
pattern SendMessage = P.C_SendMessage_34

pattern ListChannels :: ApiAction
pattern ListChannels = P.C_ListChannels_36

pattern ToggleComplete :: ApiAction
pattern ToggleComplete = P.C_ToggleComplete_38

pattern GetSubscription :: ApiAction
pattern GetSubscription = P.C_GetSubscription_40

pattern StartTrial :: ApiAction
pattern StartTrial = P.C_StartTrial_42

pattern CancelSub :: ApiAction
pattern CancelSub = P.C_CancelSub_44

{-# COMPLETE GetProfile, SendMessage, ListChannels, ToggleComplete,
             GetSubscription, StartTrial, CancelSub #-}


-- ── Error codes ──────────────────────────────────────────────

type ErrorCode = P.T_ErrorCode_50

pattern NotFound :: ErrorCode
pattern NotFound = P.C_NotFound_52

pattern Unauthorized :: ErrorCode
pattern Unauthorized = P.C_Unauthorized_54

pattern InvalidInput :: ErrorCode
pattern InvalidInput = P.C_InvalidInput_56

pattern ServerError :: ErrorCode
pattern ServerError = P.C_ServerError_58

{-# COMPLETE NotFound, Unauthorized, InvalidInput, ServerError #-}


-- ── Request ──────────────────────────────────────────────────

type Request = P.T_Request_60

pattern MkReq :: AgdaAny -> Request
pattern MkReq payload = P.C_mkReq_64 payload

{-# COMPLETE MkReq #-}


-- ── Response ─────────────────────────────────────────────────

type Response = P.T_Response_66

pattern Ok :: AgdaAny -> Response
pattern Ok val = P.C_ok_70 val

pattern Err :: ErrorCode -> Response
pattern Err code = P.C_err_74 code

{-# COMPLETE Ok, Err #-}


-- ── Dispatch ─────────────────────────────────────────────────

-- | Total dispatch: every action has a handler.
-- Proven exhaustive by Agda's coverage checker.
dispatch :: ApiAction -> AgdaAny -> Response
dispatch = P.d_dispatch_96

-- | Process a typed request, dispatching to the correct handler.
processRequest :: ApiAction -> Request -> Response
processRequest = P.d_processRequest_106
