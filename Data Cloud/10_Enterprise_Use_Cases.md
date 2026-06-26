# 10_Enterprise_Use_Cases

## Folder
Data Cloud

## Purpose
The folder's deep-format capstone. Eleven use cases, each treated across 13 facets: Business Problem, Actors, Business Process, Data Cloud Architecture, Metadata, Integration, Security, Reporting, FSC/CRM Integration, Agentforce Grounding, Hands-on Lab, Trainer Notes, Assessment Questions. Grounded in verified Data Cloud capabilities from `03_Key_Concepts.md` and `04_Architecture_Patterns.md` — never invented.

## Branding Notes
- "Data Cloud" and "Data 360" used interchangeably; this file was authored post-rebrand (October 14, 2025) and reflects Winter '26/Spring '26 capability.
- Where a use case references FSC objects (e.g., LoyaltyProgramMember, Household), this is the same FSC object vocabulary established in the Financial Services Cloud folder — kept consistent across folders deliberately.

---

## 1. Retail Banking — Unified Customer 360

**Business Problem:** Customer data fragments across core banking, card processing, mobile/online banking, and CRM, preventing a single accurate view of any one customer.

**Actors:** Retail banker, branch ops, data engineer, Data Cloud admin.

**Business Process:** New and existing customer interactions across channels generate records in disparate systems; the bank needs these resolved into one profile before any servicing, marketing, or risk decision can be trusted.

**Data Cloud Architecture:** Pattern 1 from `04_Architecture_Patterns.md` — Data Streams from CRM/core banking/card feeds → DLOs → mapped to standard Individual/Party DMOs (custom DMO extension for account-level detail) → deterministic-first Identity Resolution ruleset → Unified Individual.

**Metadata:** Standard `Individual` DMO; custom `Account_Detail` DMO; Calculated Insight `Engagement_Score`; Identity Resolution ruleset matching on verified email and government/KYC ID.

**Integration:** Data Streams from Salesforce CRM, core banking export (batch or near-real-time), card processor feed; outbound activation to Marketing Cloud.

**Security:** Data Space per legal entity if multi-entity; Dynamic Data Masking on government ID and account numbers; PII auto-tagging enabled.

**Reporting:** Data Cloud dashboards on profile-resolution rate (% of records successfully unified); Tableau Next for cross-channel engagement trend.

**FSC/CRM Integration:** Unified Individual feeds the FSC PersonAccount; resolved profile is queryable from the banker's FSC record page without leaving the CRM.

**Agentforce Grounding:** A service copilot reads the Unified Individual and `Engagement_Score` as grounding context when a customer calls in, avoiding the agent asking the customer to re-state basic facts already known.

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 1 (DLO-to-DMO mapping) is the direct foundation for this use case.

**Trainer Notes:** Use this as the very first use case taught — every other use case in this file assumes a Unified Individual already exists.

**Assessment Questions:** Why map to the standard Individual DMO rather than a custom one for this use case? What's the risk of skipping deterministic matching and going straight to probabilistic?

---

## 2. Commercial Banking — Business Account & Relationship Unification

**Business Problem:** A single business customer (e.g., a mid-market company) appears as unrelated records across treasury services, commercial lending, and merchant services, breaking relationship-level pricing and risk view.

**Actors:** Relationship manager, commercial credit analyst, Data Cloud admin.

**Business Process:** Each commercial product line onboards the business customer independently; the bank needs a unified business-entity view to manage total relationship exposure and cross-sell.

**Data Cloud Architecture:** Variant of Pattern 1, applied to a business/organization entity rather than an individual — DMO mapping targets a `Party` (Organization) DMO instead of `Individual`; Identity Resolution matches on tax ID/registration number rather than personal identifiers.

**Metadata:** Standard `Party` DMO (Organization record type); custom `Commercial_Relationship` DMO; Calculated Insight `Total_Relationship_Exposure`.

