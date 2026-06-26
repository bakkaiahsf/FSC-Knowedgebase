# 10_Enterprise_Use_Cases

## Folder

Financial Services Cloud

## Purpose

Eleven full enterprise use cases — Retail Banking, Commercial Banking, Corporate Banking, Insurance, Wealth Management, Financial Planning, Customer Service, Customer 360, AI, Data Cloud, and Agentforce — each carried through 13 facets (Business Problem, Actors, Business Process, Architecture, Metadata, Integration, Security, Reporting, Data Cloud, Agentforce, Hands-on Lab, Trainer Notes, Assessment Questions). This file is the industry-specific deep layer sitting on top of `04_Architecture_Patterns.md`'s six anchor topics — several use cases below extend beyond those six (Insurance, Commercial/Corporate Banking) into FSC capability this folder hasn't built dedicated labs for yet.

## Branding Notes

- Object names below are verified against official Salesforce Insurance and Commercial Banking data model documentation, not invented. Where an object is part of an FSC add-on (Insurance, Commercial Banking Console) rather than core FSC, this is noted — confirm licensing before assuming availability in a given org.
- Confirm `FinServ__`-namespaced vs. standard-object naming per org, as elsewhere in this folder.
- "Data Cloud" / "Data 360" and "Financial Services Cloud" / "Agentforce Financial Services" naming is used per source convention at time of writing — verify current branding against the latest release notes.

---

## 1. Retail Banking

**Business Problem**: A retail bank's clients hold checking, savings, and card products serviced across branch, call center, and digital channels, but staff lack one unified view of a client's full relationship — leading to repeated questions, missed cross-sell signals, and slow service resolution.

**Actors**: Retail client, branch teller, banker, contact center agent, branch manager.

**Business Process**: Client opens an account or contacts the bank → staff pulls up the client's Person Account → views all Financial Accounts and recent Interaction Summaries on one page → resolves the request or logs a new interaction → any service need that exceeds the channel's authority is escalated or routed.

**Architecture**: FSC as the engagement layer on Person Accounts, Financial Accounts, and Financial Account Roles; Data 360 as the unification layer reconciling the same client across core banking, card, and digital identity systems; MuleSoft (or equivalent) as the integration layer feeding balances/transactions in near-real time. See `04_Architecture_Patterns.md`, Pattern 1, for the full diagram.

**Metadata**: Person Account record type; `FinServ__FinancialAccount__c`/`FinancialAccount`; `FinServ__FinancialAccountRole__c`/`FinancialAccountRole`; Interaction Summary and Interaction Summary Participant; Banker/Teller profiles and permission sets; Lightning record page per profile.

**Integration**: Core banking system feeds Financial Account balance/status; card processor feeds card-product data; digital banking platform feeds login/session activity for a unified activity timeline.

**Security**: Field-level security differentiating teller vs. banker visibility into balance and sensitive identifiers; Shield Platform Encryption on SSN/Tax ID/account-number fields; Field Audit Trail for regulatory retention.

**Reporting**: Branch-level and banker-level dashboards on account openings, cross-sell conversion, and interaction volume; balance trend reporting per client.

**Data Cloud**: Financial Account DMO (with Deposit/Card Account subtypes) and Financial Account Party DMO via the FSC Data Kit; identity resolution unifying the client across core banking, card, and digital identity source systems.

**Agentforce**: Banking Relationship Assistance skill — post-interaction wrap-up (Structure Meeting Notes, Create Interaction Summary, Create Case/Task) reducing banker administrative time after every client interaction.

**Hands-on Lab**: `05_Hands_On_Labs.md`, Lab 1 (Retail Banking Customer 360).

**Trainer Notes**: `07_Trainer_Notes.md`, Topic 1 — whiteboard the Person Account merge and the Financial Account Role "ownerless account" gotcha before touching configuration.

**Assessment Questions**: See `06_Interview_Questions.md`, Topic 1, for Beginner through CTA-style questions on this use case.

---

## 2. Commercial Banking

