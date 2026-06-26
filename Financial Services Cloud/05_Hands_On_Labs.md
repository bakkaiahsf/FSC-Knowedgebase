# 05_Hands_On_Labs

## Folder

Financial Services Cloud

## Purpose

Six hands-on labs that operationalize the architecture patterns in `04_Architecture_Patterns.md` inside an actual org: Retail Banking Customer 360, Household Management, Wealth Household View, Advisor Workspace, Client Onboarding, and Referral Management. Every lab follows the same structure — Objective, Business Scenario, Org Prerequisites, Step-by-Step Configuration, Validation, Troubleshooting, Discussion Questions — and the labs build on each other in order: Lab 2 assumes Lab 1's client exists, Lab 3 assumes Lab 2's household exists, Lab 4 assumes Labs 1–3's data exists.

## Branding Notes

- **FSC → Agentforce Financial Services**: Salesforce has been folding "Financial Services Cloud" under the broader "Agentforce Financial Services" / "Agentforce for Financial Services" branding for AI-agent capabilities. Setup-menu paths and object names below remain the stable foundation regardless of branding.
- **Data Cloud → Data 360**: Effective October 14, 2025, Data Cloud was rebranded Data 360. Referenced only where a lab touches it directly.
- **Object Model Note — verify per org**: FSC has two coexisting object generations — legacy `FinServ__`-namespaced managed-package objects and newer namespace-less standard objects. Steps below default to the legacy managed-package names (`FinServ__FinancialAccount__c`, etc.) since that's still the more common configuration surface in admin guides and trial orgs; substitute standard-object names if your org uses the modern generation. Confirm via Object Manager before running any lab in a real org.
- **Lab environment note**: These labs assume a Financial Services Cloud trial or Developer Edition org with the managed package installed, Person Accounts enabled, and System Administrator access. Some steps depend on features that require separate provisioning (ARC, Financial Goals/Plans in Wealth Management editions, OmniStudio, Agentforce) — each such step is marked **(conditional)** with the dependency called out, so the lab degrades gracefully if your org doesn't have it.
- **Persona continuity**: All six labs use the same fictional client — **Asha Rao**, a retail-and-wealth client of fictional **Meridian Trust Bank** — so data created in earlier labs feeds directly into later ones.

---

## 1. Retail Banking Customer 360

**Objective**: Configure a single client view combining Person Account, Financial Accounts, Financial Account Roles, and Interaction Summary so a banker can see a client's full relationship without switching screens.

**Business Scenario**: Meridian Trust Bank's tellers and bankers currently check account balances in one system and service history in another. The bank wants a banker opening a client's record to immediately see every account, who's authorized on it, and the last few interactions.

**Org Prerequisites**: FSC managed package installed; System Administrator access; Person Accounts not yet enabled (this lab enables them); at least one Business Account record type already exists (required before Person Accounts can be enabled).

**Step-by-Step Configuration**:
1. Setup → Quick Find → "Person Accounts" → review the warning, select "I understand that enabling this feature results in permanent changes to my Salesforce org," → Enable.
2. Setup → Object Manager → Account → Record Types → confirm a Person Account record type (e.g., "Client") exists and is active; assign it to the System Administrator and Banker profiles.
3. Create a new Person Account: Accounts tab → New → select the Client record type → Name "Asha Rao," populate `PersonEmail` and `PersonBirthdate`.
4. Create two Financial Account records linked to Asha Rao: one Checking, one Savings (`FinServ__FinancialAccount__c` → New, or the standard `FinancialAccount` object if your org is on the modern generation) — set Status = Active and a Balance value on each.
5. For each Financial Account, create a Financial Account Role record (`FinServ__FinancialAccountRole__c`) linking Asha Rao as **Owner**.
6. Create an Interaction Summary record on Asha Rao's record logging a recent branch visit; add an Interaction Summary Participant for the banker who logged it.
7. App Builder → open or clone the Person Account Lightning record page → add the Financial Accounts related list and the Interaction Summaries component → activate as the org default (or assign to the Banker app) for the Banker profile.

