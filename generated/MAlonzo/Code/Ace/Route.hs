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

module MAlonzo.Code.Ace.Route where

import MAlonzo.RTE (coe, erased, AgdaAny, addInt, subInt, mulInt,
                    quotInt, remInt, geqInt, ltInt, eqInt, add64, sub64, mul64, quot64,
                    rem64, lt64, eq64, word64FromNat, word64ToNat)
import qualified MAlonzo.RTE
import qualified Data.Text
import qualified MAlonzo.Code.Ace.Protocol
import qualified MAlonzo.Code.Agda.Builtin.Bool
import qualified MAlonzo.Code.Agda.Builtin.Equality
import qualified MAlonzo.Code.Agda.Builtin.List
import qualified MAlonzo.Code.Agda.Builtin.Maybe
import qualified MAlonzo.Code.Agda.Builtin.String

-- Ace.Route.PageRoute
d_PageRoute_4 = ()
data T_PageRoute_4
  = C_Home_6 | C_Login_8 | C_Profile_10 | C_Leaderboard_12 |
    C_Games_14 | C_Admin_16 | C_CodeChallenge_18
-- Ace.Route.ApiRoute
d_ApiRoute_20 = ()
data T_ApiRoute_20
  = C_ApiLogin_22 | C_ApiGetProfile_24 | C_ApiSendMessage_26 |
    C_ApiListChannels_28 | C_ApiToggleTodo_30 | C_ApiPostJob_32
-- Ace.Route.AuthLevel
d_AuthLevel_34 = ()
data T_AuthLevel_34
  = C_Public_36 | C_Authenticated_38 | C_AdminOnly_40
-- Ace.Route.PagePayload
d_PagePayload_42 ::
  T_PageRoute_4 -> MAlonzo.Code.Ace.Protocol.T_U_4
d_PagePayload_42 v0
  = case coe v0 of
      C_Home_6 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_Login_8 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_Profile_10 -> coe MAlonzo.Code.Ace.Protocol.C_NAT_8
      C_Leaderboard_12 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_Games_14 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_Admin_16 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_CodeChallenge_18 -> coe MAlonzo.Code.Ace.Protocol.C_NAT_8
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.ApiPayload
d_ApiPayload_44 :: T_ApiRoute_20 -> MAlonzo.Code.Ace.Protocol.T_U_4
d_ApiPayload_44 v0
  = case coe v0 of
      C_ApiLogin_22
        -> coe
             MAlonzo.Code.Ace.Protocol.C_PAIR_16
             (coe MAlonzo.Code.Ace.Protocol.C_STR_10)
             (coe MAlonzo.Code.Ace.Protocol.C_STR_10)
      C_ApiGetProfile_24 -> coe MAlonzo.Code.Ace.Protocol.C_NAT_8
      C_ApiSendMessage_26
        -> coe
             MAlonzo.Code.Ace.Protocol.C_PAIR_16
             (coe MAlonzo.Code.Ace.Protocol.C_NAT_8)
             (coe MAlonzo.Code.Ace.Protocol.C_STR_10)
      C_ApiListChannels_28 -> coe MAlonzo.Code.Ace.Protocol.C_UNIT_18
      C_ApiToggleTodo_30 -> coe MAlonzo.Code.Ace.Protocol.C_NAT_8
      C_ApiPostJob_32 -> coe MAlonzo.Code.Ace.Protocol.C_STR_10
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.ApiRespType
d_ApiRespType_46 ::
  T_ApiRoute_20 -> MAlonzo.Code.Ace.Protocol.T_U_4
