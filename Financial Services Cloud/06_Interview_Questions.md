# 06_Interview_Questions

## Folder

Financial Services Cloud

## Purpose

Interview and exam-readiness questions spanning Beginner, Intermediate, Advanced, Scenario-Based, Architecture, and CTA-style difficulty, organized around the same six anchor topics used throughout this folder. Answers are intentionally terse pointers, not full essays — pair this file with `03_Key_Concepts.md` and `04_Architecture_Patterns.md` for the full explanation behind each answer.

## Branding Notes

- "Financial Services Cloud" and "Agentforce Financial Services" are used interchangeably below depending on which framing the question is testing.
- Where a question's answer depends on the current release (e.g., a specific Agentforce skill name), the answer says so explicitly — verify against the latest Salesforce Release Notes before using in a live interview panel or exam.
- Object Model Note: answers below default to legacy `FinServ__`-namespaced object names; if your candidate's org uses the modern standard-object generation, expect equivalent answers using `FinancialAccount`, `FinancialAccountRole`, etc.

---

## 1. Retail Banking Customer 360

**Beginner**
- Q: What is a Person Account, and why does FSC depend on it instead of the standard Account/Contact split?
  A: A Person Account merges Account and Contact into one record so an individual client can be treated as both, which FSC's retail/wealth model requires for relationship and household features. Standard Account/Contact, by contrast, models a business and the people who work there.
- Q: What two objects does a single "client has a checking account" relationship require, beyond the Account itself?
  A: A Financial Account record and a Financial Account Role record linking the client to it with a role such as Owner.

**Intermediate**
- Q: Why is enabling Person Accounts described as irreversible, and what must already exist in the org before you can enable it?
  A: Once enabled it cannot be disabled at the org level; Salesforce requires at least one Business Account record type to already exist before the feature can be turned on.
- Q: A teller-profile user reports they can't see a client's account balance that an advisor can see. What's the most likely first thing to check?
  A: Field-level security on the balance field for the teller's profile/permission set — FLS commonly differs by design between teller and advisor profiles.

**Advanced**
- Q: How would you model a joint checking account with two equal owners without breaking single-owner reporting elsewhere in the org?
  A: Two Financial Account Role records pointing at the same Financial Account, each with role Owner, and reporting logic that aggregates by Financial Account Role rather than assuming one role per account.

**Scenario-Based**
- Q: A bank wants a banker to see every account, the authorized signer on each, and the last three interactions on one screen with no extra clicks. What do you configure?
  A: A Lightning record page with the Financial Accounts related list, Financial Account Role visible on each, and an Interaction Summaries component, activated for the Banker profile/app.

**Architecture**
- Q: Where does the "engagement layer / unification layer / integration layer" reference architecture place FSC itself?
  A: FSC is the engagement layer; Data Cloud (Data 360) is the unification layer; MuleSoft (or equivalent) is the integration layer, per Salesforce's Customer 360 Guide for Retail Banking.

**CTA Style**
- Q: A client has accounts at three legal entities in three countries. How do you decide whether they're "one client" or "three," and what does that decision drive downstream?
  A: This is a Customer 360/identity-resolution decision, not just a UI one — it determines whether Data Cloud match rules unify the records, which in turn determines whether Household rollups, risk scoring, and Agentforce grounding see one client or three. Get this wrong and every downstream feature inherits the fragmentation.

---

## 2. Household Management

**Beginner**
- Q: What record type turns an Account into a Household?
  A: The Household/Group record type.
- Q: What junction object links a member to a Household, and what two fields on it matter most?
  A: `AccountContactRelation`, extended with `FinServ__PrimaryGroup__c` and `FinServ__Role__c`.

**Intermediate**
- Q: A household's balance rollup is short by one member's accounts. What two flags would you check, in order?
  A: First, whether that member's Primary Group is actually set to this household (Edit Relationship); second, whether `FinServ__IncludeInGroup__c` is checked for that member.
- Q: Can a client belong to more than one Household at once?
  A: Yes, as a member of multiple households, but only one of those can be their Primary Group — and only the Primary Group relationship counts toward rollups.

**Advanced**
- Q: Why would an admin choose a scheduled Flow for the balance rollup over a real-time declarative rollup?
  A: At scale, real-time rollups recalculating on every Financial Account change can hit performance/governor limits across thousands of households; a scheduled Flow trades immediacy for predictable, batched load.

**Scenario-Based**
- Q: A married couple wants to be treated as one household for reporting but the bank's compliance team needs each spouse's individual KYC record kept fully separate. How do you reconcile that?
  A: Model them as two distinct Person Accounts (preserving individual KYC/compliance records) joined into one Household via `AccountContactRelation` — the Household is a reporting/relationship lens on top of intact individual records, not a merge of them.

