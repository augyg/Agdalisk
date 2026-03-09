module Ace.Route where

open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool
open import Agda.Builtin.Equality
open import Agda.Builtin.List
open import Agda.Builtin.String
open import Agda.Builtin.Maybe

open import Ace.Protocol using (U; BOOL; NAT; STR; LIST; MAYBE; PAIR; UNIT; El; ErrorCode; NotFound; Unauthorized; InvalidInput; ServerError)

-- ═══════════════════════════════════════════════════════════
--
--  VERIFIED ROUTING
--
--  Routes are data. Payloads are computed from routes.
--  Response types are computed from routes.
--  Dispatch is total — add a route without a handler
--  and this module will not compile.
--
--  URL path segments are a function of the route,
--  not a manually maintained string mapping.
--
-- ═══════════════════════════════════════════════════════════


-- ─── Page routes (frontend) ──────────────────────────────

data PageRoute : Set where
  Home          : PageRoute
  Login         : PageRoute
  Profile       : PageRoute
  Leaderboard   : PageRoute
  Games         : PageRoute
  Admin         : PageRoute
  CodeChallenge : PageRoute


-- ─── API routes (backend) ────────────────────────────────

data ApiRoute : Set where
  ApiLogin        : ApiRoute
  ApiGetProfile   : ApiRoute
  ApiSendMessage  : ApiRoute
  ApiListChannels : ApiRoute
  ApiToggleTodo   : ApiRoute
  ApiPostJob      : ApiRoute


-- ─── Auth levels ─────────────────────────────────────────

data AuthLevel : Set where
  Public        : AuthLevel
  Authenticated : AuthLevel
  AdminOnly     : AuthLevel


-- ─── Page payload: what the URL carries ──────────────────

PagePayload : PageRoute → U
PagePayload Home          = UNIT
PagePayload Login         = UNIT
PagePayload Profile       = NAT         -- account ID
PagePayload Leaderboard   = UNIT
PagePayload Games         = UNIT
PagePayload Admin         = UNIT
PagePayload CodeChallenge = NAT         -- challenge ID


-- ─── API payload: what the request carries ───────────────

ApiPayload : ApiRoute → U
ApiPayload ApiLogin        = PAIR STR STR   -- (email, password)
ApiPayload ApiGetProfile   = NAT            -- account ID
ApiPayload ApiSendMessage  = PAIR NAT STR   -- (room ID, message text)
ApiPayload ApiListChannels = UNIT           -- no payload
ApiPayload ApiToggleTodo   = NAT            -- todo ID
ApiPayload ApiPostJob      = STR            -- job data


-- ─── API response: what the handler returns ──────────────

ApiRespType : ApiRoute → U
ApiRespType ApiLogin        = MAYBE STR          -- Maybe token
ApiRespType ApiGetProfile   = MAYBE STR          -- Maybe username
ApiRespType ApiSendMessage  = BOOL               -- success?
ApiRespType ApiListChannels = LIST (PAIR NAT STR) -- [(id, name)]
ApiRespType ApiToggleTodo   = BOOL               -- new state
ApiRespType ApiPostJob      = MAYBE NAT          -- Maybe job ID


-- ─── Typed response for routes ───────────────────────────

data RouteResponse : ApiRoute → Set where
  ok  : {r : ApiRoute} → El (ApiRespType r) → RouteResponse r
  err : {r : ApiRoute} → ErrorCode → RouteResponse r


-- ─── Path segments: computed from the route ──────────────
--
-- No manual string mapping. The URL structure is a
-- FUNCTION of the route constructor.

pagePath : PageRoute → List String
pagePath Home          = []
pagePath Login         = "login" ∷ []
pagePath Profile       = "profile" ∷ []
pagePath Leaderboard   = "leaderboard" ∷ []
pagePath Games         = "games" ∷ []
pagePath Admin         = "admin" ∷ []
pagePath CodeChallenge = "challenge" ∷ []

apiPath : ApiRoute → List String
apiPath ApiLogin        = "api" ∷ "login" ∷ []
apiPath ApiGetProfile   = "api" ∷ "profile" ∷ []
apiPath ApiSendMessage  = "api" ∷ "message" ∷ []
apiPath ApiListChannels = "api" ∷ "channels" ∷ []
apiPath ApiToggleTodo   = "api" ∷ "todo" ∷ "toggle" ∷ []
apiPath ApiPostJob      = "api" ∷ "job" ∷ []