d_ApiRespType_46 v0
  = case coe v0 of
      C_ApiLogin_22
        -> coe
             MAlonzo.Code.Ace.Protocol.C_MAYBE_14
             (coe MAlonzo.Code.Ace.Protocol.C_STR_10)
      C_ApiGetProfile_24
        -> coe
             MAlonzo.Code.Ace.Protocol.C_MAYBE_14
             (coe MAlonzo.Code.Ace.Protocol.C_STR_10)
      C_ApiSendMessage_26 -> coe MAlonzo.Code.Ace.Protocol.C_BOOL_6
      C_ApiListChannels_28
        -> coe
             MAlonzo.Code.Ace.Protocol.C_LIST_12
             (coe
                MAlonzo.Code.Ace.Protocol.C_PAIR_16
                (coe MAlonzo.Code.Ace.Protocol.C_NAT_8)
                (coe MAlonzo.Code.Ace.Protocol.C_STR_10))
      C_ApiToggleTodo_30 -> coe MAlonzo.Code.Ace.Protocol.C_BOOL_6
      C_ApiPostJob_32
        -> coe
             MAlonzo.Code.Ace.Protocol.C_MAYBE_14
             (coe MAlonzo.Code.Ace.Protocol.C_NAT_8)
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.RouteResponse
d_RouteResponse_48 a0 = ()
data T_RouteResponse_48
  = C_ok_52 AgdaAny |
    C_err_56 MAlonzo.Code.Ace.Protocol.T_ErrorCode_50
-- Ace.Route.pagePath
d_pagePath_58 ::
  T_PageRoute_4 -> [MAlonzo.Code.Agda.Builtin.String.T_String_6]
d_pagePath_58 v0
  = case coe v0 of
      C_Home_6 -> coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16
      C_Login_8
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("login" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      C_Profile_10
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("profile" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      C_Leaderboard_12
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("leaderboard" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      C_Games_14
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("games" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      C_Admin_16
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("admin" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      C_CodeChallenge_18
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("challenge" :: Data.Text.Text))
             (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.apiPath
d_apiPath_60 ::
  T_ApiRoute_20 -> [MAlonzo.Code.Agda.Builtin.String.T_String_6]
d_apiPath_60 v0
  = case coe v0 of
      C_ApiLogin_22
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("login" :: Data.Text.Text))
                (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16))
      C_ApiGetProfile_24
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("profile" :: Data.Text.Text))
                (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16))
      C_ApiSendMessage_26
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("message" :: Data.Text.Text))
                (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16))
      C_ApiListChannels_28
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("channels" :: Data.Text.Text))
                (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16))
      C_ApiToggleTodo_30
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("todo" :: Data.Text.Text))
                (coe
                   MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                   (coe ("toggle" :: Data.Text.Text))
                   (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)))
      C_ApiPostJob_32
        -> coe
             MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
             (coe ("api" :: Data.Text.Text))
             (coe
                MAlonzo.Code.Agda.Builtin.List.C__'8759'__22
                (coe ("job" :: Data.Text.Text))
                (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16))
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.routeAuth
d_routeAuth_62 :: T_ApiRoute_20 -> T_AuthLevel_34
d_routeAuth_62 v0
  = case coe v0 of
      C_ApiLogin_22 -> coe C_Public_36
      C_ApiGetProfile_24 -> coe C_Authenticated_38
      C_ApiSendMessage_26 -> coe C_Authenticated_38
      C_ApiListChannels_28 -> coe C_Authenticated_38
      C_ApiToggleTodo_30 -> coe C_Authenticated_38
      C_ApiPostJob_32 -> coe C_Public_36
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.pageAuth
d_pageAuth_64 :: T_PageRoute_4 -> T_AuthLevel_34
d_pageAuth_64 v0
  = case coe v0 of
      C_Home_6 -> coe C_Public_36
      C_Login_8 -> coe C_Public_36
      C_Profile_10 -> coe C_Authenticated_38
      C_Leaderboard_12 -> coe C_Public_36
      C_Games_14 -> coe C_Authenticated_38
      C_Admin_16 -> coe C_AdminOnly_40
      C_CodeChallenge_18 -> coe C_Authenticated_38
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.ApiHandler
d_ApiHandler_66 :: T_ApiRoute_20 -> ()
d_ApiHandler_66 = erased
-- Ace.Route.loginHandler
d_loginHandler_70 ::
  MAlonzo.Code.Agda.Builtin.String.T_String_6 -> T_RouteResponse_48
d_loginHandler_70 ~v0 = du_loginHandler_70
du_loginHandler_70 :: T_RouteResponse_48
du_loginHandler_70
  = coe
      C_ok_52
      (coe
         MAlonzo.Code.Agda.Builtin.Maybe.C_just_16
         (coe ("token-abc123" :: Data.Text.Text)))