**Integration:** Data Streams from treasury services platform, commercial loan origination system, merchant services platform.

**Security:** Data Space alignment to the legal entity holding each lending relationship; masking on credit-line and exposure figures restricted to credit/risk roles.

**Reporting:** Relationship-level exposure dashboard; trend view of total relationship value over time.

**FSC/CRM Integration:** Surfaces on FSC's Business Accounts / Account Plan view as a unified relationship summary rather than per-product fragments.

**Agentforce Grounding:** A relationship-manager copilot answering "what's our total exposure to this client" reads `Total_Relationship_Exposure` directly rather than requiring the RM to manually sum across systems.

**Hands-on Lab:** Extend Lab 1 with an Organization DMO mapping exercise (not separately built in `05_Hands_On_Labs.md` — flagged as a missing lab below).

**Trainer Notes:** Contrast explicitly with Use Case 1 — same architecture pattern, different entity type (Organization vs. Individual) and different identifier strategy.

**Assessment Questions:** Why is tax/registration ID a stronger deterministic identifier for businesses than email is for individuals? What changes in the reconciliation rule when two systems disagree on a company's registered address?

---

## 3. Corporate Banking — Multi-Entity Treasury Data Unification

**Business Problem:** A multinational corporate client's treasury data spans dozens of subsidiary entities and currencies; the bank needs a consolidated view without violating entity-level data residency or regulatory segregation requirements.

**Actors:** Corporate banker, treasury services manager, compliance officer, Data Cloud admin.

**Business Process:** Each subsidiary relationship is managed locally; global relationship managers need a consolidated, permissioned rollup.

**Data Cloud Architecture:** Pattern 4 (Zero-Copy Federation) combined with Pattern 1 — local entity data may be federated rather than fully ingested where regulatory residency requires the data to stay local, with only permitted aggregate Calculated Insights computed centrally.

**Metadata:** `Party` DMO per subsidiary entity, scoped to entity-specific Data Spaces; centrally-computed Calculated Insight `Global_Relationship_Value` built only from explicitly-permitted aggregate fields.

**Integration:** Mix of full ingestion (entities without residency restriction) and Zero Copy federation (entities with data-residency restriction) against regional data platforms.

**Security:** Data Space per subsidiary entity is mandatory here, not optional; compliance sign-off required on which fields are permitted to roll up into the global Calculated Insight.

**Reporting:** Global relationship-value dashboard built only from pre-approved aggregate fields, never raw entity-level detail, for cross-border viewers.

**FSC/CRM Integration:** Surfaces on FSC's Flexible Hierarchies / Account Plan view at the global relationship level, drilling down only as far as the viewer's entity-level permission allows.

**Agentforce Grounding:** A corporate banker copilot answering a global-relationship question is explicitly restricted to the aggregate Calculated Insight — it must not be grounded on entity-level federated data the requesting user isn't permissioned to see directly.

**Hands-on Lab:** Lab 4 (Zero Copy walkthrough) is the direct foundation; no dedicated corporate-banking lab exists yet — flagged below.

**Trainer Notes:** This use case is the clearest place to teach "Data Space is a compliance control, not just a technical partition" from `08_Common_Mistakes.md`.

**Assessment Questions:** Why might full ingestion be the wrong choice for a subsidiary entity even if technically straightforward? What's the audit trail requirement for the central aggregate Calculated Insight's input fields?

---

## 4. Insurance — Policy & Claims Data Unification

**Business Problem:** A carrier's policyholder data is split across policy administration, claims processing, and agent/broker systems, delaying claims handling and obscuring cross-policy risk.

**Actors:** Claims adjuster, underwriter, policyholder service agent, Data Cloud admin.

**Business Process:** A policyholder's claim history, active policies, and risk indicators must be visible together at first notice of loss (FNOL) to route and assess the claim correctly.

