# 03_Key_Concepts

## Folder
Data Cloud

## Purpose
Defines every core Data Cloud / Data 360 concept needed to read `04_Architecture_Patterns.md` and `10_Enterprise_Use_Cases.md`. Organized by layer: ingestion → modeling → unification → insight → action → governance → AI grounding.

## Branding Notes
- Object and API names below are unchanged by the Data Cloud → Data 360 rebrand (October 14, 2025). Only product marketing language changed.
- Where a capability is new for Winter '26 or Spring '26, it is marked **(New W'26)** or **(New S'26)**. Always re-check against the live release notes (`01_Official_Resources.md`) before teaching a cohort, since Data Cloud ships fast.

## 1. Ingestion Layer

**Data Source** — any system connected to Data Cloud: a Salesforce org (Sales/Service/Marketing/Commerce/FSC), an external CRM, a data warehouse, a file (CSV/Parquet), a streaming source (via Ingestion API), or a clickstream (via Web/Mobile SDK).

**Data Stream** — the configured connection that pulls data from a Data Source into Data Cloud on a schedule (or in near-real-time for CRM/streaming sources). Each stream lands data into one or more Data Lake Objects.

**Data Lake Object (DLO)** — the raw staging table. A DLO preserves the source system's schema exactly as received — field names, types, and grain are not normalized yet. DLOs exist so the original data is always traceable and re-processable if mapping logic changes.

**Bring Your Own Lake (BYOL) / Zero Copy File Federation** — connecting to data that already lives in an external lake (e.g., files in a cloud storage bucket) without copying it into Data Cloud's own storage.

**Ready-to-use Data Lake Objects (New S'26)** — Spring '26 introduced DLOs that arrive pre-mapped to standard CRM fields, reducing manual mapping effort for common Salesforce-sourced data.

## 2. Modeling Layer

**Data Model Object (DMO)** — a virtual table conforming to the Customer 360 Data Model (or a custom model). DMOs are where harmonization happens: a "Lead" DLO and a "Registrant" DLO can both map fields into the same "Individual" DMO. DMOs are what segmentation, Calculated Insights, and activation actually query — not DLOs directly.

- **Standard DMOs**: Individual, Party, Engagement, Sales Order, etc. — prebuilt to match common business entities.
- **Custom DMOs**: built when a standard DMO doesn't fit (e.g., a custom "Policy" DMO for an insurer not using FSC's standard Insurance objects).

**Mapping** — the explicit field-by-field correspondence from a DLO to a DMO, defined once per source/DMO pair and re-applied on every refresh.

**Data Space** — a partition of the entire Data Cloud environment (data, mappings, segments, activations) by brand, business unit, region, or legal entity. Data Spaces are the primary mechanism for both data isolation and access governance in a multi-brand or multi-entity org.

**Calculated Insight** — see Section 4. Technically modeled as a special object type that can read DMOs (and other Calculated Insights) and run on a batch or streaming cadence.

## 3. Identity Resolution

**Identity Resolution (IDR)** — the engine that detects when records across different DMOs/sources represent the same real-world person (or household, or account) and merges them into a single **Unified Individual** profile.

**Match Rule** — the logic that decides two records match (e.g., "same email AND same last name", or a fuzzy/probabilistic score above a threshold).

**Ruleset** — an ordered collection of match rules applied to a DMO. Rulesets are re-evaluated continuously as new data lands — identity resolution is not a one-time batch job conceptually, even though it executes as batch or streaming jobs under the hood.

**Reconciliation Rule** — when two matched records disagree on a field's value (e.g., two different phone numbers), the reconciliation rule decides which value wins on the unified profile (e.g., "most recent source wins").

**Deterministic vs. Probabilistic Matching**:
- *Deterministic*: exact match on a strong identifier (verified email, government ID, loyalty/member number). Preferred starting point — predictable, auditable.
- *Probabilistic*: fuzzy/weighted matching across multiple weaker signals (name + address + phone similarity). More powerful for messy data but riskier — can over-merge (false positive) or under-merge (false negative) if rules aren't tuned and tested.

**Unified Individual / Unified Profile** — the merged, addressable profile that downstream segmentation, insight, and activation operate against. If two records already share the same Individual ID, they unify automatically even without an explicit ruleset match — a frequent source of "why did these merge?" confusion during implementation (see `08_Common_Mistakes.md`).

## 4. Calculated Insights

**Calculated Insight (CI)** — a metric or score computed on top of DMOs (or other CIs): lifetime value, churn/attrition risk, next-purchase propensity, engagement score, household net worth, claim frequency, etc. CIs can run:
- **Batch**: scheduled recompute (e.g., nightly).
- **Streaming**: near-real-time recompute as qualifying events land.

CIs are the layer where "raw unified data" becomes "a number a banker, advisor, or Agentforce agent can act on." In the FSC integration pattern (Section 9 below), CIs surface directly on FSC record pages and dashboards.

## 5. Segmentation

**Segment** — a defined audience: a filtered, often nested AND/OR set of conditions evaluated against DMOs and Calculated Insights (e.g., "Households with net worth > $500K AND engagement score declining AND no advisor contact in 90 days").

**Einstein Segment Recipes** — guided, lighter-weight segment-building templates aimed at getting to a usable segment faster than building fully custom logic from scratch. Recommended starting point — best practice is 3–5 well-defined segments rather than one overly complex one (see `08_Common_Mistakes.md`).

**Segment Publish** — the act of running a segment and materializing its membership, which is the trigger point for activation.

## 6. Activation

**Activation Target** — the destination a segment (or individual record) is sent to: Marketing Cloud, an advertising platform, a Salesforce Flow, an external system via API, or an Agentforce action.

