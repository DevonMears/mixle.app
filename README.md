# Mixle - Intent-Based Event Matching

Meet people at events based on what you want to do right now.

## Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Set Up Supabase

#### Create a Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Sign in with GitHub
4. Click "New Project"
5. Fill in:
   - **Name:** mixle-demo (or your choice)
   - **Database Password:** (generate a strong password)
   - **Region:** Choose closest to you
   - **Pricing Plan:** Free tier is perfect
6. Click "Create new project" (takes ~2 minutes)

#### Get Your Supabase Credentials
1. Once project is created, go to **Project Settings** (gear icon)
2. Click **API** in the sidebar
3. Copy these values:
   - **Project URL** (under "Project URL")
   - **anon public** key (under "Project API keys")
   - **service_role** key (under "Project API keys" - click "Reveal")

#### Configure Environment Variables
1. Copy the example env file:
   ```bash
   cp .env.local.example .env.local
   ```
2. Open `.env.local` and paste your Supabase credentials:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
   ```

#### Run Database Migrations
1. Go to your Supabase project → **SQL Editor**
2. Follow the step-by-step guide in `supabase/SETUP.md`
3. Run the 3 migration files in order:
   - `20251122_init_schema.sql` (tables, indexes, functions)
   - `20251122_rls_policies.sql` (security policies)
   - `20251122_seed_data.sql` (event code + 10 bots)

See detailed instructions: [supabase/SETUP.md](supabase/SETUP.md)

### 3. Run the Development Server
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
mixle.app/
├── app/                    # Next.js app directory
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Home page
│   └── globals.css        # Global styles
├── lib/
│   ├── supabase/          # Supabase configuration
│   │   ├── client.ts      # Client-side Supabase
│   │   └── server.ts      # Server-side Supabase
│   └── types/             # TypeScript types
│       └── database.types.ts  # Database types
├── supabase/
│   ├── migrations/        # Database migrations
│   │   ├── 20251122_init_schema.sql
│   │   ├── 20251122_rls_policies.sql
│   │   └── 20251122_seed_data.sql
│   └── SETUP.md          # Database setup guide
├── docs/                  # Project documentation
│   ├── 00_PROJECT_OVERVIEW.md
│   ├── 01_TECH_STACK.md
│   ├── 02_DATABASE_SCHEMA.md
│   └── 99_CHANGELOG.md
├── middleware.ts          # Auth middleware
└── package.json
```

## Documentation

See the `/docs` folder for detailed documentation:
- **00_PROJECT_OVERVIEW.md** - Vision, features, and architecture
- **01_TECH_STACK.md** - Technology choices and rationale
- **02_DATABASE_SCHEMA.md** - Complete database schema with diagrams
- **99_CHANGELOG.md** - Development history

Also see:
- **supabase/SETUP.md** - Step-by-step database setup guide

## Database

### Schema
- 7 tables: users, event_codes, user_sessions, intents, matches, messages, declines
- Row Level Security (RLS) enabled on all tables
- Realtime subscriptions for matches, messages, and sessions
- Admin cleanup function for demo resets

### Seed Data
- Event code: **AFROTECH2026**
- **10 bot accounts** with diverse roles (Founder, Engineer, Designer, PM, etc.)

See [02_DATABASE_SCHEMA.md](docs/02_DATABASE_SCHEMA.md) for full details.

## Next Steps

1. ✅ Database schema implemented
2. ✅ Seed data created (event code + 10 bots)
3. ➡️ Build authentication flow
4. ➡️ Create matching system
5. ➡️ Build chat interface
6. ➡️ Add bot auto-response logic
7. ➡️ Deploy to Vercel

## Tech Stack

- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first styling
- **Supabase** - Backend (auth, database, realtime)
- **Vercel** - Deployment platform

## Brand Colors

- Blue to Purple gradient: `#4A9FD8 → #8B5CF6`
- Orange to Red gradient: `#FF8A3D → #EF4444`
- Accent pink: `#E91E63`

## Development

```bash
npm run dev      # Run development server
npm run build    # Build for production
npm run start    # Start production server
npm run lint     # Run linter
```

## License

Private - For demo purposes only