**Data Cloud Architecture:** Pattern 1 variant — Data Streams from policy admin and claims systems → DLOs → mapped to Individual DMO plus custom `Policy` and `Claim` DMOs → Identity Resolution unifies the policyholder across policy and claims systems.

**Metadata:** Custom `Policy` DMO, custom `Claim` DMO (mapped from the carrier's source systems — these are Data Cloud DMOs, distinct from FSC's native Insurance Policy/Claim objects referenced in the FSC folder); Calculated Insight `Claim_Frequency_Score`.

**Integration:** Data Streams from policy administration system, claims management system, agent/broker portal.

**Security:** Masking on claim payout amounts and medical-claim detail restricted to authorized claims roles; Data Space segregation if the carrier operates across regulated lines of business (life vs. P&C).

**Reporting:** Claim-frequency and loss-ratio trend dashboards by policy segment.

**FSC/CRM Integration:** Where the carrier also runs FSC's native Insurance objects (InsurancePolicy, Claim, Claim Participant), Data Cloud's unified profile and Calculated Insights enrich those FSC records rather than duplicating them.

**Agentforce Grounding:** A claims-intake copilot at FNOL reads the unified policyholder profile and `Claim_Frequency_Score` to help route the claim and flag potential fraud indicators for human review.

**Hands-on Lab:** No dedicated insurance lab exists yet — flagged below as a priority gap, mirroring the same gap noted in the Financial Services Cloud folder's `10_Enterprise_Use_Cases.md`.

**Trainer Notes:** Explicitly distinguish Data Cloud's custom `Policy`/`Claim` DMOs (used when source data doesn't already live in FSC) from FSC's native Insurance schema (used when the carrier is FSC-native) — conflating the two is a common point of confusion.

**Assessment Questions:** When would a carrier map claims data into Data Cloud custom DMOs versus relying entirely on FSC's native Insurance objects? What's the fraud-detection argument for streaming (not batch) the claim-frequency Calculated Insight?

---

## 5. Wealth Management — Household Net Worth & Advisor Insight

**Business Problem:** Advisors lack a consolidated, accurate view of a household's total relationship (multiple individuals, multiple accounts, multiple entities) needed for suitable advice and prioritized outreach.

**Actors:** Financial advisor, household member/client, Data Cloud admin.

**Business Process:** Individual family members hold accounts across the firm (and sometimes externally); the advisor needs household-level insight to prioritize time and tailor advice.

**Data Cloud Architecture:** Pattern 2 (Household Identity Resolution) feeding Pattern 5 (Calculated Insights) — Unified Individuals grouped into a household construct; `Household_Net_Worth` and `Household_Engagement_Trend` Calculated Insights computed at the household grouping level.

**Metadata:** Household-level grouping logic over the `Individual` DMO; Calculated Insights `Household_Net_Worth`, `Advisor_Contact_Recency`.

**Integration:** Data Streams from custodial/account platforms, external account aggregation feed (if the firm supports held-away asset visibility), CRM.

**Security:** Household aggregation must respect that adult household members may be financially independent — reconciliation logic should never silently merge independent adults without an explicit relationship signal (per `08_Common_Mistakes.md` and Pattern 2's security note).

**Reporting:** Advisor-facing household summary dashboard; firm-level book-of-business concentration view.

**FSC/CRM Integration:** Feeds FSC's Household Management and Wealth Household View directly — Data Cloud resolves the matching, FSC holds the servicing relationship (Pattern 2's stated division of responsibility).

**Agentforce Grounding:** An advisor copilot answering "which of my households need attention this week" reads `Household_Net_Worth` and `Advisor_Contact_Recency` as grounding context (this is the direct scenario built in `05_Hands_On_Labs.md` Lab 5).

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 2 (household identity resolution), Lab 3 (Calculated Insight + segment), and Lab 5 (capstone with Agentforce framing) together cover this use case end to end.

**Trainer Notes:** This is the folder's most fully-lab-supported use case — use it as the worked example when teaching the full ingestion-to-activation chain.

