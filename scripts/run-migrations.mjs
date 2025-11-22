#!/usr/bin/env node

/**
 * Mixle Database Migration Script
 * Automatically runs all SQL migrations in Supabase
 */

import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import dotenv from 'dotenv'
import { createClient } from '@supabase/supabase-js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const rootDir = join(__dirname, '..')

// Load environment variables
dotenv.config({ path: join(rootDir, '.env.local') })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Error: Missing Supabase credentials')
  console.error('Make sure .env.local has:')
  console.error('  - NEXT_PUBLIC_SUPABASE_URL')
  console.error('  - SUPABASE_SERVICE_ROLE_KEY')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
})

const migrations = [
  {
    name: 'Schema Initialization',
    file: '20251122_init_schema.sql',
    description: 'Creating tables, indexes, functions, and triggers',
  },
  {
    name: 'Row Level Security',
    file: '20251122_rls_policies.sql',
    description: 'Setting up security policies',
  },
  {
    name: 'Seed Data',
    file: '20251122_seed_data.sql',
    description: 'Loading event code and bot accounts',
  },
]

async function executeSqlViaApi(sql) {
  // Extract project ref from URL
  const projectRef = supabaseUrl.match(/https:\/\/([^.]+)/)?.[1]

  if (!projectRef) {
    throw new Error('Could not extract project ref from Supabase URL')
  }

  // Use Supabase Management API to execute SQL
  const response = await fetch(`${supabaseUrl}/rest/v1/rpc/exec`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'apikey': supabaseServiceKey,
      'Authorization': `Bearer ${supabaseServiceKey}`,
    },
    body: JSON.stringify({ query: sql }),
  })

  if (!response.ok) {
    const text = await response.text()
    throw new Error(`SQL execution failed: ${text}`)
  }

  return response
}

async function runMigration(migration) {
  console.log(`\n📦 ${migration.name}`)
  console.log(`   ${migration.description}`)

  try {
    const sqlPath = join(rootDir, 'supabase', 'migrations', migration.file)
    const sql = readFileSync(sqlPath, 'utf-8')

    // For Supabase, we need to execute the SQL directly
    // The easiest way is to use fetch to POST to the SQL endpoint
    const projectRef = supabaseUrl.match(/https:\/\/([^.]+)/)?.[1]

    const response = await fetch(`https://api.supabase.com/v1/projects/${projectRef}/database/query`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${supabaseServiceKey}`,
      },
      body: JSON.stringify({ query: sql }),
    }).catch(() => null)

    // If the management API doesn't work, print instructions
    if (!response || !response.ok) {
      console.log(`   ⚠️  Automatic execution not available`)
      console.log(`   📋 Please run this SQL manually in Supabase SQL Editor:\n`)
      console.log(`   File: supabase/migrations/${migration.file}\n`)
      return 'manual'
    }

    console.log(`   ✅ Completed successfully`)
    return true
  } catch (error) {
    console.error(`   ❌ Error:`, error.message)
    console.log(`   📋 Please run manually: supabase/migrations/${migration.file}`)
    return 'manual'
  }
}

async function verifySetup() {
  console.log('\n🔍 Verifying database setup...\n')

  try {
    // Check tables exist
    console.log('📋 Checking tables...')
    const tables = ['users', 'event_codes', 'user_sessions', 'intents', 'matches', 'messages', 'declines']

    for (const table of tables) {
      const { count, error } = await supabase.from(table).select('*', { count: 'exact', head: true })
      if (error) {
        console.log(`   ❌ Table '${table}' - Not found`)
      } else {
        console.log(`   ✅ Table '${table}' exists`)
      }
    }

    // Check event code
    console.log('\n🎫 Checking event code...')
    const { data: eventCode, error: eventError } = await supabase
      .from('event_codes')
      .select('*')
      .eq('code', 'AFROTECH2026')
      .maybeSingle()

    if (eventError || !eventCode) {
      console.log(`   ⚠️  Event code 'AFROTECH2026' not found yet`)
    } else {
      console.log(`   ✅ Event code: ${eventCode.code} - ${eventCode.name}`)
    }

    // Check bots
    console.log('\n🤖 Checking bot accounts...')
    const { data: bots, error: botsError } = await supabase
      .from('users')
      .select('name, role, company')
      .eq('is_bot', true)
      .order('name')

    if (botsError || !bots || bots.length === 0) {
      console.log(`   ⚠️  No bot accounts found yet`)
    } else {
      console.log(`   ✅ Found ${bots.length} bot accounts:`)
      bots.forEach((bot, i) => {
        console.log(`      ${i + 1}. ${bot.name} - ${bot.role} @ ${bot.company}`)
      })
    }

    return true
  } catch (error) {
    console.log(`   ⚠️  Could not verify - tables may not exist yet`)
    return false
  }
}

async function printManualInstructions() {
  console.log('\n' + '='.repeat(70))
  console.log('📝 MANUAL MIGRATION INSTRUCTIONS')
  console.log('='.repeat(70))
  console.log('\n1. Go to your Supabase project: ' + supabaseUrl)
  console.log('2. Click on "SQL Editor" in the left sidebar')
  console.log('3. Click "New Query"')
  console.log('4. Run these files IN ORDER:\n')

  migrations.forEach((m, i) => {
    console.log(`   ${i + 1}. supabase/migrations/${m.file}`)
    console.log(`      (${m.description})`)
  })

  console.log('\n5. Copy and paste each file\'s contents into the SQL editor')
  console.log('6. Click "Run" for each migration')
  console.log('\n' + '='.repeat(70) + '\n')
}

async function main() {
  console.log('🚀 Mixle Database Migration\n')
  console.log(`📍 Supabase URL: ${supabaseUrl}`)
  console.log(`🔑 Service key: ${supabaseServiceKey.substring(0, 20)}...`)

  // Try to run migrations automatically
  let needsManual = false

  for (const migration of migrations) {
    const result = await runMigration(migration)
    if (result === 'manual') {
      needsManual = true
    }
  }

  // Verify setup
  console.log('\n' + '─'.repeat(70))
  const verified = await verifySetup()

  if (needsManual || !verified) {
    await printManualInstructions()
  } else {
    console.log('\n✅ All migrations completed successfully!')
    console.log('🎉 Your database is ready to use!')
  }
}

main().catch((error) => {
  console.error('\n❌ Fatal error:', error)
  process.exit(1)
})
