Haq — Personal Institutional Agent	Agentic & Autonomous Systems

**HAQ**

*The AI Agent That Claims, Tracks, and Fights for What Is Rightfully Yours*

Theme: Agentic & Autonomous Systems

Complete Product & Build Document — Problem, Solution, Architecture, Workflows, Roadmap, Economics, and Pitch

June 2026

# Table of Contents

# 1. Executive Summary

Wealthy people have always had representatives who navigate institutions for them: chartered accountants for the tax department, lawyers for the courts, brokers for insurance. Over 800 million Indians have nobody. Haq is a Personal Institutional Agent — an autonomous AI that represents ordinary citizens in their interactions with government and institutions: discovering every welfare scheme they are eligible for, gathering documents, filing applications, tracking them for weeks, following up with departments, and fighting back when claims are wrongly rejected.

The opportunity is enormous and verified. India allocates roughly US $210 billion annually across 13,000+ central, state, and local welfare schemes, with 800+ million eligible citizens — yet take-up is chronically low. Field research in Delhi found only one-third of eligible widows were enrolled in a pension scheme they were entitled to, and that providing information alone helped only literate women; what actually worked was hands-on mediation. Today that mediation is done by expensive human agents. Haq delivers AI mediation at the cost of a WhatsApp message.

**One-liner: **“800 million Indians are owed $210B in benefits. Haq is the AI agent that claims, tracks, and fights for what is theirs — for the price of a WhatsApp message.”

**Why it wins on the judging criteria: **

- **Impact: **directly moves money into the hands of the people least served by technology; the north-star metric is rupees disbursed into users’ bank accounts.

- **Scalability: **schemes are onboarded as configuration, not code. Adding scheme #500 or state #15 means adding a config file, not engineering. The same engine extends to insurance claims, MSME licensing, and other countries.

- **Efficiency: **human mediators cost hundreds of rupees per application; Haq’s marginal cost is under ₹10 of compute, built by orchestrating rails that already exist (WhatsApp, DigiLocker, government portals) rather than inventing new infrastructure.

# 2. The Problem

## 2.1 The scale

- **800+ million Indians **are eligible for some form of welfare — social security, direct cash benefits, subsidies, scholarships, pensions, documentation services (World Bank).

- **US $210 billion **is budgeted annually by Indian governments for these programs.

- **13,000+ schemes **exist across national, state, and local governments — with no single place to discover eligibility or complete applications end-to-end.

- **Large amounts of allocated money go unspent **every year because eligible citizens never successfully apply.

- **₹78,000+ crore **additionally sits unclaimed across insurance policies, provident funds, and dormant bank deposits — money that already belongs to specific people.

## 2.2 Why benefits go unclaimed

- **Awareness gap: **citizens do not know which of 13,000 schemes they qualify for. Eligibility rules are scattered across PDFs, portals, and circulars in bureaucratic language.

- **Application friction: **forms demand documents from multiple offices, in-person visits, and repeated follow-ups. Each step is a drop-off point.

- **Literacy and language barriers: **forms are in English or formal Hindi; many beneficiaries are more comfortable speaking their dialect than typing anything.

- **No follow-through: **applications disappear into departments. There is no tracking, no escalation, and the statutory grievance routes (CPGRAMS, RTI) are themselves too complex for most citizens.

- **Wrongful rejections go unchallenged: **a rejected applicant rarely knows why, or that appeal routes exist at all.

## 2.3 The decisive evidence: information is not enough

A University of Chicago field experiment with 1,200+ pension-eligible widows in Delhi tested three interventions: information only, information plus help filling the form, and information plus help engaging authorities. Information alone raised applications only among literate women. The most vulnerable were helped only by hands-on mediation — someone acting on their behalf. This is the core design insight of Haq: the product must act, not inform.

## 2.4 Why existing solutions fall short

