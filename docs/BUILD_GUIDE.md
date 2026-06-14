Haq — Hackathon Build Guide	Agentic & Autonomous Systems

**HAQ**

**Complete Hackathon Build Guide**

*Step-by-step implementation: environment, schemas, all five n8n workflows, code, prompts, demo script, and submission checklist*

Companion to the Haq Product Document • June 2026

# Table of Contents

# 1. V0 Scope — What You Are Building

One complete product loop, end to end. A user speaks to the bot in Hindi or English, sends one document photo, gets matched to real schemes, receives a filed (or perfectly prepared) application, and watches the agent track and fight for it.

## 1.1 In scope

- Telegram bot (no approval delay; swap to WhatsApp post-hackathon) with voice-in / voice-out.

- 15 real schemes of ONE state (pick your hackathon’s state — e.g., Rajasthan), onboarded as config files.

- Document-first profiling: ration card / Aadhaar photo → OCR → profile.

- Deterministic eligibility engine + payout ÷ effort ranking.

- Tier-3 execution for all 15 schemes: pre-filled PDF + voice walkthrough.

- Tier-2 execution for ONE flagship scheme: live Playwright automation with OTP pause.

- State machine + hourly Sentinel + grievance auto-draft + user-visible audit timeline.

- The 30-second live moment: add scheme #16 as config, agent handles it immediately.

## 1.2 Explicitly OUT of scope (do not get tempted)

- DigiLocker integration (mock it: a folder of sample documents).

- Real Aadhaar eKYC, real payment verification, multiple states, WhatsApp Business verification.

- Self-healing selectors (describe it; demo the human-review dashboard as a static screen if time permits).

## 1.3 Flagship scheme selection criteria

Your Tier-2 demo lives or dies on this choice. Pick a scheme that is:

- Fully online (no physical visit step), with a public portal that works reliably.

- Document-light: needs only the 1–2 documents your profiling already captures.

- High eligibility: most demo profiles qualify (e.g., a scholarship or pension with broad criteria).

- Fast acknowledgment: returns an application number immediately on submit.

# 2. Team Roles & Hour-by-Hour Timeline (36h plan)

## 2.1 Roles (4-person team)

| **Role** | **Owns** |
| --- | --- |
| Orchestrator (you) | n8n: all five workflows, Postgres, state machine, Sentinel |
| Builder A | Telegram bot, ASR/TTS, intent classifier, vernacular UX copy |
| Builder B | Scheme config pipeline, eligibility engine, PDF generator (Tier 3) |
| Builder C | Playwright worker (Tier 2), OTP flow, audit timeline, demo environment |

Adjust for smaller teams: with 2 people, merge A into Orchestrator and B into C; cut Tier-2 to a recorded backup video + one live attempt.

## 2.2 Timeline

| **Hours** | **Milestone** |
| --- | --- |
| 0–2 | Environment up: n8n + Postgres running, Telegram bot echoing messages, repo skeleton, API keys tested. |
| 2–6 | Database schema applied. Scheme config schema frozen. First 3 schemes hand-written as configs. Inbound workflow routing text correctly. |
| 6–12 | Profiler done: photo → OCR → profile rows. Matcher done: rules engine + ranking returning real matches. Voice in/out working. |
| 12–18 | Tier-3 PDF generator producing filled forms for 3 schemes. State machine transitions wired. LLM scheme-parser producing configs; scale to 15 schemes. |
| 18–26 | Tier-2 Playwright job for the flagship scheme, including OTP hibernation/resume. Sentinel cron + grievance draft. |
| 26–30 | Audit timeline view. End-to-end test with 3 personas. Fix everything that breaks. |
| 30–34 | Demo hardening: rehearse the full script 5×, record backup video of Tier-2, prepare the add-a-scheme-live config. |
| 34–36 | Slides (5 max), submission package, sleep if possible. |

**Golden rule: **the demo path is sacred. From hour 26, nobody touches code that the demo path executes, except to fix demo-path bugs.

