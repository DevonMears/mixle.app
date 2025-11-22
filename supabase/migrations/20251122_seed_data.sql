-- Mixle Seed Data
-- Phase 2: Initial data for demo

-- ============================================================================
-- EVENT CODE
-- ============================================================================

INSERT INTO event_codes (code, name, is_active) VALUES
('AFROTECH2026', 'AfroTech 2026', true);

-- ============================================================================
-- BOT ACCOUNTS (10 bots with diverse profiles)
-- ============================================================================

-- Bot 1: Maya Chen - Founder
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Maya Chen',
  'maya.bot@mixle.app',
  'Building the future of fintech in Africa. Ex-Google PM, now founding a payments startup in Lagos. Always down to talk product, funding, or finding great coffee.',
  'Founder & CEO',
  'PayFlow Africa',
  true,
  '👩🏻‍💼'
);

-- Bot 2: James Wilson - Software Engineer
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'James Wilson',
  'james.bot@mixle.app',
  'Full-stack engineer passionate about AI/ML. Working on developer tools at a Series B startup. Love meeting other builders and exploring new cities.',
  'Senior Software Engineer',
  'DevTools Inc',
  true,
  '👨🏾‍💻'
);

-- Bot 3: Aisha Okonkwo - Product Designer
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Aisha Okonkwo',
  'aisha.bot@mixle.app',
  'Product designer obsessed with creating delightful user experiences. Previously at Figma. Currently designing for healthcare tech. Always looking for design inspiration!',
  'Lead Product Designer',
  'HealthTech Solutions',
  true,
  '👩🏿‍🎨'
);

-- Bot 4: Carlos Rodriguez - Investor
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Carlos Rodriguez',
  'carlos.bot@mixle.app',
  'Venture capitalist focused on early-stage African tech startups. Former founder (acquired by Stripe). Happy to chat about fundraising, market trends, or grab lunch.',
  'Partner',
  'AfriTech Ventures',
  true,
  '👨🏽‍💼'
);

-- Bot 5: Zuri Mwangi - Data Scientist
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Zuri Mwangi',
  'zuri.bot@mixle.app',
  'Data scientist working on recommendation systems. PhD dropout, no regrets. Love talking ML, ethics in AI, and finding the best food spots at conferences.',
  'Staff Data Scientist',
  'Spotify',
  true,
  '👩🏾‍🔬'
);

-- Bot 6: David Kim - Marketing Lead
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'David Kim',
  'david.bot@mixle.app',
  'Growth marketer helping startups scale. Ex-Airbnb, now at a B2B SaaS company. Always interested in growth strategies, content marketing, and good coffee.',
  'Head of Growth',
  'CloudScale',
  true,
  '👨🏻‍💼'
);

-- Bot 7: Fatima Hassan - Mobile Developer
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Fatima Hassan',
  'fatima.bot@mixle.app',
  'iOS developer building mobile experiences people love. Passionate about accessibility and performance. First-time conference attendee - excited to meet everyone!',
  'iOS Engineer',
  'Twitter',
  true,
  '👩🏽‍💻'
);

-- Bot 8: Marcus Thompson - Sales Director
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Marcus Thompson',
  'marcus.bot@mixle.app',
  'Enterprise sales leader with 10+ years experience. Helping companies scale their sales teams. Love networking, deal strategy talks, and discovering local restaurants.',
  'VP of Sales',
  'Salesforce',
  true,
  '👨🏿‍💼'
);

-- Bot 9: Priya Patel - UX Researcher
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Priya Patel',
  'priya.bot@mixle.app',
  'UX researcher focused on emerging markets. Anthropologist turned tech researcher. Currently studying mobile-first behaviors in Sub-Saharan Africa.',
  'Senior UX Researcher',
  'Meta',
  true,
  '👩🏾‍🔬'
);

-- Bot 10: Alex Turner - DevOps Engineer
INSERT INTO users (name, email, bio, role, company, is_bot, photo_url) VALUES
(
  'Alex Turner',
  'alex.bot@mixle.app',
  'DevOps engineer obsessed with infrastructure and automation. Building cloud platforms at scale. Always happy to talk Kubernetes, AWS, or grab a quick lunch between sessions.',
  'Principal DevOps Engineer',
  'Amazon Web Services',
  true,
  '👨🏼‍💻'
);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify event code was created
DO $$
DECLARE
  event_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO event_count FROM event_codes WHERE code = 'AFROTECH2026';
  IF event_count = 0 THEN
    RAISE EXCEPTION 'Event code AFROTECH2026 was not created';
  END IF;
  RAISE NOTICE 'Event code AFROTECH2026 created successfully';
END $$;

-- Verify all 10 bots were created
DO $$
DECLARE
  bot_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO bot_count FROM users WHERE is_bot = true;
  IF bot_count != 10 THEN
    RAISE EXCEPTION 'Expected 10 bots but got %', bot_count;
  END IF;
  RAISE NOTICE '10 bot accounts created successfully';
END $$;