| **Player** | **What they do** | **The gap** |
| --- | --- | --- |
| MyScheme (Govt.) | Discovery portal: filter schemes by age, income, occupation | Stops at discovery. The citizen still applies alone. |
| Haqdarshak | Human field-agent network assisting applications | Powerful but expensive (hundreds of rupees per application) and limited by agent headcount. |
| EasyGov | AI chatbot eligibility check, assisted digital application | Eligibility Q&A; no persistent autonomous follow-through over weeks. |
| CSC centres | Physical kiosks for government services | Requires travel, queues, and per-service fees; no proactive tracking. |

**The unclaimed gap: **nobody has built the agentic layer — a system that autonomously fills forms, pulls documents, tracks status over weeks, follows up with departments, and escalates rejections, end-to-end, at near-zero marginal cost. Everyone solved discovery; nobody solved representation.

# 3. The Solution: A Personal Institutional Agent

## 3.1 Vision

Haq is an AI agent that represents the citizen in every interaction with institutions — the way a chartered accountant represents you to the tax department. It lives on WhatsApp, speaks the user’s language (text or voice), and operates autonomously over weeks: thinking (parsing rules, matching eligibility), deciding (prioritising schemes by payout versus effort, sequencing document dependencies), and acting (filing, tracking, following up, appealing) — the purest expression of an agentic and autonomous system.

## 3.2 The expansion layers

- **Layer 1 — Claim what is yours (the wedge): **welfare schemes, scholarships, pensions, and unclaimed financial assets (insurance, PF, dormant deposits).

- **Layer 2 — Defend what is yours: **appeal insurance claim rejections, file consumer complaints, draft RTI applications, fight wrongful scheme rejections via CPGRAMS and departmental appeal routes.

- **Layer 3 — Grow what is yours: **MSME enablement for India’s 63 million micro-businesses that cannot afford a CA: Udyam registration, Mudra loans, FSSAI licences, basic GST compliance.

- **Layer 4 — The data flywheel: **every application Haq files teaches it which documents each office actually demands, how long each department really takes, and which grievance routes work. Haq ends up owning a live operational map of how Indian bureaucracy functions — something no one, including the government, possesses. This is the compounding moat.

## 3.3 Design principles

- **Act, don’t inform. **Every feature must move an application forward, not just explain it.

- **Voice-first, vernacular-first. **The user should never need to type or read English.

- **Scheme-as-config, never scheme-as-code. **Scale is structural, not heroic.

- **Deterministic where it matters. **LLMs explain and parse; rules engines decide eligibility. No hallucinated entitlements.

- **Human-in-the-loop at the legal edge. **The citizen performs the final submit (OTP), keeping agency, consent, and compliance intact.

- **Every failure makes the system smarter for all users. **Rejections feed playbooks; portal breakages heal once, globally.

# 4. End-to-End User Journey

- **Hello (trust-first onboarding): **Meena, a widowed tailor in Lucknow, gets Haq’s number from her self-help group. She sends a voice note in Hindi. Haq replies in Hindi voice + text, opening with what it will never ask for (money, OTPs at onboarding) and linking only to official portals.

- **Document-first profiling: **instead of an interrogation, Haq asks for one photo of her ration card. OCR extracts 80% of her profile. Two targeted questions fill the gaps.

- **Matching: **the deterministic rules engine finds 6 schemes; Haq presents the top 3 ranked by payout ÷ effort, explained in plain Hindi: “You are owed a widow pension of ₹X/month. I can apply for you today.”

- **Document gathering: **the pension needs an income certificate she lacks. Haq knows the dependency: it files the income-certificate application first, telling her exactly which office and what to carry — then auto-resumes the pension application when the certificate arrives.

- **Execution: **Haq fills the state portal form via browser automation, pauses at the OTP step, pings Meena (“enter this code now”), and submits. She receives the application number and a visual timeline.

- **Autonomous tracking: **for the next six weeks Haq checks status, parses the acknowledgment SMS she forwards, and nudges her only when needed.

- **Fighting back: **the department goes silent past its statutory service window. Haq auto-drafts a CPGRAMS grievance and files it after her one-tap approval. Two weeks later: approved.

