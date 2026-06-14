# Haq — Database

A Supabase Postgres project hosts everything: user profiles, scheme configs (as JSONB), applications, append-only events, and uploaded documents.

## Apply
Run these in the Supabase SQL Editor, in order:

1. `schema.sql` — 5 tables, 1 index, 1 stored function (`transition`)
2. `scheme_seed_pack.sql` — 12 real Rajasthan + Central welfare schemes
3. `demo_helpers.sql` — only the snippets you need (use during live demo)

## Tables

| Table | Purpose |
|---|---|
| `users` | One row per Telegram user. `profile` is a JSONB blob filled progressively. |
| `documents` | OCR-extracted document data; Aadhaar stored as last 4 digits only. |
| `schemes` | Versioned scheme configs (eligibility, required docs, SLAs, appeal route) — the scalability engine. |
| `applications` | An application is a state machine: `discovered → eligible → docs_pending → ready → submitting → awaiting_otp → submitted → acknowledged → under_review → approved → disbursed`. |
| `events` | Append-only log of every agent action — debugging, legal proof, and the user-facing audit timeline. |

## The `transition()` function
Every state change to an application goes through `transition(app_id, new_state, deadline, payload)` so that an event is logged atomically. Never `UPDATE` an application directly; always call `transition()`.

## Scheme config schema (example)
```json
{
  "id": "rj_widow_pension",
  "version": 1,
  "name": {"en": "Widow Pension (Rajasthan)", "hi": "विधवा पेंशन (राजस्थान)"},
  "benefit": {"type": "monthly_cash", "amount_inr": 1500},
  "effort_score": 2,
  "eligibility": {
    "all": [
      {"field": "gender", "op": "eq", "value": "female"},
      {"field": "marital_status", "op": "eq", "value": "widowed"},
      {"field": "age", "op": "gte", "value": 18},
      {"field": "annual_income", "op": "lte", "value": 48000},
      {"field": "state", "op": "eq", "value": "RJ"}
    ]
  },
  "required_docs": [...],
  "execution": {"tier2_recipe": null, "tier3_template": "templates/rj_widow_pension.pdf"},
  "slas": {"acknowledge_days": 7, "decision_days": 45},
  "appeal": {"route": "cpgrams", "grievance_dept": "..."}
}
```

Adding scheme #500 is one INSERT, not a code deploy.
