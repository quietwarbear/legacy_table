# Milestone 5: Frontend Application Flow Guide

## Overview

This document explains how Milestone 5 (Profile & Family Interaction) works from a frontend application perspective, including user flows, screen navigation, API interactions, and state management.

---

## Table of Contents

1. [Application Architecture](#application-architecture)
2. [User Flows](#user-flows)
3. [Screen Navigation Flow](#screen-navigation-flow)
4. [API Integration Flow](#api-integration-flow)
5. [State Management](#state-management)
6. [Role-Based Access Control](#role-based-access-control)
7. [Family Lifecycle](#family-lifecycle)
8. [Recipe Access Flow](#recipe-access-flow)
9. [Comment Flow](#comment-flow)
10. [Notification Flow](#notification-flow)

---

## Application Architecture

### Core Components

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Application                     │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Screens    │  │   Services   │  │    Models    │  │
│  │              │  │              │  │              │  │
│  │ - Profile    │  │ - Auth       │  │ - User       │  │
│  │ - Family     │  │ - Family     │  │ - Family     │  │
│  │ - Recipes    │  │ - Recipe     │  │ - Recipe     │  │
│  │ - Comments   │  │ - Comment    │  │ - Comment    │  │
│  │ - Notifications│ - Notification│  │ - Notification│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                           │
│  ┌──────────────┐  ┌──────────────┐                      │
│  │   Guards     │  │   Utils      │                      │
│  │              │  │              │                      │
│  │ - FamilyGuard│  │ - RoleUtils  │                      │
│  │ - AuthGuard  │  │ - Validators │                      │
│  └──────────────┘  └──────────────┘                      │
│                                                           │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    Backend API                           │
│              (FastAPI / MongoDB)                         │
└─────────────────────────────────────────────────────────┘
```

---

## User Flows

### Flow 1: New User Registration & Family Setup

#### Step-by-Step Implementation Flow

**Step 1: App Launch & Initial Check**
```
User Opens App
   ↓
App checks for stored authentication token
   ↓
If token exists:
   - Validate token with API: GET /api/auth/me
   - If valid → Navigate to Home Screen
   - If invalid → Navigate to Login Screen
If no token:
   - Navigate to Login/Registration Screen
```
 
**Step 2: Registration Screen Display**
```
UI Components:
┌─────────────────────────────────────┐
│  [App Logo]                         │
│                                     │
│  Registration Form:                │
│  ┌───────────────────────────────┐ │
│  │ Name: [____________]          │ │
│  │ Email: [____________]         │ │
│  │ Password: [____________]      │ │
│  │ Nickname (Optional): [____]  │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Register Button]                  │
│  [Already have account? Login]      │
└─────────────────────────────────────┘

State: 
- Form validation enabled
- Email format validation
- Password strength check (min 8 chars)
- Loading state: false
```

**Step 3: User Fills Registration Form**
```
User Actions:
1. Enters name: "John Doe"
2. Enters email: "john@example.com"
3. Enters password: "SecurePass123!"
4. Optionally enters nickname: "Johnny"
5. Taps "Register" button

Form Validation:
- Name: Required, min 2 characters
- Email: Required, valid email format
- Password: Required, min 8 characters
- Nickname: Optional, max 30 characters

If validation fails:
   - Show inline error messages
   - Highlight invalid fields
   - Prevent API call

If validation passes:
   - Set loading state: true
   - Disable form inputs
   - Show loading indicator
```

**Step 4: API Registration Request**
```
API Call: POST /api/auth/register
Headers: { Content-Type: application/json }
Request Body:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "nickname": "Johnny"  // optional
}

Success Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user_123456",
    "name": "John Doe",
    "email": "john@example.com",
    "nickname": "Johnny",
    "family_id": null,
    "role": null,
    "avatar": null,
    "created_at": "2026-01-12T10:30:00Z"
  }
}

Error Responses:
- 400 Bad Request: Invalid input data
- 409 Conflict: Email already exists
- 500 Server Error: Internal server error

Error Handling:
If error occurs:
   - Set loading state: false
   - Enable form inputs
   - Display error message:
     * Email exists → "This email is already registered"
     * Invalid data → "Please check your input"
     * Network error → "Connection failed. Please try again."
   - Keep user on registration screen
```

**Step 5: Store Authentication Data**
```
On Successful Registration:
1. Store token securely:
   await StorageService.saveToken(response.token);
   
2. Store user data:
   await StorageService.saveUser(response.user);
   
3. Update app state:
   AuthService.setAuthenticated(true);
   AuthService.setCurrentUser(response.user);
   UserState.setUser(response.user);
   
4. Update UI state:
   - isAuthenticated = true
   - currentUser = response.user
   - hasFamily = false (family_id is null)
   - userRole = null
```

**Step 6: Navigate to Home Screen**
```
Navigation: RegistrationScreen → HomeScreen

Home Screen Initial State:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  👥 Join or Create a Family   │ │
│  │                               │ │
│  │  Start sharing recipes with   │ │
│  │  your family!                 │ │
│  │                               │ │
│  │  [Create Family] [Join Family]│ │
│  └───────────────────────────────┘ │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  Legacy Recipes (if any)      │ │
│  │  - Recipes with family_id: null│ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (disabled or hidden)│
└─────────────────────────────────────┘

API Call: GET /api/recipes
Backend filters: family_id = null
Response: List of legacy recipes (empty for new users)

State:
- recipes = [] (or legacy recipes)
- showFamilyPrompt = true
- canCreateRecipe = false (no family)
```

**Step 7: User Taps "Create Family"**
```
User Action: Taps "Create Family" button

Navigation: HomeScreen → CreateFamilyScreen

UI Transition:
- Show loading overlay
- Navigate with animation
- Hide family prompt on home screen
```

**Step 8: Create Family Screen Display**
```
UI Components:
┌─────────────────────────────────────┐
│  [← Back] Create Family             │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Family Name: [____________]   │ │
│  │                               │ │
│  │ Description (Optional):       │ │
│  │ [________________________]    │ │
│  │ [________________________]    │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Create Family Button]             │
└─────────────────────────────────────┘

Form Validation:
- Family name: Required, min 2 characters, max 50
- Description: Optional, max 500 characters

State:
- familyName = ""
- description = ""
- isLoading = false
- errorMessage = null
```

**Step 9: User Fills Family Form**
```
User Actions:
1. Enters family name: "Smith Family"
2. Optionally enters description: "Our family recipes"
3. Taps "Create Family" button

Validation:
- If family name is empty → Show error
- If family name < 2 chars → Show error
- If valid → Proceed to API call
```

**Step 10: API Create Family Request**
```
API Call: POST /api/families
Headers: 
{
  Authorization: Bearer {token},
  Content-Type: application/json
}
Request Body:
{
  "name": "Smith Family",
  "description": "Our family recipes"
}

Success Response (201):
{
  "id": "family_789012",
  "name": "Smith Family",
  "description": "Our family recipes",
  "owner_id": "user_123456",
  "invite_code": "ABC12345",
  "metadata": {},
  "created_at": "2026-01-12T10:35:00Z"
}

Error Responses:
- 400 Bad Request: Invalid input
- 401 Unauthorized: Invalid token
- 409 Conflict: User already in a family
- 500 Server Error: Internal error

Error Handling:
If error occurs:
   - Display error message
   - Keep user on create family screen
   - Allow retry
```

**Step 11: Update User State After Family Creation**
```
On Successful Family Creation:
1. Update user object:
   user.family_id = response.id
   user.role = "keeper"
   
2. Store updated user:
   await StorageService.saveUser(updatedUser);
   
3. Update app state:
   UserState.setFamilyId(response.id);
   UserState.setRole("keeper");
   AuthService.updateUser(updatedUser);
   
4. Store family data:
   await StorageService.saveFamily(response);
   FamilyState.setFamily(response);
   
5. Update UI state:
   - hasFamily = true
   - userRole = "keeper"
   - currentFamily = response
   - showFamilyPrompt = false
   - canCreateRecipe = true
```

**Step 12: Navigate Back to Home Screen**
```
Navigation: CreateFamilyScreen → HomeScreen

Home Screen Updated State:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  Family Recipes                │ │
│  │  (Currently empty - new family)│ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (enabled)           │
└─────────────────────────────────────┘

API Call: GET /api/recipes
Backend filters: family_id = user.family_id
Response: [] (empty - no recipes yet)

State:
- recipes = []
- showFamilyPrompt = false
- canCreateRecipe = true
```

**Step 13: Profile Screen Updates**
```
User navigates to Profile Screen

Profile Screen Display:
┌─────────────────────────────────────┐
│  [Avatar]                            │
│  John Doe (Johnny)                   │
│  john@example.com                    │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  👥 Smith Family              │ │
│  │  [Keeper Badge] 🏆            │ │
│  │                               │ │
│  │  Invite Code: ABC12345        │ │
│  │  [Copy Code]                  │ │
│  │                               │ │
│  │  [View Members] [Edit Family] │ │
│  └───────────────────────────────┘ │
│                                     │
│  📖 My Recipes                      │
│  ⚙️ Settings                       │
│  [Logout]                           │
└─────────────────────────────────────┘

State:
- familyCardVisible = true
- roleBadge = "Keeper"
- inviteCode = "ABC12345"
- showKeeperActions = true
```

**Step 14: User Can Now Create Family-Scoped Recipes**
```
User taps [+ Add Recipe] on Home Screen

Navigation: HomeScreen → AddRecipeScreen

Recipe Creation:
- Form includes all recipe fields
- Backend automatically assigns family_id
- Recipe will be visible to all family members
- Notifications sent to other family members
```

#### State Management Summary

```dart
// Initial State (After Registration)
UserState {
  isAuthenticated: true,
  currentUser: {
    id: "user_123456",
    name: "John Doe",
    email: "john@example.com",
    family_id: null,
    role: null
  },
  hasFamily: false,
  canCreateRecipe: false
}

// Final State (After Family Creation)
UserState {
  isAuthenticated: true,
  currentUser: {
    id: "user_123456",
    name: "John Doe",
    email: "john@example.com",
    family_id: "family_789012",
    role: "keeper"
  },
  hasFamily: true,
  canCreateRecipe: true,
  currentFamily: {
    id: "family_789012",
    name: "Smith Family",
    invite_code: "ABC12345"
  }
}
```

#### Error Scenarios & Handling

1. **Network Error During Registration**
   - Show: "Unable to connect. Please check your internet."
   - Action: Retry button
   - State: Keep form data, allow retry

2. **Email Already Exists**
   - Show: "This email is already registered. Please login instead."
   - Action: Link to login screen
   - State: Clear email field, keep other fields

3. **Invalid Family Name**
   - Show: "Family name must be 2-50 characters"
   - Action: Highlight field, show inline error
   - State: Keep form data

4. **User Already Has Family**
   - Show: "You are already part of a family"
   - Action: Navigate to profile screen
   - State: Refresh user data

### Flow 2: Existing User Joining a Family

#### Step-by-Step Implementation Flow

**Step 1: User Opens App & Login**
```
User Opens App
   ↓
App checks for stored token
   ↓
If token exists and valid:
   - Navigate to Home Screen
   - Skip to Step 3
If no token or invalid:
   - Navigate to Login Screen
```

**Step 2: Login Screen Display**
```
UI Components:
┌─────────────────────────────────────┐
│  [App Logo]                         │
│                                     │
│  Login Form:                        │
│  ┌───────────────────────────────┐ │
│  │ Email: [____________]         │ │
│  │ Password: [____________]      │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Login Button]                     │
│  [Forgot Password?]                 │
│  [Don't have account? Register]     │
└─────────────────────────────────────┘

State:
- email = ""
- password = ""
- isLoading = false
- errorMessage = null
- showPassword = false
```

**Step 3: User Enters Credentials**
```
User Actions:
1. Enters email: "jane@example.com"
2. Enters password: "SecurePass123!"
3. Taps "Login" button

Form Validation:
- Email: Required, valid email format
- Password: Required, min 1 character

If validation fails:
   - Show inline error messages
   - Prevent API call

If validation passes:
   - Set loading state: true
   - Disable form inputs
   - Show loading indicator
```

**Step 4: API Login Request**
```
API Call: POST /api/auth/login
Headers: { Content-Type: application/json }
Request Body:
{
  "email": "jane@example.com",
  "password": "SecurePass123!"
}

Success Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user_789012",
    "name": "Jane Smith",
    "email": "jane@example.com",
    "nickname": null,
    "family_id": null,
    "role": null,
    "avatar": null,
    "created_at": "2026-01-10T08:20:00Z"
  }
}

Error Responses:
- 401 Unauthorized: Invalid credentials
- 400 Bad Request: Missing fields
- 500 Server Error: Internal error

Error Handling:
If error occurs:
   - Set loading state: false
   - Enable form inputs
   - Display error message:
     * Invalid credentials → "Email or password is incorrect"
     * Network error → "Connection failed. Please try again."
   - Keep user on login screen
```

**Step 5: Store Authentication & Navigate**
```
On Successful Login:
1. Store token securely:
   await StorageService.saveToken(response.token);
   
2. Store user data:
   await StorageService.saveUser(response.user);
   
3. Update app state:
   AuthService.setAuthenticated(true);
   AuthService.setCurrentUser(response.user);
   UserState.setUser(response.user);
   
4. Navigate to Home Screen
```

**Step 6: Home Screen Initial Load**
```
Navigation: LoginScreen → HomeScreen

Home Screen State Check:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Check: user.family_id == null?     │
│         ↓                           │
│    YES → Show Family Prompt         │
│    NO  → Show Family Recipes        │
└─────────────────────────────────────┘

Since user has no family (family_id: null):
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications]  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  👥 Join or Create a Family   │ │
│  │                               │ │
│  │  Start sharing recipes with   │ │
│  │  your family!                 │ │
│  │                               │ │
│  │  [Create Family] [Join Family]│ │
│  └───────────────────────────────┘ │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  Legacy Recipes               │ │
│  │  (Recipes with family_id: null)│ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (disabled)          │
└─────────────────────────────────────┘

API Call: GET /api/recipes
Backend filters: family_id = null
Response: List of legacy recipes

State:
- recipes = [legacy recipes]
- showFamilyPrompt = true
- canCreateRecipe = false
- hasFamily = false
```

**Step 7: User Taps "Join Family"**
```
User Action: Taps "Join Family" button

Navigation: HomeScreen → JoinFamilyScreen

UI Transition:
- Show loading overlay
- Navigate with animation
- Hide family prompt on home screen
```

**Step 8: Join Family Screen Display**
```
UI Components:
┌─────────────────────────────────────┐
│  [← Back] Join Family                │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  Enter Invite Code            │ │
│  │                               │ │
│  │  Invite Code:                 │ │
│  │  [A B C 1 2 3 4 5]           │ │
│  │                               │ │
│  │  Ask your family keeper for   │ │
│  │  the 8-character invite code  │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Join Family Button]               │
└─────────────────────────────────────┘

Form Features:
- Auto-format: Uppercase letters
- Auto-format: Remove spaces/special chars
- Character limit: 8 characters
- Real-time validation: Check format

State:
- inviteCode = ""
- isLoading = false
- errorMessage = null
- isValidFormat = false
```

**Step 9: User Enters Invite Code**
```
User Actions:
1. Types invite code: "ABC12345"
2. Code auto-formats to uppercase
3. Code validated in real-time

Validation Rules:
- Must be exactly 8 characters
- Can contain letters and numbers
- No spaces or special characters

Real-time Feedback:
- Valid format: Green checkmark ✓
- Invalid format: Red X, show error
- Empty: No indicator

State Updates:
- inviteCode = "ABC12345"
- isValidFormat = true (if 8 chars)
- errorMessage = null
```

**Step 10: User Taps "Join Family"**
```
User Action: Taps "Join Family" button

Pre-submission Check:
- If invite code length != 8:
   → Show error: "Invite code must be 8 characters"
   → Prevent API call
   
- If valid:
   → Set loading state: true
   → Disable input field
   → Show loading indicator
   → Proceed to API call
```

**Step 11: API Join Family Request**
```
API Call: POST /api/families/join
Headers: 
{
  Authorization: Bearer {token},
  Content-Type: application/json
}
Request Body:
{
  "invite_code": "ABC12345"
}

Success Response (200):
{
  "message": "Successfully joined family",
  "family": {
    "id": "family_789012",
    "name": "Smith Family",
    "description": "Our family recipes",
    "owner_id": "user_123456",
    "invite_code": "ABC12345",
    "metadata": {},
    "created_at": "2026-01-12T10:35:00Z"
  },
  "user": {
    "id": "user_789012",
    "name": "Jane Smith",
    "email": "jane@example.com",
    "family_id": "family_789012",
    "role": "member",
    ...
  }
}

Error Responses:
- 400 Bad Request: Invalid invite code format
- 404 Not Found: Invite code doesn't exist
- 401 Unauthorized: Invalid token
- 409 Conflict: User already in a family
- 500 Server Error: Internal error

Error Handling:
If 404 error:
   - Display: "Invalid invite code. Please check and try again."
   - Clear invite code field
   - Allow retry
   
If 409 error:
   - Display: "You are already part of a family"
   - Navigate to profile screen
   - Refresh user data
   
If network error:
   - Display: "Connection failed. Please try again."
   - Keep form data
   - Allow retry
```

**Step 12: Backend Processing (Server-Side)**
```
Backend Actions:
1. Validate invite code exists
2. Check user is not already in a family
3. Add user to family:
   - Set user.family_id = family.id
   - Set user.role = "member"
4. Create notification for keeper:
   {
     "type": "family_invite",
     "message": "Jane Smith joined your family",
     "user_id": "user_123456", // keeper's ID
     "related_user_id": "user_789012", // new member's ID
     "family_id": "family_789012"
   }
5. Return success response
```

**Step 13: Update User State After Joining**
```
On Successful Join:
1. Update user object:
   user.family_id = response.family.id
   user.role = "member"
   
2. Store updated user:
   await StorageService.saveUser(response.user);
   
3. Update app state:
   UserState.setFamilyId(response.family.id);
   UserState.setRole("member");
   AuthService.updateUser(response.user);
   
4. Store family data:
   await StorageService.saveFamily(response.family);
   FamilyState.setFamily(response.family);
   
5. Update UI state:
   - hasFamily = true
   - userRole = "member"
   - currentFamily = response.family
   - showFamilyPrompt = false
   - canCreateRecipe = true
   
6. Refresh notification count:
   - Fetch unread count for keeper
   - Update notification badge
```

**Step 14: Navigate Back to Home Screen**
```
Navigation: JoinFamilyScreen → HomeScreen

Home Screen Updated State:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  Family Recipes                │ │
│  │  (Recipes from Smith Family)  │ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (enabled)           │
└─────────────────────────────────────┘

API Call: GET /api/recipes
Backend filters: family_id = user.family_id
Response: List of family-scoped recipes

State:
- recipes = [family recipes]
- showFamilyPrompt = false
- canCreateRecipe = true
- hasFamily = true
```

**Step 15: Profile Screen Updates**
```
User navigates to Profile Screen

Profile Screen Display:
┌─────────────────────────────────────┐
│  [Avatar]                            │
│  Jane Smith                          │
│  jane@example.com                    │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  👥 Smith Family              │ │
│  │  [Member Badge] 👤            │ │
│  │                               │ │
│  │  You are a member of this     │ │
│  │  family                       │ │
│  │                               │ │
│  │  [View Family Details]        │ │
│  └───────────────────────────────┘ │
│                                     │
│  📖 My Recipes                      │
│  ⚙️ Settings                       │
│  [Logout]                           │
└─────────────────────────────────────┘

State:
- familyCardVisible = true
- roleBadge = "Member"
- showKeeperActions = false
- showMemberActions = true
```

**Step 16: Keeper Receives Notification**
```
Keeper's Notification Screen:
┌─────────────────────────────────────┐
│  [Mark All Read]                    │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  🔴 [Unread]                  │ │
│  │  👥 Family Invite             │ │
│  │  "Jane Smith joined your      │ │
│  │   family"                     │ │
│  │  2 minutes ago                │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘

Keeper can:
- Tap notification → View family members
- See updated member count
- View new member's profile (if accessible)
```

#### State Management Summary

```dart
// Initial State (After Login)
UserState {
  isAuthenticated: true,
  currentUser: {
    id: "user_789012",
    name: "Jane Smith",
    email: "jane@example.com",
    family_id: null,
    role: null
  },
  hasFamily: false,
  canCreateRecipe: false
}

// Final State (After Joining Family)
UserState {
  isAuthenticated: true,
  currentUser: {
    id: "user_789012",
    name: "Jane Smith",
    email: "jane@example.com",
    family_id: "family_789012",
    role: "member"
  },
  hasFamily: true,
  canCreateRecipe: true,
  currentFamily: {
    id: "family_789012",
    name: "Smith Family",
    invite_code: "ABC12345"
  }
}
```

#### Error Scenarios & Handling

1. **Invalid Invite Code**
   - Show: "Invalid invite code. Please check and try again."
   - Action: Clear field, allow retry
   - State: Keep form, show error

2. **User Already in Family**
   - Show: "You are already part of a family"
   - Action: Navigate to profile screen
   - State: Refresh user data, show current family

3. **Network Error**
   - Show: "Connection failed. Please try again."
   - Action: Retry button
   - State: Keep invite code, allow retry

4. **Expired Token During Join**
   - Show: "Session expired. Please login again."
   - Action: Navigate to login screen
   - State: Clear stored data, require re-login

### Flow 3: Recipe Creation Flow (Family Member)

#### Step-by-Step Implementation Flow

**Step 1: User on Home Screen (Has Family)**
```
Home Screen State:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  🍽️ Chocolate Cake            │ │
│  │  By: John Doe                 │ │
│  │  [Image]                      │ │
│  └───────────────────────────────┘ │
│  ┌───────────────────────────────┐ │
│  │  🍝 Pasta Carbonara           │ │
│  │  By: Jane Smith               │ │
│  │  [Image]                      │ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (enabled)           │
└─────────────────────────────────────┘

Pre-conditions Check:
- User is authenticated: ✓
- User has family: ✓ (family_id exists)
- User role: "member" or "keeper"
- Can create recipe: true

State:
- hasFamily = true
- canCreateRecipe = true
- recipes = [existing family recipes]
```

**Step 2: User Taps "Add Recipe" Button**
```
User Action: Taps [+ Add Recipe] button

Pre-navigation Check:
1. Verify user has family:
   if (user.family_id == null) {
     → Show error: "Please join or create a family first"
     → Navigate to profile screen
     → Return early
   }
   
2. If user has family:
   → Navigate to Add Recipe Screen
   → Proceed with recipe creation flow
```

**Step 3: Navigate to Add Recipe Screen**
```
Navigation: HomeScreen → AddRecipeScreen

UI Transition:
- Show loading overlay
- Navigate with slide-up animation
- Hide bottom navigation bar
```

**Step 4: Add Recipe Screen Display**
```
UI Components:
┌─────────────────────────────────────┐
│  [← Cancel] Add Recipe               │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Recipe Title: [____________] │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Description:                 │ │
│  │ [________________________]   │ │
│  │ [________________________]   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Photos:                       │ │
│  │ [📷] [📷] [📷] [+ Add Photo] │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Category: [Select ▼]         │ │
│  │ Difficulty: [Easy ▼]         │ │
│  │ Prep Time: [30 min]          │ │
│  │ Cook Time: [45 min]          │ │
│  │ Servings: [4]                │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Ingredients:                   │ │
│  │ [ ] 2 cups flour              │ │
│  │ [ ] 1 cup sugar               │ │
│  │ [+ Add Ingredient]            │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Instructions:                  │ │
│  │ 1. [________________________] │ │
│  │ [+ Add Step]                  │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Save Recipe] [Publish Recipe]     │
└─────────────────────────────────────┘

