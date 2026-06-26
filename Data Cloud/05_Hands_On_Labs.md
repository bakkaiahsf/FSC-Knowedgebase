# 05_Hands_On_Labs

## Folder
Data Cloud

## Purpose
Five labs, each following: Objective → Business Scenario → Org Prerequisites → Step-by-Step Configuration → Validation → Troubleshooting → Discussion Questions. Labs 1–3 and 5 are runnable in a standard Data Cloud trial/sandbox org. Lab 4 (Zero Copy) requires an external warehouse trial and is written as a guided walkthrough since most trainees won't have one provisioned — discussion questions substitute for hands-on access where needed.

## Branding Notes
- UI labels reflect Data Cloud as documented through Winter '26 / Spring '26. If your org displays "Data 360" branding instead of "Data Cloud," the menu structure and steps below are unaffected — only the name changed.

---

## Lab 1 — Connect a Data Source and Map a DLO to a DMO

**Objective:** Stand up a working Data Stream from a CRM object into Data Cloud, and map the resulting Data Lake Object to a standard Data Model Object.

**Business Scenario:** A retail bank wants Contact records from its Salesforce CRM org to feed the Customer 360 Data Model as a first step toward a Unified Customer Profile (Pattern 1 in `04_Architecture_Patterns.md`).

**Org Prerequisites:**
- Data Cloud (Data 360) provisioned on the org (Starter or trial SKU)
- System Administrator or Data Cloud Admin permission set
- A Salesforce CRM connection already authorized as a Data Source, or a CSV of sample contact data if no CRM org is available

**Step-by-Step Configuration:**
1. In Data Cloud, navigate to **Data Streams** and click **New**.
2. Select the CRM connection (or **File-based source** for the CSV option) and choose the **Contact** object.
3. Set the refresh schedule (start with a manual/on-demand run for the lab).
4. Save — Data Cloud creates the corresponding Data Lake Object (e.g., `Contact_DLO`) automatically.
5. Navigate to **Data Model**, locate the standard **Individual** DMO.
6. Open **New Mapping**, select `Contact_DLO` as the source and `Individual` as the target DMO.
7. Map fields: `Email` → `Email Address`, `FirstName`/`LastName` → corresponding Individual name fields, `Phone` → `Phone Number`.
8. Save the mapping and run the Data Stream.

**Validation:**
- Confirm the Data Stream run completes with a success status and a non-zero row count.
- Open **Data Explorer**, query the Individual DMO, and confirm the mapped Contact records appear with correctly populated fields.

**Troubleshooting:**
- *Stream completes but DMO is empty*: check the mapping was saved before the stream ran — mappings created after a stream run don't retroactively apply until the next run.
- *Fields show blank after mapping*: confirm source field data types are compatible with target DMO field types; type mismatches silently fail rather than erroring loudly.

**Discussion Questions:**
- Why does Data Cloud keep the raw DLO instead of mapping directly into the DMO?
- What would change about this lab if the source were a high-volume streaming event source instead of a scheduled CRM pull?

---

## Lab 2 — Identity Resolution Ruleset for Household Matching

**Objective:** Build and test a multi-rule Identity Resolution ruleset that both deduplicates Individual records and groups matched individuals toward a household-level view.

**Business Scenario:** The bank has two Individuals — "Maria Lopez" (CRM Contact) and "M. Lopez" (mobile app signup) — that are the same person, plus a second adult at the same address who is a separate, financially independent household member. The lab must merge the first pair without incorrectly merging the second.

**Org Prerequisites:**
- Completed Lab 1 (Individual DMO populated with at least 4 sample records: 2 representing the same person via different sources, 2 representing a second person at the same address)
- Data Cloud Identity Resolution permission

