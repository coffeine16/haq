-- ============================================================
-- Haq database schema
-- Apply once to a fresh Supabase Postgres project.
-- ============================================================

CREATE TABLE users (
  id           SERIAL PRIMARY KEY,
  tg_chat_id   TEXT UNIQUE NOT NULL,
  name         TEXT,
  language     TEXT DEFAULT 'hi',
  profile      JSONB DEFAULT '{}',
  consent_log  JSONB DEFAULT '[]',
  created_at   TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE documents (
  id            SERIAL PRIMARY KEY,
  user_id       INT REFERENCES users(id),
  doc_type      TEXT,
  fields        JSONB,
  quality_score REAL,
  file_ref      TEXT,
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE schemes (
  id       TEXT PRIMARY KEY,
  version  INT NOT NULL,
  config   JSONB NOT NULL,
  active   BOOLEAN DEFAULT true
);

CREATE TABLE applications (
  id          SERIAL PRIMARY KEY,
  user_id     INT REFERENCES users(id),
  scheme_id   TEXT REFERENCES schemes(id),
  state       TEXT NOT NULL DEFAULT 'discovered',
  state_since TIMESTAMPTZ DEFAULT now(),
  deadline_at TIMESTAMPTZ,
  app_number  TEXT,
  tier        INT,
  meta        JSONB DEFAULT '{}'
);

CREATE TABLE events (
  id             BIGSERIAL PRIMARY KEY,
  application_id INT REFERENCES applications(id),
  user_id        INT,
  kind           TEXT,
  payload        JSONB,
  created_at     TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_apps_deadline ON applications(deadline_at)
  WHERE state NOT IN ('disbursed', 'closed');

-- Atomic state-transition function: always logs an event with the transition.
-- Call this from n8n instead of bare UPDATEs to applications.
CREATE OR REPLACE FUNCTION transition(
  p_app      INT,
  p_state    TEXT,
  p_deadline TIMESTAMPTZ,
  p_payload  JSONB
) RETURNS VOID AS $$
BEGIN
  UPDATE applications
    SET state       = p_state,
        state_since = now(),
        deadline_at = p_deadline
  WHERE id = p_app;
  INSERT INTO events(application_id, kind, payload)
    VALUES (
      p_app,
      'transition',
      jsonb_build_object('to', p_state) || coalesce(p_payload, '{}')
    );
END;
$$ LANGUAGE plpgsql;
