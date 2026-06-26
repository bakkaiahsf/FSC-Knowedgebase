# 04_Architecture_Patterns

## Folder
Data Cloud

## Purpose
Reference architectures for each of the six anchor scenarios, showing how the concepts in `03_Key_Concepts.md` compose into an end-to-end design. Each pattern lists: trigger/problem, components, data flow, FSC integration point, and security notes.

## Branding Notes
- "Data Cloud" and "Data 360" used interchangeably per `00_README.md` convention.
- The "engagement layer + unification layer + integration layer" framing below (FSC / Data Cloud / MuleSoft) reflects a commonly observed implementation pattern in banking, not a Salesforce-mandated architecture — treat it as a starting reference, not the only valid design.

## Pattern 1 — Unified Customer Profile (Retail Banking Customer 360)
**Problem:** A retail bank's customer data is fragmented across core banking, card processing, the mobile app, and CRM — no single accurate view of "who is this customer."

**Components:** Data Streams (CRM, core banking export, card processor feed) → DLOs → mapped to standard Individual/Party DMOs (custom DMO extensions for account-level detail) → Identity Resolution ruleset → Unified Individual.

**Data flow:** Source systems land in DLOs on a scheduled or near-real-time stream → mapping normalizes into DMOs → IDR ruleset matches on deterministic identifiers first (verified email, government ID/KYC number) → Unified Profile becomes queryable by segmentation, Calculated Insights, and FSC.

**FSC integration point:** Data 360 Calculated Insights surface directly on FSC's PersonAccount/LoyaltyProgramMember-equivalent record pages; FSC's relationship/household model can be enriched with unified data sourced from systems outside Salesforce.

**Security notes:** Data Space per legal entity/brand if the bank operates multiple regulated entities; PII fields (government ID, account numbers) flagged for Dynamic Data Masking so support agents and AI agents see only what their authorization allows.

## Pattern 2 — Household Identity Resolution
**Problem:** Individuals in the same household (spouses, dependents) are seen as unrelated records, breaking household-level servicing, pricing, and advice.

**Components:** Individual DMO (already unified per Pattern 1) → a Household/Group-level matching ruleset (shared address + shared account linkage + explicit relationship data) → reconciliation rules for household-level fields (e.g., primary mailing address).

**Data flow:** Once individuals are unified, a second-pass ruleset groups Unified Individuals into a household construct, which is then the basis for household-level Calculated Insights (e.g., household net worth) and household-level segments.

**FSC integration point:** This is the natural feed for FSC's Household Management capability — Data Cloud resolves the *matching*, FSC's relationship/household objects hold the *servicing* relationship.

**Security notes:** Household-level data aggregates information about multiple individuals — access control must consider that a household view can expose one family member's financial data to another; reconciliation logic should never silently merge financially-independent adults without an explicit relationship signal.

## Pattern 3 — Next-Best-Action Segmentation & Activation
**Problem:** Marketing and advisory outreach is generic; the bank wants to identify and act on high-value, high-propensity moments (e.g., a wealth client showing rising balances but no recent advisor contact).

**Components:** Unified Individual/Household DMOs → Calculated Insights (engagement score, propensity score, balance trend) → Segment (Einstein Segment Recipe or custom) → Activation Target (Marketing Cloud journey, Flow, or Agentforce action) via Activation-Triggered Flow.

**Data flow:** Calculated Insight recomputes (batch nightly or streaming) → segment membership updates → segment publish triggers Activation-Triggered Flow → downstream system or advisor queue receives the actionable list/event.

**FSC integration point:** Activation Target can be an FSC Flow that creates a task or alert directly on the advisor's Action Plan / Workspace.

**Security notes:** Keep segment logic auditable — finance/wealth segmentation criteria used for differential treatment of customers can carry fair-lending/suitability regulatory exposure; document the business justification for each segment.

## Pattern 4 — Zero-Copy Federation with Core Systems
**Problem:** Core banking or policy administration data is enormous, changes slowly relative to engagement data, and the cost/governance overhead of fully ingesting and re-resolving identity on it isn't justified.