Form State:
- title = ""
- description = ""
- photos = []
- category = null
- difficulty = null
- prepTime = null
- cookTime = null
- servings = null
- ingredients = []
- instructions = []
- isLoading = false
- errors = {}
```

**Step 5: User Fills Recipe Form**
```
User Actions:
1. Enters title: "Grandma's Apple Pie"
2. Enters description: "A family favorite passed down..."
3. Uploads photos: [photo1.jpg, photo2.jpg]
4. Selects category: "Dessert"
5. Selects difficulty: "Medium"
6. Sets prep time: 30 minutes
7. Sets cook time: 45 minutes
8. Sets servings: 8
9. Adds ingredients:
   - "2 cups all-purpose flour"
   - "1 cup butter"
   - "6 apples"
   - "1 cup sugar"
10. Adds instructions:
    - "Mix flour and butter to make crust"
    - "Peel and slice apples"
    - "Bake at 375°F for 45 minutes"

Form Validation (Real-time):
- Title: Required, min 3 chars, max 100
- Description: Optional, max 1000 chars
- Photos: Optional, max 5 photos
- Category: Required
- Difficulty: Required
- Prep time: Required, min 0
- Cook time: Required, min 0
- Servings: Required, min 1
- Ingredients: Required, min 1 item
- Instructions: Required, min 1 step

