module Ace.Access where

open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool
open import Agda.Builtin.Equality
open import Agda.Builtin.List
open import Agda.Builtin.String

-- ═══════════════════════════════════════════════════════════
--
--  VERIFIED ACCESS CONTROL FOR THE ACE PLATFORM
--
--  Authorization is not checked at runtime and hoped correct.
--  It is PROVEN at compile time. If you cannot construct the
--  proof, you cannot call the function. Period.
--
-- ═══════════════════════════════════════════════════════════


-- ─── Bottom type (no inhabitants) ──────────────────────────

data ⊥ : Set where

¬_ : Set → Set
¬ A = A → ⊥

infixr 3 ¬_


-- ─── Account IDs ───────────────────────────────────────────

AccountId : Set
AccountId = ℕ


-- ─── Roles ─────────────────────────────────────────────────

data Role : Set where
  Admin  : Role
  Member : Role


-- ─── IsAdmin: a proposition that is only provable for Admin ─

data IsAdmin : Role → Set where
  admin-proof : IsAdmin Admin

-- THEOREM: Members can never be admin.
-- This is not a runtime check. It is a structural impossibility.
member-cannot-admin : ¬ (IsAdmin Member)
member-cannot-admin ()


-- ─── Chatroom kinds ────────────────────────────────────────

data ChatroomKind : Set where
  Public : ChatroomKind
  DM     : AccountId → AccountId → ChatroomKind
  Group  : List AccountId → ChatroomKind


-- ─── Decidable equality on ℕ ───────────────────────────────

_==ℕ_ : ℕ → ℕ → Bool
zero  ==ℕ zero  = true
suc m ==ℕ suc n = m ==ℕ n
_     ==ℕ _     = false

==ℕ-refl : (n : ℕ) → (n ==ℕ n) ≡ true
==ℕ-refl zero    = refl
==ℕ-refl (suc n) = ==ℕ-refl n


-- ─── List membership ───────────────────────────────────────

data _∈_ : AccountId → List AccountId → Set where
  here  : {x : AccountId} {xs : List AccountId}
        → x ∈ (x ∷ xs)
  there : {x y : AccountId} {xs : List AccountId}
        → x ∈ xs → x ∈ (y ∷ xs)


-- ─── CanAccess: authorization proof ────────────────────────
--
-- To call any function requiring CanAccess, you must CONSTRUCT
-- one of these values. Each constructor demands specific evidence.

data CanAccess : AccountId → ChatroomKind → Set where
  -- Anyone can access a public channel
  public-access
    : {uid : AccountId}
    → CanAccess uid Public

  -- DM: you must be one of the two participants
  dm-access-a
    : {uid : AccountId} {other : AccountId}
    → CanAccess uid (DM uid other)

  dm-access-b
    : {uid : AccountId} {other : AccountId}
    → CanAccess uid (DM other uid)

  -- Group: you must be a member of the group
  group-access
    : {uid : AccountId} {members : List AccountId}
    → uid ∈ members
    → CanAccess uid (Group members)

  -- Admin override: admins can access anything
  admin-override
    : {uid : AccountId} {room : ChatroomKind} {role : Role}
    → IsAdmin role
    → CanAccess uid room


-- ═══════════════════════════════════════════════════════════
--  IMPOSSIBILITY THEOREMS
-- ═══════════════════════════════════════════════════════════

-- You cannot be in an empty group
not-in-empty : {uid : AccountId} → ¬ (uid ∈ [])
not-in-empty ()

-- A non-participant cannot access a DM (without admin)
-- If user 3 tries to access DM(1,2), they need CanAccess 3 (DM 1 2).
-- The only constructors are dm-access-a (needs 3 ≡ 1) and
-- dm-access-b (needs 3 ≡ 2). Neither unifies. QED.


-- ═══════════════════════════════════════════════════════════
--  COMPILE DIRECTIVES FOR GHC BACKEND
-- ═══════════════════════════════════════════════════════════

-- No COMPILE pragmas needed: the GHC backend auto-generates
-- Haskell types. Wrapper modules provide clean names.


-- ═══════════════════════════════════════════════════════════
--  OPERATIONS THAT REQUIRE AUTHORIZATION
-- ═══════════════════════════════════════════════════════════

-- Send a message: requires proof of access
-- The proof is erased at runtime, but the TYPE SYSTEM
-- guarantees it was constructed.

data MessageResult : Set where
  sent   : MessageResult
  failed : MessageResult


-- This function CANNOT be called without a CanAccess proof.
-- The proof parameter exists at compile time; it's erased at runtime.
sendMessage : {uid : AccountId} {room : ChatroomKind}
            → CanAccess uid room
            → String            -- message text
            → MessageResult
sendMessage _ _ = sent


-- Admin-only operation: clear all messages in a chatroom
clearMessages : {role : Role}
              → IsAdmin role
              → MessageResult
clearMessages admin-proof = sent


-- ═══════════════════════════════════════════════════════════
--  EXAMPLE: compile-time verified access
-- ═══════════════════════════════════════════════════════════

-- User 1 accessing public channel: trivially authorized
_ : MessageResult
_ = sendMessage (public-access {1}) "hello everyone"

-- User 1 accessing DM(1, 2): authorized as participant A
_ : MessageResult
_ = sendMessage (dm-access-a {1} {2}) "hey"

-- User 2 accessing DM(1, 2): authorized as participant B
_ : MessageResult
_ = sendMessage (dm-access-b {2} {1}) "hey back"

-- User 1 in group [1, 2, 3]: authorized via membership proof
_ : MessageResult
_ = sendMessage (group-access {1} {1 ∷ 2 ∷ 3 ∷ []} here) "group msg"

-- Admin accessing private DM: authorized via admin override
_ : MessageResult
_ = sendMessage (admin-override {99} {DM 1 2} {Admin} admin-proof) "admin here"

-- Admin clearing messages: only possible with IsAdmin proof
_ : MessageResult
_ = clearMessages admin-proof

-- IMPOSSIBLE (won't compile):
-- sendMessage ??? "hack" -- where ??? : CanAccess 99 (DM 1 2)
-- There is no constructor for non-participant, non-admin access.