**Architecture**
- Q: What FSC component would you add to a Household record page to visualize members and relationships without the ARC license?
  A: The Relationship Map component — it covers aggregate holding summaries and basic visualization without requiring the Actionable Relationship Center permission.

**CTA Style**
- Q: How would you design Household membership so a client's "primary" household can change (e.g., after a divorce) without losing historical attribution of past transactions to the old household?
  A: Keep `TransactionJournal`/ledger records pointing at the individual client (or the Financial Account, not the Household), and treat Primary Group as a point-in-time relationship attribute — changing it going forward shouldn't rewrite historical journal entries' Household attribution, which should instead be derived at reporting time from an effective-dated relationship history if that level of audit fidelity is required.

---

## 3. Wealth Household View

**Beginner**
- Q: What object holds an individual investment position under a Financial Account?
  A: `FinServ__FinancialHolding__c`.
- Q: What junction object supports a financial goal jointly owned by two people?
  A: `FinancialGoalParty`.

**Intermediate**
- Q: ARC cards aren't rendering for any user. What's the single most common root cause?
  A: One of the three Association Type values (Group, Member, Peer) is inactive — all three must be active or ARC fails to render cards, often silently.
- Q: What two permission sets/permissions does a user need to see the ARC graph?
  A: A clone of the "Financial Services Cloud Extension" permission set (never edit the original) with "Access Actionable Relationship Center" enabled and assigned to the user.

**Advanced**
- Q: A Financial Goal shows 0% progress despite the client's investment account growing substantially. What's the most likely cause?
  A: No Financial Account was linked as a contributing account to the goal — progress is driven only by explicitly linked accounts, not by overall client net worth.

**Scenario-Based**
- Q: A wealth advisor wants to see the client, their spouse, their household, and their estate attorney in one relationship view, with the attorney card sometimes mysteriously missing for certain users. What do you check?
  A: Check the missing user's field-level/object-level access to whatever the attorney's relationship record references — ARC hides cards the user lacks access to rather than erroring, so an FLS/sharing gap looks identical to a config bug.

**Architecture**
- Q: Why does ARC require the Person Account model and not the legacy Individual Model?
  A: ARC's relationship graph is built on Person Account-based relationship records (Account-Account, Account-Contact relations extended for FSC); the legacy Individual Model doesn't carry the same relationship object structure ARC reads from.

**CTA Style**
- Q: A bank wants holdings data to always reflect the custodian's system of record rather than what's manually entered in Salesforce. How does that change your architecture?
  A: Holdings become integration-fed (via MuleSoft or a Data Cloud ingestion pipeline) rather than admin-entered, which shifts the design problem from "build a UI for holdings" to "build a reliable, reconciled sync with the custodian system" — including how you handle sync failures so advisors never act on stale or partial holdings data.

---

## 4. Advisor Workspace

**Beginner**
- Q: What tool do you use to compose a single page combining multiple FSC components?
  A: Lightning App Builder.

**Intermediate**
- Q: An Associate-profile user can see the ARC card on the Advisor Workspace page when they shouldn't be able to. What's the most likely misconfiguration?
  A: The component visibility rule restricting the ARC card to users with the ARC permission either wasn't saved/activated, or references the wrong permission/profile.

**Advanced**
- Q: The Advisor Workspace page loads noticeably slowly. What's a structural (not code-level) fix?
  A: Move lower-priority components further down the page so they lazy-load on scroll, rather than rendering every card above the fold simultaneously.

**Scenario-Based**
- Q: An advisor wants household summary, relationships, holdings, life events, interaction history, and action plans all visible without leaving the page — but two of those depend on optional licensed features. How do you design for that gracefully?
  A: Build the page with the licensed-feature components (e.g., ARC, embedded Agentforce panel) included but governed by visibility rules tied to the relevant permission, so the page degrades gracefully to its unlicensed equivalent (e.g., Relationship Map instead of ARC) rather than breaking for orgs without the license.

**Architecture**
- Q: What's the architectural difference between "a card is hidden by a visibility rule" and "a card is hidden because the user lacks sharing access to the underlying object," and why does that distinction matter operationally?
  A: A visibility rule is a presentation-layer decision (the data may exist and be accessible, but you chose not to show it); a sharing/FLS gap is a data-access-layer restriction. They look identical to an end user but require completely different troubleshooting paths — checking page configuration versus checking the sharing model.

**CTA Style**
- Q: How do you decide when a workspace page has accumulated too many components and should be split into a second tab or page?
  A: When the page's primary persona starts needing to scroll past content irrelevant to their majority-case task to reach what they need daily — at that point, segment by frequency of use (daily-use components stay on the primary tab) rather than by topic, and move occasional-use components to a secondary tab.

---

## 5. Client Onboarding

**Beginner**
- Q: What object defines a reusable onboarding checklist in FSC?
  A: Action Plan Template, containing Action Plan Items and Document Checklist Items.

