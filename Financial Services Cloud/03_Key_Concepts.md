# 03_Key_Concepts

## Folder
Financial Services Cloud

## Purpose
Reference documentation for the 11 core Financial Services Cloud (FSC) concepts every FSC practitioner must master: Person Accounts, Households, Financial Accounts, Financial Holdings, Financial Goals, Financial Account Roles, Relationship Groups, Relationship Map, Actionable Relationship Center, Interaction Summary, and Referral Management. Each concept is documented with definition, business context, data model, configuration, limitations, pitfalls, Data Cloud/Agentforce tie-ins, and trainer/interview material, using official Salesforce terminology.

## Branding Notes
- **FSC → Agentforce Financial Services:** Salesforce has been folding "Financial Services Cloud" under the broader "Agentforce Financial Services" / "Agentforce for Financial Services" branding for AI-agent capabilities. The underlying data model and admin terminology below (Account, Financial Account, etc.) remain the stable foundation regardless of branding.
- **Data Cloud → Data 360:** Effective October 14, 2025, Data Cloud was rebranded Data 360. This document uses "Data Cloud (Data 360)" to stay correct across older and newer official sources.
- **Object Model Note — verify per org:** FSC has two coexisting object generations. Older/managed-package orgs use `FinServ__`-namespaced custom objects (e.g., `FinServ__FinancialAccount__c`, `FinServ__FinancialAccountRole__c`, `FinServ__FinancialHolding__c`, `FinServ__FinancialGoal__c`). Newer orgs (and orgs that adopted the "Financial Account Management" standard objects) use namespace-less standard objects (`FinancialAccount`, `FinancialAccountRole`, `FinancialAccountTransaction`, `InteractionSummary`). **Always confirm which generation a given org is on via Object Manager before writing SOQL, Apex, or Flow logic** — this document calls out both names where they differ, but does not assume one over the other. Verify exact availability against the latest Salesforce Release Notes for the org's release.

---

## 1. Person Accounts

**Definition:** A Person Account is an Account record using a person-based record type (`Account.IsPersonAccount = true`) that merges Account and Contact fields into a single record, representing an individual rather than splitting them across a business Account plus a child Contact.

**Business Purpose:** FSC clients (retail banking customers, wealth clients, policyholders) are individuals, not companies. Person Accounts let the platform treat the individual as the primary record while still supporting Account-level rollups, opportunities, cases, and financial accounts.

**Business Example:** A bank onboards client Asha Rao as a single PersonAccount record carrying both Account-style fields (financial account rollups) and Contact-style fields (`PersonEmail`, `PersonMobilePhone`, `PersonBirthdate`) — no separate Contact record exists.

**FSC Objects:** `Account` (with `IsPersonAccount = true`), `PersonContactId` (read-only link to the auto-created Contact), `Person*`-prefixed fields (`PersonEmail`, `PersonMailingAddress`, `PersonBirthdate`). FSC also still supports a legacy "Individual Model" (separate Account + Contact) for older implementations.

**Relationships:** Joins Households/Relationship Groups via `AccountContactRelation`; holds Financial Accounts via Financial Account Role; connects to other Accounts via `FinServ__AccountAccountRelation__c` or `FinServ__ContactContactRelation__c`.

**Configuration:** Enable Person Accounts org-wide (irreversible) in Setup, then enable on the desired record types in FSC setup. New FSC trial orgs and new installations have Person Accounts enabled by default.

**Limitations:** Enabling Person Accounts is irreversible at the org level. Individual-Model orgs require a migration project to adopt Person Accounts. Several FSC features (notably ARC) require Person Accounts and do not support the Individual Model.

**Best Practices:** Decide Person Account vs. Individual Model at project kickoff, never mid-build. Keep custom fields on Account (not split across the hidden Contact). Use dedicated Person Account record types for all individual clients.

**Common Mistakes:** Editing the hidden Contact directly instead of the Account. Mixing person and business record types on one page layout. Assuming third-party packages support the Individual Model when they require Person Accounts (or vice versa).

**Related Data Cloud concepts:** Person Account records typically feed the Data Cloud (Data 360) Individual and Party Identification data model objects during identity resolution, anchoring the unified customer profile.