- **Proactive layer: **months later Meena mentions her daughter starting college. Haq surfaces two scholarship schemes unprompted, with deadlines. The agent has become a representative who watches out for her.

# 5. System Architecture

## 5.1 Component overview

| **Layer** | **Responsibility** |
| --- | --- |
| Channel Layer | WhatsApp Business API (Telegram in V0). Inbound webhooks, outbound templates, voice-note handling. The only UI most users ever see. |
| Language Layer | Bhashini / Indic ASR for speech-to-text, TTS for voice replies, language detection, translation. Voice-first by default. |
| Intent Router | Cheap classifier model triages every inbound message (new info / status query / document upload / smalltalk) before any expensive model is invoked. |
| Profile Store | Postgres. User profiles built document-first via OCR; consent records; channel identifiers. |
| Scheme Registry | Versioned configs: eligibility rules (JSON logic), required-document graphs, portal recipes, department SLAs, appeal routes. The scalability engine. |
| Eligibility Engine | Pure deterministic code executing scheme rules against profiles. Zero LLM tokens at runtime; zero hallucination risk. |
| Document Service | OCR + field extraction, image-quality validation (blur/glare), DigiLocker fetch, document-dependency resolution. |
| Execution Workers | Containerised Playwright jobs with tiered degradation (API → automation → pre-filled PDF). Self-healing selectors. OTP hibernation. |
| Orchestrator | n8n event-driven workflows + cron sentinels driving the application state machine. Dead-letter queue for stuck cases. |
| Human Escalation Desk | Dashboard where one reviewer fixes a broken portal recipe once — healing every queued user. Also handles edge-case appeals. |
| Audit & Trust Layer | Append-only event log of every agent action, rendered to the user as a transparent timeline. Doubles as debugging and training data. |

## 5.2 Data flow (happy path)

WhatsApp message → Language Layer (ASR/translate) → Intent Router → Profiler (if document) or Matcher (if profile change) → Eligibility Engine → ranked matches to user → user consents → Document Service resolves dependencies → Execution Worker files application → state machine takes over → Sentinel cron tracks to disbursal → audit timeline updated at every step.

## 5.3 The scheme-as-config pipeline (how scale stays cheap)

- Ingest: scheme PDF / portal page collected.

- LLM parses it offline into structured config: eligibility rules, document list, form fields, SLAs, appeal route.

- Human verifier spot-checks the config (minutes, not days).

- Config published to the registry, versioned. The agent can serve it immediately — no code deployed.

Demo moment: add a new scheme as a config file in 30 seconds and show the agent handling it live. This single moment proves scalability better than any slide.

# 6. Failure-Mode Analysis & Hardening (Step by Step)

Every stage of the pipeline was stress-tested for its dominant failure mode and redesigned. This section is the engineering heart of the product.

## 6.1 Onboarding — failure: drop-off and distrust

- Typing-based onboarding excludes low-literacy users → voice-first: users send voice notes, transcribed via Bhashini/Indic ASR; replies are voice + text.

- “Is this a scam?” → the agent opens by stating what it will never do (ask for money, ask for OTPs at onboarding), cites only official portals, and is distributed through organisations users already trust (SHGs, NGOs).

## 6.2 Profiling — failure: people don’t know their own data

- Questions like “annual income bracket?” or “category code?” fail → document-first profiling: one photo of a ration card / Aadhaar yields ~80% of the profile via OCR. Every extracted field is a signalled input the user never had to answer.

- Bad photos cause silent downstream rejections → image-quality validation (blur/glare/crop detection) at the moment of upload, with instant re-prompt — not a bounce three weeks later.

## 6.3 Eligibility matching — failure: LLM hallucinates entitlements

- The LLM never decides eligibility at runtime. Offline: LLM parses scheme documents into structured rules → human verifies → published as config. Runtime: a deterministic rules engine executes them. LLM only explains results in the user’s language.

- Ambiguous profiles → confidence scoring; below threshold the agent asks one targeted clarifying question instead of guessing.