**Assessment Questions:** What signal would you require before merging two adults at the same address into one household, and why is "shared address alone" insufficient? How does `Advisor_Contact_Recency` change the segmentation logic in Use Case 6 below?

---

## 6. Financial Planning — Goals-Based Calculated Insights

**Business Problem:** Clients set financial goals (retirement, education funding, home purchase) that exist in planning tools disconnected from the firm's broader unified profile, so progress tracking and proactive advice are manual.

**Actors:** Financial planner, client, Data Cloud admin.

**Business Process:** Goal data lives in a financial-planning tool; account/balance data lives elsewhere; the planner needs goal-progress visibility alongside the client's full unified financial picture.

**Data Cloud Architecture:** Pattern 1 ingestion of planning-tool goal data into a custom `Financial_Goal` DMO, joined at query time against the Unified Individual and account-balance DMOs to compute a `Goal_Progress_Score` Calculated Insight.

**Metadata:** Custom `Financial_Goal` DMO (goal type, target amount, target date); Calculated Insight `Goal_Progress_Score`.

**Integration:** Data Stream from the financial-planning tool; join against existing account/balance DMOs already populated for Use Case 1/5.

**Security:** Goal and balance data are sensitive personal financial information — apply the same Dynamic Data Masking posture as account-level data elsewhere in this file.

**Reporting:** Goal-progress dashboard per client, aggregated goal-achievement trend across the planner's book.

**FSC/CRM Integration:** Surfaces goal-progress on the FSC advisor record page alongside the household view from Use Case 5.

**Agentforce Grounding:** A planning copilot answering "is this client on track for retirement" reads `Goal_Progress_Score` directly instead of the planner manually cross-referencing two systems.

**Hands-on Lab:** No dedicated lab exists yet — flagged below; would extend Lab 3's Calculated Insight pattern to a goals dataset.

**Trainer Notes:** Use this use case to reinforce that Calculated Insights can join across DMOs originally built for different use cases (goal data + balance data) — insight composability is the teaching point, not new ingestion mechanics.

**Assessment Questions:** Why is this a Calculated Insight problem rather than a new Identity Resolution problem? What would change if goal tracking needed to be near-real-time instead of nightly batch?

---

## 7. Customer Service — Service Copilot Grounding

**Business Problem:** Service agents (human or AI) lack a single accurate view of the customer at the start of an interaction, leading to repeated questions, slow resolution, and inconsistent answers.

**Actors:** Contact-center agent, customer, Data Cloud admin, Agentforce admin.

**Business Process:** A customer contacts service via phone, chat, or self-service; the handling agent (or Agentforce agent) needs immediate, accurate context to resolve the inquiry in one interaction.

**Data Cloud Architecture:** Pattern 6 (Data-Grounded Agentforce Actions) directly — Unified Individual, relevant Calculated Insights, and (where configured) Intelligent Context over unstructured case history are surfaced as grounding at conversation start.

**Metadata:** Unified `Individual` DMO; Calculated Insight `Engagement_Score`; Tableau Semantics governed metric layer for consistent metric definitions across human dashboards and agent grounding.

**Integration:** Data Streams already established for Use Case 1; case-history data optionally ingested for Intelligent Context grounding.

**Security:** Dynamic Data Masking is the central control here — the agent (human or AI) must see only what the specific service channel is authorized to expose, audited the same way as human report access.

**Reporting:** First-contact-resolution rate correlated against grounding-context completeness; agent-handle-time trend.

**FSC/CRM Integration:** Surfaces directly in the Service Console alongside FSC record context for financial-services-specific service interactions.

**Agentforce Grounding:** This use case *is* the Agentforce grounding pattern — see `04_Architecture_Patterns.md` Pattern 6 for the full data-flow detail.

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 5's discussion section covers this directly; no separate graded lab exists yet (Agentforce-side configuration is out of scope for this folder and belongs to the future Agentforce folder).