**Related Agentforce opportunities:** Agentforce for Financial Services actions (e.g., client-detail lookups, wealth client summaries) read Person Account fields directly to ground responses — data quality here is a prerequisite for reliable agent output.

**Trainer Tips:** Demo using the standard Client record type, then show the hidden Contact via `PersonContactId` in Developer Console to demystify the model. Always contrast with the legacy Individual Model.

**Interview Questions:** How does a Person Account differ from a standard Account+Contact pair? Why is enabling Person Accounts irreversible, and what would you check before doing it in a live org? Which FSC features require Person Accounts over the Individual Model?

**Hands-on Exercise:** Create a Client (Person Account), populate `PersonEmail` and `PersonBirthdate`, then run `SELECT Id, IsPersonAccount, PersonContactId, PersonEmail FROM Account WHERE IsPersonAccount = true` in Developer Console to confirm the underlying Contact link.

---

## 2. Households

**Definition:** A Household is an Account record (Group/Household record type) that aggregates related Person Accounts — and optionally business Accounts — so financial data, relationships, and engagement can be viewed and reported at the family/group level.

**Business Purpose:** Wealth and banking relationships are rarely individual. Households let an advisor see consolidated AUM, goals, and risk across a family instead of stitching together separate client views manually.

**Business Example:** "The Rao Household" groups Asha Rao (primary), her spouse, and two dependents, rolling up their combined financial account balances on a single household dashboard.

**FSC Objects:** `Account` (Household/Group record type); `AccountContactRelation` (standard object, extended with `FinServ__` fields such as `FinServ__PrimaryGroup__c`, `FinServ__Role__c`); `FinServ__IncludeInGroup__c` (controls rollup inclusion); `FinServ__AccountAccountRelation__c` (household-to-household or household-to-business links).

**Relationships:** Each member's `AccountContactRelation` links to the Household; `FinServ__PrimaryGroup__c` designates exactly one Household per client as primary for rollups. Households can link to other Households or Business Accounts via `FinServ__AccountAccountRelation__c`.

**Configuration:** Create Households from the Account tab using the Household record type or guided "New Household" action; add members via the household member flow, setting role and rollup inclusion per member.

**Limitations:** A client can have only one Primary Group for rollup purposes, even if they belong to multiple groups. Rollup refresh timing (real-time vs. batch) depends on configuration and has its own limits.

**Best Practices:** Set `FinServ__IncludeInGroup__c` deliberately per member rather than relying on defaults. Use the guided flow rather than manual edits to keep roles consistent. Model blended/multi-generational families with multiple relationships rather than forcing everyone into one Household.

**Common Mistakes:** Creating duplicate Households because members weren't searched for first. Forgetting to mark a Primary Group, which silently breaks rollups. Conflating the legacy "Household" record type with the newer "Group" terminology used in current docs — related, but the language has shifted across releases.

**Related Data Cloud concepts:** Household membership and rollups inform Data Cloud (Data 360) party-relationship/household-style segments (e.g., "households with AUM above $X") used for marketing and engagement scoring.

**Related Agentforce opportunities:** Banking Relationship Assistance and Financial Advisor Assistance skills can generate household-level summaries by reading rolled-up Household data instead of a single client's view.

**Trainer Tips:** Sketch a family tree on a whiteboard before touching the UI — the Household-vs-individual relational model confuses newcomers faster than any other FSC concept.

**Interview Questions:** How does FSC determine which Household a rollup uses if a client belongs to two groups? Walk through adding a new spouse to an existing Household and setting their role. What breaks if `FinServ__IncludeInGroup__c` is left unchecked?

**Hands-on Exercise:** Create a Household, add two Person Account members with different roles, mark one member's Household as Primary, and confirm the rollup reflects only included members' financial accounts.

---

## 3. Relationship Groups

**Definition:** A Relationship Group (also "Party Relationship Group," or simply "Group" in current docs) is the same underlying mechanism as a Household, generalized to organize any set of related parties — people, businesses, or other groups — with an Association Type (Group, Member, Peer) defining each party's role.

**Business Purpose:** Advisors and bankers model financial circles beyond the nuclear family — a client's professional network (attorney, accountant, power of attorney), a small-business ownership group, or a referral network. Relationship Groups generalize the Household pattern for any such structure.