-- ─── Auth requirement: computed from the route ───────────

routeAuth : ApiRoute → AuthLevel
routeAuth ApiLogin        = Public
routeAuth ApiGetProfile   = Authenticated
routeAuth ApiSendMessage  = Authenticated
routeAuth ApiListChannels = Authenticated
routeAuth ApiToggleTodo   = Authenticated
routeAuth ApiPostJob      = Public

pageAuth : PageRoute → AuthLevel
pageAuth Home          = Public
pageAuth Login         = Public
pageAuth Profile       = Authenticated
pageAuth Leaderboard   = Public
pageAuth Games         = Authenticated
pageAuth Admin         = AdminOnly
pageAuth CodeChallenge = Authenticated


-- ─── Handler type ────────────────────────────────────────

ApiHandler : ApiRoute → Set
ApiHandler r = El (ApiPayload r) → RouteResponse r


-- ─── Example handlers ────────────────────────────────────

loginHandler : ApiHandler ApiLogin
loginHandler _ = ok (just "token-abc123")

getProfileHandler : ApiHandler ApiGetProfile
getProfileHandler _ = ok (just "alice")

sendMessageHandler : ApiHandler ApiSendMessage
sendMessageHandler _ = ok true

listChannelsHandler : ApiHandler ApiListChannels
listChannelsHandler _ = ok []

toggleTodoHandler : ApiHandler ApiToggleTodo
toggleTodoHandler _ = ok true

postJobHandler : ApiHandler ApiPostJob
postJobHandler _ = ok (just 1)


-- ─── Total dispatch ──────────────────────────────────────
--
-- If you add an ApiRoute constructor and forget to add
-- a case here, Agda WILL NOT COMPILE this module.

apiDispatch : (r : ApiRoute) → ApiHandler r
apiDispatch ApiLogin        = loginHandler
apiDispatch ApiGetProfile   = getProfileHandler
apiDispatch ApiSendMessage  = sendMessageHandler
apiDispatch ApiListChannels = listChannelsHandler
apiDispatch ApiToggleTodo   = toggleTodoHandler
apiDispatch ApiPostJob      = postJobHandler


-- ─── Process a routed request ────────────────────────────

processApiRequest : (r : ApiRoute) → El (ApiPayload r) → RouteResponse r
processApiRequest r payload = apiDispatch r payload


-- ═══════════════════════════════════════════════════════════
--  THEOREMS
-- ═══════════════════════════════════════════════════════════

-- Dispatch is total (coverage checker guarantees this)
-- Path functions are total (coverage checker guarantees this)
-- Auth functions are total (coverage checker guarantees this)

-- Login does not require authentication
login-is-public : routeAuth ApiLogin ≡ Public
login-is-public = refl

-- GetProfile requires authentication
get-profile-needs-auth : routeAuth ApiGetProfile ≡ Authenticated
get-profile-needs-auth = refl

-- Admin page requires admin
admin-page-needs-admin : pageAuth Admin ≡ AdminOnly
admin-page-needs-admin = refl

-- PostJob is public (no auth required)
post-job-is-public : routeAuth ApiPostJob ≡ Public
post-job-is-public = refl

-- Home page has no payload
home-has-no-payload : PagePayload Home ≡ UNIT
home-has-no-payload = refl

-- Profile page carries an account ID
profile-carries-id : PagePayload Profile ≡ NAT
profile-carries-id = refl


-- ═══════════════════════════════════════════════════════════
--  COMPILE-TIME TESTS
-- ═══════════════════════════════════════════════════════════

-- Login request with email/password
_ : RouteResponse ApiLogin
_ = processApiRequest ApiLogin "email@test.com"

-- Get profile for account 42
_ : RouteResponse ApiGetProfile
_ = processApiRequest ApiGetProfile 42

-- List channels (unit payload = 0)
_ : RouteResponse ApiListChannels
_ = processApiRequest ApiListChannels 0

-- Toggle todo 7
_ : RouteResponse ApiToggleTodo
_ = processApiRequest ApiToggleTodo 7

-- Post a job
_ : RouteResponse ApiPostJob
_ = processApiRequest ApiPostJob "Software Engineer"

-- Path for login page
_ : List String
_ = pagePath Login  -- evaluates to "login" ∷ []

-- Path for API toggle todo
_ : List String
_ = apiPath ApiToggleTodo  -- evaluates to "api" ∷ "todo" ∷ "toggle" ∷ []