**Trainer Notes:** Be explicit that the *data* readiness (this folder) and the *agent* configuration (future Agentforce folder) are separate workstreams that must both be done well — good grounding data with poor agent configuration still fails, and vice versa.

**Assessment Questions:** What's the audit argument for treating agent grounding queries with at least as much scrutiny as human report access? Which fields from Use Case 1's Unified Individual should never be exposed to a self-service channel agent?

---

## 8. Marketing & Activation — Next-Best-Offer Segmentation

**Business Problem:** Marketing and advisory outreach is generic rather than targeted to genuinely high-propensity moments, wasting outreach capacity and annoying low-fit customers.

**Actors:** Marketing operations, advisor/banker, Data Cloud admin.

**Business Process:** The bank wants to identify and act on specific signals (e.g., rising balance with no recent advisor contact) rather than blanket campaigns.

**Data Cloud Architecture:** Pattern 3 (Next-Best-Action Segmentation & Activation) directly — this is the architecture pattern's worked business use case, built hands-on in `05_Hands_On_Labs.md` Lab 3.

**Metadata:** Calculated Insights `Balance_Trend_90d`, `Advisor_Contact_Recency`; Segment definition combining both.

**Integration:** Activation Target to Marketing Cloud (for marketing-led outreach) or to an FSC Flow (for advisor-led outreach) depending on the segment's intended channel.

**Security:** Document the business justification for each segment used for differential customer treatment — fair-lending/suitability regulatory exposure applies to financial-services next-best-offer logic specifically.

**Reporting:** Segment-to-conversion-rate dashboard; comparison of advisor-led vs. marketing-led activation outcomes.

**FSC/CRM Integration:** Advisor-led activation path creates tasks directly on the FSC Action Plan / Workspace, as built in Lab 5.

**Agentforce Grounding:** An Agentforce action can itself be the activation target — e.g., automatically drafting (not sending) a personalized outreach note for advisor review when a customer enters the segment.

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 3 and Lab 5.

**Trainer Notes:** Use this use case to teach the segment-simplicity principle from `08_Common_Mistakes.md` — 3–5 well-defined segments, not one sprawling rule set.

**Assessment Questions:** What's the regulatory argument for documenting segment logic even when no regulator has asked yet? Why activate to an advisor task queue instead of directly to an automated marketing send for this specific signal?

---

## 9. Risk & Fraud — Real-Time Risk Scoring

**Business Problem:** Fraud and credit-risk signals need to be assessed in near-real-time against a unified view of the customer, not batch-processed after the risk window has passed.

**Actors:** Fraud analyst, risk officer, Data Cloud admin.

**Business Process:** Transaction and behavioral signals stream in continuously; the bank needs an up-to-the-moment risk score, not yesterday's batch number.

**Data Cloud Architecture:** Pattern 5 (Calculated Insights), streaming variant — `Real_Time_Risk_Score` Calculated Insight recomputes on streaming cadence as qualifying transaction events land, rather than nightly batch.

**Metadata:** Calculated Insight `Real_Time_Risk_Score` (streaming); supporting DMOs for transaction-event data.

**Integration:** Streaming ingestion (Ingestion API) from transaction-monitoring systems rather than scheduled batch Data Streams.

**Security:** Highest sensitivity tier in this file — risk-score inputs and outputs restricted to fraud/risk roles; explainability documentation is a regulatory expectation, not optional, per `03_Key_Concepts.md` Section 11 and the Pattern 5 security note in `04_Architecture_Patterns.md`.

**Reporting:** Real-time risk dashboard for fraud operations; false-positive/false-negative rate tracking for the scoring model over time.

**FSC/CRM Integration:** Risk score surfaces as an alert on the relevant FSC record (account, transaction journal context) for the banker/risk officer reviewing the case.