**Components:** Zero Copy Live Query connection to the external warehouse (Snowflake/Databricks/BigQuery/Redshift) holding core banking or policy data → federated query joins against Data Cloud's already-unified profiles at query time → no DLO/DMO copy created for the federated data.

**Data flow:** Query-time pushdown — Data Cloud sends the query to the external platform, results return without a persisted Data Cloud copy; outbound direction lets the external platform's data scientists query Data Cloud's unified profiles/segments directly (e.g., via Databricks zero-copy sharing built on open table formats).

**FSC integration point:** Avoids duplicating a system of record's data (e.g., core banking ledger balances) into Data Cloud purely for read access — the ledger of record stays the ledger of record.

**Security notes:** Federated queries still cross a trust boundary — confirm the external platform's access controls independently; Data Space governance only covers data that has landed in Data Cloud, not the federated source.

## Pattern 5 — Calculated Insights for Risk & Engagement Scoring
**Problem:** The bank wants a consistent, governed definition of "engagement," "churn risk," or "attrition risk" usable everywhere (dashboards, segments, Agentforce), instead of five teams computing it five different ways in spreadsheets.

**Components:** Calculated Insight defined once on top of unified DMOs (and optionally other Calculated Insights, e.g., a risk score that references an engagement score) → exposed to Data Cloud Reports/Dashboards, Tableau Next, segmentation, and Agentforce grounding simultaneously.

**Data flow:** Batch recompute nightly for slower-moving scores (lifetime value); streaming recompute for fast-moving signals (real-time fraud/risk flags) where latency matters.

**FSC integration point:** Same Calculated Insight definition surfaces on the FSC advisor's record page and feeds the Pattern 3 segmentation — single source of truth, not a duplicated metric.

**Security notes:** Document the input fields and logic behind any risk score used for customer-facing decisions (credit, pricing, retention offers) — regulators increasingly expect explainability for automated scoring used in financial services decisioning.

## Pattern 6 — Data-Grounded Agentforce Actions
**Problem:** An Agentforce service or advisor copilot needs accurate, current customer context to avoid hallucinated or stale answers.

**Components:** Unified Individual/Household DMOs + Calculated Insights + (new) Notebook AI / Intelligent Context + Tableau Semantics governed metric layer → Agentforce topic/action reads this as grounding context at conversation time.

**Data flow:** Agent receives a user query → Agentforce retrieves grounding context from Data 360 (unified profile fields, relevant Calculated Insights, and where configured, unstructured context via Intelligent Context) → generates a response/action constrained to that grounded data → Dynamic Data Masking still applies, so the agent only sees what its assigned authorization permits.

**FSC integration point:** This is the forward-looking link to the Agentforce folder (next in the STOS build order) — Data Cloud is positioned as the data substrate Agentforce depends on, not a separate workstream.

**Security notes:** Grounding context must respect the same masking/authorization rules as human users — an agent acting on a customer's behalf should never see more than that customer-facing channel is authorized to see; audit agent grounding queries the same way human report access is audited.

## Open Decisions
- Pattern 4 and Pattern 6 both touch architecture that isn't fully "Data Cloud" in isolation (external warehouse trust boundaries; Agentforce's own grounding configuration). Flagging here that full depth on those edges belongs partly to a future Agentforce folder and partly to Integration/Security folders later in the STOS sequence.
- Whether to add a seventh pattern specifically for Insurance (claims-data unification) given `10_Enterprise_Use_Cases.md` will cover Insurance — current call is to keep architecture patterns scoped to the six anchors and let `10` carry the additional industry breadth.

## Next Steps
- Build `05_Hands_On_Labs.md` with at least one lab per pattern above (or a combined capstone covering multiple patterns).
- Carry Pattern 6's "Agentforce grounding" framing forward verbatim when the Agentforce folder build starts, to keep the two folders consistent.