**Intermediate**
- Q: A template doesn't appear in the "Apply Action Plan" quick action list. What two things would you check?
  A: Whether the template is marked active, and whether it's assigned to the object you're applying it from (e.g., Account).
- Q: How are Action Plan Item due dates calculated, and what's a common point of confusion?
  A: By a date offset from the plan's start date, calculated either by calendar days or working days — confusion arises when a template's offset basis isn't what the reviewer assumes.

**Advanced**
- Q: What does an Action-Plan-only onboarding design give up compared to an OmniStudio-based onboarding flow (Omniscript + Integration Procedures)?
  A: It gives up guided, branching UI and direct external-system callouts (e.g., live KYC/AML/credit-bureau API calls) baked into the flow itself — Action Plans track and assign tasks but don't themselves orchestrate external integrations; that has to happen via fronting Flows or manual steps instead.

**Scenario-Based**
- Q: A compliance reviewer marks "Run KYC Check" complete without an actual KYC result attached anywhere on the record. What's the risk, and how would you close the gap?
  A: The completed task gives a false signal of compliance with no evidence trail; close the gap by requiring a Document Checklist Item or a populated KYC-result field as a validation-rule-enforced prerequisite for marking that specific task complete.

**Architecture**
- Q: When would OmniStudio's Omniscript/Integration Procedures genuinely be the right choice over Action Plans for onboarding, despite the added licensing/complexity?
  A: When onboarding requires real-time branching logic driven by live external responses (e.g., a credit-bureau call changing the next on-screen question) — Action Plans can't branch based on integration results mid-flow the way an Integration Procedure-backed Omniscript can.

**CTA Style**
- Q: How would you redesign a manual "create the Financial Account on final task completion" step to be automatic, and what governance question does that automation raise?
  A: Trigger Financial Account (and Financial Account Role) creation from a Flow fired on the last Action Plan Item's completion — but that raises the governance question of who's accountable if an account gets auto-opened on a checklist completion that was marked complete in error, which argues for a secondary approval gate before the account goes fully active.

---

## 6. Referral Management

**Beginner**
- Q: What Lead record type does FSC ship for individual-to-individual referrals, and what's it displayed as to users?
  A: The `Referral` record type (API name), displayed in the UI as "Person Referral."

**Intermediate**
- Q: What custom metadata type must be configured alongside the Referral record type, and what happens if it's skipped?
  A: `Referral Record Type Mapper` — if skipped, referral automation/scoring can default-miscategorize referral records.
- Q: A referral Lead is rejected by a validation rule. What's the likely cause and the better fix than disabling the rule?
  A: An org-wide Lead validation rule built for sales Leads isn't record-type-aware; add a record-type exclusion rather than disabling the rule for all Leads.

**Advanced**
- Q: Why is the `Referral Record Type Mapper` configuration step easy to lose during an org upgrade, and what's the practical mitigation?
  A: It's a custom metadata record, not a guided-setup checkbox, so it's invisible unless someone specifically remembers to re-verify it; mitigate with a documented post-upgrade checklist item or an automated metadata-deployment validation.

**Scenario-Based**
- Q: A banker refers a client to wealth management, but the bank needs to guarantee only licensed advisors receive it. What do you configure?
  A: A Queue containing only licensed wealth advisors, with an assignment rule routing new Person Referral Leads into that queue specifically.

**Architecture**
- Q: What's the architectural risk of building Referral Management on the standard Lead object rather than a dedicated custom object?
  A: Lead carries assumptions and automation built for sales prospecting (validation rules, conversion mapping, reporting) that referral records inherit by default and must be explicitly excluded from — every shared automation point is a potential miscategorization risk, as illustrated by the validation-rule scenario above.

**CTA Style**
- Q: How would you justify the licensing/territory routing check to a stakeholder who just wants referrals to move as fast as possible?
  A: Frame it as risk-adjusted speed, not slower speed — an unlicensed advisor working a wealth referral creates regulatory and suitability exposure, and remediating a mis-routed referral after the fact costs far more time than the queue-assignment check costs up front.

---

## Open Decisions

- **Answer depth**: Answers here are intentionally terse (interview-pace), not full explanations — confirm this is the right depth for your training audience versus the fuller treatment in `04_Architecture_Patterns.md`.
- **CTA-style calibration**: The CTA-style questions above are scenario-judgment questions rather than Salesforce-capability questions by design, consistent with how actual CTA board reviews are structured — confirm this framing matches your training intent.

## Next Steps

- Pair this file with mock-interview sessions using `07_Trainer_Notes.md`'s audience-interaction guidance.
- Expand with additional Data Cloud- and Agentforce-specific interview questions once the `Data Cloud` and `Agentforce` folders are populated, to avoid duplicating content prematurely.
