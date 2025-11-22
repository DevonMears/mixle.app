# Mixle - Database Schema

## Overview

The Mixle database is hosted on Supabase (PostgreSQL) and handles all core functionality including user profiles, event management, matching, chat, and session cleanup.

## Database Diagram

```
┌─────────────┐
│ event_codes │
│─────────────│
│ id          │◄─────┐
│ code        │      │
│ name        │      │
│ is_active   │      │
│ created_at  │      │
└─────────────┘      │
                     │
┌─────────────┐      │       ┌──────────────┐
│   users     │      │       │ user_sessions│
│─────────────│      │       │──────────────│
│ id          │◄─────┼───────┤ user_id      │
│ email       │      │       │ event_code_id│───┐
│ name        │      │       │ last_active  │   │
│ bio         │      │       └──────────────┘   │
│ photo_url   │      │                          │
│ role        │      │       ┌──────────────┐   │
│ company     │      │       │   intents    │   │
│ is_bot      │      │       │──────────────│   │
│ created_at  │      └───────┤ user_id      │   │
└─────────────┘              │ event_code_id│───┤
      │                      │ intent_type  │   │
      │                      │ custom_text  │   │
      │                      │ is_active    │   │
      │                      │ created_at   │   │
      │                      └──────────────┘   │
      │                                         │
      │                      ┌──────────────┐   │
      │                      │   matches    │   │
      │                      │──────────────│   │
      ├──────────────────────┤ user1_id     │   │
      │                      │ user2_id     │   │
      │                      │ event_code_id│───┤
      │                      │ intent_type  │   │
      │                      │ status       │   │
      │                      │ created_at   │   │
      │                      └──────────────┘   │
      │                            │            │
      │                            │            │
      │                      ┌──────────────┐   │
      │                      │   messages   │   │
      │                      │──────────────│   │
      │                      │ match_id     │───┘
      ├──────────────────────┤ sender_id    │
      │                      │ content      │
      │                      │ is_read      │
      │                      │ created_at   │
      │                      └──────────────┘
      │
      │                      ┌──────────────┐
      │                      │   declines   │
      │                      │──────────────│
      ├──────────────────────┤ user_id      │
      └──────────────────────┤ declined_id  │
                             │ event_code_id│
                             │ created_at   │
                             └──────────────┘
```

## Tables

### 1. users
Stores all user profiles including both real users and bots.

| Column      | Type      | Description                          |
|-------------|-----------|--------------------------------------|
| id          | UUID      | Primary key                          |
| email       | TEXT      | Email (nullable for anonymous users) |
| name        | TEXT      | Display name (required)              |
| bio         | TEXT      | User bio/description                 |
| photo_url   | TEXT      | Profile photo URL or emoji           |
| role        | TEXT      | Job role (e.g., "Founder", "PM")     |
| company     | TEXT      | Company name                         |
| is_bot      | BOOLEAN   | True for bot accounts                |
| created_at  | TIMESTAMP | Account creation time                |

**Indexes:**
- `idx_users_email` on email
- `idx_users_is_bot` on is_bot

### 2. event_codes
Stores event codes that users can join.

| Column     | Type      | Description                    |
|------------|-----------|--------------------------------|
| id         | UUID      | Primary key                    |
| code       | TEXT      | Unique event code (e.g., "AFROTECH2026") |
| name       | TEXT      | Event display name             |
| is_active  | BOOLEAN   | Whether event is accepting joins |
| created_at | TIMESTAMP | Event creation time            |

**Indexes:**
- `idx_event_codes_code` on code
- `idx_event_codes_is_active` on is_active

### 3. user_sessions
Tracks which users are at which events.

| Column        | Type      | Description                      |
|---------------|-----------|----------------------------------|
| id            | UUID      | Primary key                      |
| user_id       | UUID      | Foreign key → users.id           |
| event_code_id | UUID      | Foreign key → event_codes.id     |
| last_active   | TIMESTAMP | Last activity timestamp          |

**Constraints:**
- UNIQUE(user_id, event_code_id) - One session per user per event

**Indexes:**
- `idx_user_sessions_user_id` on user_id
- `idx_user_sessions_event_code_id` on event_code_id
- `idx_user_sessions_last_active` on last_active

### 4. intents
Stores what users want to do (lunch, coffee, etc.).

| Column            | Type      | Description                         |
|-------------------|-----------|-------------------------------------|
| id                | UUID      | Primary key                         |
| user_id           | UUID      | Foreign key → users.id              |
| event_code_id     | UUID      | Foreign key → event_codes.id        |
| intent_type       | TEXT      | Type of intent (lunch, coffee, etc.)|
| custom_intent_text| TEXT      | Custom text for "other" intents     |
| is_active         | BOOLEAN   | Whether intent is currently active  |
| created_at        | TIMESTAMP | Intent creation time                |

**Indexes:**
- `idx_intents_user_id` on user_id
- `idx_intents_event_code_id` on event_code_id
- `idx_intents_is_active` on is_active
- `idx_intents_intent_type` on intent_type

**Intent Types:**
- `lunch` - Grab lunch together
- `coffee` - Get coffee
- `networking` - General networking
- `walk` - Take a walk
- `drinks` - Get drinks
- `workshop` - Attend a workshop together
- `custom` - Custom intent (uses custom_intent_text)

### 5. matches
Stores matches between two users.