## 6.4 Document gathering — failure: DigiLocker doesn’t have it

- Every required document has a fallback graph: where to obtain it, which office, what to carry — and where possible, Haq files that prerequisite application itself.

- Dependency-aware sequencing: the agent recognises that application B requires document X produced by application A, and orders its own queue. Genuine think-decide-act.

## 6.5 Execution — failure: portals break, captchas, OTPs

- **Tier 1 (gold, rare): **official API where one exists.

- **Tier 2 (default): **Playwright automation with self-healing selectors — on a missed field, an LLM re-reads the DOM, proposes a new selector, retries once, and writes the fix back to the versioned portal recipe (flagged for review).

- **Tier 3 (never stuck): **after two hard failures, automatic downgrade to a perfectly pre-filled PDF plus a step-by-step voice-note walkthrough.

- **OTP / captcha: **the job hibernates, WhatsApp pings the user (“enter this code now”), and the response resumes the job within a TTL window; expiry reschedules at the user’s preferred time. The citizen performing the final submit also resolves the consent/legality question.

## 6.6 Tracking — failure: no status APIs exist

- Every application is a state machine with per-state timeouts learned from real departmental data. The Sentinel cron sweeps hourly for breaches.

- On timeout: portal status scrape → ask user to forward any SMS → if the department is silent past its statutory window, auto-draft an RTI or CPGRAMS grievance. Silence becomes an actionable signal.

## 6.7 Rejection — failure: dead end for the user

- Rejection reason parsed → mapped to a remediation playbook: wrong document → re-gather and refile; wrongful rejection → auto-draft the appeal.

- Every rejection feeds back into the rules engine and playbooks, so the same mistake never repeats for any user. Failures compound into the moat.

## 6.8 Cost — failure: token burn at scale

- Route by complexity: a cheap classifier handles routine messages; the frontier model is reserved for genuine reasoning.

- Eligibility is pure code (zero tokens). Scheme configs cached. Embeddings computed once per scheme, not per user. Target: < ₹10 per completed application.

## 6.9 Trust & compliance — failure: data disaster

- Encryption at rest; Aadhaar masked (last 4 digits only, never stored in full); DPDP Act-aligned consent ledger.

- Full audit trail of every agent action, rendered to the user as a plain-language timeline (“filed on the 3rd, acknowledged on the 7th”). Transparency is also the most demo-able screen.

## 6.10 Reactivity — failure: agents that only answer

- Life events are signals: a mention of a newborn surfaces maternity benefits; an approaching scheme deadline triggers proactive nudges to all eligible users. The agent shifts from tool-you-ask to representative-who-watches-out-for-you.

# 7. Execution Layer Deep-Dive

## 7.1 Worker design

- Each application runs as an isolated, containerised Playwright job pulled from a queue.

- Job payload = **{scheme_config, user_profile, documents, portal_recipe}**. The portal recipe is versioned config: URL flow, field mappings, expected screens, checkpoints.

- Every step screenshots before/after; screenshots flow into the audit trail.

## 7.2 Failure handling inside a job

- Selector miss → LLM reads the live DOM, proposes a replacement selector, retries once, writes the fix to the recipe (version-bumped, flagged for human review).

- Unexpected screen (redesign, downtime notice) → job pauses; snapshot lands on the human-review dashboard; one reviewer fixes the recipe once and all queued jobs for that scheme resume. One human fix heals every user.

- Two hard failures → automatic Tier-3 downgrade (pre-filled PDF + voice walkthrough). The user is never stranded.

- OTP/captcha checkpoint → hibernate → WhatsApp ping → resume on reply within TTL; on expiry, reschedule at the user’s preferred hour.

## 7.3 Why this design wins

- Fragility is quarantined: portal chaos never corrupts state; it only pauses one queue.

- Maintenance scales sub-linearly: self-healing handles small drift; humans handle redesigns once per scheme, not once per user.

- Graceful degradation means the product’s promise (“your application moves forward”) survives even total portal failure.

# 8. Data Model

