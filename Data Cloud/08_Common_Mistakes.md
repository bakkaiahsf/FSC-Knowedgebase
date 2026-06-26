# 08_Common_Mistakes

## Folder
Data Cloud

## Purpose
Implementation pitfalls observed across the industry (sourced from public Salesforce-ecosystem commentary, not from any specific client engagement), organized by category with the fix for each. All examples are generic/composite — see Confidentiality Guardrail below.

## Confidentiality Guardrail
This repository is **public**. No file in this repository, including this one, names a real client engagement or that client's specific internal object/field/metadata API names. Examples below are generic and industry-typical, not drawn from any named implementation. This rule applies to all future folders in this knowledge base.

## Branding Notes
- Mistakes below apply equally whether the org displays "Data Cloud" or "Data 360" branding — none are rebrand-specific.

## 1. Strategy & Scope Mistakes
- **Starting from ingestion instead of outcomes.** Connecting every available source on day one, before the team has agreed which business outcome (e.g., "reduce time-to-next-best-action") the project serves. *Fix:* define the target Calculated Insight or segment first, then connect only the sources that feed it.
- **Vague success criteria.** "Unify our customer data" isn't a testable goal. *Fix:* state a measurable target tied to one of the anchor scenarios (e.g., "resolve 95% of retail banking individuals to a single Unified Profile within two data-stream refresh cycles").
- **Underestimating non-ingestion effort.** Data mapping, profiling, integration testing, security configuration, and end-user training are frequently under-scoped relative to the (more visible) connector setup work. *Fix:* budget explicit project time for each of these, not just "connect the sources."

## 2. Data Modeling Mistakes
- **Mapping straight into custom DMOs instead of using standard DMOs where they fit.** This forfeits out-of-the-box compatibility with Calculated Insights, segmentation templates, and Agentforce grounding patterns built against standard objects. *Fix:* default to standard DMOs (Individual, Party, Engagement, etc.); go custom only when a standard DMO genuinely doesn't fit.
- **Treating Data Spaces as an afterthought.** Retrofitting multi-entity/multi-brand partitioning after data has already landed unpartitioned is far more disruptive than designing Data Spaces up front. *Fix:* decide the Data Space strategy (Pattern 4 reasoning in `04_Architecture_Patterns.md`) before the first production data stream runs.

## 3. Identity Resolution Mistakes
- **Using weak identifiers as primary match keys.** Free-text names or frequently-changing values produce both false merges and missed merges. *Fix:* start with deterministic matching on strong identifiers (verified email, government/member ID); add probabilistic matching deliberately and test it against known pairs/non-pairs before trusting it.
- **Assuming the same identifier works identically across every channel.** An identifier that's authoritative in one source system may be unreliable or absent in another. *Fix:* choose the identifier that most authentically represents the customer in each specific source, not a single one-size-fits-all key.
- **Not filtering nonsense data before matching.** Placeholder emails, all-zero phone numbers, and other junk values can create false matches across genuinely unrelated people. *Fix:* blacklist known-bad values before they enter the matching pipeline.
- **Forgetting that shared upstream IDs auto-unify.** If two records already carry the same `Individual ID` from an upstream system, they unify automatically — independent of any ruleset configured in Data Cloud. This causes "why did these merge, I didn't write a rule for that" confusion during testing. *Fix:* check upstream ID assignment logic as part of identity-resolution design review, not only the Data Cloud ruleset.
- **Over-engineering probabilistic matching on day one.** Aggressive fuzzy matching without a tuning/testing cycle tends to over-merge. *Fix:* ship deterministic first, add probabilistic in a second iteration with a documented false-positive/false-negative review.

## 4. Segmentation & Activation Mistakes
- **Building one large, complex segment instead of several simple ones.** Overly sophisticated nested logic confuses the business users who have to interpret or maintain it. *Fix:* start with 3–5 simple, well-defined segments; use guided templates (Einstein Segment Recipes) before hand-building complex logic.
- **No downstream capacity check before activation.** Activating a large next-best-action segment straight to an advisor/agent queue without checking downstream capacity creates an operational bottleneck, not a business win. *Fix:* size the segment against realistic downstream handling capacity before publishing.

## 5. Cost & Governance Mistakes
- **Ingesting and re-resolving identity on data that only needed federation.** Running full ingestion plus Identity Resolution on large, slow-changing external data (e.g., a core ledger) when Zero Copy federation would have answered the same business question far more cheaply. *Fix:* apply the Pattern 4 decision test from `04_Architecture_Patterns.md` — does this data need to participate in identity resolution, or only need to be queried/joined?
- **No one watching consumption.** Credit-based pricing means an unmonitored, overly broad ingestion or identity-resolution schedule can silently run up cost. *Fix:* monitor consumption (the platform's usage-tracking tooling) from week one of a production rollout, not only at renewal time.
- **Treating Data Spaces as purely technical instead of also a compliance control.** Multi-entity/regulated organizations that don't map Data Spaces to actual legal-entity or data-residency requirements risk a compliance gap dressed up as a technical partition. *Fix:* have compliance/legal sign off on the Data Space-to-entity mapping, not just the architecture team.

## 6. Training & Adoption Mistakes
- **Teaching Data Cloud as "just another Salesforce object model."** Learners who skip Identity Resolution and Calculated Insight concepts and jump straight to building segments produce technically-working but conceptually-shaky solutions. *Fix:* enforce the learning path order in `02_Learning_Path.md` — ingestion/modeling before unification before insight before activation.

## Open Decisions
- Overlap with `05_Hands_On_Labs.md` Troubleshooting sections is intentional (same pitfalls reinforced two ways) — flag if this duplication should instead be consolidated into a single cross-referenced source.
- Confidentiality guardrail (above) must be re-applied verbatim to every future folder in this repository — do not relax it for folders that feel "less sensitive" than Financial Services Cloud or Data Cloud.

## Next Steps
- Build `09_Whats_New.md` next, citing sources per the master prompt's requirement.