**Step-by-Step Configuration:**
1. Navigate to **Identity Resolution**, click **New Ruleset**, select the **Individual** DMO.
2. Add **Match Rule 1 (deterministic)**: match on exact `Email Address`.
3. Add **Match Rule 2 (deterministic)**: match on exact `Phone Number`.
4. Deliberately omit a name-only or address-only match rule for this lab — this is the control that prevents the two different household members from merging.
5. Configure a **Reconciliation Rule**: "most recently updated source wins" for conflicting fields like `Mailing Address`.
6. Save and run the ruleset.

**Validation:**
- Confirm "Maria Lopez" and "M. Lopez" resolve into a single Unified Individual (same Unified ID).
- Confirm the second household member remains a separate Unified Individual — not merged, despite the shared address.
- Inspect the reconciled `Mailing Address` field and confirm it reflects the most recently updated source per the reconciliation rule.

**Troubleshooting:**
- *Two different people merged unexpectedly*: check whether a shared `Individual ID` already existed upstream — records sharing an ID unify automatically regardless of ruleset logic, which is a frequent surprise (see `08_Common_Mistakes.md`).
- *Same person didn't merge*: verify the email/phone values aren't stored with inconsistent formatting (e.g., `+1` prefix on one record only) — deterministic matching requires literal equality.

**Discussion Questions:**
- Why is "same address" a dangerous sole signal for matching individuals into one profile, but a reasonable signal for grouping individuals into a household?
- How would you extend this ruleset if the bank later wanted probabilistic matching for a messier, multi-country dataset?

---

## Lab 3 — Calculated Insight + Segment for Next-Best-Action

**Objective:** Build a Calculated Insight scoring engagement, then build a segment that uses it to identify a next-best-action audience.

**Business Scenario:** The bank wants to identify wealth clients with rising account balances but no advisor contact in 90 days, to feed an advisor outreach queue (Pattern 3 and Pattern 5).

**Org Prerequisites:**
- Unified Individual DMO from Lab 2
- Sample transaction/balance history DLO mapped to a DMO (or simulated with a small CSV: balance snapshots over time, plus a "last advisor contact date" field)

**Step-by-Step Configuration:**
1. Navigate to **Calculated Insights**, click **New**.
2. Define the metric: `Balance_Trend_90d` = (current balance − balance 90 days ago) on the transaction/balance DMO, grouped by Unified Individual.
3. Set the run cadence to **Batch, nightly** for the lab.
4. Save and run once manually to populate initial values.
5. Navigate to **Segments**, click **New Segment** (or use an **Einstein Segment Recipe** template if available in your org).
6. Build the condition: `Balance_Trend_90d > 0` AND `Last_Advisor_Contact_Date` older than 90 days.
7. Publish the segment.

**Validation:**
- Confirm the Calculated Insight populated non-null values for all Unified Individuals with transaction history.
- Confirm the segment's member count is non-zero and excludes individuals contacted within 90 days.

**Troubleshooting:**
- *Calculated Insight returns null for everyone*: check the DMO grouping key matches the Unified Individual ID, not the original source-system ID.
- *Segment count is zero*: loosen the date condition temporarily to confirm the underlying data has any qualifying dates, then tighten back.

**Discussion Questions:**
- Why batch this Calculated Insight nightly rather than streaming, given balances don't change every second?
- What's the business risk of activating this segment without an advisor capacity check downstream?

---

## Lab 4 — Zero Copy Federation Walkthrough (Guided, No Hands-On Org Required)

**Objective:** Understand the configuration sequence for Zero Copy Live Query against an external warehouse, without requiring a provisioned Snowflake/Databricks trial for every trainee.

**Business Scenario:** Core banking ledger data lives in Snowflake. The bank wants Data Cloud to query current account balances at request time for use in a segment, without ingesting and re-resolving identity on the full ledger.

**Org Prerequisites:**
- Conceptual only for this lab: an existing Snowflake (or Databricks/BigQuery/Redshift) account with a service account/role Data Cloud can authenticate as
- Data Cloud Zero Copy connector enabled (org-level setup, typically done once by a platform admin)

