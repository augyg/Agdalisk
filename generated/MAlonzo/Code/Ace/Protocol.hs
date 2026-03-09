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

module MAlonzo.Code.Ace.Protocol where

import MAlonzo.RTE (coe, erased, AgdaAny, addInt, subInt, mulInt,
                    quotInt, remInt, geqInt, ltInt, eqInt, add64, sub64, mul64, quot64,
                    rem64, lt64, eq64, word64FromNat, word64ToNat)
import qualified MAlonzo.RTE
import qualified Data.Text
import qualified MAlonzo.Code.Agda.Builtin.Bool
import qualified MAlonzo.Code.Agda.Builtin.List
import qualified MAlonzo.Code.Agda.Builtin.Maybe
import qualified MAlonzo.Code.Agda.Builtin.String

-- Ace.Protocol.U
d_U_4 = ()
data T_U_4
  = C_BOOL_6 | C_NAT_8 | C_STR_10 | C_LIST_12 T_U_4 |
    C_MAYBE_14 T_U_4 | C_PAIR_16 T_U_4 T_U_4 | C_UNIT_18
-- Ace.Protocol.El
d_El_20 :: T_U_4 -> ()
d_El_20 = erased
-- Ace.Protocol.ApiAction
d_ApiAction_30 = ()
data T_ApiAction_30
  = C_GetProfile_32 | C_SendMessage_34 | C_ListChannels_36 |
    C_ToggleComplete_38 | C_GetSubscription_40 | C_StartTrial_42 |
    C_CancelSub_44
-- Ace.Protocol.ReqPayload
d_ReqPayload_46 :: T_ApiAction_30 -> T_U_4
d_ReqPayload_46 v0
  = case coe v0 of
      C_GetProfile_32 -> coe C_NAT_8
      C_SendMessage_34 -> coe C_PAIR_16 (coe C_NAT_8) (coe C_STR_10)
      C_ListChannels_36 -> coe C_UNIT_18
      C_ToggleComplete_38 -> coe C_NAT_8
      C_GetSubscription_40 -> coe C_NAT_8
      C_StartTrial_42 -> coe C_NAT_8
      C_CancelSub_44 -> coe C_NAT_8
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Protocol.RespPayload
d_RespPayload_48 :: T_ApiAction_30 -> T_U_4
d_RespPayload_48 v0
  = case coe v0 of
      C_GetProfile_32 -> coe C_MAYBE_14 (coe C_STR_10)
      C_SendMessage_34 -> coe C_BOOL_6
      C_ListChannels_36
        -> coe C_LIST_12 (coe C_PAIR_16 (coe C_NAT_8) (coe C_STR_10))
      C_ToggleComplete_38 -> coe C_BOOL_6
      C_GetSubscription_40 -> coe C_NAT_8
      C_StartTrial_42 -> coe C_BOOL_6
      C_CancelSub_44 -> coe C_BOOL_6
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Protocol.ErrorCode
d_ErrorCode_50 = ()
data T_ErrorCode_50
  = C_NotFound_52 | C_Unauthorized_54 | C_InvalidInput_56 |
    C_ServerError_58
-- Ace.Protocol.Request
d_Request_60 a0 = ()
newtype T_Request_60 = C_mkReq_64 AgdaAny
-- Ace.Protocol.Response
d_Response_66 a0 = ()
data T_Response_66 = C_ok_70 AgdaAny | C_err_74 T_ErrorCode_50
-- Ace.Protocol.Handler
d_Handler_76 :: T_ApiAction_30 -> ()
d_Handler_76 = erased
-- Ace.Protocol.getProfileHandler
d_getProfileHandler_80 :: Integer -> T_Response_66
d_getProfileHandler_80 ~v0 = du_getProfileHandler_80
du_getProfileHandler_80 :: T_Response_66
du_getProfileHandler_80
  = coe
      C_ok_70
      (coe
         MAlonzo.Code.Agda.Builtin.Maybe.C_just_16
         (coe
            MAlonzo.Code.Agda.Builtin.String.d_primStringAppend_16
            ("user-" :: Data.Text.Text) ("name" :: Data.Text.Text)))
-- Ace.Protocol.sendMessageHandler
d_sendMessageHandler_84 :: Integer -> T_Response_66
d_sendMessageHandler_84 ~v0 = du_sendMessageHandler_84
du_sendMessageHandler_84 :: T_Response_66
du_sendMessageHandler_84
  = coe C_ok_70 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10)
-- Ace.Protocol.listChannelsHandler
d_listChannelsHandler_88 :: Integer -> T_Response_66
d_listChannelsHandler_88 ~v0 = du_listChannelsHandler_88
du_listChannelsHandler_88 :: T_Response_66
du_listChannelsHandler_88
  = coe C_ok_70 (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
-- Ace.Protocol.toggleHandler
d_toggleHandler_90 :: Integer -> T_Response_66
d_toggleHandler_90 ~v0 = du_toggleHandler_90
du_toggleHandler_90 :: T_Response_66
du_toggleHandler_90
  = coe C_ok_70 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10)
-- Ace.Protocol.dispatch
d_dispatch_96 :: T_ApiAction_30 -> AgdaAny -> T_Response_66
d_dispatch_96 v0
  = case coe v0 of
      C_GetProfile_32 -> coe (\ v1 -> coe du_getProfileHandler_80)
      C_SendMessage_34 -> coe (\ v1 -> coe du_sendMessageHandler_84)
      C_ListChannels_36 -> coe (\ v1 -> coe du_listChannelsHandler_88)
      C_ToggleComplete_38 -> coe (\ v1 -> coe du_toggleHandler_90)
      C_GetSubscription_40 -> coe (\ v1 -> coe C_ok_70 (0 :: Integer))
      C_StartTrial_42
        -> coe
             (\ v1 ->
                coe C_ok_70 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10))
      C_CancelSub_44
        -> coe
             (\ v1 ->
                coe C_ok_70 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10))
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Protocol.processRequest
d_processRequest_106 ::
  T_ApiAction_30 -> T_Request_60 -> T_Response_66
d_processRequest_106 v0 v1
  = case coe v1 of
      C_mkReq_64 v3 -> coe d_dispatch_96 v0 v3
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Protocol.process-preserves-action
d_process'45'preserves'45'action_116 ::
  T_ApiAction_30 -> T_Request_60 -> T_Response_66
d_process'45'preserves'45'action_116 v0
  = coe d_processRequest_106 (coe v0)