**Business Example:** A wealth advisor creates a "Centers of Influence" group linking a client to their estate attorney and CPA, so all three appear together on the client's relationship view despite only the client being a Household member.

**FSC Objects:** `Account` (Group record type); `FinServ__AccountAccountRelation__c` (with Association Type values Group/Member/Peer); `AccountContactRelation` for person-to-group membership.

**Relationships:** A Relationship Group can contain Person Accounts, Business Accounts, and nested Groups, connected via `FinServ__AccountAccountRelation__c`, each carrying a role (e.g., Attorney, Beneficiary) and an Association Type.

**Configuration:** Create, merge, or split groups via FSC's guided flow; configure the Association Type and Role picklist values to match the firm's relationship taxonomy before go-live, since these drive both Relationship Map and ARC visualizations.

**Limitations:** All three Association Type values must be active or ARC rendering breaks. Overly granular custom roles make relationship graphs cluttered and hard to interpret.

**Best Practices:** Standardize a small, governed set of relationship roles org-wide. Use Peer for non-hierarchical links (e.g., business partners); use Group/Member for hierarchical household-style links.

**Common Mistakes:** Modeling every business connection as a Household when a lighter Peer relationship is clearer. Leaving Association Type values inactive, which silently breaks ARC without an obvious error.

**Related Data Cloud concepts:** Relationship Group structures feed the party-relationship/network graph Data Cloud (Data 360) uses for identity resolution and influence-based segmentation (e.g., centers-of-influence scoring).

**Related Agentforce opportunities:** Relationship-aware Agentforce actions (e.g., referral-network lookups in Banking Relationship Assistance) traverse these relationship records to recommend who to loop in next.

**Trainer Tips:** Show that one object (`FinServ__AccountAccountRelation__c`) powers three UI experiences — Household, Relationship Group, and ARC — so learners see one data model with multiple views, not three separate systems.

**Interview Questions:** What's the difference between a Household and a general Relationship Group? Explain the three Association Type values and when you'd use each. How would you model a small business with three co-owners and a shared accountant?

**Hands-on Exercise:** Create a Relationship Group linking a Person Account to a Business Account using the Peer association type, then confirm it renders correctly on both the Relationship Map and ARC components.

---

## 4. Relationship Map

**Definition:** The Relationship Map is a Lightning component that renders a client's or household's relationship network and rollups as an interactive tree/graph, with role-based visibility controlling what each user persona sees.

**Business Purpose:** Advisors, bankers, and tellers need an at-a-glance view of who's connected to whom and how financials roll up, without manually navigating related lists. The Relationship Map turns the relationship data model into something a frontline user can read in seconds.

**Business Example:** A branch banker opens a client record and sees a Relationship Map showing the client's household, a joint account co-holder, and a linked business account, with household rollup totals visible directly on the map.

**FSC Objects:** Built on `Account`, `AccountContactRelation`, and `FinServ__AccountAccountRelation__c`; rendered through the managed package's Relationship Map Lightning component (ARC is positioned as the richer, more interactive successor view in many current orgs).

**Relationships:** Pure presentation layer over the same Household/Relationship Group graph — not a separate data object.

**Configuration:** Add the Relationship Map component to the Account/Person Account Lightning page; configure role-based visibility ("who sees what") by persona (advisor vs. teller, for example) using the managed package's visibility settings.

**Limitations:** Visibility rules must be deliberately configured per persona — the default view can over- or under-expose information if not reviewed. Deeply nested graphs can become visually cluttered.

**Best Practices:** Define persona-based visibility during design, not after go-live. Keep maps focused by using well-scoped Relationship Groups rather than one sprawling graph.

**Common Mistakes:** Giving every persona the same visibility level, exposing sensitive data to frontline staff who shouldn't see it. Confusing the legacy Relationship Map with the newer ARC Relationship Graph — overlapping purpose, different configuration.

**Related Data Cloud concepts:** The visualized graph corresponds to the party-relationship network Data Cloud (Data 360) uses for household-level and influence-based segmentation.

**Related Agentforce opportunities:** Agent reasoning over "who else is connected to this client" (e.g., before recommending a household-level offer) draws on the same relationship graph the Relationship Map renders for humans.

**Trainer Tips:** Demo an advisor view and a teller view side by side — a single static screenshot doesn't land the role-based visibility point.

