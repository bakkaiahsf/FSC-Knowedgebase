# 06_Interview_Questions

## Folder
Data Cloud

## Purpose
Interview-style Q&A across Beginner, Intermediate, and Advanced tiers. Answers are deliberately concise — expand verbally in an actual interview using `03_Key_Concepts.md` and `04_Architecture_Patterns.md` for supporting depth.

## Branding Notes
- A candidate may say "Data Cloud" or "Data 360" — both are correct; the rename took effect October 14, 2025 and didn't change underlying functionality. Don't penalize either term.

## Beginner

**Q1. What is Data Cloud / Data 360, in one sentence?**
A: Salesforce's data unification and AI-context layer — it ingests data from many sources, harmonizes it into a common model, resolves duplicate identities, and makes the result usable for analytics, segmentation, and Agentforce.

**Q2. What's the difference between a Data Lake Object (DLO) and a Data Model Object (DMO)?**
A: A DLO is raw, source-shaped staging data; a DMO is the harmonized, standard-schema version that segmentation/insights/activation actually query. Mapping connects DLO fields to DMO fields.

**Q3. What is a Data Space used for?**
A: Partitioning an org's Data Cloud environment — by brand, business unit, region, or legal entity — for both data isolation and access governance.

**Q4. Name two ways data gets into Data Cloud.**
A: Scheduled/near-real-time Data Streams from connected sources (CRM, external systems), and direct file or streaming ingestion (CSV, Ingestion API, Web/Mobile SDK).

**Q5. What happened to "Data Cloud" as a product name?**
A: Renamed to **Data 360** on October 14, 2025, as part of the Agentforce 360 platform positioning. Same product, new name and narrative (data layer feeding AI agents).

## Intermediate

**Q6. Explain Identity Resolution and why deterministic matching is usually the safer starting point.**
A: Identity Resolution merges records representing the same real-world entity into a Unified Individual, using match rules. Deterministic matching (exact match on strong identifiers like verified email or a government ID) is predictable and auditable; probabilistic/fuzzy matching is more powerful on messy data but risks both false merges and missed merges if not carefully tuned and tested.

**Q7. What's a Reconciliation Rule, and why is it needed even after a match is found?**
A: When two matched records disagree on a field's value (e.g., two different phone numbers), the reconciliation rule decides which value wins on the resulting Unified Profile — e.g., "most recently updated source wins."

**Q8. What is a Calculated Insight, and how does batch differ from streaming for one?**
A: A metric or score computed on top of DMOs (e.g., churn risk, lifetime value). Batch recomputes on a schedule (good for slower-moving metrics); streaming recomputes near-real-time as qualifying events land (needed for fast-moving signals).

**Q9. A client says "we connected every system on day one of our Data Cloud project." Is that a good sign?**
A: Usually a red flag. A common implementation mistake is starting from ingestion rather than from a defined business outcome — connecting every available source early creates unnecessary complexity before the team has validated which data actually drives the target use case.

**Q10. What's the role of Activation-Triggered Flows?**
A: They fire automatically the moment a segment publishes or a DMO updates, enabling near-real-time downstream action instead of waiting for the next scheduled segment run.

**Q11. How does Data Cloud typically integrate with Financial Services Cloud?**
A: Data Cloud's Calculated Insights surface on FSC record pages/dashboards; FSC's household/relationship model gets enriched with unified data sourced outside Salesforce; Agentforce templates read Data Cloud's unified profiles as grounding context automatically.

## Advanced

**Q12. When would you choose Zero Copy federation over full ingestion for an external data source, and what's the cost argument?**
A: Choose federation when the source is large, changes slowly relative to engagement data, and doesn't need to participate in Identity Resolution (e.g., a core banking ledger read for balance lookups). Identity Resolution is the most expensive Data Cloud operation by volume — federating avoids re-running it on duplicated copies, and federated queries are dramatically cheaper per row than ingest-plus-resolve.

**Q13. Two individuals who are clearly different people keep merging into one Unified Profile despite no matching rule that should cause it. What do you check first?**
A: Whether the records already share the same upstream `Individual ID` — records sharing an ID unify automatically regardless of ruleset configuration. This is a frequent, non-obvious cause of unwanted merges.

**Q14. Design a Data Space strategy for a multi-entity banking group operating in five countries under separate regulated legal entities.**
A: One Data Space per legal entity (data isolation for regulatory/data-residency reasons) is the conservative default; cross-entity reporting/insights that are explicitly permitted to span entities are built as a separate, intentionally-scoped layer rather than collapsing all entities into one space. Justify any cross-entity merge against the specific regulatory permission, not convenience.

**Q15. How would Dynamic Data Masking apply differently to a human support agent versus an Agentforce agent answering the same customer?**
A: Both should be bound by the same authorization model — masking is evaluated against the requesting identity's clearance, not against whether the requester is human or AI. An Agentforce agent acting in a customer-facing channel should never see more than that channel is authorized to see; if anything, agent grounding queries deserve tighter audit scrutiny since they execute unattended.

**Q16. What changed in Winter '26 / Spring '26 that affects architecture decisions (not just UI)?**
A: Winter '26 added Data Processing Engine improvements (write-back to DMOs, new formula functions) increasing in-platform transform capability. Spring '26 added ready-to-use pre-mapped DLOs (reduces mapping effort), Code Extension Beta (custom Python transforms — opens advanced enrichment/matching use cases without leaving the platform), Clean Rooms GA (governed cross-org joint analysis), and a 12 MB SOQL result-size cap on Data 360 queries (affects how integration code must paginate). All of these should be re-verified against the live release notes before being treated as current.

**Q17. A regulator asks how the bank's "next-best-action" segment logic can be explained. What's your answer architecture, not just policy answer?**
A: Calculated Insights used as segment inputs should be defined once, centrally, with documented input fields and logic (Section 5/11 of `03_Key_Concepts.md`) rather than computed ad hoc per dashboard — this gives a single, inspectable definition to hand to a regulator instead of reverse-engineering five different spreadsheet calculations.

## Open Decisions
- Calibrate answer depth against the actual interview's seniority bar — Advanced answers here are interview-length, not full design-doc length; expand verbally as needed.
- Confirm Q16's release-specific claims against the release notes at delivery time, since this is the fastest-moving content in the file.

## Next Steps
- Build `07_Trainer_Notes.md` using these questions as in-session check-for-understanding prompts.
