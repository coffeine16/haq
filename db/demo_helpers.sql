-- ============================================================
-- Haq — Demo helper snippets
-- Replace 1280704497 with your own Telegram chat_id everywhere below.
-- ============================================================


-- ---------- 1. Reset a persona between demo runs ----------
-- Clears applications/events/documents for one user and zeros the profile.
DELETE FROM events
  WHERE application_id IN (
    SELECT id FROM applications
    WHERE user_id IN (SELECT id FROM users WHERE tg_chat_id = '1280704497')
  );

DELETE FROM applications
  WHERE user_id IN (SELECT id FROM users WHERE tg_chat_id = '1280704497');

DELETE FROM documents
  WHERE user_id IN (SELECT id FROM users WHERE tg_chat_id = '1280704497');

UPDATE users SET profile = '{}' WHERE tg_chat_id = '1280704497';


-- ---------- 2. Seed a stalled application (for the Sentinel demo) ----------
-- Creates a widow-pension application that's 50 days old and 5 days past its
-- statutory decision deadline. Sentinel will pick it up on next run.
INSERT INTO applications (user_id, scheme_id, state, state_since, deadline_at, app_number, tier, meta)
VALUES (
  (SELECT id FROM users WHERE tg_chat_id = '1280704497'),
  'rj_widow_pension',
  'under_review',
  now() - interval '50 days',
  now() - interval '5 days',
  'RJ-WP-2026-001234',
  3,
  '{"submitted_on":"2026-04-24","portal":"sso.rajasthan.gov.in"}'::jsonb
)
RETURNING id;


-- ---------- 3. "Add a scheme in 30 seconds" demo ----------
-- New scheme: free bicycle for class 9 girls in Rajasthan (real scheme: Mukhyamantri
-- Balika Cycle Yojana). After running this INSERT, send a fresh profile for a
-- 14-year-old girl from RJ and watch the agent match it.
INSERT INTO schemes (id, version, config, active) VALUES (
  'rj_cycle_yojana',
  1,
  '{
    "id":"rj_cycle_yojana","version":1,
    "name":{"en":"CM Cycle Yojana (Class 9 Girls)","hi":"मुख्यमंत्री बालिका साइकिल योजना"},
    "benefit":{"type":"one_time","amount_inr":3000},
    "effort_score":1,
    "eligibility":{"all":[
      {"field":"gender","op":"eq","value":"female"},
      {"field":"age","op":"gte","value":13},
      {"field":"age","op":"lte","value":16},
      {"field":"state","op":"eq","value":"RJ"}
    ]},
    "required_docs":[{"type":"aadhaar_masked"},{"type":"school_id"}],
    "execution":{"tier2_recipe":null,"tier3_template":"templates/rj_cycle.pdf"},
    "slas":{"acknowledge_days":7,"decision_days":30},
    "appeal":{"route":"cpgrams","grievance_dept":"Education Department, Rajasthan"}
  }'::jsonb,
  true
)
ON CONFLICT (id) DO UPDATE SET config = EXCLUDED.config, version = EXCLUDED.version;