**Interview Questions:** How do you restrict what a teller sees on the Relationship Map compared to an advisor? What underlying objects does the Relationship Map actually query?

**Hands-on Exercise:** Configure two visibility profiles ("Advisor – Full" and "Teller – Restricted") and verify with two test users that each sees the correct level of detail.

---

## 5. Actionable Relationship Center (ARC)

**Definition:** ARC is a configurable Lightning framework that displays a client's relationships as an interactive, card-based relationship graph, letting users act on related records (open a case, launch a flow) directly from the graph rather than just viewing it.

**Business Purpose:** Static relationship views show data but don't let users act on it. ARC turns relationship visualization into a productivity tool — the advisor sees the graph and can immediately trigger a record action without navigating away.

**Business Example:** A relationship manager opens a business client's ARC graph, sees financial accounts, related contacts, and open cases as cards, and creates a new case for a related contact directly from its card.

**FSC Objects:** Built on `Account`, Person Account, `AccountContactRelation`, and `FinServ__AccountAccountRelation__c` (Association Type: Group/Member/Peer); configured through admin-built ARC Relationship Graph definitions rather than a dedicated custom object.

**Relationships:** Traverses the same relationship records as Households and Relationship Groups. Requires the Person Account model — ARC does not support the legacy Individual Model.