Validation Feedback:
- Invalid fields: Red border, error message below
- Valid fields: Green checkmark
- Submit button: Enabled only when all required fields valid
```

**Step 6: User Taps "Publish Recipe"**
```
User Action: Taps "Publish Recipe" button

Pre-submission Validation:
1. Check all required fields:
   if (!title || !category || !difficulty || 
       ingredients.isEmpty || instructions.isEmpty) {
     → Show error: "Please fill all required fields"
     → Scroll to first invalid field
     → Prevent API call
   }
   
2. If validation passes:
   → Set loading state: true
   → Disable form inputs
   → Show loading indicator
   → Disable submit button
   → Proceed to API call
```

**Step 7: Prepare Recipe Data for API**
```
Form Data Preparation:
{
  "title": "Grandma's Apple Pie",
  "description": "A family favorite passed down...",
  "category": "dessert",
  "difficulty": "medium",
  "prep_time": 30,
  "cook_time": 45,
  "servings": 8,
  "ingredients": [
    "2 cups all-purpose flour",
    "1 cup butter",
    "6 apples",
    "1 cup sugar"
  ],
  "instructions": [
    "Mix flour and butter to make crust",
    "Peel and slice apples",
    "Bake at 375°F for 45 minutes"
  ],
  "photos": [photo1_base64, photo2_base64]
}

