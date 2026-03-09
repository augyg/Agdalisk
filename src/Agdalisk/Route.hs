{-# LANGUAGE PatternSynonyms #-}

-- | Verified routing for the Ace platform.
--
-- Every route has a computed payload type, computed response type,
-- and computed auth level. Dispatch is total — add a route without
-- a handler and the Agda source won't compile.
--
-- Source: agda/Ace/Route.agda
module Agdalisk.Route
  ( -- * Page routes (frontend)
    PageRoute
  , pattern Home
  , pattern Login
  , pattern Profile
  , pattern Leaderboard
  , pattern Games
  , pattern Admin
  , pattern CodeChallenge
    -- * API routes (backend)
  , ApiRoute
  , pattern ApiLogin
  , pattern ApiGetProfile
  , pattern ApiSendMessage
  , pattern ApiListChannels
  , pattern ApiToggleTodo
  , pattern ApiPostJob
    -- * Auth levels
  , AuthLevel
  , pattern Public
  , pattern Authenticated
  , pattern AdminOnly
    -- * Route response
  , RouteResponse
  , pattern Ok
  , pattern Err
    -- * Path computation
  , pagePath
  , apiPath
    -- * Auth computation
  , routeAuth
  , pageAuth
    -- * Dispatch
  , apiDispatch
  , processApiRequest
  ) where

import Data.Text (Text)
import MAlonzo.RTE (AgdaAny)
import qualified MAlonzo.Code.Ace.Route as R
import qualified MAlonzo.Code.Ace.Protocol as P

-- ── Page routes ──────────────────────────────────────────

type PageRoute = R.T_PageRoute_4

pattern Home :: PageRoute
pattern Home = R.C_Home_6

pattern Login :: PageRoute
pattern Login = R.C_Login_8

pattern Profile :: PageRoute
pattern Profile = R.C_Profile_10

pattern Leaderboard :: PageRoute
pattern Leaderboard = R.C_Leaderboard_12

pattern Games :: PageRoute
pattern Games = R.C_Games_14

pattern Admin :: PageRoute
pattern Admin = R.C_Admin_16

pattern CodeChallenge :: PageRoute
pattern CodeChallenge = R.C_CodeChallenge_18

{-# COMPLETE Home, Login, Profile, Leaderboard, Games, Admin, CodeChallenge #-}


-- ── API routes ───────────────────────────────────────────

type ApiRoute = R.T_ApiRoute_20

pattern ApiLogin :: ApiRoute
pattern ApiLogin = R.C_ApiLogin_22

pattern ApiGetProfile :: ApiRoute
pattern ApiGetProfile = R.C_ApiGetProfile_24

pattern ApiSendMessage :: ApiRoute
pattern ApiSendMessage = R.C_ApiSendMessage_26

pattern ApiListChannels :: ApiRoute
pattern ApiListChannels = R.C_ApiListChannels_28

pattern ApiToggleTodo :: ApiRoute
pattern ApiToggleTodo = R.C_ApiToggleTodo_30

pattern ApiPostJob :: ApiRoute
pattern ApiPostJob = R.C_ApiPostJob_32

{-# COMPLETE ApiLogin, ApiGetProfile, ApiSendMessage, ApiListChannels, ApiToggleTodo, ApiPostJob #-}


-- ── Auth levels ──────────────────────────────────────────

type AuthLevel = R.T_AuthLevel_34

pattern Public :: AuthLevel
pattern Public = R.C_Public_36

pattern Authenticated :: AuthLevel
pattern Authenticated = R.C_Authenticated_38

pattern AdminOnly :: AuthLevel
pattern AdminOnly = R.C_AdminOnly_40

{-# COMPLETE Public, Authenticated, AdminOnly #-}


-- ── Route response ───────────────────────────────────────

type RouteResponse = R.T_RouteResponse_48

pattern Ok :: AgdaAny -> RouteResponse
pattern Ok val = R.C_ok_52 val

pattern Err :: P.T_ErrorCode_50 -> RouteResponse
pattern Err code = R.C_err_56 code

{-# COMPLETE Ok, Err #-}


-- ── Path computation ─────────────────────────────────────

pagePath :: PageRoute -> [Text]
pagePath = R.d_pagePath_58

apiPath :: ApiRoute -> [Text]
apiPath = R.d_apiPath_60


-- ── Auth computation ─────────────────────────────────────

routeAuth :: ApiRoute -> AuthLevel
routeAuth = R.d_routeAuth_62

pageAuth :: PageRoute -> AuthLevel
pageAuth = R.d_pageAuth_64


-- ── Dispatch ─────────────────────────────────────────────

apiDispatch :: ApiRoute -> AgdaAny -> RouteResponse
apiDispatch = R.d_apiDispatch_84

processApiRequest :: ApiRoute -> AgdaAny -> RouteResponse
processApiRequest = R.d_processApiRequest_88