# 3. Environment Setup (Hours 0–2)

## 3.1 Core services (Docker)

# docker-compose.yml — n8n + Postgres

version: '3.8'

services:

  postgres:

    image: postgres:16

    environment:

      POSTGRES_USER: haq

      POSTGRES_PASSWORD: haq_dev

      POSTGRES_DB: haq

    ports: ['5432:5432']

    volumes: ['pgdata:/var/lib/postgresql/data']

  n8n:

    image: n8nio/n8n:latest

    ports: ['5678:5678']

    environment:

      DB_TYPE: postgresdb

      DB_POSTGRESDB_HOST: postgres

      DB_POSTGRESDB_DATABASE: haq

      DB_POSTGRESDB_USER: haq

      DB_POSTGRESDB_PASSWORD: haq_dev

      N8N_ENCRYPTION_KEY: change_me

      GENERIC_TIMEZONE: Asia/Kolkata

    volumes: ['n8ndata:/home/node/.n8n']

volumes: { pgdata: {}, n8ndata: {} }

## 3.2 Accounts & keys checklist

- Telegram: create bot via @BotFather → save token. Enable webhook to your n8n URL (use ngrok or cloudflared for a public tunnel during the hackathon).

- LLM API key (Anthropic/OpenAI) — one key, set as n8n credential.

- ASR/TTS: Bhashini API registration (free, may take time — apply on Day 0) OR fallback: Google Speech-to-Text / Sarvam AI for Hindi. Have the fallback ready.

- OCR: cloud vision API key, OR install Tesseract locally with Hindi language pack as fallback.

- Playwright worker host: a small Node service alongside n8n (same machine is fine).

## 3.3 Project structure

haq/

  docker-compose.yml

  schemes/                # the scalability engine: one JSON per scheme

    rj_widow_pension.json

    rj_scholarship_obc.json

    ...

  worker/                 # Playwright execution service

    server.js             # HTTP API: POST /jobs, POST /jobs/:id/otp

    recipes/              # portal recipes (versioned JSON)

  pdf/                    # Tier-3 form templates + filler

    templates/

    fill.js

  sql/schema.sql

  prompts/                # all LLM prompts, version-controlled

  demo/                   # personas, sample documents, scheme16.json

# 4. Database Schema (Apply at Hour 2)

CREATE TABLE users (

  id            SERIAL PRIMARY KEY,

  tg_chat_id    TEXT UNIQUE NOT NULL,

  name          TEXT,

  language      TEXT DEFAULT 'hi',

  profile       JSONB DEFAULT '{}',   -- age, gender, income, category,

                                      -- district, marital_status, ...

  consent_log   JSONB DEFAULT '[]',

  created_at    TIMESTAMPTZ DEFAULT now()

);

 

CREATE TABLE documents (

  id            SERIAL PRIMARY KEY,

  user_id       INT REFERENCES users(id),

  doc_type      TEXT,                 -- ration_card, aadhaar_masked, income_cert

  fields        JSONB,                -- OCR-extracted fields

  quality_score REAL,

  file_ref      TEXT,

  created_at    TIMESTAMPTZ DEFAULT now()

);

 

CREATE TABLE schemes (

  id            TEXT PRIMARY KEY,     -- 'rj_widow_pension'

  version       INT NOT NULL,

  config        JSONB NOT NULL,       -- full scheme config (Section 5)

  active        BOOLEAN DEFAULT true

);

 

CREATE TABLE applications (

  id            SERIAL PRIMARY KEY,

  user_id       INT REFERENCES users(id),

  scheme_id     TEXT REFERENCES schemes(id),

  state         TEXT NOT NULL DEFAULT 'discovered',

  state_since   TIMESTAMPTZ DEFAULT now(),

  deadline_at   TIMESTAMPTZ,          -- when current state times out

  app_number    TEXT,

  tier          INT,                  -- 2 or 3

  meta          JSONB DEFAULT '{}'

);

 