**Configuration:** Clone the "Financial Services Cloud Extension" permission set (don't edit it directly), enable "Access Actionable Relationship Center," assign to users, then build ARC Relationship Graph definitions and add the ARC Relationship Graph component to record pages. FSC also ships a preconfigured "ARC Financial Services Cloud" component.

**Limitations:** Requires Person Account model (Individual Model orgs must migrate first). All three Association Type values (Group, Member, Peer) must be active or cards may fail to render. Users need read access to every object/field referenced on a graph, or the corresponding card is silently hidden.

**Best Practices:** Start from FSC's preconfigured graphs and customize incrementally. Audit field-level security for every referenced object before go-live to avoid silently missing cards.

**Common Mistakes:** Assuming a missing card is a bug when it's actually a field/object access gap. Forgetting to activate all Association Type values. Attempting to use ARC on an org still on the Individual Model.

**Related Data Cloud concepts:** ARC's relationship graph is the natural UI counterpart to the Data Cloud (Data 360) party-relationship model — the same network that powers household segmentation can be surfaced to end users via ARC.

**Related Agentforce opportunities:** ARC's action-oriented cards are a strong fit for Agentforce-initiated actions (e.g., an agent flags a household-level risk and a user resolves it directly from the card). Agentforce for Financial Services topics like Banking Relationship Assistance complement ARC by automating actions a human would otherwise trigger from the graph.

**Trainer Tips:** When troubleshooting "cards not showing" in a lab, check Person Account enablement and Association Type activation first — the two most common root causes.

**Interview Questions:** Why won't ARC work on an org still using the Individual Model? A user reports a missing card on their ARC graph — what do you check first? How is ARC different from the classic Relationship Map?

**Hands-on Exercise:** Clone the FSC Extension permission set, enable ARC access, build a simple ARC graph showing Account → related Contacts → Cases, and add a record action to the Contact card.

---

## 6. Financial Accounts

**Definition:** A Financial Account represents an account held at a financial institution — checking, savings, credit card, mortgage, brokerage, retirement account, or insurance policy — and is the central financial data record in FSC.

**Business Purpose:** Every FSC use case (advisor dashboards, household rollups, Agentforce grounding) ultimately needs to know what accounts a client holds, their balances, and their roles. Financial Account is the object the rest of the financial data model (Holdings, Roles, Goals) attaches to.

**Business Example:** Asha Rao's checking, savings, and brokerage accounts are each a separate Financial Account record, all linked to her Person Account via Financial Account Role.

**FSC Objects:** Legacy managed package: `FinServ__FinancialAccount__c`. Modern standard object set (introduced as FSC's core financial data moved onto the core platform): `FinancialAccount`, `FinancialAccountTransaction` (API v61.0+). Confirm which generation an org uses before building automation — see the Object Model Note above.

**Relationships:** Connects to Person/Business Accounts via Financial Account Role; holds Financial Holdings; can be tagged to a Financial Goal; rolls up to the client's Household for group-level reporting.

**Configuration:** Enable Financial Account and related standard objects if moving to the modern object set; otherwise configure the managed package's Financial Account page layouts, record types (deposit, investment, loan, insurance), and rollup fields.

**Limitations:** Legacy and modern object sets are not interchangeable without migration — mixing assumptions about which is in play is a recurring architecture error. Rollups to Household depend on correct Financial Account Role configuration; missing roles mean missing rollups.

**Best Practices:** Confirm at kickoff whether the org uses `FinServ__`-namespaced or standard objects, and document it prominently — it changes every SOQL query and Flow. Use record types to distinguish account categories rather than free-text fields.

**Common Mistakes:** Writing SOQL/Apex against `FinServ__FinancialAccount__c` in an org that has actually moved to the standard `FinancialAccount` object (or vice versa). Omitting a Financial Account Role, leaving an account effectively orphaned from its owning client.

**Related Data Cloud concepts:** Maps to the Data Cloud (Data 360) Financial Account DMO and its subtypes — Deposit Account, Investment Account, Loan Account, and Card Account DMOs — shipped as pre-built mappings in the FSC Data Kit.

**Related Agentforce opportunities:** Agentforce for Financial Services actions such as "Get Financial Accounts," balance inquiries, and portfolio performance summaries read Financial Account (and Holding) data directly — one of the most heavily grounded objects across prebuilt skill templates (Financial Advisor Assistance, Banking Relationship Assistance, Loan Product Assistance).

**Trainer Tips:** Open Object Manager first in any session and have learners confirm for themselves whether they're looking at `FinServ__FinancialAccount__c` or standard `FinancialAccount` — don't just tell them, make them check.

**Interview Questions:** How do you determine whether an FSC org uses managed-package or standard Financial Account objects? What breaks if a Financial Account has no Financial Account Role? How does a Financial Account roll up to a Household?

**Hands-on Exercise:** Create a checking-type Financial Account, link it to a Person Account via a Financial Account Role with role "Owner," and confirm the balance rolls up on the client's Household view.

---

## 7. Financial Holdings

**Definition:** A Financial Holding represents a specific asset held within a Financial Account — a stock position, bond, mutual fund, or ETF lot — capturing quantity, value, and asset detail below the account level.

**Business Purpose:** Advisors need portfolio-level detail, not just account balances — asset allocation, concentration risk, and performance all require holding-level data. Financial Holding makes a brokerage/investment account analyzable rather than a single opaque balance.

**Business Example:** Asha Rao's brokerage Financial Account contains three Financial Holding records — a stock position, a bond position, and a mutual fund position — each with its own market value.

**FSC Objects:** `FinServ__FinancialHolding__c` — represents a financial holding such as a security, bond, or mutual fund in relation to an Account and/or Financial Account.

**Relationships:** Each Financial Holding links to a parent Financial Account; aggregated holding values typically roll up into the Financial Account's total value, and from there into Household-level rollups.

**Configuration:** Populate Financial Holdings via data migration/integration from the core banking or custodial platform (holdings data rarely originates in Salesforce); configure page layouts and list views by asset class; set up Holding-to-Financial Account rollups.

**Limitations:** Holdings data freshness depends entirely on the integration cadence with the source-of-truth custodial/banking system — Salesforce is a reporting and engagement layer here, not the system of record for positions. High holding volumes per account can affect rollup/list-view performance if not indexed well.

**Best Practices:** Treat Financial Holding as an integration-fed object and design the ingestion pipeline before the UI. Use asset-class record types or fields to support allocation reporting.

**Common Mistakes:** Manually maintaining holdings in Salesforce instead of integrating from the custodial system, leading to stale positions. Inconsistent asset-class modeling, which breaks allocation/concentration reports.

**Related Data Cloud concepts:** Feeds the Investment Account DMO and related holding-level calculated insights in the Data Cloud (Data 360) FSC Data Kit, supporting asset-allocation and portfolio-trend analytics across channels.

**Related Agentforce opportunities:** "Review current and target asset allocation" and portfolio performance summary actions in Agentforce for Financial Services templates read Financial Holding data to ground advisor-facing recommendations.

**Trainer Tips:** Use a real (anonymized) brokerage statement as a teaching prop — mapping its line items to Financial Holding records makes the object concrete instead of abstract.

**Interview Questions:** What's the difference between a Financial Account and a Financial Holding? Where does holdings data typically originate, and what does that imply for integration design?

**Hands-on Exercise:** Create an Investment-type Financial Account, add two Financial Holding records with different asset classes, and build a rollup showing total holding value at the account level.

---

## 8. Financial Goals

**Definition:** A Financial Goal represents a client's defined financial objective — retirement, education funding, home purchase — tracked against a target amount, timeline, and progress, typically organized under a Financial Plan.

**Business Purpose:** Goals-based wealth management is now a competitive expectation — clients want to see progress toward specific outcomes, not just a portfolio balance. Financial Goals let advisors operationalize goals-based planning conversations inside Salesforce.

**Business Example:** Asha Rao has a Financial Goal "Retire by 60" with a target amount, linked to a Financial Plan; her advisor tracks progress as her linked Financial Accounts grow.

**FSC Objects:** `FinServ__FinancialGoal__c` (the goal record) and `FinancialGoalParty` (junction associating a Financial Goal with the party/Person Account who owns it); goals are typically grouped under a Financial Plan.

**Relationships:** A Financial Goal links to one or more parties via `FinancialGoalParty` (supporting joint goals, e.g., both spouses), and references the Financial Account(s) whose balances count toward progress.

**Configuration:** Create a Financial Plan, then add Financial Goals via the guided "Create a Financial Plan and Goals" flow; set target amount, target date, and link contributing Financial Accounts.

**Limitations:** Progress tracking accuracy depends entirely on which Financial Accounts are explicitly linked — an unlinked account won't count even if economically relevant. Goal modeling is most mature in wealth/advisory contexts; less commonly used in pure retail banking or insurance.

**Best Practices:** Always link the full set of contributing Financial Accounts, not just the primary one. Review and update goals at every client meeting rather than treating them as set-and-forget.

**Common Mistakes:** Creating a goal with no linked Financial Accounts, so progress shows 0% indefinitely. Duplicating goals instead of updating the existing one after a planning conversation.

**Related Data Cloud concepts:** Goal progress and target data can feed Data Cloud (Data 360) calculated insights for goals-based segmentation (e.g., "clients behind on retirement goal") used in advisor work queues or nudge campaigns.

**Related Agentforce opportunities:** Financial Advisor Assistance-style Agentforce skills can generate goal-progress summaries ahead of client meetings, reading Financial Goal and linked Financial Account data to prep talking points automatically.

**Trainer Tips:** Teach the full workflow end-to-end (create plan → add goal → link accounts → review progress) rather than the object in isolation — goals only make sense in that workflow context.

**Interview Questions:** How do you model a joint financial goal shared by two spouses? Why might a Financial Goal show no progress even though the client's net worth is growing?

**Hands-on Exercise:** Create a Financial Plan with one Financial Goal, link it to two Person Account parties (joint goal) and one Financial Account, then update the account balance and confirm the goal's progress indicator changes.

---

## 9. Financial Account Roles

**Definition:** A Financial Account Role represents the role a person or organization plays with respect to a specific Financial Account — owner, joint holder, beneficiary, trustee, power of attorney, or authorized signer.

**Business Purpose:** A single account can have multiple legitimate parties with different rights and responsibilities. Financial Account Role makes that many-to-many, role-qualified relationship explicit and queryable instead of assuming one owner per account.

**Business Example:** A joint checking account has two Financial Account Role records — Asha Rao as "Primary Owner" and her spouse as "Joint Owner" — plus a third role record naming their adult child as "Beneficiary."

**FSC Objects:** Legacy managed package: `FinServ__FinancialAccountRole__c`. Modern standard object set: `FinancialAccountRole` — represents the role of the person or organization entity involved with a Financial Account, such as beneficiary or trustee, referencing the related Financial Account.

**Relationships:** Junction between Account/Person Account and Financial Account; multiple roles can exist per account, and a single party can hold roles across multiple accounts.

**Configuration:** Add Financial Account Roles via the "Add a Financial Account Role" guided action on the Financial Account record; define role picklist values up front (Owner, Joint Owner, Beneficiary, Trustee, Power of Attorney, Authorized Signer) to match compliance/KYC requirements.

**Limitations:** The legacy-vs-modern object distinction applies here too and must be confirmed per org. Role values are typically a governed picklist — adding a genuinely new role type requires admin configuration, not just data entry.

**Best Practices:** Model every legitimate party on an account with an explicit role record, even secondary ones like beneficiaries. Align role picklist values with KYC/AML and regulatory recordkeeping requirements — a compliance decision, not just a UI one.

**Common Mistakes:** Recording only the primary owner and omitting joint holders/beneficiaries, breaking both reporting and downstream compliance processes. Using free-text role descriptions instead of governed picklist values.

**Related Data Cloud concepts:** Maps to the Financial Account Party DMO in Data Cloud (Data 360), representing the role of an organization or person account related to a financial account — used for cross-channel views of who's entitled to act on or benefit from an account.

**Related Agentforce opportunities:** Identity- and entitlement-sensitive Agentforce actions (e.g., before processing a balance inquiry or fee reversal) should check Financial Account Role to confirm the requesting party is actually authorized on that account — a key guardrail for banking-assistant agent actions.

**Trainer Tips:** Use a joint-account-with-beneficiary scenario as the standard teaching example — fastest way to show why a single "Owner" lookup field on Financial Account would be insufficient.

**Interview Questions:** Why is Financial Account Role modeled as a separate junction object instead of an Owner field on Financial Account? How would you enforce that only an authorized role can trigger a self-service action on an account?

**Hands-on Exercise:** Create one Financial Account with two Financial Account Role records (Primary Owner and Beneficiary) for two different Person Accounts, then write a SOQL query returning all parties with any role on that account.

---

## 10. Interaction Summary

**Definition:** Interaction Summary is a standard FSC object capturing a structured summary of a client interaction — a meeting, call, or branch visit — including notes, topics, and confidentiality controls, with Interaction Summary Participant tracking who the summary is shared with.

**Business Purpose:** Advisors and relationship managers need a fast, structured way to log what happened in a client conversation (beyond a generic Task or Event) and control who on the team can see sensitive notes. Interaction Summary replaces ad hoc note-taking with a governed, reportable record.

**Business Example:** After a quarterly review call, Asha Rao's advisor logs an Interaction Summary noting topics discussed (goal review, risk tolerance change), shares it with an associate via an Interaction Summary Participant record, and marks it confidential to exclude other branch staff.

**FSC Objects:** `InteractionSummary` (standard object, API v51.0+) and `InteractionSummaryParticipant` (represents a user the summary is shared with); related to the broader Financial Deal/Interaction data model FSC ships for deal- and meeting-centric tracking.

**Relationships:** An Interaction Summary attaches to an Account/Person Account (and optionally a Financial Deal); Interaction Summary Participant records define the sharing list, layered on top of standard Salesforce sharing.

**Configuration:** Enable and configure Interaction Summaries per the admin guide, add the Interaction Summaries component to the Account/Person Account Lightning page, and enable Topics on the object if using topic tagging for searchability.

**Limitations:** Confidentiality is enforced via the participant-sharing model — not a substitute for an org-wide sharing/security review; misconfigured sharing settings can still leak access. Interaction Summary is a relatively recent (Spring '21+) addition, so older orgs may still rely on Tasks/Events/Notes and need a deliberate adoption push.

**Best Practices:** Standardize a lightweight topic taxonomy so summaries are searchable/reportable, not just freeform text. Train advisors to set confidentiality deliberately at creation time.

**Common Mistakes:** Continuing to log meeting notes in generic Task descriptions out of habit, losing the structure and sharing controls Interaction Summary provides. Over-sharing summaries by default, eroding the confidentiality control's value.

**Related Data Cloud concepts:** Interaction content and metadata can feed Data Cloud (Data 360) engagement-related data model objects (conversation/engagement signals) for next-best-action and churn-risk scoring when combined with other engagement data.

**Related Agentforce opportunities:** Agentforce can draft Interaction Summary content directly from meeting transcripts or call recordings (an "AI meeting notes" pattern), and Financial Advisor Assistance-style skills can read prior summaries to prep an advisor before the next client meeting.

**Trainer Tips:** Contrast Interaction Summary explicitly against Tasks/Events/Notes — the confidentiality/participant model is the differentiator to emphasize, not just "another place to write notes."

**Interview Questions:** How does Interaction Summary's confidentiality model differ from standard Salesforce sharing rules? When would you use Interaction Summary versus a standard Task or Event?

**Hands-on Exercise:** Log an Interaction Summary on a Person Account, mark it confidential, add one Interaction Summary Participant, and verify a second test user without participant access cannot see the summary.

---

## 11. Referral Management

**Definition:** Referral Management in FSC is the capability for tracking and scoring referrals — both client-to-client (centers of influence) and internal cross-sell/cross-team referrals — built on the standard Lead object using dedicated referral record types, enhanced with intelligent, need-based referral scoring.

**Business Purpose:** Financial institutions grow significantly through referrals — a banker referring a client to wealth management, a satisfied client referring a friend. Referral Management gives that informal process a trackable, measurable pipeline instead of relying on word of mouth.

**Business Example:** A retail banker notices a client's growing balance and creates a referral (Lead with a referral record type) to the wealth management team; the referral is scored based on need indicators and routed to the right advisor.

**FSC Objects:** `Lead`, using referral-specific record types (the original "Referral" record type, with "Person Referral" used for individual-to-individual referrals in more recent releases), governed by the `ReferralRecordTypeMapper` custom metadata type, and enhanced by the "Intelligent Need-Based Referrals and Scoring" feature.

**Relationships:** A referral Lead typically links back to the referring Account/Person Account and, once converted, to the resulting Opportunity/client relationship — connecting the referral pipeline to the broader client and household model.

**Configuration:** Follow the "Configure Referral Management" checklist to set up referral record types, routing rules, and scoring; configure `ReferralRecordTypeMapper` to map legacy and current record types correctly during upgrades.

**Limitations:** Built on the standard Lead object rather than a dedicated custom object, so org-wide Lead customizations (validation rules, automation) can unintentionally affect referrals — needs deliberate isolation in design. Scoring quality depends on need-indicator data being populated and current.

**Best Practices:** Keep referral record types and routing rules centrally governed rather than letting business units invent their own Lead processes. Periodically tune need-based scoring criteria as products and segments evolve.

**Common Mistakes:** Treating referral Leads exactly like sales Leads in automation/reporting, conflating two different processes. Skipping `ReferralRecordTypeMapper` configuration during an org upgrade, leaving legacy referrals miscategorized.

**Related Data Cloud concepts:** Referral and conversion outcomes can feed Data Cloud (Data 360) calculated insights for referral-network and centers-of-influence scoring, identifying which relationships generate the highest-value referrals over time.

**Related Agentforce opportunities:** Agentforce can flag need-based referral opportunities proactively during or after a client interaction (e.g., inside Banking Relationship Assistance) and draft the referral record automatically from conversation context.

**Trainer Tips:** Make the Lead-based foundation explicit early — many learners assume referrals must be a bespoke custom object and are reassured to learn it reuses standard Lead infrastructure.

**Interview Questions:** Why is Referral Management built on Lead rather than a custom object, and what risk does that introduce? What does `ReferralRecordTypeMapper` do, and when would you need to touch it?

**Hands-on Exercise:** Create a referral Lead using the Person Referral record type, populate a need-indicator field used by referral scoring, and trace the record through to conversion against a target Person Account.

---

## Open Decisions
1. **Object generation in target client orgs** — for any hands-on lab or client engagement, confirm whether the org uses `FinServ__`-namespaced managed-package objects or the modern standard object set (Financial Account, Financial Account Role, Interaction Summary) before publishing org-specific guidance.
2. **Depth of Data Cloud/Agentforce sections** — current entries name the relevant DMOs and skill templates at a conceptual level; decide whether a future revision should add concrete field-level DMO mappings and exact Agentforce action/topic names per release.
3. **Insurance- and mortgage-specific extensions** — this file covers the core 11 concepts only; Insurance for FSC and Mortgage data models (policies, claims, beneficiaries) are referenced in passing but not documented in depth here.

## Next Steps
1. Cross-check this file's object names against a live FSC org (Object Manager) before using it to write production SOQL/Apex/Flow.
2. Use this file as the concept reference underpinning `04_Architecture_Patterns.md`, `05_Hands_On_Labs.md`, and `06_Interview_Questions.md` as those are populated.
3. Revisit Agentforce action/topic names each release cycle — Agentforce for Financial Services templates are evolving faster than the core data model.