| Column        | Type      | Description                         |
|---------------|-----------|-------------------------------------|
| id            | UUID      | Primary key                         |
| user1_id      | UUID      | Foreign key → users.id              |
| user2_id      | UUID      | Foreign key → users.id              |
| event_code_id | UUID      | Foreign key → event_codes.id        |
| intent_type   | TEXT      | Shared intent that led to match     |
| status        | TEXT      | active, completed, or cancelled     |
| created_at    | TIMESTAMP | Match creation time                 |

**Constraints:**
- CHECK(user1_id != user2_id) - Can't match with yourself
- CHECK(status IN ('active', 'completed', 'cancelled'))

**Indexes:**
- `idx_matches_user1_id` on user1_id
- `idx_matches_user2_id` on user2_id
- `idx_matches_event_code_id` on event_code_id
- `idx_matches_status` on status
- `idx_matches_created_at` on created_at DESC

### 6. messages
Stores chat messages between matched users.

| Column     | Type      | Description                    |
|------------|-----------|--------------------------------|
| id         | UUID      | Primary key                    |
| match_id   | UUID      | Foreign key → matches.id       |
| sender_id  | UUID      | Foreign key → users.id         |
| content    | TEXT      | Message content                |
| is_read    | BOOLEAN   | Whether message has been read  |
| created_at | TIMESTAMP | Message send time              |

**Indexes:**
- `idx_messages_match_id` on match_id
- `idx_messages_sender_id` on sender_id
- `idx_messages_created_at` on created_at DESC
- `idx_messages_is_read` on is_read

### 7. declines
Tracks when users decline to match with someone (prevents re-matching).

| Column           | Type      | Description                      |
|------------------|-----------|----------------------------------|
| id               | UUID      | Primary key                      |
| user_id          | UUID      | Foreign key → users.id           |
| declined_user_id | UUID      | Foreign key → users.id           |
| event_code_id    | UUID      | Foreign key → event_codes.id     |
| created_at       | TIMESTAMP | Decline timestamp                |

**Constraints:**
- UNIQUE(user_id, declined_user_id, event_code_id)
- CHECK(user_id != declined_user_id)

**Indexes:**
- `idx_declines_user_id` on user_id
- `idx_declines_event_code_id` on event_code_id

## Row Level Security (RLS)

All tables have RLS enabled with the following policies:

### users
- ✅ SELECT: Anyone can read all profiles (needed for matching)
- ✅ INSERT: Anyone can create a profile
- ✅ UPDATE: Users can only update their own profile

### event_codes
- ✅ SELECT: Anyone can read active event codes
- ✅ INSERT: Authenticated users can create events (admin)

### user_sessions
- ✅ SELECT: Anyone can read all sessions
- ✅ INSERT: Anyone can create a session
- ✅ UPDATE: Users can only update their own sessions
- ✅ DELETE: Users can only delete their own sessions

### intents
- ✅ SELECT: Anyone can read all intents (needed for matching)
- ✅ INSERT/UPDATE/DELETE: Users can only modify their own intents

### matches
- ✅ SELECT: Users can only see matches they're part of
- ✅ INSERT: Users can create matches they're part of
- ✅ UPDATE: Users can only update matches they're part of

### messages
- ✅ SELECT: Users can only read messages in their matches
- ✅ INSERT: Users can only send messages in their matches
- ✅ UPDATE: Users can update messages in their matches (mark as read)

### declines
- ✅ SELECT: Users can only see their own declines
- ✅ INSERT: Users can only create their own declines

## Functions & Triggers

### update_last_active()
Automatically updates the `last_active` timestamp in `user_sessions` when a user creates a new intent.

**Trigger:** `trigger_update_last_active_on_intent`

### cleanup_event_data(event_code)
Admin function to wipe all data for a specific event code.

**Usage:**
```sql
SELECT cleanup_event_data('AFROTECH2026');
```

**What it deletes:**
1. All messages for matches at the event
2. All matches at the event
3. All declines at the event
4. All intents at the event
5. All user sessions at the event

Note: Does NOT delete the event code or user profiles.

## Realtime Subscriptions

The following tables have realtime enabled:
- ✅ `matches` - Get notified when matched
- ✅ `messages` - Live chat updates
- ✅ `user_sessions` - See who's active at the event

## Seed Data

### Event Code
- **Code:** AFROTECH2026
- **Name:** AfroTech 2026
- **Status:** Active

### Bot Accounts (10 total)

1. **Maya Chen** - Founder & CEO @ PayFlow Africa
2. **James Wilson** - Senior Software Engineer @ DevTools Inc
3. **Aisha Okonkwo** - Lead Product Designer @ HealthTech Solutions
4. **Carlos Rodriguez** - Partner @ AfriTech Ventures
5. **Zuri Mwangi** - Staff Data Scientist @ Spotify
6. **David Kim** - Head of Growth @ CloudScale
7. **Fatima Hassan** - iOS Engineer @ Twitter
8. **Marcus Thompson** - VP of Sales @ Salesforce
9. **Priya Patel** - Senior UX Researcher @ Meta
10. **Alex Turner** - Principal DevOps Engineer @ AWS

All bots have:
- Realistic names and roles
- Detailed bios
- Company information
- Emoji profile photos
- `is_bot = true` flag

## Migration Files

All schema files are located in `/supabase/migrations/`:

1. **20251122_init_schema.sql** - Tables, indexes, functions, triggers
2. **20251122_rls_policies.sql** - Row Level Security policies
3. **20251122_seed_data.sql** - Event code + 10 bot accounts

## TypeScript Types

Database types are defined in `/lib/types/database.types.ts` with full type safety for all tables, including Insert and Update types.