CREATE TABLE events (

  id            BIGSERIAL PRIMARY KEY,

  application_id INT REFERENCES applications(id),

  user_id       INT,

  kind          TEXT,                 -- agent_action | user_msg | portal_resp | transition

  payload       JSONB,

  created_at    TIMESTAMPTZ DEFAULT now()

);

 

CREATE INDEX idx_apps_deadline ON applications(deadline_at)

  WHERE state NOT IN ('disbursed','closed');

**Rule: **never UPDATE an application without also INSERTing an event. Write a single Postgres function transition(app_id, new_state, payload) that does both atomically, and call only that from n8n.

CREATE OR REPLACE FUNCTION transition(p_app INT, p_state TEXT,

    p_deadline TIMESTAMPTZ, p_payload JSONB) RETURNS VOID AS $$

BEGIN

  UPDATE applications SET state = p_state, state_since = now(),

    deadline_at = p_deadline WHERE id = p_app;

  INSERT INTO events(application_id, kind, payload)

    VALUES (p_app, 'transition',

            jsonb_build_object('to', p_state) || coalesce(p_payload,'{}'));

END; $$ LANGUAGE plpgsql;

# 5. Scheme Config Schema — The Scalability Engine

One JSON file per scheme. Adding a scheme = adding a file. This is the artifact you add live on stage.

{

  "id": "rj_widow_pension",

  "version": 1,

  "name": { "en": "Widow Pension (Rajasthan)",

             "hi": "\u0935\u093f\u0927\u0935\u093e \u092a\u0947\u0902\u0936\u0928" },

  "benefit": { "type": "monthly_cash", "amount_inr": 1500 },

  "effort_score": 2,            // 1 (trivial) .. 5 (heavy)

  "eligibility": {              // JSON-logic style, evaluated by code

    "all": [

      { "field": "gender",         "op": "eq",  "value": "female" },

      { "field": "marital_status", "op": "eq",  "value": "widowed" },

      { "field": "age",            "op": "gte", "value": 18 },

      { "field": "annual_income",  "op": "lte", "value": 48000 },

      { "field": "state",          "op": "eq",  "value": "RJ" }

    ]

  },

  "required_docs": [

    { "type": "aadhaar_masked" },

    { "type": "death_certificate_spouse",

      "fallback": { "office": "Municipal office / Gram Panchayat",

                    "carry": ["aadhaar", "hospital record if any"] } },

    { "type": "income_certificate",

      "fallback": { "obtainable_via_scheme": "rj_income_certificate" } }

  ],

  "execution": {

    "tier2_recipe": "recipes/rj_sso_pension_v1.json",   // null if Tier-3 only

    "tier3_template": "templates/rj_widow_pension.pdf"

  },

  "slas": { "acknowledge_days": 7, "decision_days": 45 },

  "appeal": { "route": "cpgrams",

              "grievance_dept": "Social Justice & Empowerment, Rajasthan" }

}

## 5.1 The LLM config pipeline (Builder B, hours 12–18)

- Collect each scheme’s official PDF / portal page into a folder.

- Run the Scheme Parser prompt (Section 12) per document → draft config JSON.

- Human verification pass: open the draft next to the source, check every eligibility rule and document. Budget 5 minutes per scheme. NEVER skip this.

- Insert into Postgres: INSERT INTO schemes(id,version,config) VALUES ($1,$2,$3).

# 6. Workflow 1 — Inbound (Telegram Router)