**Activation-Triggered Flow** — a Flow that fires automatically the moment a segment publishes or a DMO updates, allowing near-real-time downstream action (e.g., trigger a retention outreach Flow the moment a churn-risk Calculated Insight crosses a threshold) rather than waiting for the next scheduled segment run.

## 7. Zero Copy & Federation

**Zero Copy** — querying data that lives in an external system (or letting an external system query Data Cloud's unified data) without physically copying/duplicating it. Two directions:
- **Inbound (Live Query / Federation)**: Data Cloud queries tables in Snowflake, Databricks, BigQuery, or Redshift directly via metadata-driven query pushdown — no persisted copy in Data Cloud.
- **Outbound (Zero Copy Data Sharing)**: external systems (e.g., Databricks, built on open standards like Iceberg) query Data Cloud's unified profiles, segments, and insights directly.

**Zero Copy Partner Network** — the ecosystem of data-platform vendors (Snowflake, Databricks, Google BigQuery, AWS Redshift, and others) with certified bidirectional zero-copy integration into Data Cloud.

**Why it matters for cost**: federated (zero-copy) queries are dramatically cheaper per row than full ingestion + identity resolution, because the expensive operation (identity resolution) only ever runs once on unified, already-deduplicated data rather than re-running on duplicated copies. See Section 11.

## 8. Governance & Security

**Data Space access control** — Data Spaces double as the access-boundary unit: a user or integration is granted access to specific Data Spaces, not to the whole platform.

**AI-powered PII tagging** — automatic classification of fields likely to contain personally identifiable information, used to drive masking and access policy rather than relying purely on manual classification.

**Dynamic Data Masking** — masks sensitive field values at query time based on the requesting user's or agent's authorization level, so the same DMO can be safely queried by users (or AI agents) with different clearance.

**Clean Rooms (New S'26, GA)** — a governed collaboration environment where two organizations (e.g., a bank and a card-network partner) can run joint analysis on combined data without either party exposing its raw underlying records to the other.

## 9. AI & Agentforce Grounding

**Notebook AI (New S'26, GA)** — a workspace for blending files, links, and Data Cloud data sources, then exploring/analyzing that blended context conversationally rather than only through dashboards.

**Intelligent Context** — Data 360 capability (paired with Tableau Semantics) that helps Agentforce agents reason over unstructured data alongside structured DMOs.

**Tableau Semantics / Tableau Next integration** — surfaces a governed semantic layer so analytics (and AI agents) consume consistent metric definitions rather than ad hoc calculations per dashboard.

**Data 360 as Agentforce grounding layer** — Agentforce templates and topics can read Unified Profiles and Calculated Insights as grounding context automatically, meaning an agent (e.g., a service or advisor copilot) reasons over the same unified customer view a human user sees — this is the core link to the future Agentforce folder in this knowledge base.

## 10. Data Processing Engine & Extensibility

**Data Processing Engine (DPE)** — the batch transformation engine for building custom data pipelines inside Data Cloud (joins, aggregations, formula fields) without needing to push logic externally. Winter '26 added the ability to debug CRM Analytics jobs (beta), write transformation output back to DMOs, and new formula functions (`coalesce`, `array_join`, `MD5`).

**Code Extension (New S'26, Beta)** — lets developers run custom Python logic directly inside Data 360 for advanced transformation, enrichment, matching, or modeling scenarios that go beyond declarative DPE transforms.

## 11. Credits & Consumption Model

Data Cloud / Data 360 is consumption-priced. Credits are consumed per operation type, scaled by data volume — broadly: `Credits ≈ (rows processed / 1,000,000) × operation multiplier`. Multipliers vary enormously by operation: simple queries are cheap; **Identity Resolution is the single most expensive operation type**, which is the architectural reason to batch identity resolution where possible and to prefer Zero Copy federation over full ingestion for high-volume external sources that don't need to participate in identity resolution. Treat all specific multiplier and pricing figures as **point-in-time and commercially sensitive** — always verify against the live Data 360 pricing page before quoting a number to a client (see `01_Official_Resources.md`).

## Glossary Quick Reference
| Term | One-line definition |
|---|---|
| DLO | Raw, source-shaped staging object |
| DMO | Harmonized virtual table conforming to the Customer 360 (or custom) data model |
| Data Space | Partition for data isolation + access governance |
| Identity Resolution | Engine that merges matching records into a Unified Individual |
| Match Rule / Ruleset | Logic deciding whether two records represent the same entity |
| Reconciliation Rule | Logic deciding which value wins on conflicting merged fields |
| Calculated Insight | Metric/score computed on DMOs, batch or streaming |
| Segment | Defined, queryable audience |
| Activation | Sending a segment/record to a downstream target or Flow |
| Zero Copy | Querying external/Data Cloud data without duplicating it |
| Clean Room | Governed joint-analysis environment across two orgs' data |
| Data Processing Engine | Declarative batch transformation pipeline builder |
| Code Extension | Beta: custom Python logic inside Data 360 |

## Open Decisions
- Whether to add a dedicated sub-section on the Ingestion API / Web & Mobile SDK (streaming event ingestion) — currently folded into "Data Source" definition only; may warrant its own concept entry if labs require it.
- How deep to go on Data Processing Engine formula syntax — kept conceptual here; full syntax reference belongs in a future Apex/Flow-adjacent technical appendix, not this conceptual file.

## Next Steps
- Build `04_Architecture_Patterns.md`, mapping each concept above onto the six anchor scenarios.
- Confirm Code Extension (Beta) and Clean Rooms (GA) status hasn't shifted by Summer '26 before reusing this file unchanged.