| **Table** | **Contents ****&**** purpose** |
| --- | --- |
| users | Profile fields, preferred language, consent records (DPDP-aligned), channel IDs (WhatsApp/Telegram). |
| documents | Type, masked identifiers, DigiLocker references, OCR-extracted fields, quality score, expiry dates. |
| schemes | Versioned config: eligibility rules (JSON logic), required-document graph, portal recipe reference, department SLAs, appeal routes. |
| applications | The heart: user × scheme, current state, event-sourced state history, application number, expected-by date. |
| events | Append-only log of everything — agent actions, user messages, portal responses. Enables replay of any case, dispute resolution, and becomes training data. |
| playbooks | Rejection-reason → remediation mappings, learned and refined over time across all users. |

Event-sourcing the applications table is deliberate: it is simultaneously the debugging tool, the legal proof of what the agent did, the user-facing trust timeline, and the dataset that powers the bureaucracy-map moat.

# 9. The Application State Machine (The Product’s Soul)

What separates an agent from a form-filler is unprompted action over weeks. Every application advances through this machine:

*discovered → eligible → docs_pending → ready → submitting → awaiting_otp → submitted → acknowledged → under_review → approved → disbursed*

Branches: **rejected → remediation → resubmitted**  and  **stalled → grievance_filed → escalated**

| **State** | **Entry action** | **Timeout** | **Timeout action** |
| --- | --- | --- | --- |
| docs_pending | Send fallback graph for missing docs | 7 days | Voice-note reminder; offer prerequisite filing |
| awaiting_otp | WhatsApp ping with resume link | 10 min TTL | Reschedule at user’s preferred hour |
| submitted | Store application number; notify user | Dept SLA (learned) | Portal status scrape; ask user to forward SMS |
| under_review | Update timeline | Statutory window | Auto-draft CPGRAMS grievance / RTI; one-tap user approval |
| rejected | Parse reason → playbook lookup | 48 hours | Refile with fix, or draft appeal |
| approved | Congratulate; explain disbursal | Disbursal SLA | Verify receipt with user; escalate if unpaid |

Timeout durations start from statutory service-delivery windows and are continuously refined from observed departmental behaviour — the data flywheel in action. The hourly Sentinel cron sweeps for breaches and fires the corresponding action.

# 10. n8n Workflow Architecture (The Build Plan)

The entire orchestration layer is five cleanly separated n8n workflows over Postgres, with a dead-letter queue and an alert channel for human escalation.

| **Workflow** | **Trigger** | **Pipeline** |
| --- | --- | --- |
| 1. Inbound | WhatsApp/Telegram webhook | Language detect → ASR if voice → cheap intent classifier → route to Profiler / Matcher / status answer / smalltalk |
| 2. Profiler | Document image received | Quality check (blur/glare) → OCR → field extraction → profile update → targeted gap questions |
| 3. Matcher | Profile-change event | Deterministic rules engine (code node) → rank by payout ÷ effort → vernacular presentation → consent capture |
| 4. Executor | Application reaches ‘ready’ | Dispatch job to Playwright worker (HTTP) → handle OTP callbacks → tier downgrades → write events |
| 5. Sentinel | Hourly cron | Sweep state timeouts → status checks → nudges → grievance drafting → proactive scheme/deadline alerts |

## 10.1 Why n8n is the right backbone

- The product is, at its core, orchestrated long-running workflows with an LLM brain — exactly n8n’s shape: webhooks, crons, queues, conditional branching, native AI-agent nodes.

- Build economics: assembling existing rails (WhatsApp, DigiLocker, Bhashini, government portals) rather than inventing infrastructure. Judges hear “we orchestrated, we didn’t reinvent” as efficiency.

# 11. Technology Stack