| **Node** | **Configuration** |
| --- | --- |
| Webhook (Telegram) | Telegram Trigger node with bot token. Receives text, voice, and photo updates. |
| Switch: message type | voice → ASR branch; photo → hand off to Profiler (Execute Workflow node); text → continue. |
| ASR (HTTP Request) | POST audio to Bhashini/fallback ASR → transcript + detected language. Save language to users.language. |
| Upsert user | Postgres node: INSERT ... ON CONFLICT (tg_chat_id) DO UPDATE. |
| Intent classifier (LLM, cheap model) | Classify into: PROFILE_INFO │ STATUS_QUERY │ DOC_QUESTION │ CONSENT_YES │ SMALLTALK │ OTP_REPLY. Output strict JSON. |
| Switch: intent | PROFILE_INFO → extract fields, update profile, trigger Matcher. STATUS_QUERY → query applications + events, render timeline. CONSENT_YES → transition app to docs_pending/ready. OTP_REPLY → forward to worker (Section 9). SMALLTALK → short vernacular reply + gentle steer. |
| Reply (Telegram node) | Always text + TTS voice note in users.language. |

**Cost control: **the classifier uses the cheapest model with max_tokens ≤ 50. The expensive model is called only by Matcher explanations and the config pipeline.

## 6.1 Trust-first welcome message (copy this)

*“नमस्ते! मैं हक़ हूँ — आपका सरकारी योजना सहायक। मैं कभी पैसे या OTP नहीं माँगूँगा (OTP केवल तब, जब आप खुद आवेदन जमा करेंगे)। अपने राशन कार्ड की एक फ़ोटो भेजिए — मैं बताऊँगा कि आपको कौन-कौन सी योजनाओं का हक़ है।”*

# 7. Workflow 2 — Profiler (Document-First)

| **Node** | **Configuration** |
| --- | --- |
| Trigger | Execute-Workflow trigger (called by Inbound on photo). |
| Download photo | Telegram getFile → binary. |
| Quality gate (Code node) | Use sharp: reject if width < 800px or Laplacian variance (blur proxy) below threshold → instant vernacular re-prompt: “photo is blurry, please retake in daylight, hold steady.” |
| OCR + extraction (LLM vision or OCR+LLM) | Document Extractor prompt (Section 12) → strict JSON: doc_type, fields{name, age/dob, gender, address/district, category, income?}, confidence per field. |
| Mask & store | If Aadhaar detected: store ONLY last 4 digits. Insert documents row; merge high-confidence fields into users.profile. |
| Gap questions | Compare profile against the union of fields used by all active schemes’ eligibility rules. Ask AT MOST 2 targeted questions, one message each. |
| Trigger Matcher | Execute Workflow → Matcher with user_id. |

**Key trick: **derive the question list from the scheme configs themselves (SELECT DISTINCT field FROM eligibility rules) so adding scheme #16 automatically teaches the Profiler which new field to ask for. Config drives everything.

# 8. Workflow 3 — Matcher (Deterministic Engine)

## 8.1 Eligibility engine (n8n Code node — paste this)

// items[0].json = { profile: {...}, schemes: [{id, config}, ...] }

const ops = {

  eq:  (a,b) => a === b,

  neq: (a,b) => a !== b,

  gte: (a,b) => Number(a) >= Number(b),

  lte: (a,b) => Number(a) <= Number(b),

  in:  (a,b) => Array.isArray(b) && b.includes(a),

};

function evalRule(rule, profile) {

  if (rule.all) return rule.all.every(r => evalRule(r, profile));

  if (rule.any) return rule.any.some(r => evalRule(r, profile));

  const v = profile[rule.field];

  if (v === undefined || v === null)

    return { unknown: rule.field };          // missing data, not a 'no'

  return ops[rule.op](v, rule.value);

}

const { profile, schemes } = items[0].json;

const results = schemes.map(s => {

  let unknowns = [];

  const walk = (rule) => {

    const r = evalRule(rule, profile);

    if (typeof r === 'object' && r.unknown) { unknowns.push(r.unknown); return true; }

    return r;

  };

  const eligible = walk(s.config.eligibility);

  const score = s.config.benefit.amount_inr / s.config.effort_score;

  return { id: s.id, name: s.config.name, eligible,

           unknown_fields: [...new Set(unknowns)], score,

           benefit: s.config.benefit };

});