**Agentforce Grounding:** A fraud-triage copilot reads `Real_Time_Risk_Score` to help prioritize the analyst's queue — but final action (blocking a transaction, freezing an account) remains a human decision, not an autonomous agent action, given the financial and customer-trust stakes.

**Hands-on Lab:** No dedicated streaming-Calculated-Insight lab exists yet — flagged below; would need a simulated streaming event source, which most trial orgs won't have readily available.

**Trainer Notes:** Use this use case to contrast batch vs. streaming Calculated Insights concretely — Use Case 6 (goals, batch-appropriate) versus this one (risk, streaming-appropriate) makes the distinction tangible.

**Assessment Questions:** Why must a human remain in the loop for the action this score triggers, even though the score itself is computed automatically? What's the cost tradeoff of streaming versus batch for this specific signal, referencing the credit-consumption model in `03_Key_Concepts.md`?

---

## 10. Zero-Copy Core Systems Federation

**Business Problem:** Core banking ledger or policy-administration data is too large, too sensitive, or too slow-changing relative to engagement data to justify full ingestion and re-resolution into Data Cloud.

**Actors:** Data architect, core-banking system owner, Data Cloud admin.

**Business Process:** A business question (e.g., a segment condition or Calculated Insight) needs a current core-system value (account balance, policy status) without that system's data being duplicated into Data Cloud.

**Data Cloud Architecture:** Pattern 4 (Zero-Copy Federation) directly — this use case *is* the architecture pattern's worked example, built as a guided walkthrough in `05_Hands_On_Labs.md` Lab 4.

**Metadata:** No new DLO/DMO created for the federated table; the federated table is referenced directly in joins from segments/Calculated Insights against existing Unified Individual DMOs.

**Integration:** Zero Copy connection to Snowflake/Databricks/BigQuery/Redshift via the Zero Copy Partner Network; bidirectional — Data Cloud can also expose unified profiles/segments for the warehouse side to query.

**Security:** The warehouse-side trust boundary is independent of Data Cloud's Data Space governance — must be verified separately, not assumed covered.

**Reporting:** Query-performance and credit-cost comparison dashboard (federation vs. ingestion) to justify the architecture choice to stakeholders.

**FSC/CRM Integration:** Avoids duplicating a system of record's data purely for FSC read access — the ledger/policy-admin system stays the system of record.

**Agentforce Grounding:** An agent answering a balance-lookup question can be grounded on the federated query result directly, with the same masking rules applied as if the data had been ingested.

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 4.

**Trainer Notes:** This is the use case where the credit-cost argument (Identity Resolution is the expensive operation; federation avoids re-running it on duplicates) lands most concretely — bring the numbers from `03_Key_Concepts.md` Section 11 (verified at delivery time) into this discussion.

**Assessment Questions:** What's lost, if anything, by not running Identity Resolution on the federated data? Under what condition would you reverse this decision and ingest the data after all?

---

## 11. Agentforce-Grounded Advisor/Banker Copilot (Cross-Cutting Capstone)

**Business Problem:** Advisors and bankers need a single AI-assisted workspace that draws on unified profile, household, risk, and next-best-action signals together — not five separate dashboards.

**Actors:** Advisor, banker, client, Data Cloud admin, Agentforce admin.

**Business Process:** The advisor asks a natural-language question ("which clients need attention this week, and why"); the answer requires synthesizing Use Cases 1, 5, 8, and 9's data simultaneously.

**Data Cloud Architecture:** Pattern 6, composed on top of every other pattern in this file — the copilot's grounding context is the union of Unified Individual/Household DMOs, the relevant Calculated Insights (`Engagement_Score`, `Household_Net_Worth`, `Balance_Trend_90d`, `Real_Time_Risk_Score` where relevant), and governed metric definitions via Tableau Semantics.

**Metadata:** No new DMOs — this use case is an integration/composition exercise over metadata already defined in Use Cases 1–9.

**Integration:** No new Data Streams required if Use Cases 1–9 are already built; this is purely an Agentforce-grounding-configuration exercise on top of existing Data Cloud assets.