Note: family_id will be automatically added by backend
from the authenticated user's token
```

**Step 8: API Create Recipe Request**
```
API Call: POST /api/recipes
Headers: 
{
  Authorization: Bearer {token},
  Content-Type: multipart/form-data
}
Request Body: FormData with recipe fields + photos

Success Response (201):
{
  "id": "recipe_456789",
  "title": "Grandma's Apple Pie",
  "description": "A family favorite passed down...",
  "author_id": "user_789012",
  "author_name": "Jane Smith",
  "family_id": "family_789012",
  "category": "dessert",
  "difficulty": "medium",
  "prep_time": 30,
  "cook_time": 45,
  "servings": 8,
  "ingredients": [...],
  "instructions": [...],
  "photos": ["photo1_url", "photo2_url"],
  "created_at": "2026-01-12T11:00:00Z",
  "updated_at": "2026-01-12T11:00:00Z"
}

Error Responses:
- 400 Bad Request: Invalid input data
- 401 Unauthorized: Invalid token
- 403 Forbidden: User doesn't have family
- 413 Payload Too Large: Photos too large
- 500 Server Error: Internal error

Error Handling:
If 400 error:
   - Display: "Please check your input and try again"
   - Show field-specific errors if provided
   - Keep form data
   - Allow retry
   
If 403 error:
   - Display: "You must be part of a family to create recipes"
   - Navigate to profile screen
   - Refresh user data
   
If 413 error:
   - Display: "Photos are too large. Please reduce size."
   - Keep form data
   - Allow photo re-upload
   
If network error:
   - Display: "Connection failed. Please try again."
   - Keep form data
   - Allow retry
```

**Step 9: Backend Processing (Server-Side)**
```
Backend Actions:
1. Validate authentication token
2. Get user from token
3. Check user has family_id:
   if (user.family_id == null) {
     → Return 403 Forbidden
   }
4. Create recipe:
   - Set recipe.family_id = user.family_id
   - Set recipe.author_id = user.id
   - Save recipe to database
   - Upload photos to storage
5. Get all family members (excluding recipe author):
   familyMembers = getFamilyMembers(user.family_id)
   otherMembers = filter(familyMembers, id != user.id)
6. Create notifications for other members:
   for each member in otherMembers:
     createNotification({
       type: "new_recipe",
       message: "${user.name} shared: ${recipe.title}",
       user_id: member.id,
       recipe_id: recipe.id,
       is_read: false
     })
7. Return created recipe
```

**Step 10: Update App State After Recipe Creation**
```
On Successful Recipe Creation:
1. Add recipe to local state:
   RecipeState.addRecipe(response);
   
2. Update recipe list:
   recipes.insert(0, response); // Add to top
   
3. Clear form:
   - Reset all form fields
   - Clear photos
   - Reset validation errors
   
4. Update UI state:
   - isLoading = false
   - showSuccessMessage = true
   - canNavigate = true
   
5. Show success message:
   "Recipe created successfully!"
   (Auto-dismiss after 2 seconds)
```

**Step 11: Navigate Back to Home Screen**
```
Navigation: AddRecipeScreen → HomeScreen

Options:
A. Auto-navigate after success (recommended)
   - Wait 2 seconds after success message
   - Navigate to home screen
   - Show new recipe at top of feed
   
B. Manual navigation
   - Show "View Recipe" button
   - User taps → Navigate to recipe detail
   - Or user taps back → Navigate to home
```

**Step 12: Home Screen Updates**
```
Home Screen Updated State:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  🍎 Grandma's Apple Pie       │ │ ← NEW
│  │  By: Jane Smith               │ │
│  │  [Image]                      │ │
│  │  Just now                     │ │
│  └───────────────────────────────┘ │
│  ┌───────────────────────────────┐ │
│  │  🍽️ Chocolate Cake            │ │
│  │  By: John Doe                 │ │
│  │  [Image]                      │ │
│  └───────────────────────────────┘ │
│  ┌───────────────────────────────┐ │
│  │  🍝 Pasta Carbonara           │ │
│  │  By: Jane Smith               │ │
│  │  [Image]                      │ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe]                     │
└─────────────────────────────────────┘

State Updates:
- recipes = [new recipe, ...existing recipes]
- recipeCount = recipeCount + 1
- lastUpdated = now()
```

**Step 13: Notifications Created for Family Members**
```
Backend creates notifications for:
- All family members except recipe author
- Type: "new_recipe"
- Message: "Jane Smith shared: Grandma's Apple Pie"

Example Notifications:
┌─────────────────────────────────────┐
│  John Doe's Notifications:           │
│  ┌───────────────────────────────┐ │
│  │  🔴 [Unread]                  │ │
│  │  🍽️ New Recipe                │ │
│  │  "Jane Smith shared:          │ │
│  │   Grandma's Apple Pie"        │ │
│  │  1 minute ago                 │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘

Notification Badge Updates:
- Unread count increments for each member
- Badge shows on notification icon
- Members can tap to view recipe
```

**Step 14: Recipe Visibility**
```
Recipe Access Rules:
- Recipe is family-scoped (family_id = "family_789012")
- Visible to: All members of Smith Family
- Not visible to: Users outside the family
- Not visible to: Users without a family

API: GET /api/recipes
Backend filters:
- If user.family_id == recipe.family_id → Show
- If user.family_id != recipe.family_id → Hide
- If user.family_id == null → Hide (legacy users see only legacy recipes)
```

#### State Management Summary

```dart
// Before Recipe Creation
RecipeState {
  recipes: [existing recipes],
  isLoading: false,
  hasMore: true
}

UserState {
  hasFamily: true,
  familyId: "family_789012",
  canCreateRecipe: true
}

// After Recipe Creation
RecipeState {
  recipes: [new recipe, ...existing recipes],
  isLoading: false,
  hasMore: true,
  lastCreated: "recipe_456789"
}

UserState {
  hasFamily: true,
  familyId: "family_789012",
  canCreateRecipe: true
}
```

#### Error Scenarios & Handling

1. **User Loses Family During Creation**
   - Scenario: User removed from family while filling form
   - Detection: API returns 403 on submit
   - Action: Show error, navigate to profile
   - State: Clear form, refresh user data

2. **Network Error During Upload**
   - Show: "Upload failed. Please check connection."
   - Action: Retry button, keep form data
   - State: Preserve all form fields

3. **Photo Upload Failure**
   - Show: "Failed to upload photos. Retry?"
   - Action: Retry photo upload only
   - State: Keep other form data

4. **Validation Errors**
   - Show: Field-specific error messages
   - Action: Scroll to first error
   - State: Keep all valid fields

5. **Session Expired**
   - Show: "Session expired. Please login again."
   - Action: Navigate to login
   - State: Clear form, require re-login

### Flow 4: Recipe Access Flow

#### Scenario A: User with Family - Viewing Recipe Feed

**Step 1: User Opens Home Screen**
```
User State Check:
- isAuthenticated: true
- hasFamily: true
- familyId: "family_789012"
- role: "member" or "keeper"

Navigation: Any Screen → HomeScreen

Home Screen Initialization:
1. Check user authentication
2. Check user has family
3. If no family → Show join/create prompt
4. If has family → Load family recipes
```

**Step 2: API Request for Family Recipes**
```
API Call: GET /api/recipes
Headers: 
{
  Authorization: Bearer {token}
}
Query Parameters: (optional)
- category: "dessert"
- author_id: "user_123456"
- limit: 20
- offset: 0

Backend Processing:
1. Extract user from token
2. Check user.family_id:
   if (user.family_id == null) {
     → Filter: family_id = null (legacy recipes)
   } else {
     → Filter: family_id = user.family_id
   }
3. Apply additional filters (category, author, etc.)
4. Sort by created_at DESC
5. Return paginated results