return [{ json: {

  matches: results.filter(r => r.eligible && !r.unknown_fields.length)

                  .sort((a,b) => b.score - a.score).slice(0, 3),

  need_info: results.filter(r => r.eligible && r.unknown_fields.length),

}}];

## 8.2 Presentation & consent

- LLM Vernacular Explainer prompt (Section 12) renders the top 3 matches as short, warm Hindi messages with concrete amounts: “You are owed ₹1,500/month widow pension. Shall I apply for you? Reply HAAN.”

- If need_info is non-empty, ask the single highest-impact unknown field (the one unblocking the highest-score scheme) — never an interrogation.

- On consent: log to consent_log, create the application row, transition to docs_pending or ready depending on the required-docs check.

# 9. Workflow 4 — Executor (Tier 3 + Tier 2)

## 9.1 Tier 3 — pre-filled PDF for all 15 schemes (build FIRST)

- Get each scheme’s official application form PDF. Map its fields once using pdf-lib (if it is an AcroForm) or by overlaying text at fixed coordinates (if flat).

- Filler service pdf/fill.js: input {scheme_id, profile, documents} → output filled PDF.

- Send via Telegram with a TTS voice walkthrough: “Print this, sign at the bottom, take it to [office] with [documents]. I will remind you and track it.”

- Transition: ready → submitted (tier=3) once the user confirms they handed it in (one-tap button).

**Why Tier 3 first: **it guarantees a complete loop for all 15 schemes even if Tier 2 explodes at 3 a.m.

## 9.2 Tier 2 — Playwright worker (flagship scheme only)

// worker/server.js (Express, runs beside n8n)

// POST /jobs        { app_id, recipe, profile, docs, callback_url }

// POST /jobs/:id/otp { otp }

const jobs = new Map();   // app_id -> { page, resume }

 

app.post('/jobs', async (req, res) => {

  const { app_id, recipe, profile, callback_url } = req.body;

  res.json({ accepted: true });

  const browser = await chromium.launch();

  const page = await browser.newPage();

  try {

    for (const step of recipe.steps) {

      await page.screenshot({ path: shot(app_id, step.id, 'before') });

      if (step.action === 'goto')  await page.goto(step.url);

      if (step.action === 'fill')  await page.fill(step.selector,

                                     resolve(step.value, profile));

      if (step.action === 'click') await page.click(step.selector);

      if (step.action === 'await_otp') {

        await notify(callback_url, { app_id, status: 'awaiting_otp' });

        const otp = await waitForOtp(app_id, 10 * 60 * 1000); // hibernate

        await page.fill(step.selector, otp);

      }

      await page.screenshot({ path: shot(app_id, step.id, 'after') });

    }

    const appNo = await page.textContent(recipe.success_selector);

    await notify(callback_url, { app_id, status: 'submitted', appNo });

  } catch (e) {

    await notify(callback_url, { app_id, status: 'tier2_failed',

                                 error: e.message });   // n8n downgrades to Tier 3

  } finally { await browser.close(); }

});

## 9.3 Portal recipe format

{ "id": "rj_sso_pension_v1",

  "steps": [

    { "id": "s1", "action": "goto",  "url": "https://..." },

    { "id": "s2", "action": "fill",  "selector": "#applicantName",

      "value": "{profile.name}" },

    { "id": "s3", "action": "await_otp", "selector": "#otpInput" },

    { "id": "s4", "action": "click", "selector": "#submitBtn" }

  ],

  "success_selector": ".application-number" }

## 9.4 The OTP round-trip

- Worker hits n8n callback awaiting_otp → n8n transitions state, messages user: “Enter the code you just received by SMS — I am submitting your application right now.”

- User replies with digits → Inbound classifies OTP_REPLY → n8n POSTs /jobs/:id/otp → worker resumes.

- TTL expiry → worker fails gracefully → n8n asks the user for a preferred time and re-queues.

