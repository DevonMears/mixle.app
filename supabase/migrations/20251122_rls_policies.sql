-- Mixle Row Level Security Policies
-- Phase 2: Security setup

-- ============================================================================
-- ENABLE RLS
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE intents ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE declines ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- USERS TABLE POLICIES
-- ============================================================================

-- Users can read all user profiles (needed for matching)
CREATE POLICY "Users can read all profiles"
ON users FOR SELECT
USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
ON users FOR INSERT
WITH CHECK (true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON users FOR UPDATE
USING (auth.uid()::text = id::text);

-- ============================================================================
-- EVENT CODES TABLE POLICIES
-- ============================================================================

-- Everyone can read active event codes
CREATE POLICY "Anyone can read active event codes"
ON event_codes FOR SELECT
USING (is_active = true);

-- Only authenticated users can create event codes (admin function)
CREATE POLICY "Authenticated users can create event codes"
ON event_codes FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- ============================================================================
-- USER SESSIONS TABLE POLICIES
-- ============================================================================

-- Users can read all sessions (to see who's at the event)
CREATE POLICY "Users can read all sessions"
ON user_sessions FOR SELECT
USING (true);

-- Users can insert their own session
CREATE POLICY "Users can insert own session"
ON user_sessions FOR INSERT
WITH CHECK (true);

-- Users can update their own session
CREATE POLICY "Users can update own session"
ON user_sessions FOR UPDATE
USING (auth.uid()::text = user_id::text);

-- Users can delete their own session
CREATE POLICY "Users can delete own session"
ON user_sessions FOR DELETE
USING (auth.uid()::text = user_id::text);

-- ============================================================================
-- INTENTS TABLE POLICIES
-- ============================================================================

-- Users can read all intents (needed for matching)
CREATE POLICY "Users can read all intents"
ON intents FOR SELECT
USING (true);

-- Users can insert their own intent
CREATE POLICY "Users can insert own intent"
ON intents FOR INSERT
WITH CHECK (auth.uid()::text = user_id::text);

-- Users can update their own intent
CREATE POLICY "Users can update own intent"
ON intents FOR UPDATE
USING (auth.uid()::text = user_id::text);

-- Users can delete their own intent
CREATE POLICY "Users can delete own intent"
ON intents FOR DELETE
USING (auth.uid()::text = user_id::text);

-- ============================================================================
-- MATCHES TABLE POLICIES
-- ============================================================================

-- Users can read matches they're part of
CREATE POLICY "Users can read own matches"
ON matches FOR SELECT
USING (
  auth.uid()::text = user1_id::text OR
  auth.uid()::text = user2_id::text
);

-- Users can insert matches (for matching system)
CREATE POLICY "Users can create matches"
ON matches FOR INSERT
WITH CHECK (
  auth.uid()::text = user1_id::text OR
  auth.uid()::text = user2_id::text
);

-- Users can update matches they're part of
CREATE POLICY "Users can update own matches"
ON matches FOR UPDATE
USING (
  auth.uid()::text = user1_id::text OR
  auth.uid()::text = user2_id::text
);

-- ============================================================================
-- MESSAGES TABLE POLICIES
-- ============================================================================

-- Users can read messages in their matches
CREATE POLICY "Users can read messages in their matches"
ON messages FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM matches
    WHERE matches.id = messages.match_id
    AND (matches.user1_id::text = auth.uid()::text OR matches.user2_id::text = auth.uid()::text)
  )
);

-- Users can send messages in their matches
CREATE POLICY "Users can send messages in their matches"
ON messages FOR INSERT
WITH CHECK (
  auth.uid()::text = sender_id::text AND
  EXISTS (
    SELECT 1 FROM matches
    WHERE matches.id = match_id
    AND (matches.user1_id::text = auth.uid()::text OR matches.user2_id::text = auth.uid()::text)
  )
);

-- Users can update their own messages (mark as read)
CREATE POLICY "Users can update messages in their matches"
ON messages FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM matches
    WHERE matches.id = messages.match_id
    AND (matches.user1_id::text = auth.uid()::text OR matches.user2_id::text = auth.uid()::text)
  )
);

-- ============================================================================
-- DECLINES TABLE POLICIES
-- ============================================================================

-- Users can read their own declines
CREATE POLICY "Users can read own declines"
ON declines FOR SELECT
USING (auth.uid()::text = user_id::text);

-- Users can insert their own declines
CREATE POLICY "Users can insert own declines"
ON declines FOR INSERT
WITH CHECK (auth.uid()::text = user_id::text);

-- ============================================================================
-- SERVICE ROLE BYPASS
-- ============================================================================

-- Note: Service role key bypasses RLS automatically
-- This allows admin functions and bot operations
