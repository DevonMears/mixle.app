-- Mixle Database Schema
-- Phase 2: Initial schema setup

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- TABLES
-- ============================================================================

-- 1. Users Table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE,
  name TEXT NOT NULL,
  bio TEXT,
  photo_url TEXT,
  role TEXT,
  company TEXT,
  is_bot BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Event Codes Table
CREATE TABLE event_codes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. User Sessions Table
CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_code_id UUID NOT NULL REFERENCES event_codes(id) ON DELETE CASCADE,
  last_active TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, event_code_id)
);

-- 4. Intents Table
CREATE TABLE intents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_code_id UUID NOT NULL REFERENCES event_codes(id) ON DELETE CASCADE,
  intent_type TEXT NOT NULL,
  custom_intent_text TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Matches Table
CREATE TABLE matches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  user2_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_code_id UUID NOT NULL REFERENCES event_codes(id) ON DELETE CASCADE,
  intent_type TEXT NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT different_users CHECK (user1_id != user2_id)
);

-- 6. Messages Table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Declines Table
CREATE TABLE declines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  declined_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_code_id UUID NOT NULL REFERENCES event_codes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, declined_user_id, event_code_id),
  CONSTRAINT different_decline_users CHECK (user_id != declined_user_id)
);

-- ============================================================================
-- INDEXES for Performance
-- ============================================================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_bot ON users(is_bot);

CREATE INDEX idx_event_codes_code ON event_codes(code);
CREATE INDEX idx_event_codes_is_active ON event_codes(is_active);

CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_event_code_id ON user_sessions(event_code_id);
CREATE INDEX idx_user_sessions_last_active ON user_sessions(last_active);

CREATE INDEX idx_intents_user_id ON intents(user_id);
CREATE INDEX idx_intents_event_code_id ON intents(event_code_id);
CREATE INDEX idx_intents_is_active ON intents(is_active);
CREATE INDEX idx_intents_intent_type ON intents(intent_type);

CREATE INDEX idx_matches_user1_id ON matches(user1_id);
CREATE INDEX idx_matches_user2_id ON matches(user2_id);
CREATE INDEX idx_matches_event_code_id ON matches(event_code_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_created_at ON matches(created_at DESC);

CREATE INDEX idx_messages_match_id ON messages(match_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX idx_messages_is_read ON messages(is_read);

CREATE INDEX idx_declines_user_id ON declines(user_id);
CREATE INDEX idx_declines_event_code_id ON declines(event_code_id);

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function to update last_active timestamp
CREATE OR REPLACE FUNCTION update_last_active()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE user_sessions
  SET last_active = NOW()
  WHERE user_id = NEW.user_id AND event_code_id = NEW.event_code_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update last_active when user creates an intent
CREATE TRIGGER trigger_update_last_active_on_intent
AFTER INSERT ON intents
FOR EACH ROW
EXECUTE FUNCTION update_last_active();

-- Function to cleanup event data (for admin use)
CREATE OR REPLACE FUNCTION cleanup_event_data(event_code_param TEXT)
RETURNS void AS $$
DECLARE
  event_id UUID;
BEGIN
  -- Get event_code_id
  SELECT id INTO event_id FROM event_codes WHERE code = event_code_param;

  IF event_id IS NULL THEN
    RAISE EXCEPTION 'Event code % not found', event_code_param;
  END IF;

  -- Delete in order to respect foreign key constraints
  DELETE FROM messages WHERE match_id IN (SELECT id FROM matches WHERE event_code_id = event_id);
  DELETE FROM matches WHERE event_code_id = event_id;
  DELETE FROM declines WHERE event_code_id = event_id;
  DELETE FROM intents WHERE event_code_id = event_id;
  DELETE FROM user_sessions WHERE event_code_id = event_id;

  RAISE NOTICE 'Cleaned up all data for event code %', event_code_param;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- REALTIME SETUP
-- ============================================================================

-- Enable realtime for tables that need live updates
ALTER PUBLICATION supabase_realtime ADD TABLE matches;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE user_sessions;