**Hackathon honesty: **if the real portal is flaky, build a realistic mock portal (a simple HTML form with OTP step) and demo against it, clearly labelled “staging replica of [portal]”. Judges respect a controlled demo over a crashed live one — and you show one real-portal screenshot/recording as proof it works there too.

# 10. Workflow 5 — Sentinel (The Agent’s Heartbeat)

| **Node** | **Configuration** |
| --- | --- |
| Cron | Every hour. |
| Query breaches | SELECT * FROM applications WHERE deadline_at < now() AND state NOT IN ('disbursed','closed') |
| Switch on state | docs_pending → voice reminder + fallback-graph message. submitted → status check (portal scrape if recipe exists; else ask user to forward any SMS). under_review past SLA → grievance branch. approved → “did the money arrive?” verification. |
| Grievance branch | LLM drafts CPGRAMS grievance from the event log (facts only: dates, application number, statutory window). Send to user with one-tap APPROVE → file (V0: generate the filled grievance text + deep link; live filing is V1). Transition → grievance_filed. |
| Set next deadline | Every branch ends by calling transition() with the next deadline_at from the scheme’s SLAs. |

**Demo gold: **seed one application with deadline_at in the past before the demo. Trigger the Sentinel manually on stage and show the grievance appearing in the chat: “while we slept, the agent fought.”

## 10.1 Audit timeline (trust view)

SELECT created_at, kind, payload FROM events

 WHERE application_id = $1 ORDER BY created_at;

Render as a numbered vernacular timeline in chat: “1. Applied on 3 June. 2. Department acknowledged on 7 June. 3. Reminder sent 21 June…” Every demo persona should have a rich timeline ready.

# 11. State Machine Wiring Reference

| **From state** | **Event** | **To state** | **deadline_at** |
| --- | --- | --- | --- |
| discovered | user consent | docs_pending / ready | +7 days / now |
| docs_pending | all docs present | ready | now |
| ready | executor dispatch | submitting | +1 hour |
| submitting | worker: awaiting_otp | awaiting_otp | +10 min |
| awaiting_otp | OTP received | submitting | +1 hour |
| submitting | worker: submitted | submitted | +SLA acknowledge_days |
| submitting | worker: tier2_failed ×2 | ready (tier=3 path) | now |
| submitted | ack detected | under_review | +SLA decision_days |
| under_review | SLA breach | grievance_filed | +15 days |
| under_review | approved | approved | +disbursal SLA |
| under_review | rejected | remediation | +48 hours |
| approved | user confirms money | disbursed | — |

# 12. LLM Prompt Library (version-control these)

## 12.1 Intent classifier (cheap model)

Classify the user message into exactly one intent.

Intents: PROFILE_INFO, STATUS_QUERY, DOC_QUESTION, CONSENT_YES,

         OTP_REPLY, SMALLTALK.

Rules: 4-8 digit number alone => OTP_REPLY. 'haan/yes/ok' after an

application offer => CONSENT_YES. Mentions of self/family/income/

age/job => PROFILE_INFO.

Reply with JSON only: {"intent": "..."}

Message: {{message}}

## 12.2 Scheme parser (offline config pipeline)

You convert an Indian government scheme document into a strict JSON

config. Output ONLY JSON matching this schema: <paste Section 5 schema>.

Rules:

- eligibility: only rules EXPLICITLY stated in the document. If a

  criterion is ambiguous, add it to "_flags" for human review instead

  of guessing.

- amounts in INR integers; effort_score: 1 if fully online & <=2 docs,

  3 if 3-4 docs, 5 if physical visit required.

- required_docs: official names; add fallback office guidance only if

  stated in the document.

Document text: {{doc_text}}

## 12.3 Document extractor (vision)

Extract fields from this Indian identity/welfare document image.

Output ONLY JSON: { "doc_type": ration_card|aadhaar|income_cert|other,

  "fields": { name, dob_or_age, gender, district, state, category,

               annual_income }, "confidence": {field: 0..1} }

If Aadhaar number visible: return only last 4 digits as aadhaar_last4.

Use null for absent fields. Never guess income.