| **Concern** | **Choice** | **Notes** |
| --- | --- | --- |
| Orchestration | n8n (self-hosted) | Five workflows; AI-agent nodes; queues + crons |
| Channel | WhatsApp Business API (Telegram for V0) | Telegram needs no approval — ideal for hackathon |
| Speech & language | Bhashini / Indic ASR + TTS | Voice-first, 12+ Indian languages |
| LLM reasoning | Claude / GPT APIs | Offline scheme parsing, DOM healing, vernacular explanation |
| Cheap routing | Small classifier model | Intent triage to control token cost |
| Eligibility | Deterministic JSON-logic engine | Code node; zero tokens, zero hallucination |
| RAG | Embeddings over scheme documents | Computed once per scheme; grounded Q&A |
| Browser automation | Playwright in containers | Self-healing selectors; screenshot audit |
| OCR | Tesseract / cloud OCR + LLM extraction | Document-first profiling |
| Documents | DigiLocker APIs | Fetch certificates; fallback graphs when absent |
| Database | Postgres (event-sourced applications) | Airtable acceptable for V0 speed |
| Govt data | MyScheme / api.setu.in ecosystem | Scheme corpus for the config pipeline |
| Compliance | Encryption at rest; Aadhaar masking; DPDP consent ledger | Trust is a feature, not a checkbox |

# 12. Roadmap

## 12.1 V0 — Hackathon (a complete product loop, not a demo)

- Telegram (or WhatsApp sandbox) bot, voice-in/voice-out in Hindi + English.

- 15 real schemes of one state, onboarded via the config pipeline.

- Document-first profiling with image-quality validation.

- Deterministic matcher with payout ÷ effort ranking.

- Tier-3 execution (pre-filled PDF + voice walkthrough) for all 15; Tier-2 live portal automation for one flagship scheme.

- Full state-machine tracking with the Sentinel cron and the user-facing audit timeline.

- Live scalability demo: add scheme #16 as a config file in 30 seconds.

## 12.2 V1 — First 3 months

- Verified WhatsApp Business; DigiLocker integration; OTP-resume flow hardened.

- 100+ schemes via the LLM-parse → human-verify → publish pipeline; second state added.

- Grievance automation (CPGRAMS/RTI drafting) live; rejection playbooks accumulating.

- Distribution pilots with 2–3 SHG/NGO networks; human-escalation desk operational.

## 12.3 Scale — 6 to 18 months

- Multi-state coverage; department-SLA dataset becomes the live bureaucracy map.

- Layer 2 (defend): insurance claim appeals, consumer complaints.

- Layer 3 (grow): MSME vertical — Udyam, Mudra, FSSAI, GST basics.

- Partner-distribution at scale through SHGs, NGOs, MFIs, and CSC networks: they bring trust, Haq brings the engine.

- The engine is country-agnostic: rules + forms + follow-ups exist everywhere benefits go unclaimed.

# 13. Metrics That Prove Impact

**North star: **rupees disbursed into users’ bank accounts.

| **Metric** | **Why it matters** |
| --- | --- |
| Applications completed per user | Measures representation, not engagement |
| Success rate vs. ~33% baseline take-up | Direct comparison to the Delhi-study status quo |
| Median time-to-disbursal vs. dept average | Proves the follow-up engine works |
| Cost per completed application (< ₹10) | Unit economics vs. hundreds of rupees for human mediation |
| % of failures auto-remediated | Proves the playbook flywheel |
| Grievances filed → resolved | Proves the agent fights, not just files |

# 14. Business Model

**Free for citizens, always. **Two ethical and regulatory lines are never crossed: no commission on benefits, and no sale of personal data.

- **Government ****&**** CSR contracts: **states actively want scheme-utilisation numbers; Haq delivers measurable take-up improvement per district.

- **NGO / MFI / SHG licensing: **organisations pay per active beneficiary to give their members a tireless caseworker.

- **MSME subscriptions (later): **micro-businesses pay a small monthly fee for compliance representation they could never afford from a CA.

- **The data asset: **the anonymised live map of departmental performance is valuable to policy bodies and researchers — shared on privacy-preserving terms only.

# 15. Honest Risk Register

Stating these aloud earns credibility with judges.

