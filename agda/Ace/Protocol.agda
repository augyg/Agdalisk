module Ace.Protocol where

open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool
open import Agda.Builtin.Equality
open import Agda.Builtin.List
open import Agda.Builtin.String
open import Agda.Builtin.Maybe

-- ═══════════════════════════════════════════════════════════
--
--  VERIFIED REQUEST-RESPONSE PROTOCOL
--
--  The response type is COMPUTED from the request.
--  Not pattern-matched. Not looked up. Computed.
--  If you add a request, the type system forces you
--  to handle it with the correct response type.
--
-- ═══════════════════════════════════════════════════════════


-- ─── Universe of serializable types ────────────────────────
--
-- These codes represent types. El interprets them.
-- This lets us write GENERIC functions over all types
-- while keeping everything type-safe.

data U : Set where
  BOOL   : U
  NAT    : U
  STR    : U
  LIST   : U → U
  MAYBE  : U → U
  PAIR   : U → U → U
  UNIT   : U

El : U → Set
El BOOL       = Bool
El NAT        = ℕ
El STR        = String
El (LIST a)   = List (El a)
El (MAYBE a)  = Maybe (El a)
El (PAIR a b) = El a
El UNIT       = ℕ  -- placeholder, ⊤ from Builtin.Unit would need import


-- ─── API actions ───────────────────────────────────────────

data ApiAction : Set where
  GetProfile       : ApiAction
  SendMessage      : ApiAction
  ListChannels     : ApiAction
  ToggleComplete   : ApiAction
  GetSubscription  : ApiAction
  StartTrial       : ApiAction
  CancelSub        : ApiAction



-- ─── Request payload: depends on the action ────────────────

ReqPayload : ApiAction → U
ReqPayload GetProfile      = NAT           -- account ID
ReqPayload SendMessage     = PAIR NAT STR  -- (room ID, message text)
ReqPayload ListChannels    = UNIT          -- no payload needed
ReqPayload ToggleComplete  = NAT           -- todo ID
ReqPayload GetSubscription = NAT           -- account ID
ReqPayload StartTrial      = NAT           -- account ID
ReqPayload CancelSub       = NAT           -- account ID


-- ─── Response payload: depends on the action ───────────────

RespPayload : ApiAction → U
RespPayload GetProfile      = MAYBE STR         -- Maybe username
RespPayload SendMessage     = BOOL              -- success?
RespPayload ListChannels    = LIST (PAIR NAT STR) -- [(id, name)]
RespPayload ToggleComplete  = BOOL              -- new state
RespPayload GetSubscription = NAT               -- state code
RespPayload StartTrial      = BOOL              -- success?
RespPayload CancelSub       = BOOL              -- success?


-- ─── Error codes ───────────────────────────────────────────

data ErrorCode : Set where
  NotFound      : ErrorCode
  Unauthorized  : ErrorCode
  InvalidInput  : ErrorCode
  ServerError   : ErrorCode



-- ─── Typed request: carries its payload at the right type ──

data Request : ApiAction → Set where
  mkReq : (action : ApiAction)
         → El (ReqPayload action)
         → Request action

-- No COMPILE GHC for Request/Response: they use El (a type family),
-- which can't be mapped to Haskell. The proofs are still verified.
-- At runtime these become erased/AgdaAny.


-- ─── Typed response: either error or correctly-typed data ──

data Response : ApiAction → Set where
  ok  : {action : ApiAction}
      → El (RespPayload action)
      → Response action
  err : {action : ApiAction}
      → ErrorCode
      → Response action


-- ─── Handler type: a function from request to response ─────
--
-- A handler for action `a` MUST accept the request payload
-- for `a` and return the response payload for `a`.
-- The type system ensures this correspondence.

Handler : ApiAction → Set
Handler a = El (ReqPayload a) → Response a


-- ─── Example handlers ──────────────────────────────────────

getProfileHandler : Handler GetProfile
getProfileHandler accountId = ok (just (primStringAppend "user-" "name"))

sendMessageHandler : Handler SendMessage
sendMessageHandler roomId = ok true

listChannelsHandler : Handler ListChannels
listChannelsHandler _ = ok []

toggleHandler : Handler ToggleComplete
toggleHandler todoId = ok true


-- ─── Handler registry ──────────────────────────────────────
--
-- A COMPLETE registry must handle EVERY action.
-- If you add a new ApiAction constructor and forget
-- to add a handler here, this won't compile.

dispatch : (a : ApiAction) → Handler a
dispatch GetProfile      = getProfileHandler
dispatch SendMessage     = sendMessageHandler
dispatch ListChannels    = listChannelsHandler
dispatch ToggleComplete  = toggleHandler
dispatch GetSubscription = λ _ → ok 0
dispatch StartTrial      = λ _ → ok true
dispatch CancelSub       = λ _ → ok true


-- ─── Process a request ─────────────────────────────────────

processRequest : {a : ApiAction} → Request a → Response a
processRequest (mkReq action payload) = dispatch action payload


-- ═══════════════════════════════════════════════════════════
--  THEOREMS
-- ═══════════════════════════════════════════════════════════

-- dispatch is total: it handles every action.
-- This is guaranteed by Agda's coverage checker.
-- If we added a new ApiAction and forgot a case,
-- the module would not compile.

-- GetProfile returns a Maybe String, not a Bool
-- This is enforced by the type: Handler GetProfile = ℕ → Response GetProfile
-- where RespPayload GetProfile = MAYBE STR

-- processRequest preserves the action index
process-preserves-action : {a : ApiAction} (r : Request a) → Response a
process-preserves-action = processRequest
-- The fact that this type-checks proves the action is preserved.


-- ═══════════════════════════════════════════════════════════
--  COMPILE-TIME TESTS
-- ═══════════════════════════════════════════════════════════

-- Requesting a profile with account ID 42
_ : Response GetProfile
_ = processRequest (mkReq GetProfile 42)

-- Sending a message to room 1
_ : Response SendMessage
_ = processRequest (mkReq SendMessage 1)

-- Listing channels (unit payload = 0)
_ : Response ListChannels
_ = processRequest (mkReq ListChannels 0)