Success Response (200):
{
  "recipes": [
    {
      "id": "recipe_111",
      "title": "Chocolate Cake",
      "author_name": "John Doe",
      "family_id": "family_789012",
      "category": "dessert",
      "prep_time": 30,
      "cook_time": 45,
      "photos": ["photo1_url"],
      "created_at": "2026-01-12T10:00:00Z"
    },
    {
      "id": "recipe_222",
      "title": "Pasta Carbonara",
      "author_name": "Jane Smith",
      "family_id": "family_789012",
      "category": "main",
      "prep_time": 15,
      "cook_time": 20,
      "photos": ["photo2_url"],
      "created_at": "2026-01-11T15:30:00Z"
    }
  ],
  "total": 15,
  "limit": 20,
  "offset": 0,
  "has_more": false
}

Error Responses:
- 401 Unauthorized: Invalid token
- 500 Server Error: Internal error
```

**Step 3: Display Family-Scoped Recipes**
```
Home Screen UI:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications] │
│                                     │
│  Recipe Feed:                       │
│  ┌───────────────────────────────┐ │
│  │  🍫 Chocolate Cake            │ │
│  │  By: John Doe                │ │
│  │  [Image]                     │ │
│  │  Dessert • 30 min prep       │ │
│  │  2 hours ago                 │ │
│  └───────────────────────────────┘ │
│  ┌───────────────────────────────┐ │
│  │  🍝 Pasta Carbonara           │ │
│  │  By: Jane Smith               │ │
│  │  [Image]                     │ │
│  │  Main Course • 15 min prep   │ │
│  │  1 day ago                    │ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe]                     │
└─────────────────────────────────────┘

State Updates:
- recipes = response.recipes
- isLoading = false
- hasMore = response.has_more
- totalRecipes = response.total

Recipe Visibility Rules:
✓ Recipes with family_id = "family_789012" → Visible
✗ Recipes with family_id = null → Hidden
✗ Recipes with different family_id → Hidden
```

**Step 4: Recipe Card Interaction**
```
User Actions:
- Tap recipe card → Navigate to detail screen
- Swipe to refresh → Reload recipes
- Scroll to bottom → Load more (if hasMore)
- Tap filter → Filter by category/author
```

---

#### Scenario B: User without Family - Viewing Legacy Recipes

**Step 1: User Opens Home Screen (No Family)**
```
User State Check:
- isAuthenticated: true
- hasFamily: false
- familyId: null
- role: null

Home Screen Initialization:
1. Check user authentication
2. Check user has family
3. If no family → Show join/create prompt
4. Load legacy recipes (family_id = null)
```

**Step 2: API Request for Legacy Recipes**
```
API Call: GET /api/recipes
Headers: 
{
  Authorization: Bearer {token}
}

Backend Processing:
1. Extract user from token
2. Check user.family_id:
   if (user.family_id == null) {
     → Filter: family_id = null (legacy recipes only)
   }
3. Return only legacy recipes

Success Response (200):
{
  "recipes": [
    {
      "id": "recipe_999",
      "title": "Old Family Recipe",
      "author_name": "Grandma",
      "family_id": null,  // Legacy recipe
      "category": "dessert",
      "prep_time": 20,
      "cook_time": 30,
      "photos": ["photo3_url"],
      "created_at": "2025-12-01T08:00:00Z"
    }
  ],
  "total": 1,
  "limit": 20,
  "offset": 0,
  "has_more": false
}
```

**Step 3: Display Legacy Recipes**
```
Home Screen UI:
┌─────────────────────────────────────┐
│  [Profile] [Search] [Notifications]  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  👥 Join or Create a Family  │ │
│  │                               │ │
│  │  Start sharing recipes with   │ │
│  │  your family!                 │ │
│  │                               │ │
│  │  [Create Family] [Join Family]│ │
│  └───────────────────────────────┘ │
│                                     │
│  Legacy Recipes:                    │
│  ┌───────────────────────────────┐ │
│  │  🍰 Old Family Recipe         │ │
│  │  By: Grandma                  │ │
│  │  [Image]                     │ │
│  │  Dessert • 20 min prep       │ │
│  │  1 month ago                  │ │
│  └───────────────────────────────┘ │
│                                     │
│  [+ Add Recipe] (disabled)          │
└─────────────────────────────────────┘

State Updates:
- recipes = response.recipes (legacy only)
- isLoading = false
- showFamilyPrompt = true
- canCreateRecipe = false

Recipe Visibility Rules:
✓ Recipes with family_id = null → Visible
✗ Recipes with family_id != null → Hidden
```

**Step 4: User Cannot See Family Recipes**
```
Access Control:
- User without family cannot see family-scoped recipes
- Backend enforces this at API level
- Frontend also filters for safety

If user somehow receives family recipe:
- Recipe card shows error state
- Tapping shows: "Join a family to view this recipe"
- Option to navigate to join family screen
```

---

#### Scenario C: Recipe Detail Access

**Step 1: User Taps Recipe Card**
```
User Action: Taps on recipe card from feed

Recipe Information:
- Recipe ID: "recipe_111"
- Recipe family_id: "family_789012"
- User family_id: "family_789012" (or null)

Navigation: HomeScreen → RecipeDetailScreen

Pre-navigation Check:
- Store recipe ID
- Prepare to fetch full recipe details
```

**Step 2: API Request for Recipe Details**
```
API Call: GET /api/recipes/{recipe_id}
Headers: 
{
  Authorization: Bearer {token}
}
Path Parameter: recipe_id = "recipe_111"

Backend Access Control:
1. Extract user from token
2. Fetch recipe from database
3. Check access permissions:

   if (recipe.family_id == null) {
     // Legacy recipe - accessible to all authenticated users
     → Access granted
   } else if (recipe.family_id == user.family_id) {
     // Family recipe - user is in same family
     → Access granted
   } else {
     // Family recipe - user is not in same family
     → Return 403 Forbidden
   }

Success Response (200):
{
  "id": "recipe_111",
  "title": "Chocolate Cake",
  "description": "Rich and moist chocolate cake...",
  "author_id": "user_123456",
  "author_name": "John Doe",
  "family_id": "family_789012",
  "category": "dessert",
  "difficulty": "medium",
  "prep_time": 30,
  "cook_time": 45,
  "servings": 8,
  "ingredients": [
    "2 cups flour",
    "1 cup sugar",
    "3 eggs",
    ...
  ],
  "instructions": [
    "Preheat oven to 350°F",
    "Mix dry ingredients",
    ...
  ],
  "photos": ["photo1_url", "photo2_url"],
  "created_at": "2026-01-12T10:00:00Z",
  "updated_at": "2026-01-12T10:00:00Z"
}

Error Response (403 Forbidden):
{
  "error": "Access denied",
  "message": "You don't have permission to view this recipe"
}

Error Response (404 Not Found):
{
  "error": "Not found",
  "message": "Recipe not found"
}
```

**Step 3A: Access Granted - Display Recipe Details**
```
Recipe Detail Screen UI:
┌─────────────────────────────────────┐
│  [← Back]                            │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  [Photo Gallery]               │ │
│  │  [← →] 1/2                    │ │
│  └───────────────────────────────┘ │
│                                     │
│  🍫 Chocolate Cake                  │
│  By: John Doe                       │
│                                     │
│  Dessert • Medium • 30 min prep     │
│  45 min cook • Serves 8             │
│                                     │
│  Description:                       │
│  Rich and moist chocolate cake...   │
│                                     │
│  Ingredients:                       │
│  • 2 cups flour                     │
│  • 1 cup sugar                      │
│  • 3 eggs                           │
│  ...                                │
│                                     │
│  Instructions:                      │
│  1. Preheat oven to 350°F           │
│  2. Mix dry ingredients             │
│  3. Add wet ingredients             │
│  ...                                │
│                                     │
│  ────────────────────────────────   │
│                                     │
│  Comments (5)                        │
│  ┌───────────────────────────────┐ │
│  │ [Avatar] Jane Smith           │ │
│  │ "This looks amazing!"         │ │
│  │ 2 hours ago                   │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Add Comment Input] [Send]         │
└─────────────────────────────────────┘

State Updates:
- selectedRecipe = response
- isLoading = false
- canEdit = (user.id == recipe.author_id)
- canDelete = (user.id == recipe.author_id || user.role == "keeper")
```

**Step 3B: Access Denied - Show Error**
```
Error Screen UI:
┌─────────────────────────────────────┐
│  [← Back]                            │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  ⚠️ Access Denied             │ │
│  │                               │ │
│  │  You don't have permission    │ │
│  │  to view this recipe.         │ │
│  │                               │ │
│  │  This recipe belongs to        │ │
│  │  another family.              │ │
│  │                               │ │
│  │  [Join or Create Family]     │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘

State Updates:
- error = "Access denied"
- isLoading = false
- showJoinPrompt = true

User Actions:
- Tap "Join or Create Family" → Navigate to profile
- Tap back → Return to home screen
```

**Step 4: Load Recipe Comments**
```
API Call: GET /api/recipes/{recipe_id}/comments
Headers: 
{
  Authorization: Bearer {token}
}

Success Response (200):
{
  "comments": [
    {
      "id": "comment_1",
      "user_name": "Jane Smith",
      "text": "This looks amazing!",
      "created_at": "2026-01-12T12:00:00Z"
    },
    {
      "id": "comment_2",
      "user_name": "John Doe",
      "text": "Can't wait to try this!",
      "created_at": "2026-01-12T11:30:00Z"
    }
  ]
}

Display Comments:
- Show in chronological order (oldest first)
- Display user name, comment text, timestamp
- Allow adding new comments (if user has access)
```

---

#### Scenario D: Recipe Access Edge Cases

**Case 1: User Joins Family After Viewing Legacy Recipe**
```
Scenario:
1. User without family views legacy recipe
2. User joins family
3. User tries to access same legacy recipe

Result:
- Legacy recipe still accessible (family_id = null)
- User can still view it
- Recipe remains in legacy category
```

**Case 2: User Leaves Family While Viewing Recipe**
```
Scenario:
1. User with family views family recipe
2. User is removed from family (or leaves)
3. User tries to refresh recipe detail

Result:
- API returns 403 Forbidden
- Show access denied message
- Option to rejoin family
- Navigate back to home (shows legacy recipes)
```

**Case 3: Recipe Author Leaves Family**
```
Scenario:
1. User creates recipe in family
2. User leaves family
3. Recipe remains with family_id

Result:
- Recipe stays with family (family_id preserved)
- Original author cannot access recipe
- Only current family members can access
- Recipe shows original author name
```

**Case 4: Multiple Family Members Viewing Same Recipe**
```
Scenario:
- Multiple family members access same recipe simultaneously

Result:
- All members can view recipe
- All members can add comments
- Real-time updates (if WebSocket implemented)
- Notification when new comment added
```

---

#### State Management Summary

```dart
// Recipe Feed State
RecipeFeedState {
  recipes: List<Recipe>,
  isLoading: bool,
  hasMore: bool,
  error: String?,
  filterCategory: String?,
  filterAuthor: String?
}

// Recipe Detail State
RecipeDetailState {
  selectedRecipe: Recipe?,
  comments: List<Comment>,
  isLoading: bool,
  error: String?,
  canEdit: bool,
  canDelete: bool
}

// Access Control Logic
bool canAccessRecipe(Recipe recipe, User user) {
  // Legacy recipe - accessible to all
  if (recipe.familyId == null) {
    return true;
  }
  
  // Family recipe - must be in same family
  if (user.familyId == recipe.familyId) {
    return true;
  }
  
  // No access
  return false;
}
```

#### Error Scenarios & Handling

1. **403 Forbidden - Access Denied**
   - Show: "You don't have permission to view this recipe"
   - Action: Show join family prompt
   - State: Clear recipe data, show error

2. **404 Not Found - Recipe Doesn't Exist**
   - Show: "Recipe not found"
   - Action: Navigate back to home
   - State: Clear recipe data

3. **Network Error**
   - Show: "Failed to load recipe. Retry?"
   - Action: Retry button
   - State: Keep recipe ID, allow retry

4. **User Loses Access During Viewing**
   - Detection: Refresh returns 403
   - Action: Show access denied, navigate home
   - State: Clear recipe, refresh user data

### Flow 5: Comment Flow

```
1. User on Recipe Detail Screen
   ↓
2. Scrolls to Comments Section
   ↓
3. Enters Comment Text
   ↓
4. Taps "Send" Button
   ↓
5. API: POST /api/recipes/{recipe_id}/comments
   - Creates comment
   ↓
6. Comment Added to List
   ↓
7. Notification Created (if applicable)
   - If recipe author is in same family
   - Type: "comment"
   - Message: "User commented on your recipe"
   ↓
8. Recipe Author Receives Notification
   - Shows in notifications list
   - Can tap to navigate to recipe
```

### Flow 6: Profile & My Recipes Flow

```
1. User Taps Profile Icon
   ↓
2. Profile Screen Loads
   ↓
3. API: GET /api/auth/me
   - Returns: user with family_id, role
   ↓
4. Display Profile Information
   - Avatar, name, email
   - Family card (if has family)
   - Role badge (keeper/member)
   ↓
5. User Taps "My Recipes"
   ↓
6. My Recipes Screen
   ↓
7. API: GET /api/recipes?author_id={user_id}
   - Backend filters by author_id
   - Returns only user's recipes
   ↓
8. Display User's Recipes
   - Edit button (author only)
   - Delete button (author or keeper)
   ↓
9. User Taps Edit
   - Navigate to Edit Recipe Screen
   ↓
10. User Taps Delete
    - Show confirmation dialog
    - API: DELETE /api/recipes/{id}
    - Backend checks:
      • Legacy recipe: author only
      • Family recipe: author OR keeper
```

### Flow 7: Notification Flow

```
1. User Taps Notification Icon
   ↓
2. Notifications Screen Loads
   ↓
3. API: GET /api/notifications
   - Returns: all user notifications
   - Sorted by created_at (newest first)
   ↓
4. Display Notifications List
   - Unread: bold text, indicator dot
   - Read: normal text
   ↓
5. User Taps Notification
   ↓
6. API: PUT /api/notifications/{id}/read
   - Marks as read
   ↓
7. Navigate Based on Type
   - "new_recipe" → Recipe Detail Screen
   - "comment" → Recipe Detail Screen
   - "family_invite" → Family Details Screen
   ↓
8. Notification Updates
   - Removes unread indicator
```

### Flow 8: Family Management (Keeper)

```
Scenario A: Update Family
┌─────────────────────────────────────┐
│ 1. Keeper on Profile Screen          │
│    - Sees family card                │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 2. Taps "Edit Family"                │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 3. Edit Family Screen                │
│    - Update name, description       │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 4. API: PUT /api/families/{id}       │
│    - Validates: keeper role          │
│    - Updates family                  │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 5. Family Updated                    │
│    - Profile screen refreshes        │
└──────────────────────────────────────┘

Scenario B: View Family Members
┌─────────────────────────────────────┐
│ 1. Keeper on Profile Screen          │
│    - Taps "View Members"             │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 2. API: GET /api/families/{id}/members│
│    - Returns: list of members        │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 3. Display Members List               │
│    - Name, email, role               │
│    - Remove button (keeper only)     │
└──────────────────────────────────────┘

Scenario C: Remove Member
┌─────────────────────────────────────┐
│ 1. Keeper Taps "Remove" on Member    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 2. Confirmation Dialog               │
│    - "Remove member from family?"    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 3. API: DELETE /api/families/{id}/   │
│    members/{user_id}                 │
│    - Validates: keeper role          │
│    - Removes member                  │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 4. Member Removed                    │
│    - Notification sent to member     │
│    - Members list refreshes          │
└──────────────────────────────────────┘
```

---

## Screen Navigation Flow

### Main Navigation Structure

```
┌─────────────────────────────────────────────────────────┐
│                    App Entry Point                        │
└──────────────────────┬───────────────────────────────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │   Authentication     │
            │   Check (AuthGuard)  │
            └──────────┬───────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ▼                             ▼
┌───────────────┐            ┌───────────────┐
│  Not Logged   │            │   Logged In   │
│  In            │            │               │
└───────┬───────┘            └───────┬───────┘
        │                             │
        ▼                             ▼
┌───────────────┐            ┌───────────────┐
│ Login/Register│            │  Family Check  │
│  Screen       │            │  (FamilyGuard) │
└───────────────┘            └───────┬───────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
            ┌───────────────┐              ┌───────────────┐
            │  Has Family   │              │  No Family    │
            └───────┬───────┘              └───────┬───────┘
                    │                               │
                    ▼                               ▼
        ┌───────────────────────┐      ┌───────────────────────┐
        │   Main App            │      │  Join/Create Family   │
        │   Navigation          │      │  Prompt Screen        │
        └───────┬───────────────┘      └───────────────────────┘
                │
    ┌───────────┼───────────┬───────────┬───────────┐
    │           │           │           │           │
    ▼           ▼           ▼           ▼           ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│ Home   │ │Profile│ │Search  │ │Create  │ │Notif.  │
