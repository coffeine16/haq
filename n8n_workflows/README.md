# Haq — n8n Workflows

Five workflows orchestrate the entire agent. Import in dependency order; later workflows reference earlier ones via Execute-Sub-Workflow nodes.

| File | Workflow | Trigger | Responsibility |
|---|---|---|---|
| `Haq_3_Matcher.json` | 3 - Matcher | Execute Workflow | Deterministic eligibility engine + vernacular explainer |
| `Haq_2_Profiler.json` | 2 - Profiler | Execute Workflow | Photo → Gemini Vision → profile extraction + gap questions |
| `Haq_4_Executor.json` | 4 - Executor | Execute Workflow + Webhook | Application lifecycle — calls PDF service, handles callbacks |
| `Haq_1_Inbound.json` | 1 - Inbound | Telegram + Webhook | Intent classifier, routes to sub-workflows |
| `Haq_5_Sentinel.json` | 5 - Sentinel | Hourly cron | Sweeps deadlines, drafts grievances, sends reminders |

## Import order (matters)
1. `Haq_3_Matcher.json`
2. `Haq_2_Profiler.json`
3. `Haq_4_Executor.json`
4. `Haq_1_Inbound.json`
5. `Haq_5_Sentinel.json`

In each: **Workflows → ⋯ menu → Import from File**.

## After import — wiring

### Credentials (create once, reused everywhere)
- **Telegram API** — paste your BotFather token
- **Postgres** — Supabase pooler details:
  - Host: `aws-1-ap-south-1.pooler.supabase.com` (or `aws-0` depending on your project; check Supabase → Connect)
  - Port: 5432
  - Database: `postgres`
  - User: `postgres.<your-supabase-project-ref>`
  - Password: your Supabase password
  - SSL: Disable (the pooler handles TLS internally)

Then open each workflow and assign these credentials to every red Telegram / Postgres node.

### Sub-workflow IDs (the Execute Workflow nodes)
n8n stores sub-workflow links by ID, which differ per import. In **Workflow 1**, click each Execute-Workflow node and pick the correct target from the dropdown:
- **Run Profiler** → Haq 2 - Profiler
- **Run Matcher** → Haq 3 - Matcher
- **Run Executor** → Haq 4 - Executor

In **Workflow 2**:
- **Run Matcher** → Haq 3 - Matcher

On each Execute-Workflow node, also turn **"Attempt To Convert Types"** ON so user_id/chat_id auto-cast between number and string.

### Gemini API key
Five HTTP-Request nodes call Gemini. In each, replace `YOUR_GEMINI_API_KEY` in the URL with a real key (free tier from https://aistudio.google.com/apikey works).

| Workflow | Node |
|---|---|
| 1 Inbound | Classify Intent (LLM) — uses `gemini-3.1-flash-lite` |
| 1 Inbound | Extract Fields (LLM) — `gemini-3.5-flash` |
| 2 Profiler | Vision Extract (LLM) — `gemini-3.5-flash` |
| 3 Matcher | Vernacular Explainer (LLM) — `gemini-3.5-flash` |
| 5 Sentinel | Draft Grievance (LLM) — `gemini-3.5-flash` |

### Activate
Publish all five workflows. Publish Workflow 3 first, then 2, 4, 1, 5 — same dependency order as import.

### Telegram webhook
After Workflow 1 is published, copy the **Production URL** from its Telegram Trigger node and set it as your bot's webhook:
```
https://api.telegram.org/bot<YOUR_TOKEN>/setWebhook?url=<production-url>
```

Verify:
```
https://api.telegram.org/bot<YOUR_TOKEN>/getWebhookInfo
```

## Smoke test
Send to your bot:
> Main Meena hoon, 45 saal ki, vidhva, mahila, Rajasthan ke Jaipur mein rehti hoon, saalana aamdani 40000 rupaye

Expected: bot replies in Hindi with the matched schemes and a HAAN/YES consent prompt.