**Validation**: Log in as (or impersonate) a Banker-profile user, open Asha Rao's record, and confirm both Financial Accounts are visible with their Owner role, and the Interaction Summary appears with the correct participant.

**Troubleshooting**:
- *Can't enable Person Accounts*: confirm a Business Account record type already exists — Salesforce blocks enablement without one.
- *New Person Account has no record type to pick*: the Client record type wasn't assigned to your profile in step 2 — check Setup → Profiles → Record Type Settings.
- *Financial Account shows on the Account but with no clear owner*: the Financial Account Role record was skipped — an account with no role record is effectively orphaned from its client for reporting purposes.
- *Balance fields don't show for a teller-profile test user*: check field-level security on the balance field — tellers and bankers are commonly given different FLS by design.

**Discussion Questions**: Why is enabling Person Accounts irreversible, and what should you confirm with the client before doing it in a real org? What breaks downstream if a Financial Account is created without a Financial Account Role? How would you extend this lab to support a joint Checking account with two owners?

---

## 2. Household Management

**Objective**: Group two related Person Accounts into a Household with a Primary Group designation and a balance rollup.

**Business Scenario**: Asha Rao and her spouse hold separate accounts at Meridian Trust Bank but manage their finances as one family unit. Their advisor wants a single household view showing combined balances instead of checking two separate client records.