│ Screen │ │Screen │ │Screen  │ │Recipe  │ │Screen  │
└────────┘ └────────┘ └────────┘ └────────┘ └────────┘
```

### Detailed Screen Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      Home Screen                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  [Profile] [Search] [Notifications]                   │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Recipe Feed (Family-scoped or Legacy)                │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │   │
│  │  │ Recipe 1 │ │ Recipe 2 │ │ Recipe 3 │            │   │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘            │   │
│  │       │            │            │                   │   │
│  │       └────────────┴────────────┘                   │   │
│  │                    │                                 │   │
│  │                    ▼                                 │   │
│  │            Recipe Detail Screen                      │   │
│  │            ┌─────────────────────┐                 │   │
│  │            │ Recipe Info          │                 │   │
│  │            │ Ingredients          │                 │   │
│  │            │ Instructions         │                 │   │
│  │            │ ───────────────────  │                 │   │
│  │            │ Comments Section      │                 │   │
│  │            │ [Add Comment Input]  │                 │   │
│  │            └─────────────────────┘                 │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  [+ Add Recipe] Button                                │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────┐
│                      Profile Screen                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  [Avatar]                                            │   │
│  │  Name: John Doe                                      │   │
│  │  Email: john@example.com                             │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Family Card                                          │   │
│  │  ┌──────────────────────────────────────────────┐    │   │
│  │  │ 👥 Smith Family                              │    │   │
│  │  │ [Keeper Badge]                                │    │   │
│  │  │ Invite Code: ABC12345                         │    │   │
│  │  │ [View Members] [Edit Family]                  │    │   │
│  │  └──────────────────────────────────────────────┘    │   │
│  │  OR                                                  │   │
│  │  ┌──────────────────────────────────────────────┐    │   │
│  │  │ 👥 Join or Create a Family                   │    │   │
│  │  │ [Create] [Join]                               │    │   │
│  │  └──────────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  📖 My Recipes                                        │   │
│  │  → Navigate to My Recipes Screen                     │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  ⚙️ Settings                                          │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  [Logout]                                             │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## API Integration Flow

### Authentication Flow

```dart
// 1. Login
POST /api/auth/login
Request: { email, password }
Response: { token, user: { id, name, email, family_id, role } }

// Store token in secure storage
await AuthService.saveToken(response.token);
await AuthService.saveUser(response.user);

// 2. Get Current User
GET /api/auth/me
Headers: { Authorization: Bearer {token} }
Response: { id, name, email, family_id, role, ... }

// 3. Update Profile
PUT /api/auth/profile
Headers: { Authorization: Bearer {token} }
Request: { nickname?, avatar? }
Response: { updated user }
```

### Family Management Flow

```dart
// 1. Create Family
POST /api/families
Headers: { Authorization: Bearer {token} }
Request: { name, description? }
Response: { id, name, owner_id, invite_code, metadata, created_at }

// User automatically becomes keeper
// Update local user state: family_id, role = "keeper"

// 2. Join Family
POST /api/families/join
Headers: { Authorization: Bearer {token} }
Request: { invite_code }
Response: { family details }

// User becomes member
// Update local user state: family_id, role = "member"

// 3. Get Family Details
GET /api/families/{family_id}
Headers: { Authorization: Bearer {token} }
Response: { id, name, owner_id, invite_code, metadata }

// 4. Update Family (Keeper only)
PUT /api/families/{family_id}
Headers: { Authorization: Bearer {token} }
Request: { name?, description?, cover_image? }
Response: { updated family }

// 5. Get Family Members
GET /api/families/{family_id}/members
Headers: { Authorization: Bearer {token} }
Response: [{ id, name, email, role, ... }]

// 6. Remove Member (Keeper only)
DELETE /api/families/{family_id}/members/{user_id}
Headers: { Authorization: Bearer {token} }
Response: { message }
```

### Recipe Flow

```dart
// 1. Get Recipes (Family-scoped or Legacy)
GET /api/recipes?category={category}&author_id={author_id}
Headers: { Authorization: Bearer {token} }
Response: [{ id, family_id, title, ingredients, ... }]

// Backend automatically filters:
// - If user has family_id: shows family-scoped recipes
// - If user has no family_id: shows legacy recipes (family_id: null)

// 2. Create Recipe
POST /api/recipes
Headers: { Authorization: Bearer {token} }
Request: { title, ingredients, instructions, ... }
Response: { id, family_id, title, ... }

// Backend automatically adds family_id from user
// Creates notifications for family members

// 3. Get Recipe Detail
GET /api/recipes/{recipe_id}
Headers: { Authorization: Bearer {token} }
Response: { recipe details }

// Backend checks access:
// - Legacy recipe (family_id: null) → accessible to all
// - Family recipe → only accessible to family members

// 4. Update Recipe
PUT /api/recipes/{recipe_id}
Headers: { Authorization: Bearer {token} }
Request: { title?, ingredients?, ... }
Response: { updated recipe }

// Only author can update

// 5. Delete Recipe
DELETE /api/recipes/{recipe_id}
Headers: { Authorization: Bearer {token} }
Response: { message }

// Author can always delete
// Keeper can delete any recipe in family
```

### Comment Flow

```dart
// 1. Get Comments
GET /api/recipes/{recipe_id}/comments
Response: [{ id, user_name, text, created_at }]

// 2. Add Comment
POST /api/recipes/{recipe_id}/comments
Headers: { Authorization: Bearer {token} }
Request: { text }
Response: { comment }

// Creates notification for recipe author (if in same family)
```

### Notification Flow

```dart
// 1. Get Notifications
GET /api/notifications
Headers: { Authorization: Bearer {token} }
Response: [{ id, type, message, is_read, recipe_id?, ... }]

// 2. Get Unread Count
GET /api/notifications/unread-count
Headers: { Authorization: Bearer {token} }
Response: { count }

// 3. Mark as Read
PUT /api/notifications/{notification_id}/read
Headers: { Authorization: Bearer {token} }
Response: { message }

// 4. Mark All as Read
PUT /api/notifications/read-all
Headers: { Authorization: Bearer {token} }
Response: { message }
```

---

## State Management

### User State

```dart
class UserState {
  User? currentUser;
  bool isAuthenticated;
  bool isLoading;
  
  // User properties
  String? userId;
  String? familyId;
  String? role; // "keeper" | "member" | null
  
  // Methods
  void setUser(User user) {
    currentUser = user;
    userId = user.id;
    familyId = user.familyId;
    role = user.role;
    isAuthenticated = true;
  }
  
  void clearUser() {
    currentUser = null;
    userId = null;
    familyId = null;
    role = null;
    isAuthenticated = false;
  }
  
  bool get hasFamily => familyId != null;
  bool get isKeeper => role == "keeper";
  bool get isMember => role == "member";
}
```

### Family State

```dart
class FamilyState {
  Family? currentFamily;
  List<FamilyMember> members;
  bool isLoading;
  
  void setFamily(Family family) {
    currentFamily = family;
  }
  
  void setMembers(List<FamilyMember> membersList) {
    members = membersList;
  }
  
  void clearFamily() {
    currentFamily = null;
    members = [];
  }
}
```

### Recipe State

```dart
class RecipeState {
  List<Recipe> recipes;
  Recipe? selectedRecipe;
  bool isLoading;
  
  // Filter recipes by family
  List<Recipe> getFamilyRecipes(String? familyId) {
    if (familyId == null) {
      return recipes.where((r) => r.familyId == null).toList();
    }
    return recipes.where((r) => r.familyId == familyId).toList();
  }
  
  // Get user's recipes
  List<Recipe> getUserRecipes(String userId) {
    return recipes.where((r) => r.authorId == userId).toList();
  }
}
```

---

## Role-Based Access Control

### UI Element Visibility

```dart
// Example: Show/Hide based on role
Widget buildFamilyActions() {
  if (!userState.hasFamily) {
    return JoinOrCreateFamilyCard();
  }
  
  if (userState.isKeeper) {
    return Column(
      children: [
        Text('Invite Code: ${family.inviteCode}'),
        ElevatedButton(
          onPressed: () => navigateToEditFamily(),
          child: Text('Edit Family'),
        ),
        ElevatedButton(
          onPressed: () => navigateToMembers(),
          child: Text('View Members'),
        ),
      ],
    );
  }
  
  // Member view
  return Column(
    children: [
      Text('Family: ${family.name}'),
      RoleBadge(role: 'member'),
    ],
  );
}
```

### Action Permissions

```dart
// Recipe deletion permission
bool canDeleteRecipe(Recipe recipe, User user) {
  // Legacy recipe: only author can delete
  if (recipe.familyId == null) {
    return recipe.authorId == user.id;
  }
  
  // Family recipe: author can always delete
  if (recipe.authorId == user.id) {
    return true;
  }
  
  // Keeper can delete any recipe in family
  if (user.role == "keeper" && recipe.familyId == user.familyId) {
    return true;
  }
  
  return false;
}