## 12.4 Vernacular explainer

You are Haq, a warm, plain-spoken assistant. Language: {{language}}.

Explain these scheme matches to a user who may not read well.

Rules: short sentences. Concrete amounts first. No jargon. One

question max at the end (consent to apply for the top scheme).

Never promise approval; say "you appear eligible". Matches: {{json}}

## 12.5 Grievance drafter

Draft a formal CPGRAMS grievance in English from these facts only:

{{event_log_json}}. Structure: applicant details, scheme name,

application number, date filed, statutory service window, days

elapsed, request for status and time-bound action. Polite, factual,

no accusations. 150 words max.

# 13. Demo Script (Rehearse 5×)

- **0:00 Hook: **“Rich people have CAs and lawyers for bureaucracy. 800 million Indians have nobody.”

- **0:20 Live — onboarding: **send a Hindi voice note as “Meena”. Show voice reply. Send the ration-card photo → profile appears.

- **1:00 Live — matching: **top 3 schemes in Hindi with amounts. Tap HAAN.

- **1:20 Live — execution: **Tier-2 automation runs on screen → OTP ping → enter OTP → application number lands in chat with timeline.

- **2:10 Live — the agent fights: **switch to the seeded stalled application; trigger Sentinel; the auto-drafted grievance appears. “It doesn’t just file. It fights.”

- **2:30 Live — the scale moment: **open scheme16.json, insert it, send one message as a matching persona → instantly matched. “Scheme #16 took 30 seconds. That’s how 13,000 schemes become reachable.”

- **2:50 Close: **“Under ₹10 per application versus hundreds for human mediation. Built on n8n, WhatsApp rails, and existing portals. Rupees disbursed is our only metric that matters.”

## 13.1 Demo insurance

- Record a clean screen capture of the full Tier-2 run as backup; play it if the live portal/tunnel misbehaves.

- Pre-seed 3 personas with documents in /demo; know which persona matches scheme16.json.

- Run everything on a local tunnel you tested from the venue Wi-Fi; carry a phone hotspot.

# 14. Testing & Submission Checklist

## 14.1 End-to-end tests (hour 26–30)

- Persona A (widow, eligible for flagship): voice onboarding → photo → match → Tier-2 submit → timeline.

- Persona B (student): match → Tier-3 PDF → confirm handed in → state advances.

- Persona C (missing income field): need_info path asks exactly one question, then matches.

- OTP timeout path: let TTL expire → reschedule message arrives.

- Tier-2 double failure → automatic Tier-3 PDF arrives.

- Sentinel breach → grievance draft → APPROVE → state = grievance_filed.

- Blurry photo → instant re-prompt.

- Add scheme16.json → Profiler asks its new field → match works (the live moment, tested cold).

## 14.2 Submission package

- Repo with README: architecture diagram, this guide’s structure, run instructions.

- The Product Document (problem → architecture → roadmap) as the written submission.

- 2–3 min demo video (your backup recording, edited).

- 5 slides max: problem stat → Delhi-study proof → architecture → unit economics → roadmap.

- Metrics slide pre-filled with V0 numbers: schemes onboarded, seconds to add a scheme, cost per application.

## 14.3 Common pitfalls (learned the hard way)

- Telegram webhooks silently fail behind changing ngrok URLs — pin the tunnel early, or use cloudflared with a stable hostname.

- LLM JSON output drift — always wrap parsing in try/catch with one retry that says “output valid JSON only”.

- Postgres connections exhausted by parallel n8n executions — set a pool limit; keep Code nodes free of direct DB calls (use Postgres nodes).

- Hindi TTS latency — generate voice asynchronously; send text immediately, voice note follows.

- Time sinks to refuse: beautiful dashboards, auth systems, more than one Tier-2 recipe, real DigiLocker.

**Build order recap: Tier 3 before Tier 2. Config pipeline before more schemes. Demo path sacred after hour 26. Ship the loop, not the features.**

Page