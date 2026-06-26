# 02_Learning_Path

## Folder
Data Cloud

## Purpose
A sequenced Beginner → Intermediate → Advanced path for becoming proficient in Data Cloud / Data 360, aligned to the six sections of the Salesforce Certified Data 360 Consultant exam guide and to this folder's six anchor scenarios (see `00_README.md`).

## Branding Notes
- Path uses "Data Cloud" for concepts unchanged since before the rebrand and "Data 360" for anything introduced Winter '26 or later (Clean Rooms GA, Notebook AI GA, Code Extension Beta).

## Beginner — Foundations (Exam sections 1–2: Setup & Administration, Ingestion & Modeling)
**Goal:** Understand what Data Cloud is for, the core object model, and how data physically gets in.

| Step | Topic | Resource |
|---|---|---|
| 1 | Why Data Cloud exists — fragmented customer data problem, Customer 360 vision | `03_Key_Concepts.md` intro section |
| 2 | Data Cloud vs. a traditional CDP vs. a data warehouse | `03_Key_Concepts.md` |
| 3 | Data Streams — connecting Salesforce clouds, CRM, and external sources | Unlock Your Data with Data Cloud trail |
| 4 | Data Lake Objects (DLO) — raw, source-shaped staging layer | `03_Key_Concepts.md` |
| 5 | Data Model Objects (DMO) — Customer 360 Data Model, standard vs. custom DMOs | `03_Key_Concepts.md` |
| 6 | Data Spaces — partitioning data by brand, region, or business unit | `03_Key_Concepts.md` |
| 7 | First lab: connect a CRM data source and map a DLO to a DMO | `05_Hands_On_Labs.md`, Lab 1 |

**Beginner milestone:** can explain DLO → DMO → mapping flow to a non-technical stakeholder, and has completed one hands-on data-mapping exercise.

## Intermediate — Unification & Insight (Exam sections 3–4: Identity Resolution, Segmentation & Insights)
**Goal:** Take ingested data from "mapped" to "unified" to "actionable."

| Step | Topic | Resource |
|---|---|---|
| 1 | Identity Resolution — match rules, rulesets, reconciliation, deterministic vs. probabilistic matching | `03_Key_Concepts.md` |
| 2 | Unified Individual / Unified Profile — how records merge, why aggressive probabilistic matching is risky | `08_Common_Mistakes.md` |
| 3 | Calculated Insights — metrics defined on DMOs (e.g., engagement score, churn risk, lifetime value), batch vs. streaming | `03_Key_Concepts.md` |
| 4 | Segmentation — building segments against unified profiles, Einstein Segment Recipes for a faster start | `04_Architecture_Patterns.md` |
| 5 | Data Cloud Reports & Dashboards vs. Tableau Next vs. CRM Analytics — when to use which | `03_Key_Concepts.md` |
| 6 | Second lab: build an identity resolution ruleset and a Calculated Insight | `05_Hands_On_Labs.md`, Lab 2–3 |

**Intermediate milestone:** can design an identity-resolution ruleset for a named scenario (e.g., Household matching) and justify the choice of deterministic vs. probabilistic matching keys.

## Advanced — Activation, Federation & AI Grounding (Exam sections 5–6: Activation, Governance — plus cross-cutting Zero Copy and Agentforce integration)
**Goal:** Design enterprise-grade, governed, AI-ready Data Cloud architectures.

| Step | Topic | Resource |
|---|---|---|
| 1 | Activation — Activation Targets, Activation-Triggered Flows firing on segment publish or DMO update | `04_Architecture_Patterns.md` |
| 2 | Zero Copy — Live Query federation with Snowflake/Databricks/BigQuery/Redshift; when to federate vs. ingest | `04_Architecture_Patterns.md`, `08_Common_Mistakes.md` |
| 3 | Governance — Data Spaces access control, AI-powered PII tagging, Dynamic Data Masking | `03_Key_Concepts.md` |
| 4 | Data 360 + Financial Services Cloud integration — Calculated Insights surfaced on FSC record pages, household/relationship enrichment | `04_Architecture_Patterns.md` |
| 5 | Data 360 as Agentforce grounding layer — unified profiles and Calculated Insights as agent context | `04_Architecture_Patterns.md`, Agentforce folder (future) |
| 6 | Winter '26 / Spring '26 additions: Clean Rooms (GA), Notebook AI (GA), Code Extension (Beta, Python transforms), pre-mapped DLOs, Tableau Semantics, Intelligent Context | `09_Whats_New.md` |
| 7 | Capstone lab: end-to-end — ingest, resolve identity, compute insight, segment, activate, ground an Agentforce action | `05_Hands_On_Labs.md`, Lab 4–5 |

**Advanced milestone:** can produce a reference architecture diagram for a named enterprise scenario (see `10_Enterprise_Use_Cases.md`) covering ingestion, identity resolution, governance, and activation/AI grounding, and can defend credit-consumption tradeoffs (e.g., identity resolution is the most expensive operation type — batch where possible).

## Suggested Pacing
- Beginner: 1–2 weeks, self-paced, ~6–8 hours of Trailhead + 1 lab
- Intermediate: 2–3 weeks, ~10–12 hours including 2 labs
- Advanced: 3–4 weeks, ~15+ hours including architecture exercise and capstone lab
- Total to certification readiness: ~8–10 weeks part-time

## Open Decisions
- Whether to insert a standalone "SQL/SOQL for Data Cloud" micro-module given the Spring '26 12 MB SOQL result-size limit on Data 360 queries — currently folded into `03_Key_Concepts.md` rather than broken out.
- Whether Advanced should require hands-on access to a non-Salesforce data warehouse (Snowflake/Databricks trial) to genuinely practice Zero Copy, or whether a simulated/described walkthrough is sufficient for a trainer-led cohort.

## Next Steps
- Build `03_Key_Concepts.md` to back every "Resource" cell above with real definitions.
- Confirm capstone lab scope against `05_Hands_On_Labs.md` once drafted.