| **Risk** | **Mitigation** |
| --- | --- |
| Portal automation ToS gray zones | Human-in-the-loop final submit: the citizen performs the legally meaningful act; the agent prepares everything. Tier-3 PDF fallback is always fully compliant. |
| Aadhaar / personal-data sensitivity | Masking (last 4 digits only), encryption at rest, DPDP-aligned consent ledger, full user-visible audit trail. |
| Scheme rule drift (rules change quietly) | Versioned configs; scheduled re-parsing of source documents; human verification gate before publish. |
| Portal redesigns breaking automation | Self-healing selectors for drift; human-review desk fixes a recipe once for all users; automatic Tier-3 downgrade meanwhile. |
| User trust cold-start | Distribute exclusively through organisations people already trust (SHGs, NGOs, MFIs); scam-proof onboarding script. |
| LLM errors creating false hope | Eligibility is deterministic code; LLM never asserts entitlements; confidence thresholds trigger clarifying questions. |
| Department hostility / rate limiting | Respectful request pacing; PDF fallback; government partnerships convert adversaries into clients who want utilisation numbers. |

# 16. The Pitch (Script & Framing)

## 16.1 Name

Haq (हक़) — “rightful claim.” The product’s entire thesis in one word.

## 16.2 One-liner

*“800 million Indians are owed $210B in benefits. Haq is the AI agent that claims, tracks, and fights for what is theirs — for the price of a WhatsApp message.”*

## 16.3 Three-minute structure

- **The hook (20s): **“Rich people have CAs and lawyers to deal with bureaucracy. 800 million Indians have nobody.” One stat: $210B allocated, a third of beneficiaries never enrolled.

- **The proof it’s real (20s): **the Delhi widow study — information alone failed; only mediation worked. Today mediation is human and expensive. We made it AI and nearly free.

- **Live demo (90s): **voice note in Hindi → ration-card photo → instant matches → one-tap apply → OTP ping → application number + timeline. Then the killer 30 seconds: add a brand-new scheme as a config file and apply to it immediately.

- **The agentic close (30s): **show the Sentinel: an application stalled past its statutory window and the agent auto-drafted a grievance overnight. “It doesn’t just file. It fights.”

- **Scale + economics (20s): **scheme-as-config, < ₹10 per application, distribution through SHG networks, same engine for insurance, MSMEs, and any country.

## 16.4 Anticipated judge questions

- **“How is this different from MyScheme/Haqdarshak?” **They solved discovery or use human agents. We built autonomous representation — the agent acts for weeks, at ~1% of the cost.

- **“What if portals block you?” **Tiered degradation; the PDF fallback is unblockable; and governments are prospective clients, not adversaries — they want utilisation numbers.

- **“Is it legal?” **The citizen performs the final submit; the agent prepares, tracks, and drafts. Consent is logged; data handling is DPDP-aligned.

- **“How do you make money without charging the poor?” **Governments, CSR, and NGO networks pay for outcomes; citizens never pay.

# 17. Hackathon Build Checklist (V0)

- Set up n8n + Postgres; create the five workflow skeletons (Inbound, Profiler, Matcher, Executor, Sentinel).

- Stand up the Telegram bot; wire voice-note → ASR → intent classifier.

- Build the scheme-config schema; run the LLM-parse pipeline on 15 real schemes of one state; human-verify.

- Implement the deterministic eligibility engine (code node) + payout ÷ effort ranking.

- Document-first profiling: OCR + quality validation + gap questions.

- Tier-3 execution: pre-filled PDF generator + voice walkthrough for all 15 schemes.

- Tier-2 execution: Playwright automation for the one flagship scheme, with OTP hibernation.

- State machine + Sentinel cron + user-facing audit timeline.

- Grievance auto-draft (CPGRAMS template) on statutory-window breach.

- Rehearse the 30-second add-a-scheme-live moment until flawless.

**End state: a user can speak to Haq in Hindi, be matched to real schemes, receive a filed (or perfectly prepared) application, and watch the agent track and fight for it — a complete product loop, end to end.**

Page