**Step-by-Step Configuration (walkthrough, not graded hands-on):**
1. In Data Cloud, navigate to **Data Sources** → **Add Connection** → select the warehouse type (Snowflake, Databricks, BigQuery, or Redshift).
2. Authenticate using the warehouse's federated credential mechanism (never type a warehouse password directly into a shared lab environment).
3. Select the specific schema/tables to expose for federation — typically the ledger balance table.
4. Confirm "Federated" (not "Ingested") is selected as the connection mode — this is the setting that keeps the data as a live query rather than a copy.
5. Reference the federated table in a segment or Calculated Insight join, alongside the existing Unified Individual DMO.

**Validation (discuss, don't execute, if no warehouse access):**
- A successful federated join returns current ledger balances without a corresponding DLO appearing in Data Cloud's own storage.
- Query latency reflects the external warehouse's performance, not Data Cloud's ingestion pipeline.

**Troubleshooting:**
- *Federated join times out*: large warehouse tables without appropriate indexing/clustering on the join key will be slow regardless of Zero Copy — this isn't a Data Cloud-side problem to fix.
- *Permission denied*: the warehouse-side service account/role needs explicit grant on the specific schema, not just account-level access.

**Discussion Questions:**
- Why is identity resolution still run only on the Data Cloud side, never pushed down into the federated warehouse query?
- What's the cost tradeoff between federating the ledger table versus ingesting it nightly as a DLO?

---

## Lab 5 — Capstone: End-to-End with Activation and Agentforce Grounding

**Objective:** Chain Labs 1–3 into a single flow that ends in an activation, and describe how the same Unified Profile/Calculated Insight would ground an Agentforce action.

**Business Scenario:** Combine the prior labs: ingest → unify → score → segment → activate to an advisor queue, then connect that to a future Agentforce advisor-copilot scenario.

**Org Prerequisites:** Completed Labs 1–3.

**Step-by-Step Configuration:**
1. Confirm the Lab 3 segment (`Balance_Trend_90d` + stale advisor contact) is published.
2. Navigate to **Activation**, create a **New Activation Target** pointed at a Flow (or, if available, an FSC-side queue/task creation Flow).
3. Build an **Activation-Triggered Flow** that fires on segment publish and creates an advisor task/alert record per segment member.
4. Run the activation manually for the lab and confirm task records are created.
5. (Discussion only, no build required) Describe how an Agentforce advisor-copilot topic would be configured to read the same Unified Individual + `Balance_Trend_90d` Calculated Insight as grounding context when an advisor asks the agent "which of my clients need outreach this week?"

**Validation:**
- Confirm one task/alert record exists per segment member after the activation runs.
- Walk through, in writing, exactly which fields an Agentforce grounding configuration would need read access to in order to answer the advisor's question accurately — and which fields it should be masked from (e.g., full account number).

**Troubleshooting:**
- *Activation runs but creates no records*: check the Activation-Triggered Flow's entry criteria match the segment's actual publish event, not a different trigger object.
- *Duplicate tasks per member*: check whether the Flow is configured to run once per publish event or incorrectly re-fires on every DMO update.

**Discussion Questions:**
- At what point in this five-lab chain would a credit-consumption-conscious architect choose to batch versus stream, and why?
- If this exact capstone were rebuilt for an Insurance carrier instead of a bank, which DMOs/Calculated Insights would change, and which architecture pattern stays identical?

## Open Decisions
- Lab 4's "guided, not hands-on" format is a deliberate accommodation for trainees without warehouse trial access — flag whether the trainer's actual cohort has Snowflake/Databricks trial access, in which case Lab 4 should be upgraded to a fully graded hands-on lab.
- Whether to add a sixth lab specifically on Clean Rooms or Notebook AI (Spring '26 GA features) — held back for now pending confirmation these are available in standard trial orgs.

## Next Steps
- Build `06_Interview_Questions.md`, drawing scenario material directly from these five labs.
- Validate Lab 1–3 and Lab 5 end-to-end in an actual Data Cloud trial org before delivering to a live cohort — this file has not been execution-tested against a live org, only designed against documented capabilities.