// Family management permissions
bool canEditFamily(User user, Family family) {
  return user.role == "keeper" && user.familyId == family.id;
}

bool canRemoveMember(User user, Family family) {
  return user.role == "keeper" && user.familyId == family.id;
}
```

---

## Family Lifecycle

### Creating a Family

```
1. User Registration/Login
   ↓
2. User has no family (family_id: null)
   ↓
3. User sees "Join or Create Family" prompt
   ↓
4. User taps "Create Family"
   ↓
5. Enter family name and description
   ↓
6. API: POST /api/families
   ↓
7. Backend:
   - Creates family record
   - Generates unique invite code
   - Sets user.family_id = family.id
   - Sets user.role = "keeper"
   ↓
8. Frontend:
   - Updates user state
   - Shows family card in profile
   - Displays invite code
   - Home screen now shows family-scoped recipes
```

### Joining a Family

```
1. User has no family
   ↓
2. User taps "Join Family"
   ↓
3. Enter invite code
   ↓
4. API: POST /api/families/join
   ↓
5. Backend:
   - Validates invite code
   - Sets user.family_id = family.id
   - Sets user.role = "member"
   - Creates notification for keeper
   ↓
6. Frontend:
   - Updates user state
   - Shows family card in profile
   - Home screen now shows family-scoped recipes
```

### Leaving/Removing from Family

```
Scenario A: Keeper Removes Member
1. Keeper on Members List
   ↓
2. Taps "Remove" on member
   ↓
3. Confirmation dialog
   ↓
4. API: DELETE /api/families/{id}/members/{user_id}
   ↓
5. Backend:
   - Removes user.family_id
   - Removes user.role
   - Creates notification for removed member
   ↓
6. Frontend (Removed User):
   - User state updated (no family)
   - Sees "Join or Create Family" prompt
   - Home screen shows legacy recipes

Scenario B: Keeper Deletes Family
1. Keeper on Profile Screen
   ↓
2. Taps "Delete Family"
   ↓
3. Confirmation dialog (warning about all members)
   ↓
4. API: DELETE /api/families/{id}
   ↓
5. Backend:
   - Removes all members' family_id and role
   - Deletes family record
   ↓
6. Frontend (All Members):
   - User state updated (no family)
   - Sees "Join or Create Family" prompt
```

---

## Recipe Access Flow

### Recipe Visibility Rules

```
┌─────────────────────────────────────────────────────────┐
│              Recipe Access Decision Tree                 │
└─────────────────────────────────────────────────────────┘

User Opens Home Screen
         │
         ▼
    Has family_id?
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    ▼         ▼
Show      Show
Family    Legacy
Recipes   Recipes
(family_id (family_id
 = user's  = null)
 family_id)
```

### Recipe Creation Rules

```
User Creates Recipe
         │
         ▼
    Has family_id?
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    ▼         ▼
Recipe      Recipe
Created     Created
with        with
family_id   family_id
= user's    = null
family_id   (legacy)
         │
         ▼
Notifications
Created for
Family Members
(if family_id exists)
```

---

## Comment Flow

### Adding a Comment

```
1. User on Recipe Detail Screen
   ↓
2. Scrolls to Comments Section
   ↓
3. Sees existing comments (if any)
   ↓
4. Enters comment text
   ↓
5. Taps "Send" button
   ↓
6. API: POST /api/recipes/{id}/comments
   ↓
7. Comment added to list
   ↓
8. If recipe author is in same family:
   - Notification created
   - Type: "comment"
   - Recipe author sees notification
```

### Comment Display

```
Recipe Detail Screen
┌─────────────────────────────────────┐
│ Recipe Information                  │
│ ...                                  │
│ ─────────────────────────────────   │
│ Comments                            │
│ ┌─────────────────────────────────┐ │
│ │ [Avatar] John Doe               │ │
│ │ "This looks amazing!"           │ │
│ │ 2 hours ago                     │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [Avatar] Jane Smith             │ │
│ │ "Can't wait to try this!"       │ │
│ │ 1 hour ago                      │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [Comment Input Field]               │
│ [Send Button]                       │
└─────────────────────────────────────┘
```

---

## Notification Flow

### Notification Types

```
1. "new_recipe"
   - Trigger: Family member creates recipe
   - Recipients: All other family members
   - Action: Tap → Navigate to recipe detail

2. "comment"
   - Trigger: Someone comments on user's recipe
   - Recipients: Recipe author (if in same family)
   - Action: Tap → Navigate to recipe detail

3. "family_invite"
   - Trigger: User joins family OR is removed
   - Recipients: Family keeper (on join) OR removed user
   - Action: Tap → Navigate to family details or profile
```

### Notification Display

```
Notifications Screen
┌─────────────────────────────────────┐
│ [Mark All Read] Button              │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔴 [Unread Indicator]          │ │
│ │ 🍽️ New Recipe                 │ │
│ │ "John shared: Chocolate Cake" │ │
│ │ 5 minutes ago                   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [No Indicator - Read]            │ │
│ │ 💬 Comment                      │ │
│ │ "Jane commented on your recipe"  │ │
│ │ 1 hour ago                      │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Notification Badge

```
App Bar
┌─────────────────────────────────────┐
│ [Logo] HTrecipes    [🔔 3] [Profile]│
│                      ↑               │
│                  Badge shows          │
│                  unread count        │
└─────────────────────────────────────┘

API: GET /api/notifications/unread-count
Response: { count: 3 }
```

---

## Error Handling

### Common Error Scenarios

```
1. User tries to access family-scoped recipe without family
   → Error: 403 Forbidden
   → UI: Show "Join or Create Family" prompt

2. User tries to create family when already in one
   → Error: 400 Bad Request
   → UI: Show error message

3. Invalid invite code
   → Error: 404 Not Found
   → UI: Show "Invalid invite code" message

4. Member tries to delete family
   → Error: 403 Forbidden
   → UI: Hide delete button for members

5. Network error
   → Error: NetworkException
   → UI: Show retry button, offline message
```

---

## Data Flow Summary

### Complete User Journey

```
Registration
    ↓
Login
    ↓
Check Family Status
    ↓
┌───────────┴───────────┐
│                       │
No Family            Has Family
    │                       │
    ↓                       ↓
Join/Create          Main App
Family Flow           Flow
    │                       │
    └───────────┬───────────┘
                ↓
        Family-Scoped
        Recipe Access
                ↓
        Create/View Recipes
                ↓
        Add Comments
                ↓
        Receive Notifications
                ↓
        Manage Profile
```

---

## Key Implementation Points

### 1. Family Guard Implementation

```dart
class FamilyGuard {
  static Future<bool> requireFamily(BuildContext context) async {
    final user = await AuthService.getCurrentUser();
    
    if (user?.familyId == null) {
      // Show dialog to join/create family
      final result = await showFamilyPrompt(context);
      if (result == true) {
        // User joined/created family
        return true;
      }
      return false;
    }
    
    return true;
  }
}
```

### 2. State Synchronization

```dart
// When user joins/creates family
void onFamilyJoined(Family family) {
  // Update user state
  userState.setFamilyId(family.id);
  userState.setRole("member"); // or "keeper"
  
  // Refresh home screen
  recipeState.refreshRecipes();
  
  // Update profile screen
  profileScreen.refresh();
}
```

### 3. Real-time Updates

```dart
// Poll for notifications
Timer.periodic(Duration(minutes: 1), (timer) {
  notificationService.getUnreadCount().then((count) {
    if (count > 0) {
      updateNotificationBadge(count);
    }
  });
});
```

---

## Testing Scenarios

### Test Case 1: New User Flow
1. Register new user
2. Verify no family assigned
3. Create family
4. Verify user is keeper
5. Verify home shows family-scoped recipes

### Test Case 2: Join Family Flow
1. Login as user without family
2. Join family with invite code
3. Verify user is member
4. Verify home shows family-scoped recipes

### Test Case 3: Recipe Access
1. User with family creates recipe
2. Verify recipe has family_id
3. Another family member sees recipe
4. User without family cannot see recipe

### Test Case 4: Role-Based Actions
1. Keeper can edit/delete family
2. Keeper can remove members
3. Member cannot edit/delete family
4. Member cannot remove other members

---

## Summary

This document outlines the complete frontend application flow for Milestone 5, covering:

- ✅ User registration and family setup
- ✅ Family joining and management
- ✅ Recipe creation and access control
- ✅ Comment system
- ✅ Notification system
- ✅ Role-based access control
- ✅ State management
- ✅ API integration patterns
- ✅ Error handling

All flows are designed to be backward compatible, ensuring existing users without families can continue using the app while new family features are gradually adopted.
