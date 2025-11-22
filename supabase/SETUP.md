# Supabase Database Setup

This guide will help you set up the Mixle database in Supabase.

## Prerequisites

- Supabase account (free tier works fine)
- Supabase project created
- Environment variables configured in `.env.local`

## Step 1: Access SQL Editor

1. Go to your Supabase project dashboard
2. Click on **SQL Editor** in the left sidebar
3. Click **New query** button

## Step 2: Run Migrations (In Order)

Run these SQL files in the following order:

### 1. Initialize Schema (Tables, Indexes, Functions)

1. Open `supabase/migrations/20251122_init_schema.sql`
2. Copy the entire contents
3. Paste into Supabase SQL Editor
4. Click **Run** (or press Cmd/Ctrl + Enter)
5. Verify you see: "Query executed successfully"

**What this creates:**
- 7 tables (users, event_codes, user_sessions, intents, matches, messages, declines)
- All foreign keys and constraints
- Performance indexes
- `update_last_active()` function and trigger
- `cleanup_event_data()` admin function
- Realtime subscriptions enabled

### 2. Set Up Row Level Security

1. Open `supabase/migrations/20251122_rls_policies.sql`
2. Copy the entire contents
3. Paste into a new query in Supabase SQL Editor
4. Click **Run**
5. Verify you see: "Query executed successfully"

**What this creates:**
- RLS policies for all tables
- Secure access patterns
- Users can only access their own data

### 3. Load Seed Data

1. Open `supabase/migrations/20251122_seed_data.sql`
2. Copy the entire contents
3. Paste into a new query in Supabase SQL Editor
4. Click **Run**
5. Verify you see:
   - "Event code AFROTECH2026 created successfully"
   - "10 bot accounts created successfully"

**What this creates:**
- Event code: AFROTECH2026
- 10 bot accounts with profiles

## Step 3: Verify Setup

### Check Tables Created

Run this query:
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

You should see:
- declines
- event_codes
- intents
- matches
- messages
- user_sessions
- users

### Check Bot Accounts

Run this query:
```sql
SELECT name, role, company, is_bot
FROM users
WHERE is_bot = true
ORDER BY name;
```

You should see 10 bot accounts.

### Check Event Code

Run this query:
```sql
SELECT code, name, is_active
FROM event_codes;
```

You should see: AFROTECH2026

## Step 4: Enable Realtime (if not already enabled)

1. Go to **Database** → **Replication** in Supabase
2. Enable replication for these tables:
   - ✅ matches
   - ✅ messages
   - ✅ user_sessions

## Step 5: Test Connection from App

In your Next.js app, test the connection:

```typescript
import { createClient } from '@/lib/supabase/client'

const supabase = createClient()

// Test query
const { data, error } = await supabase
  .from('event_codes')
  .select('*')
  .eq('code', 'AFROTECH2026')
  .single()

console.log('Event:', data)
```

## Troubleshooting

### "Permission denied" errors
- Make sure you're logged into Supabase
- Check that RLS policies were created correctly
- For development, you can temporarily disable RLS on a table (not recommended for production)

### "Relation does not exist" errors
- Make sure you ran the init_schema.sql first
- Check for any error messages during migration
- Verify tables were created in the `public` schema

### Bot accounts not showing up
- Make sure seed_data.sql ran successfully
- Check for verification messages in the SQL output
- Run the verification query above

### Realtime not working
- Enable replication in Database → Replication
- Make sure tables are checked
- Refresh the page after enabling

## Admin Functions

### Cleanup Event Data

To wipe all data for an event (useful for demos):

```sql
SELECT cleanup_event_data('AFROTECH2026');
```

This will delete:
- All messages for matches at the event
- All matches at the event
- All declines at the event
- All intents at the event
- All user sessions at the event

**Note:** This does NOT delete:
- The event code itself
- User profiles (including bots)

### Create a New Event Code

```sql
INSERT INTO event_codes (code, name, is_active)
VALUES ('MYEVENT2026', 'My Event 2026', true);
```

## Next Steps

After database setup is complete:
1. ✅ Database is ready
2. ➡️ Build authentication flow
3. ➡️ Implement matching system
4. ➡️ Create chat interface
5. ➡️ Add bot auto-response logic