**Org Prerequisites**: Lab 1 completed (Asha Rao's Person Account and Financial Accounts exist); a second Person Account created for the spouse (same steps as Lab 1, step 3); Household/Group record type active for Account.

**Step-by-Step Configuration**:
1. From Asha Rao's record, launch the **New Household** quick action (or create an Account directly with the Household/Group record type) → name it "Rao Household."
2. Add Asha Rao as a member via the household member flow: set `FinServ__Role__c` = "Account Holder" and check `FinServ__IncludeInGroup__c` so her financial data counts toward the rollup.
3. Add the spouse as a second member with `FinServ__Role__c` = "Spouse," also marked `FinServ__IncludeInGroup__c`.
4. For each member, open **Edit Relationship** and set "Rao Household" as their **Primary Group** — this is what the rollup engine reads.
5. Configure the balance rollup (a scheduled Flow or your org's existing rollup mechanism) to sum Financial Account balances for all `IncludeInGroup` members up to the Household record.
6. Add the Relationship Map component to the Household record's Lightning page.

**Validation**: Open the Rao Household record and confirm the rollup total equals the sum of both members' Financial Account balances, and the Relationship Map renders both Asha Rao and her spouse as members.

**Troubleshooting**:
- *Rollup shows zero or partial total*: check that Primary Group is actually set on each member — a member can belong to a household without it being their Primary Group, and the rollup only counts the Primary Group relationship.
- *A member's balance is missing from the total*: `FinServ__IncludeInGroup__c` was left unchecked for that member — this fails silently with no error.
- *Duplicate "Rao Household" records appear*: a second household was created because the existing one wasn't searched for first before clicking New Household — always search existing households before creating one.

**Discussion Questions**: What happens if a client genuinely needs to be treated as "primary" in two different households — how would you model that given the one-Primary-Group constraint? Why might an admin choose a scheduled Flow rollup over a real-time one at scale? How would you explain `FinServ__IncludeInGroup__c` to a new admin in one sentence?

---

## 3. Wealth Household View

**Objective**: Extend the Rao Household with investment holdings, a shared financial goal, and a centers-of-influence relationship, then visualize all of it through the Actionable Relationship Center (ARC).

**Business Scenario**: Asha Rao's relationship has grown beyond retail banking — she now has a brokerage account, a joint retirement goal with her spouse, and an estate attorney the advisor should be aware of. The wealth advisor wants one view showing assets, goal progress, and relationships together.

**Org Prerequisites**: Lab 2 completed (Rao Household exists); Financial Goal/Financial Plan features provisioned (Wealth Management edition or equivalent — **(conditional)**, skip steps 3–5 if unavailable); ARC requires Person Accounts (already enabled in Lab 1).

**Step-by-Step Configuration**:
1. Create an Investment-type Financial Account for Asha Rao.
2. Add two or three `FinServ__FinancialHolding__c` records under it with different asset classes (e.g., one equity position, one bond position), each with a market value.
3. **(conditional)** Create a Financial Plan for Asha Rao, then use the "Create a Financial Plan and Goals" guided action to add a Financial Goal — e.g., "Retire by 60" — with a target amount and target date.
4. **(conditional)** Link the new Investment Financial Account (and the existing Checking/Savings accounts) as contributing accounts to the goal.
5. **(conditional)** Add a `FinancialGoalParty` record for the spouse so the goal is jointly owned.
6. Create a Peer-association `FinServ__AccountAccountRelation__c` record between Asha Rao and a Business/Person Account representing her estate attorney — set Association Type = **Peer**.
7. Setup → Permission Sets → clone "Financial Services Cloud Extension" (label it e.g. "FSC with ARC") → open the clone → System Permissions → confirm "Access Actionable Relationship Center" is selected → save and assign the clone to the advisor's user.
8. Build a simple ARC Relationship Graph definition (Account → related Contacts/Accounts → Cases) and add the ARC Relationship Graph component to the Household/Person Account Lightning page.

**Validation**: As the advisor user, open Asha Rao's record and confirm the ARC graph renders cards for the spouse, the household, and the attorney; confirm the Financial Goal (if configured) shows a progress percentage above 0%; confirm the Investment Financial Account's total reflects both holdings.

**Troubleshooting**:
- *ARC cards don't render at all*: check Person Account enablement first, then confirm all three Association Type values (Group, Member, Peer) are active — ARC silently fails to render cards if any one of them is inactive.
- *A specific card is missing (e.g., the attorney)*: the logged-in user likely lacks field- or object-level access to something the graph references — ARC hides the card rather than erroring, so check FLS/object permissions before assuming it's a bug.
- *Goal shows 0% progress despite real account growth*: no Financial Account was linked to the goal in step 4 — an unlinked account never counts toward progress no matter how much it grows.

**Discussion Questions**: Why does ARC require the Person Account model and not the legacy Individual Model? Walk through what you'd check, in order, if a user reports "the attorney card disappeared from ARC." Why is holdings data described as integration-fed rather than admin-entered in a production org, and what does that imply for this lab's realism?

---

## 4. Advisor Workspace

**Objective**: Compose a single Lightning App page that surfaces the household, ARC graph, holdings, life events, interaction history, and action plans together, so an advisor never has to leave the page during client prep.

**Business Scenario**: Asha Rao's advisor currently checks five different tabs before a client meeting. Meridian Trust Bank wants one workspace page an advisor opens once and never has to navigate away from.

**Org Prerequisites**: Labs 1–3 completed (or equivalent data); Lightning App Builder access; Agentforce for Financial Services provisioned for step 7 (**(conditional)** — skip if not licensed).

**Step-by-Step Configuration**:
1. App Builder → create a new Lightning Record Page (or clone the existing Person Account page from Lab 1) named "Advisor Workspace."
2. Add a Highlights Panel + Household summary card at the top.
3. Add the Relationship Map or ARC Relationship Graph component (from Lab 3) below it.
4. Add the Financial Accounts and Financial Holdings related-list components.
5. Add the Life Events & Business Milestones component.
6. Add the Interaction Summaries component (timeline of past meetings/calls).
7. Add the Action Plans related-list component.
8. **(conditional)** Add the embedded Agentforce conversational panel component if Agentforce for Financial Services is provisioned in the org.
9. Set component-level visibility rules so the ARC card only displays for users holding the "Access Actionable Relationship Center" permission from Lab 3.
10. Activate the page and assign it to the Advisor app and profile.

**Validation**: Log in as a test Advisor user and confirm every card renders real data from Labs 1–3 on one page; log in as a test Associate-profile user and confirm the ARC card is hidden per the visibility rule from step 9.

**Troubleshooting**:
- *Page loads noticeably slowly*: too many components are rendering above the fold simultaneously — move lower-priority cards further down the page so they lazy-load on scroll instead of all loading at once.
- *A card that worked on the Person Account page is missing here*: re-check the visibility rule criteria from step 9 — a rule scoped to the wrong permission or profile will hide a card with no error message.
- *Associate-profile user sees everything an Advisor sees*: the visibility rule in step 9 wasn't actually saved/activated, or is referencing the wrong permission API name — re-open the rule and verify the exact permission picked.

**Discussion Questions**: How would you decide which cards go above the fold versus below it for this persona? What's the architectural difference between "the workspace hides a card via visibility rule" and "the workspace's underlying object has no sharing access" — why does that distinction matter when troubleshooting? Where would you draw the line on how much should be on one page before splitting into a second tab?

---

## 5. Client Onboarding

**Objective**: Build a Flow- and Action-Plan-based onboarding checklist that takes a prospect through document collection and account opening without requiring OmniStudio.

**Business Scenario**: Meridian Trust Bank wants every new retail client to go through the same onboarding checklist — ID collection, KYC check, account opening, welcome call — with nothing skipped, but the branch doesn't yet have OmniStudio provisioned, so this lab uses the lighter-weight Action Plan pattern flagged as the fallback option in `04_Architecture_Patterns.md`.

**Org Prerequisites**: Action Plans enabled in the FSC managed package; System Administrator access; a new prospect Person Account (or Lead) to onboard, separate from Asha Rao.

**Step-by-Step Configuration**:
1. Setup → Object Manager → confirm Action Plan, Action Plan Template, and Action Plan Item are visible objects in the org.
2. Go to the Action Plan Templates tab → New → name it "Retail Client Onboarding."
3. Add Action Plan Items (tasks): "Collect Government ID," "Run KYC Check," "Open Checking Account," "Welcome Call" — assign each an owner (role, queue, or the plan creator) and a date offset from the plan's start date.
4. Add Document Checklist Items: "Photo ID" and "Proof of Address," with instructions explaining what's acceptable for each.
5. Open the new prospect's Person Account record and launch the **Apply Action Plan** quick action, selecting the "Retail Client Onboarding" template.
6. Work through the generated tasks and document checklist items, marking each complete as the prospect's documents and KYC result come in.
7. On final task completion, create the Financial Account and a Financial Account Role record (manually for this lab, or via a Flow triggered on the last task's completion in a production build).

**Validation**: Confirm the Action Plan record shows all four tasks and both document checklist items; confirm completing every task correlates with a new Financial Account existing for the prospect, with a Financial Account Role assigning them as Owner.

**Troubleshooting**:
- *"Apply Action Plan" doesn't show the template*: the template isn't marked active, or isn't assigned to the Account object — check the template's status and object assignment.
- *Task due dates look wrong*: check whether the template is set to calculate offsets by calendar days or working days — this is a common point of confusion when reviewing a generated plan.
- *Tasks aren't auto-assigned to anyone*: the owner field was left blank at the template-item level — every item needs an explicit owner, role, or queue, or the plan creator becomes the de facto fallback.

**Discussion Questions**: What does this lab's design give up by not using OmniStudio's Omniscript/Integration Procedures, and when would that trade-off no longer be acceptable for a real bank? How would you redesign step 7 so the Financial Account is created automatically rather than manually? What's the compliance risk if "Run KYC Check" is marked complete without an actual KYC result attached?

---

## 6. Referral Management

**Objective**: Configure a referral record type, the record-type mapper, and a routing queue so a banker can refer a client to wealth management with the referral tracked end-to-end.

**Business Scenario**: Asha Rao's banker notices her growing balance and average transaction size and wants to refer her to the wealth management team — but the bank needs the referral tracked, scored, and routed only to licensed advisors, not lost in an email.

**Org Prerequisites**: Lab 1 completed (Asha Rao's Person Account exists); Lead object available; System Administrator access; at least one wealth-advisor user or queue to route referrals to.

**Step-by-Step Configuration**:
1. Setup → Object Manager → Lead → Record Types → New → Existing Record Type **Referral** (displayed to users as "Person Referral" for individual-to-individual referrals) → assign to the org's Lead Process → activate → assign to the Banker and Wealth Advisor profiles.
2. Setup → Quick Find → "Custom Metadata Types" → **Referral Record Type Mapper** → Manage Records → New → enter the API name of the Referral record type from step 1 so the mapper correctly maps it.
3. Add a need-indicator field to Lead if one doesn't already exist (e.g., `Estimated_Assets__c`) to support need-based scoring.
4. Create a Queue ("Wealth Referral Queue") containing only licensed wealth advisors, and an assignment rule routing new Person Referral Leads into it.
5. From Asha Rao's Person Account, launch the **New Lead and Referral** quick action, select the **Person Referral** record type, and populate the need-indicator field.
6. **(conditional)** If Intelligent Need-Based Referrals and Scoring is provisioned, confirm the scoring field populates on the new Lead.
7. Confirm the Lead lands in the Wealth Referral Queue; have the test advisor user accept it and work the disposition.
8. Convert the Lead to an Opportunity (or new client relationship) and confirm the outcome links back to Asha Rao's Person Account as the referrer.

**Validation**: Confirm the Lead was created with the Person Referral record type and is visible in the Wealth Referral Queue; confirm the `ReferralRecordTypeMapper` custom metadata record exists and correctly maps the record type; confirm conversion produces an Opportunity traceable back to Asha Rao as referrer.

**Troubleshooting**:
- *Person Referral isn't selectable when creating the Lead*: the record type wasn't assigned to the user's profile in step 1, or wasn't activated for the org's Lead Process.
- *Referral Lead is rejected by a validation rule built for sales Leads*: a pre-existing org-wide Lead validation rule isn't record-type-aware — add a record-type exclusion rather than disabling the rule entirely.
- *Lead doesn't appear in the Wealth Referral Queue*: re-check the assignment rule's criteria — it's easy to scope it to the wrong record type API name if step 1's API name wasn't confirmed first.

**Discussion Questions**: Why is the `ReferralRecordTypeMapper` step easy to skip during an org upgrade, and what breaks if it's skipped? How would you justify adding the licensing/territory check in step 4 to a stakeholder who just wants referrals to move faster? What's the architectural risk of building Referral Management on the standard Lead object rather than a dedicated custom object, and how does this lab's step 2 (the validation-rule troubleshooting note) illustrate it directly?

---

## Open Decisions

- **OmniStudio path for Lab 5**: This lab deliberately uses the Action-Plan-only fallback rather than the full OmniStudio Onboarding sample app (Omniscript/Integration Procedures), consistent with the OmniStudio-provisioning Open Decision already flagged in `04_Architecture_Patterns.md`. Decide whether a second, OmniStudio-based version of this lab should be added once provisioning is confirmed for a given org.
- **Conditional-step density**: Labs 3, 4, and 6 each contain steps marked **(conditional)** on Wealth Management editions, Agentforce, or Intelligent Need-Based Referral Scoring being provisioned. Decide whether future revisions should split these into fully separate "core" and "extended" lab variants instead of inline conditionals.
- **Lab data reset**: All six labs build on one running fictional client (Asha Rao / Meridian Trust Bank). Decide whether to publish a companion data-reset script/checklist so a learner can re-run labs cleanly in the same sandbox.

## Next Steps

- Run all six labs end-to-end in a fresh FSC trial org to confirm every step still matches the current release before using this file in a live training session.
- Use this file as the hands-on layer underpinning `06_Interview_Questions.md` — each lab's Discussion Questions are candidate seeds for that file.
- Revisit conditional steps (ARC, Financial Goals/Plans, OmniStudio, Agentforce, Intelligent Need-Based Referral Scoring) each release cycle, consistent with the verification discipline already established in `03_Key_Concepts.md` and `04_Architecture_Patterns.md`.
