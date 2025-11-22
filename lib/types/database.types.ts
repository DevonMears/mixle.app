// Mixle Database Types
// Auto-generated from Supabase schema

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string | null
          name: string
          bio: string | null
          photo_url: string | null
          role: string | null
          company: string | null
          is_bot: boolean
          created_at: string
        }
        Insert: {
          id?: string
          email?: string | null
          name: string
          bio?: string | null
          photo_url?: string | null
          role?: string | null
          company?: string | null
          is_bot?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          email?: string | null
          name?: string
          bio?: string | null
          photo_url?: string | null
          role?: string | null
          company?: string | null
          is_bot?: boolean
          created_at?: string
        }
      }
      event_codes: {
        Row: {
          id: string
          code: string
          name: string
          is_active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          code: string
          name: string
          is_active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          code?: string
          name?: string
          is_active?: boolean
          created_at?: string
        }
      }
      user_sessions: {
        Row: {
          id: string
          user_id: string
          event_code_id: string
          last_active: string
        }
        Insert: {
          id?: string
          user_id: string
          event_code_id: string
          last_active?: string
        }
        Update: {
          id?: string
          user_id?: string
          event_code_id?: string
          last_active?: string
        }
      }
      intents: {
        Row: {
          id: string
          user_id: string
          event_code_id: string
          intent_type: string
          custom_intent_text: string | null
          is_active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          event_code_id: string
          intent_type: string
          custom_intent_text?: string | null
          is_active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          event_code_id?: string
          intent_type?: string
          custom_intent_text?: string | null
          is_active?: boolean
          created_at?: string
        }
      }
      matches: {
        Row: {
          id: string
          user1_id: string
          user2_id: string
          event_code_id: string
          intent_type: string
          status: 'active' | 'completed' | 'cancelled'
          created_at: string
        }
        Insert: {
          id?: string
          user1_id: string
          user2_id: string
          event_code_id: string
          intent_type: string
          status?: 'active' | 'completed' | 'cancelled'
          created_at?: string
        }
        Update: {
          id?: string
          user1_id?: string
          user2_id?: string
          event_code_id?: string
          intent_type?: string
          status?: 'active' | 'completed' | 'cancelled'
          created_at?: string
        }
      }
      messages: {
        Row: {
          id: string
          match_id: string
          sender_id: string
          content: string
          is_read: boolean
          created_at: string
        }
        Insert: {
          id?: string
          match_id: string
          sender_id: string
          content: string
          is_read?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          match_id?: string
          sender_id?: string
          content?: string
          is_read?: boolean
          created_at?: string
        }
      }
      declines: {
        Row: {
          id: string
          user_id: string
          declined_user_id: string
          event_code_id: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          declined_user_id: string
          event_code_id: string
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          declined_user_id?: string
          event_code_id?: string
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      cleanup_event_data: {
        Args: {
          event_code_param: string
        }
        Returns: void
      }
    }
    Enums: {
      [_ in never]: never
    }
  }
}

// Helper types for easier usage
export type User = Database['public']['Tables']['users']['Row']
export type EventCode = Database['public']['Tables']['event_codes']['Row']
export type UserSession = Database['public']['Tables']['user_sessions']['Row']
export type Intent = Database['public']['Tables']['intents']['Row']
export type Match = Database['public']['Tables']['matches']['Row']
export type Message = Database['public']['Tables']['messages']['Row']
export type Decline = Database['public']['Tables']['declines']['Row']

// Insert types
export type UserInsert = Database['public']['Tables']['users']['Insert']
export type EventCodeInsert = Database['public']['Tables']['event_codes']['Insert']
export type UserSessionInsert = Database['public']['Tables']['user_sessions']['Insert']
export type IntentInsert = Database['public']['Tables']['intents']['Insert']
export type MatchInsert = Database['public']['Tables']['matches']['Insert']
export type MessageInsert = Database['public']['Tables']['messages']['Insert']
export type DeclineInsert = Database['public']['Tables']['declines']['Insert']

// Update types
export type UserUpdate = Database['public']['Tables']['users']['Update']
export type EventCodeUpdate = Database['public']['Tables']['event_codes']['Update']
export type UserSessionUpdate = Database['public']['Tables']['user_sessions']['Update']
export type IntentUpdate = Database['public']['Tables']['intents']['Update']
export type MatchUpdate = Database['public']['Tables']['matches']['Update']
export type MessageUpdate = Database['public']['Tables']['messages']['Update']
export type DeclineUpdate = Database['public']['Tables']['declines']['Update']

// Intent types enum
export const INTENT_TYPES = {
  LUNCH: 'lunch',
  COFFEE: 'coffee',
  NETWORKING: 'networking',
  WALK: 'walk',
  DRINKS: 'drinks',
  WORKSHOP: 'workshop',
  CUSTOM: 'custom',
} as const

export type IntentType = typeof INTENT_TYPES[keyof typeof INTENT_TYPES]
