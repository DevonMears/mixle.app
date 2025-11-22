# Mixle - Tech Stack

## Frontend

### Next.js 14 (App Router)
**Version:** 14.2.x
**Why:**
- Industry standard for React applications
- App Router provides modern file-based routing
- Server Components for better performance
- Built-in API routes
- Excellent Vercel deployment integration
- Great developer experience

### TypeScript
**Version:** 5.x
**Why:**
- Type safety reduces bugs
- Better IDE support and autocomplete
- Self-documenting code
- Industry standard for serious projects
- Catches errors at compile time

### Tailwind CSS
**Version:** 4.x
**Why:**
- Utility-first approach for rapid development
- Consistent design system
- Excellent for responsive design
- Small bundle size with purging
- Perfect for Instagram/Notion aesthetic
- No context switching between CSS files

## Backend

### Supabase
**Version:** Latest
**Why:**
- PostgreSQL database (robust, reliable)
- Built-in authentication (anonymous users)
- Real-time subscriptions (chat, matches)
- Row Level Security for data protection
- Generous free tier
- Great developer experience
- No backend code needed

**Packages:**
- `@supabase/supabase-js` - Main client library
- `@supabase/ssr` - Server-side rendering support

## Development Tools

### ESLint
- Code quality and consistency
- Catch common mistakes
- Enforce best practices

### TypeScript Compiler
- Type checking
- Compile-time error detection

## Deployment

### Vercel
**Why:**
- Built by Next.js creators
- Zero-config deployment
- Automatic HTTPS
- Edge network for fast global delivery
- Preview deployments for PRs
- Free tier perfect for demos
- Seamless git integration

## Key Dependencies

```json
{
  "next": "^14.2.33",
  "react": "^18.3.1",
  "react-dom": "^18.3.1",
  "typescript": "^5.9.3",
  "tailwindcss": "^4.1.17",
  "@supabase/supabase-js": "^2.84.0",
  "@supabase/ssr": "^0.7.0"
}
```

## Architecture Decisions

### Why No Express/Node Backend?
- Supabase handles all backend logic
- Next.js API routes for any custom logic
- Simpler deployment (one codebase)
- Lower maintenance burden
- Faster development

### Why Not Firebase?
- Supabase uses PostgreSQL (more powerful)
- Better real-time capabilities
- More control over database
- Better developer experience
- Open source

### Why Not MongoDB?
- PostgreSQL is more reliable
- Better for relational data (users, matches, messages)
- Built into Supabase
- Stronger consistency guarantees
- Better for this use case

### Why Next.js App Router vs Pages Router?
- Modern approach (future of Next.js)
- Better performance with Server Components
- Cleaner code organization
- Built-in loading/error states
- Better streaming support

## Development Workflow

1. **Local Development**
   ```bash
   npm run dev
   ```
   Runs on http://localhost:3000

2. **Build for Production**
   ```bash
   npm run build
   ```

3. **Deploy to Vercel**
   - Push to git
   - Vercel auto-deploys
   - Environment variables set in Vercel dashboard

## Environment Variables

Required for the app to function:

```env
NEXT_PUBLIC_SUPABASE_URL=your-project-url.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Browser Support

- Chrome/Edge (latest)
- Safari (latest)
- Firefox (latest)
- Mobile Safari (iOS 14+)
- Mobile Chrome (latest)

Focus on mobile-first since this is a mobile demo app.
