# Mixle - Project Overview

## Vision
Mixle is an intent-based matching app for events and conferences. Users enter an event code, pick what they want to do (grab lunch, network, coffee), get matched with someone who wants the same thing, chat, then meet IRL.

## Purpose
This is a working demo the founder will use on their phone to pitch investors. It must be fully functional and polished.

## Core Concept
Unlike traditional networking apps that match based on profiles/interests, Mixle matches based on **immediate intent** - what you want to do RIGHT NOW at this event.

## Key Features

### Venue Mode ONLY
- Users are at physical events right now
- Real-time matching within the same event code
- Geographic proximity implied (everyone is at the same venue)

### Simple User Flow
1. Enter event code
2. Select intent (lunch, coffee, networking, etc.)
3. Get matched with someone with same intent
4. Chat in-app
5. Meet IRL at the event

### Session-Based Cleanup
- Admin can wipe all data per event code
- Clean slate for each new event
- No persistent user accounts needed

### Bot Accounts
- 10 bot accounts that auto-respond when matched
- Ensures demo always works even with low user count
- Creates impression of active user base

## Design Philosophy

### Instagram/Notion/Figma Aesthetic
- Clean, minimal interface
- Lots of whitespace
- Modern typography
- Smooth animations
- Mobile-first design

### Brand Colors
- Blue to Purple gradient: #4A9FD8 → #8B5CF6
- Orange to Red gradient: #FF8A3D → #EF4444
- Accent pink: #E91E63

## Technical Architecture

### Frontend
- Next.js 14 with App Router
- TypeScript for type safety
- Tailwind CSS for styling
- Mobile-responsive design

### Backend
- Supabase for:
  - Authentication (anonymous/guest accounts)
  - PostgreSQL database
  - Realtime subscriptions (chat, matches)
  - Row Level Security (RLS)

### Deployment
- Vercel for hosting
- Edge functions for serverless API routes
- Automatic deployments from git

## Success Criteria
- App works flawlessly on founder's phone
- Matching happens in < 5 seconds
- Chat is real-time and reliable
- UI is polished and professional
- Demo can run repeatedly with session cleanup

## Development Approach
- Build iteratively in phases
- Prioritize working functionality over perfect code
- Test each feature thoroughly before moving on
- Keep it simple - no over-engineering