**Business Problem**: A bank's commercial relationship managers serve mid-market business clients with multiple accounts, lending products, and evolving financial objectives, but lack a structured way to plan and track the relationship beyond ad hoc spreadsheets and email threads.

**Actors**: Business client (Business Account), relationship manager (RM), credit/underwriting analyst, commercial banking service rep.

**Business Process**: RM onboards a business client as a Business Account → opens an Account Plan capturing the client's financial objectives and progress → tracks accounts, applications in progress, and recent activity via the Commercial Banking Console App → reviews and updates the plan on a cadence (quarterly/annual).

**Architecture**: Business Account as the client record (distinct from the Household-as-business-account pattern used for retail households); Account Plan object extending the Business Account with objectives and progress tracking; Commercial Banking Console App as the RM's purpose-built workspace surfacing customer details, key updates, recent accounts, and in-progress applications in one place.

**Metadata**: Business Account record type; Account Plan object and related fields (objectives, progress); Financial Account and Financial Account Party (junction object defining a client's relationship to an account — owner, beneficiary, trustee); Commercial Banking Console App pages and components.

**Integration**: Loan origination/underwriting system feeding application status into the console; core banking feeding account balances and Financial Account Transaction history.

**Security**: Sharing rules scoping a Business Account's visibility to its assigned RM and credit team; FLS on credit/risk-sensitive fields distinct from standard account fields.

**Reporting**: RM portfolio dashboards (accounts under management, plan objectives on-track vs. at-risk); pipeline reporting on in-progress applications.

**Data Cloud**: Financial Account DMO with Loan Account subtype; Financial Account Party DMO capturing the business's relationship to each account; calculated insights on portfolio concentration or utilization trends per RM book.

**Agentforce**: Financial Advisor Assistance-style meeting-prep pattern adapted to RM context — portfolio summary and objective-progress briefing ahead of a client review, grounded in Account Plan and Financial Account data.

**Hands-on Lab**: Not yet built in `05_Hands_On_Labs.md` — flagged as a missing lab below.

**Trainer Notes**: Introduce Business Account vs. Household-as-Business-Account distinction early; common student confusion is assuming all Business Accounts are households.

**Assessment Questions**: What's the difference between a Household and a non-household Business Account in FSC's data model? What does the Financial Account Party junction capture that a direct Account-to-Financial-Account lookup wouldn't?

---

## 3. Corporate Banking

**Business Problem**: A bank's corporate clients are themselves complex organizations — parent companies with multiple subsidiaries — and RMs need to see risk and revenue across the entire corporate family tree, not just the single entity they're directly speaking with.

**Actors**: Corporate client (parent + subsidiary entities), corporate relationship manager, credit risk officer, treasury services specialist.

**Business Process**: RM maps the client's corporate structure using Flexible Hierarchies (parent → subsidiaries) → reviews aggregated risk and revenue across the family tree → identifies hidden revenue or risk concentration at the subsidiary level → validates the hierarchy via the Connect REST API before it moves out of Draft status.

**Architecture**: Flexible Hierarchies for Financial Services (Spring '26) as the hierarchy-modeling layer over Business Accounts; family-tree-level aggregation distinct from the single-entity Account Plan view used in Commercial Banking.

**Metadata**: Flexible Hierarchy objects/relationships (parent-subsidiary linkage); Business Account per legal entity; Account Plan rolled up at the corporate-family level where supported.

**Integration**: Treasury/cash-management platform feeding multi-entity balance and transaction data; external corporate-registry data (e.g., company-house-style sources) for hierarchy validation.

**Security**: Sharing model must respect that a subsidiary's data may need to stay visible to its dedicated RM even when rolled up to the parent's family-tree view for a senior RM — requires careful role-hierarchy and sharing-rule design, not just a flat aggregation.

**Reporting**: Family-tree-level risk and revenue dashboards; subsidiary-level drill-down reporting.

**Data Cloud**: Identity resolution at the entity level (matching legal entities across treasury, core banking, and external registry sources) underpinning the hierarchy view, distinct from individual-client identity resolution used in Retail Banking.

**Agentforce**: A plausible Multi-Agent Orchestration (Summer '26) use case — one agent surfacing risk concentration, another surfacing revenue opportunity, orchestrated together into one RM-facing briefing — verify against current Agentforce-for-Financial-Services guidance before teaching this as production-ready.

**Hands-on Lab**: Not yet built — flagged as a missing lab below; depends on Flexible Hierarchies being provisioned in a trial org, which should be verified before lab design begins.

**Trainer Notes**: This is the newest capability referenced in this folder (Spring '26) — explicitly tell students to verify against the latest release notes rather than treating this section as a stable, long-documented feature.

**Assessment Questions**: Why does corporate-family risk visualization need a different sharing model than a flat parent-only view? What does the Flexible Hierarchies Connect REST API validate before a hierarchy can be processed?

---

## 4. Insurance

**Business Problem**: An insurer's policyholders interact across sales, service, and claims, but agents and adjusters often lack a unified view connecting the policy, its coverage details, the insured assets, and any open claims — slowing both new business and claims resolution.

**Actors**: Policyholder (Person Account or Business Account), insurance agent, claims adjuster, claim participant (e.g., a third party involved in a claim).

**Business Process**: Agent sells a policy → InsurancePolicy record created with associated Insurance Policy Coverage detailing what's covered (e.g., collision, comprehensive) → policyholder's insured assets linked via Insurance Policy Assets → if a claim occurs, a Claim record is created, capturing claim number, report date, type, and status → Insurance Claim Asset links the insured asset to the claim, and Claim Coverage links the claim to the specific coverage being invoked → Claim Participant records track everyone involved.

**Architecture**: InsurancePolicy and Claim as the two core objects, each with their own relationship web (Coverage, Assets, Participants) — distinct enough from the Financial Account-centric banking/wealth model that this use case is flagged as extending beyond this folder's six anchor topics.

**Metadata**: InsurancePolicy, Claim, Insurance Policy Coverage, Insurance Policy Assets, Insurance Claim Asset, Claim Coverage, Claim Participant — all part of FSC's Insurance data model (confirm licensing/provisioning, as this is part of "Financial Services Cloud for Insurance," not core FSC).

**Integration**: Policy administration system as system of record for policy issuance; claims processing system feeding claim status updates; third-party data (e.g., vehicle/property valuation services) feeding asset data.

**Security**: Claim Participant access needs careful sharing design — a claim may involve parties (e.g., an at-fault third party) who should never see the policyholder's full record, only the specific claim-relevant data.

**Reporting**: Claims aging and status dashboards; loss-ratio reporting per policy line; policy renewal pipeline.

**Data Cloud**: Policy and claims data as additional DLOs/DMOs alongside the Financial Account model, enabling a true cross-product Customer 360 (a client who is both a banking client and a policyholder) once mapped and identity-resolved together.

**Agentforce**: A claims-status or FNOL (first-notice-of-loss) intake assistant is the natural Agentforce pattern here, analogous to Banking Relationship Assistance's post-interaction wrap-up but oriented around claim intake and status communication — verify current Agentforce-for-Insurance skill availability against release notes before teaching as available out-of-the-box.

**Hands-on Lab**: Not yet built — flagged as a missing lab below; recommend as the first lab for a future dedicated `Insurance` folder rather than shoehorning into this folder's six-topic structure.

**Trainer Notes**: Make explicit to students that Insurance is licensed/provisioned separately from core FSC — don't assume a generic FSC trial org has these objects available.

**Assessment Questions**: What's the relationship between Insurance Policy Coverage and Claim Coverage, and why are they two separate objects rather than one? Why does Claim Participant access require different sharing logic than standard household/relationship sharing?

---

## 5. Wealth Management

**Business Problem**: A wealth advisor's view of a client is fragmented across custodial statements, a separate financial planning tool, and Salesforce itself, making it hard to see holdings, goal progress, and the client's broader relationship network in one place during time-constrained client meetings.

**Actors**: Wealth client (often part of a Household), wealth advisor, centers of influence (e.g., the client's attorney or accountant).

**Business Process**: Advisor reviews the client's Investment Financial Account and Financial Holdings → checks Financial Goal progress against linked contributing accounts → reviews the ARC relationship graph for the household and any centers of influence → prepares for and conducts the client meeting → logs the Interaction Summary afterward.

**Architecture**: Extends Household Management (anchor topic 2) with Investment Financial Accounts, Financial Holdings, Financial Plan/Goal, and ARC — see `04_Architecture_Patterns.md`, Pattern 3, for the full diagram.

**Metadata**: `FinServ__FinancialHolding__c`; Financial Plan and Financial Goal; `FinancialGoalParty` for joint goals; `FinServ__AccountAccountRelation__c` for Peer (centers-of-influence) relationships; cloned "Financial Services Cloud Extension" permission set with ARC access.

**Integration**: Custodian/brokerage platform feeding holdings and market-value data; financial planning tool (if kept separate) feeding goal-progress data, or replaced entirely by native Financial Plan/Goal.

**Security**: ARC's three Association Types (Group, Member, Peer) must all be active; FLS on holdings/market-value fields distinct from basic account-balance visibility.

**Reporting**: Assets-under-management trend per advisor/book; goal-progress dashboards across the advisor's client base.

**Data Cloud**: Holdings and market-value data as integration-fed DLOs/DMOs once sourced from the custodian rather than manually entered, consistent with the realism note in `05_Hands_On_Labs.md`, Lab 3.

**Agentforce**: Financial Advisor Assistance skill — automated meeting-prep (portfolio summary, asset allocation, goal progress, agenda/talking points) ahead of a client review.

**Hands-on Lab**: `05_Hands_On_Labs.md`, Lab 3 (Wealth Household View).

**Trainer Notes**: `07_Trainer_Notes.md`, Topic 3 — anchor the ARC permission-set-cloning discipline early; it's the most common real-world support ticket for this topic.

**Assessment Questions**: See `06_Interview_Questions.md`, Topic 3.

---

## 6. Financial Planning

**Business Problem**: Clients set financial goals (retirement, education, major purchases) but without an explicit, trackable link between the goal and the accounts actually funding it, advisors can't show real progress or course-correct proactively.

**Actors**: Client (individual or joint, e.g., spouses), advisor, financial planner.

**Business Process**: Advisor launches the "Create a Financial Plan and Goals" guided action → sets a target amount and target date for a goal (e.g., "Retire by 60") → explicitly links the Financial Account(s) that contribute to the goal → for joint goals, adds a `FinancialGoalParty` record for the second party → reviews progress percentage over time, which is driven only by linked accounts.

**Architecture**: Financial Plan as the container, Financial Goal as the trackable target within it, `FinancialGoalParty` as the join for shared ownership — a thin but precise object model where the explicit-linking step is the single most important (and most-skipped) configuration detail.

**Metadata**: Financial Plan, Financial Goal, `FinancialGoalParty`, plus whatever Financial Account(s) are linked as contributing accounts. Requires Wealth Management edition or equivalent provisioning — verify per org.

**Integration**: Same custodian/brokerage feed as Wealth Management above, since contributing accounts are typically investment accounts.

**Security**: Goal visibility should follow household/relationship sharing rules so a joint goal is visible to both named parties but not to unrelated household members by default.

**Reporting**: Goal-progress-by-client and goal-progress-by-advisor-book dashboards; aging report on goals with stalled (0%) progress, which usually indicates a missed account-linking step rather than a real lack of progress.

**Data Cloud**: Goal and contributing-account data as a calculated insight (e.g., "percent of clients with at least one stalled goal") rolled up across the advisor's book or the firm.

**Agentforce**: Goal-progress narrative generation as part of the Financial Advisor Assistance meeting-prep skill — summarizing progress in plain language ahead of a client conversation.

**Hands-on Lab**: `05_Hands_On_Labs.md`, Lab 3, steps 3-5 (the conditional Financial Plan/Goal steps).

**Trainer Notes**: `07_Trainer_Notes.md`, Topic 3 — use the "0% progress despite real growth" scenario as the anchor teaching moment for why explicit linking matters.

**Assessment Questions**: Why does a Financial Goal's progress not move just because the client's overall net worth grows? What does `FinancialGoalParty` solve that a single Goal-owner field wouldn't?

---

## 7. Customer Service

**Business Problem**: Service requests from banking and wealth clients (disputes, document requests, account changes) need consistent intake, assignment, and resolution tracking, but ad hoc case handling leads to inconsistent SLAs and lost context between interactions.

**Actors**: Client, contact center agent, service supervisor, specialist team (e.g., fraud, disputes).

**Business Process**: Client raises a request via phone, branch, or digital channel → agent creates or updates a Case linked to the client's Person Account → Case is routed to the right queue/specialist based on type → Interaction Summary captures the conversation → resolution is tracked and the Case closed, optionally triggering a follow-up Task or Action Plan for multi-step resolutions.

**Architecture**: Case object as the service-request backbone, linked to Person Account and (where relevant) the specific Financial Account in dispute; Action Plans (anchor topic 5's pattern) reused here for any multi-step resolution checklist (e.g., a fraud-dispute investigation sequence).

**Metadata**: Case record types per service category; Case assignment/queue rules; Interaction Summary; Action Plan Template reused for structured resolution workflows.

**Integration**: Core banking/card systems for transaction-dispute detail; document management system for supporting evidence uploads.

**Security**: Case visibility scoped to the assigned queue/specialist team; sensitive dispute data (e.g., disputed transaction detail) subject to the same FLS/Shield Encryption considerations as elsewhere in this folder.

**Reporting**: SLA-compliance dashboards by Case type and queue; repeat-contact-rate reporting (a proxy for first-contact-resolution quality).

**Data Cloud**: Case and Interaction Summary history as DLOs feeding a unified client engagement timeline alongside Financial Account activity, enabling a true Customer 360 service history view.

**Agentforce**: Banking Relationship Assistance's post-interaction wrap-up actions (Structure Meeting Notes, Create Case, Create/Assign Task) apply directly here, reducing agent administrative time after every service interaction.

**Hands-on Lab**: Not built as a standalone lab — partially covered inside `05_Hands_On_Labs.md`, Lab 1 (Interaction Summary logging); flagged as a missing dedicated Case-management lab below.

**Trainer Notes**: Tie this use case explicitly back to Lab 1's Interaction Summary step so students see Case and Interaction Summary as complementary, not competing, records.

**Assessment Questions**: When would you use a Case versus an Interaction Summary for the same client conversation, and could you justify creating both for one interaction?

---

## 8. Customer 360

**Business Problem**: The same client may exist as fragmented records across retail banking, wealth, insurance, and digital systems, each with a slightly different name spelling, contact detail, or identifier — preventing any single team from seeing the true, complete relationship.

**Actors**: Enterprise data/architecture team, every client-facing role across the bank (banker, advisor, claims adjuster, service agent).

**Business Process**: Source systems land client data into Data 360 as Data Lake Objects → DLOs are mapped to Data Model Objects using the C360 Data Model → identity resolution (fuzzy/exact/normalized match rules plus reconciliation rules) unifies fragmented records into one resolved profile → that unified profile becomes the grounding source for FSC's Person Account/Household view and for Agentforce grounding across every skill in this folder.

**Architecture**: Data 360 as the unification layer beneath FSC's engagement layer, per the reference architecture cited in `04_Architecture_Patterns.md`, Pattern 1; this use case is the cross-cutting foundation underneath all ten other use cases in this file, not a standalone feature.

**Metadata**: FSC Data Kit's pre-built DMOs and mappings (Financial Account DMO with Deposit/Investment/Loan/Card subtypes, Financial Account Party DMO); identity resolution match/reconciliation rule configuration; Calculated Insights and Segments built atop the unified profile.

**Integration**: Every source system referenced across this file's other ten use cases (core banking, card, custodian/brokerage, policy administration, claims processing, digital banking) feeds into this single unification layer.

**Security**: Data 360's own sharing and dataspace model must be configured to respect the same regulatory and least-privilege boundaries already enforced in FSC itself — a unified profile shouldn't become a way to bypass FLS/sharing that exists for good reason in the source application.

**Reporting**: Identity-resolution match-rate and false-merge/false-split monitoring; data-quality dashboards by source system.

**Data Cloud**: This entire use case is the Data Cloud/Data 360 layer itself — see `04_Architecture_Patterns.md`'s Data Cloud subsections across all six anchor patterns for how each consumes this unified layer.

**Agentforce**: Every Agentforce skill referenced in this file depends on grounding against this unified Customer 360 profile rather than a single fragmented source system — get identity resolution wrong and every downstream agent inherits the fragmentation, as already flagged in `06_Interview_Questions.md`'s CTA-style question for Topic 1.

**Hands-on Lab**: Not yet built — depends on the `Data Cloud` folder (next in the population order) being populated with its own dedicated labs on DLO/DMO mapping and identity resolution configuration.

**Trainer Notes**: Teach this use case last among the eleven, after students have seen the fragmentation problem play out concretely in Retail Banking, Insurance, and Wealth Management — the unification layer lands better once the pain it solves is already visible.

**Assessment Questions**: Why is identity resolution described as the foundation underneath every other use case in this file rather than a feature of any one of them? What's the risk of a "false merge" in identity resolution, concretely, for a banking client?

---

## 9. AI

**Business Problem**: Client-facing staff need AI assistance that's grounded in real, governed client data and constrained by trust/compliance guardrails — not a generic chatbot that might hallucinate account details or surface ungoverned recommendations in a regulated industry.

**Actors**: Every client-facing role across this file, plus the compliance/risk team responsible for AI governance.

**Business Process**: A business need (meeting prep, post-interaction wrap-up, claims intake, collections outreach) is mapped to an Agentforce skill → the skill's actions are grounded against governed data (Customer 360 via Data 360, FSC objects) rather than free-text generation → guardrails constrain what the agent can say or do → the Trust Layer logs and governs the interaction for audit purposes → human staff review/action the agent's output per the workflow's design.

**Architecture**: This use case is the AI layer cutting across Agentforce (use case 11) and Data Cloud (use case 8) together — Agentforce provides the skill/action/orchestration layer, Data 360 provides the grounding data, and the Trust Layer provides governance over both.

**Metadata**: Agent, Topics, Instructions, Actions, Prompt Templates (Prompt Builder), Grounding configuration, Guardrails — all part of Agentforce's metadata surface; verify exact configuration screens against the current release, since Agentforce's setup surface has changed release-over-release (see `09_Whats_New.md`).

**Integration**: Same source systems as Customer 360 (use case 8), since AI grounding is only as good as the unified profile beneath it.

**Security**: Guardrails to prevent disclosure of sensitive data (e.g., full account numbers, SSN) in agent responses; Trust Layer audit logging for every AI-generated action in a regulated context.

**Reporting**: Agent-action audit reports for compliance review; AI-assisted-task volume and time-saved reporting for ROI tracking.

**Data Cloud**: Grounding data source for every AI action referenced in this use case — see use case 8 for the full unification-layer detail.

**Agentforce**: This use case and use case 11 (Agentforce) overlap substantially by design — use case 9 frames the governance/trust question, use case 11 frames the skill-by-skill implementation detail.

**Hands-on Lab**: Not yet built — recommend as the first lab in the future `Agentforce` folder (next-but-one in the population order), covering Topics/Actions/Guardrails configuration from scratch rather than duplicating inside this folder.

**Trainer Notes**: Lead with the trust/governance framing before the "cool demo" framing — in BFSI training specifically, compliance officers in the room will disengage if guardrails and audit logging aren't addressed up front.

**Assessment Questions**: What's the difference between an Agentforce guardrail and a standard FSC sharing rule, and why do you need both? Why might a compliance team require audit logging on AI-generated Case notes specifically?

---

## 10. Data Cloud

**Business Problem**: Without a dedicated unification and activation layer, every client-data initiative (segmentation, personalization, AI grounding) ends up rebuilding its own fragile point-to-point integration against the same fragmented source systems.

**Actors**: Data/architecture team, marketing/segmentation team (for activations), every consumer of unified data across this file's other use cases.

**Business Process**: Source systems are connected and landed as DLOs → DLOs are mapped to DMOs using the C360 Data Model → identity resolution unifies records → Calculated Insights derive metrics (e.g., portfolio concentration, churn risk) → Segments group clients by criteria → Activations push segments/insights to downstream channels (marketing, Agentforce grounding, FSC itself).

**Architecture**: This use case is the same unification layer described in Customer 360 (use case 8), described here specifically through the Data 360 product lens (DLO/DMO/Segments/Activations mechanics) rather than the client-360 business outcome lens.

**Metadata**: Data Streams, DLOs, DMOs (including FSC Data Kit's pre-built Financial Account/Financial Account Party DMOs), identity resolution rulesets, Calculated Insights, Segments, Activations; dataspace-aware SOQL for querying Data 360 DLOs directly (Summer '26).

**Integration**: Every source system across this file; Summer '26 added Currency Reporting in Data 360 directly relevant to multi-currency consolidation needs.

**Security**: Dataspace-level access control; currency and PII fields subject to the same regulatory handling expectations as the FSC-native equivalents.

**Reporting**: Calculated Insights surfaced directly in reporting; Segment-membership reporting for activation effectiveness.

**Data Cloud**: This entire use case is Data Cloud/Data 360 itself.

**Agentforce**: Segments and Calculated Insights as grounding inputs for Agentforce actions — e.g., an agent recommending outreach only to clients in a specific risk-scored segment.

**Hands-on Lab**: Not yet built — primary candidate lab for the `Data Cloud` folder, the next folder in the population order per `MASTER_INSTRUCTIONS.md`.

**Trainer Notes**: Don't teach Data Cloud mechanics in a vacuum — anchor every DLO/DMO/identity-resolution concept back to a concrete FSC pain point already covered in this folder (e.g., "this is what fixes the fragmented-client problem from Retail Banking, use case 1").

**Assessment Questions**: What's the difference between a DLO and a DMO, and why does the mapping step matter? What does dataspace-aware SOQL let you do that standard SOQL against Salesforce core objects doesn't?

---

## 11. Agentforce

**Business Problem**: Client-facing staff spend significant time on administrative work around client interactions (meeting prep, note-taking, follow-up task creation) that takes time away from the actual relationship-building work only a human can do.

**Actors**: Advisor, banker, RM, every Agentforce-skill consumer across this file's other use cases.

**Business Process**: A Topic (e.g., "meeting preparation") groups related Instructions and Actions into a coherent agent capability → Actions call into FSC/Data 360 data (grounding) → Prompt Templates (via Prompt Builder) generate the actual language output → Guardrails constrain scope and disclosure → the agent is tested before deployment → in production, the Trust Layer governs and logs every action.

**Architecture**: Agent/Topic/Instruction/Action as the core configuration hierarchy; this folder has so far documented two concrete skills (Financial Advisor Assistance, Banking Relationship Assistance) per `04_Architecture_Patterns.md` — `09_Whats_New.md` flags that Spring '26's Banking Service Assistance Agent Templates likely expand this list substantially, and that update hasn't been reflected here yet.

**Metadata**: Agent, Topic, Instruction, Action, Prompt Template, Grounding configuration, Guardrail configuration — Setup-level Agentforce Studio configuration surface (verify exact screens against current release).

**Integration**: Data 360 as the grounding source (use case 10); FSC objects as the action targets (e.g., "Create Interaction Summary" writing directly to FSC).

**Security**: Guardrails as the primary AI-specific control; standard FSC sharing/FLS still applies to whatever data/object an Action ultimately touches — Agentforce doesn't bypass the underlying security model, it operates within it.

**Reporting**: Skill-adoption and time-saved reporting per role; Trust Layer audit reports for compliance review.

**Data Cloud**: Every Action's grounding ultimately traces back to the Customer 360/Data 360 unification layer (use cases 8 and 10).

**Agentforce**: This use case is the implementation-detail counterpart to use case 9 (AI) — see that use case for the governance/trust framing.

**Hands-on Lab**: Not yet built in this folder — recommend as the anchor lab for the future `Agentforce` folder, building one Topic/Action/Guardrail configuration from scratch using the Financial Advisor Assistance skill as the worked example.

**Trainer Notes**: Demo the two already-documented skills (Financial Advisor Assistance, Banking Relationship Assistance) live where licensed, but explicitly tell students the skill catalogue is expanding release-over-release and to verify current availability before a real engagement.

**Assessment Questions**: What's the difference between a Topic and an Action in Agentforce's configuration model? Why can't an Agentforce guardrail substitute for proper FLS/sharing configuration on the underlying object?

---

## Missing Labs Identified

The following use cases above reference hands-on labs that don't yet exist in `05_Hands_On_Labs.md` and are recommended as future additions, in priority order:

1. **Data Cloud DLO/DMO mapping and identity resolution lab** — foundational for use cases 8 and 10; should live in the `Data Cloud` folder, not this one.
2. **Agentforce Topic/Action/Guardrail configuration lab** — foundational for use cases 9 and 11; should live in the `Agentforce` folder.
3. **Commercial Banking Account Plan + Console App lab** — use case 2; could live in this folder as a seventh anchor topic, or in a future `Banking` folder.
4. **Corporate Banking Flexible Hierarchies lab** — use case 3; explicitly depends on confirming Spring '26 provisioning first.
5. **Insurance Policy/Claim lab** — use case 4; recommended for a dedicated `Insurance` folder rather than this one, given how distinct the object model is from this folder's Financial-Account-centric anchor topics.
6. **Case-management/Customer Service lab** — use case 7; the most natural seventh lab to add directly to this folder, since it reuses Person Account, Interaction Summary, and Action Plans already covered here.

## Missing Architecture Patterns Identified

- A dedicated **Customer Service / Case Management** pattern (paralleling use case 7) is not yet in `04_Architecture_Patterns.md`'s six patterns, despite Case being referenced implicitly via Interaction Summary in Lab 1.
- A dedicated **Commercial/Corporate Banking** pattern (use cases 2-3) is not yet covered — current six patterns lean retail/wealth.

## Missing Interview Questions Identified

- `06_Interview_Questions.md` does not yet cover Insurance, Commercial Banking, Corporate Banking, Data Cloud mechanics, or Agentforce configuration mechanics directly — these are flagged for addition once the corresponding folders/labs above exist, to avoid writing ungrounded questions ahead of verified content.

## Missing Trainer Material Identified

- `07_Trainer_Notes.md` has no session plan yet for Customer Service (use case 7) despite it being the most reusable seventh topic for this folder specifically.

## Open Decisions

- **Scope boundary**: Insurance (use case 4) and Corporate Banking (use case 3) are included here per the master prompt's required use-case list, but both meaningfully exceed this folder's six-anchor-topic design. Confirm whether they should eventually move to dedicated folders (`Insurance` and a future `Banking` folder both already exist in the repo's folder list) rather than staying in `Financial Services Cloud`.
- **Depth ceiling for use cases without labs**: Five of the eleven use cases above point to labs that don't exist yet. Confirm whether that's acceptable for this pass (with labs added as those folders are populated) or whether this file should be held back until labs exist for all eleven.

## Next Steps

- Build the Case-management lab (Missing Labs Identified, item 6) as the most natural seventh addition to this specific folder, since it requires no new folder and reuses existing objects.
- Carry the Commercial/Corporate Banking and Insurance gaps forward explicitly when the `Banking` and `Insurance` folders are reached in the population order, rather than retrofitting them into this folder later.
- Treat this file, alongside 00 and 06-09, as completing the Financial Services Cloud folder per the STOS "stop after each folder" rule — hold here for review before starting `Data Cloud`.