**Security:** The strictest-applicable masking rule from any contributing use case applies — e.g., if risk-score data is restricted to risk roles, the copilot must not surface it to an advisor without that authorization, even if the advisor is otherwise authorized for the household and engagement data.

**Reporting:** Advisor productivity and client-outcome correlation dashboard, measuring whether grounded-copilot-assisted advisors outperform ungrounded baseline.

**FSC/CRM Integration:** This is the natural full-circle use case connecting every FSC tie-in noted across Use Cases 1–9 into one advisor-facing experience.

**Agentforce Grounding:** This use case *is* the Agentforce grounding story for this entire folder — intentionally positioned last as the capstone that the Agentforce folder (next in the STOS build sequence) will pick up and go deep on from the agent-configuration side.

**Hands-on Lab:** `05_Hands_On_Labs.md` Lab 5 is the closest existing lab; a fuller capstone lab combining all nine prior use cases' data is a candidate for either this folder's future revision or the Agentforce folder's hands-on labs.

**Trainer Notes:** Deliver this use case last, explicitly as a bridge — tell the cohort "everything from here forward about *configuring the agent itself* lives in the next folder; everything about *the data the agent reads* lives in what we just covered."

**Assessment Questions:** Which specific Calculated Insights and DMOs would this copilot need read access to, and which masking rule is the binding constraint? How would you explain to a compliance officer that this copilot's answers are auditable and explainable rather than a black box?

---

## Missing Labs Identified
1. Organization/business-entity DMO mapping lab (Use Case 2)
2. Multi-entity Zero-Copy + Data Space compliance lab (Use Case 3)
3. Insurance policy/claims DMO mapping lab (Use Case 4) — same gap independently flagged in the Financial Services Cloud folder
4. Goals-based Calculated Insight lab joining across existing DMOs (Use Case 6)
5. Streaming Calculated Insight lab with a simulated streaming source (Use Case 9)
6. Full nine-use-case composed capstone lab for the Agentforce-grounded copilot (Use Case 11) — likely belongs partly to the future Agentforce folder

## Missing Architecture Patterns Identified
- A dedicated pattern for streaming ingestion via the Ingestion API / Web-Mobile SDK was referenced in `03_Key_Concepts.md` but not given its own numbered pattern in `04_Architecture_Patterns.md` — Use Case 9 surfaced this gap concretely.
- A dedicated pattern for Clean Rooms (cross-organization joint analysis, Spring '26 GA) has no architecture pattern yet — no use case in this file currently requires it, but it's a plausible near-term addition (e.g., a bank and a card network analyzing combined fraud signals).

## Missing Interview Questions Identified
- No question in `06_Interview_Questions.md` currently tests the batch-vs-streaming Calculated Insight tradeoff as concretely as Use Case 9 does here — candidate addition for that file's Advanced tier.

## Missing Trainer Material Identified
- `07_Trainer_Notes.md` does not yet have a dedicated section bridging into the future Agentforce folder the way Use Case 11 does here — candidate addition once the Agentforce folder build begins.

## Open Decisions
- **Scope boundary**: Use Cases 3 (Corporate Banking) and 4 (Insurance) extend beyond this folder's six anchor scenarios, mirroring the identical scope-extension decision flagged in the Financial Services Cloud folder's `10_Enterprise_Use_Cases.md`. Recommend resolving both folders' scope-boundary questions together at the same review checkpoint rather than separately.
- **Depth ceiling for use cases without labs**: six of eleven use cases above reference a "missing lab" rather than an existing one. Decide whether this folder ships now with those gaps documented (current approach) or whether lab-building should block folder completion.

## Next Steps
- Commit all 11 Data Cloud files to GitHub and verify each individually.
- Hold for user review before starting the Agentforce folder, per the master prompt's stop-after-each-folder rule — Use Case 11 above is the explicit handoff point.
