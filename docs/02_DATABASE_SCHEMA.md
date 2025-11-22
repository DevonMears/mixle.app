# Mixle - Database Schema

> **Note:** This document will be updated with the full database schema once provided.

## Overview

The Mixle database will be hosted on Supabase (PostgreSQL) and will handle:
- Event codes and venues
- User profiles (anonymous/guest accounts)
- Matching system
- Chat messages
- Bot accounts
- Session cleanup

## Key Considerations

### Row Level Security (RLS)
All tables will have RLS policies to ensure:
- Users can only see their own data
- Users can only see matches they're part of
- Messages are only visible to participants
- Admins can manage event sessions

### Real-time Subscriptions
Tables that need real-time updates:
- `matches` - Know when you get matched
- `messages` - Live chat functionality
- `users` - Online status updates

### Session Cleanup
Admin functionality to wipe data per event code:
- Delete all matches for an event
- Delete all messages for an event
- Reset user states for an event
- Keep event codes reusable

### Bot Accounts
- 10 pre-configured bot accounts
- Auto-respond when matched
- Realistic conversation patterns
- Help make demo feel active

## Schema Details

*Schema details will be added once provided by the founder.*

## Indexes

Suggested indexes for performance:
- `users.event_code` - Fast lookup by event
- `users.current_intent` - Match users by intent
- `matches.created_at` - Recent matches first
- `messages.match_id` - Fast message retrieval

## Functions & Triggers

Potential database functions:
- `match_users()` - Find and create matches
- `cleanup_event()` - Admin session cleanup
- `bot_respond()` - Auto-respond for bots

## Migration Strategy

1. Create tables in Supabase dashboard or SQL editor
2. Set up RLS policies
3. Create indexes
4. Set up real-time subscriptions
5. Test with sample data
6. Deploy to production