-- Ace.Route.getProfileHandler
d_getProfileHandler_72 :: Integer -> T_RouteResponse_48
d_getProfileHandler_72 ~v0 = du_getProfileHandler_72
du_getProfileHandler_72 :: T_RouteResponse_48
du_getProfileHandler_72
  = coe
      C_ok_52
      (coe
         MAlonzo.Code.Agda.Builtin.Maybe.C_just_16
         (coe ("alice" :: Data.Text.Text)))
-- Ace.Route.sendMessageHandler
d_sendMessageHandler_74 :: Integer -> T_RouteResponse_48
d_sendMessageHandler_74 ~v0 = du_sendMessageHandler_74
du_sendMessageHandler_74 :: T_RouteResponse_48
du_sendMessageHandler_74
  = coe C_ok_52 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10)
-- Ace.Route.listChannelsHandler
d_listChannelsHandler_76 :: Integer -> T_RouteResponse_48
d_listChannelsHandler_76 ~v0 = du_listChannelsHandler_76
du_listChannelsHandler_76 :: T_RouteResponse_48
du_listChannelsHandler_76
  = coe C_ok_52 (coe MAlonzo.Code.Agda.Builtin.List.C_'91''93'_16)
-- Ace.Route.toggleTodoHandler
d_toggleTodoHandler_78 :: Integer -> T_RouteResponse_48
d_toggleTodoHandler_78 ~v0 = du_toggleTodoHandler_78
du_toggleTodoHandler_78 :: T_RouteResponse_48
du_toggleTodoHandler_78
  = coe C_ok_52 (coe MAlonzo.Code.Agda.Builtin.Bool.C_true_10)
-- Ace.Route.postJobHandler
d_postJobHandler_80 ::
  MAlonzo.Code.Agda.Builtin.String.T_String_6 -> T_RouteResponse_48
d_postJobHandler_80 ~v0 = du_postJobHandler_80
du_postJobHandler_80 :: T_RouteResponse_48
du_postJobHandler_80
  = coe
      C_ok_52
      (coe
         MAlonzo.Code.Agda.Builtin.Maybe.C_just_16 (coe (1 :: Integer)))
-- Ace.Route.apiDispatch
d_apiDispatch_84 :: T_ApiRoute_20 -> AgdaAny -> T_RouteResponse_48
d_apiDispatch_84 v0
  = case coe v0 of
      C_ApiLogin_22 -> coe (\ v1 -> coe du_loginHandler_70)
      C_ApiGetProfile_24 -> coe (\ v1 -> coe du_getProfileHandler_72)
      C_ApiSendMessage_26 -> coe (\ v1 -> coe du_sendMessageHandler_74)
      C_ApiListChannels_28 -> coe (\ v1 -> coe du_listChannelsHandler_76)
      C_ApiToggleTodo_30 -> coe (\ v1 -> coe du_toggleTodoHandler_78)
      C_ApiPostJob_32 -> coe (\ v1 -> coe du_postJobHandler_80)
      _ -> MAlonzo.RTE.mazUnreachableError
-- Ace.Route.processApiRequest
d_processApiRequest_88 ::
  T_ApiRoute_20 -> AgdaAny -> T_RouteResponse_48
d_processApiRequest_88 v0 v1 = coe d_apiDispatch_84 v0 v1
-- Ace.Route.login-is-public
d_login'45'is'45'public_94 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_login'45'is'45'public_94 = erased
-- Ace.Route.get-profile-needs-auth
d_get'45'profile'45'needs'45'auth_96 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_get'45'profile'45'needs'45'auth_96 = erased
-- Ace.Route.admin-page-needs-admin
d_admin'45'page'45'needs'45'admin_98 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_admin'45'page'45'needs'45'admin_98 = erased
-- Ace.Route.post-job-is-public
d_post'45'job'45'is'45'public_100 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_post'45'job'45'is'45'public_100 = erased
-- Ace.Route.home-has-no-payload
d_home'45'has'45'no'45'payload_102 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_home'45'has'45'no'45'payload_102 = erased
-- Ace.Route.profile-carries-id
d_profile'45'carries'45'id_104 ::
  MAlonzo.Code.Agda.Builtin.Equality.T__'8801'__12
d_profile'45'carries'45'id_104 = erased
