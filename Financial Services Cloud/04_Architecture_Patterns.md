# 04_Architecture_Patterns

## Folder

Financial Services Cloud

## Purpose

Six practitioner-level architecture patterns for Financial Services Cloud (FSC), each documented to Technical Architect depth: business problem, architecture diagram description, data model, security, integration, Data Cloud (Data 360), Agentforce, and trade-offs. Patterns covered: Retail Banking Customer 360, Household Management, Wealth Household View, Advisor Workspace, Client Onboarding, and Referral Management. Use this file as the architecture layer that sits on top of the concept definitions in `03_Key_Concepts.md`.

## Branding Notes

- **FSC → Agentforce Financial Services**: Salesforce has been folding "Financial Services Cloud" under the broader "Agentforce Financial Services" / "Agentforce for Financial Services" branding for AI-agent capabilities. The underlying data model and admin terminology below (Account, Financial Account, etc.) remain the stable foundation regardless of branding.
- **Data Cloud → Data 360**: Effective October 14, 2025, Data Cloud was rebranded Data 360. This document uses "Data Cloud (Data 360)" to stay correct across older and newer official sources.
- **Object Model Note — verify per org**: FSC has two coexisting object generations — legacy `FinServ__`-namespaced managed-package objects and newer namespace-less standard objects (`FinancialAccount`, `FinancialAccountRole`, `InteractionSummary`). Confirm which generation a target org is on via Object Manager before treating any data model below as literal SOQL/Apex/Flow reference. See `03_Key_Concepts.md` for the full explanation.
- **Diagram format note**: "Architecture diagram description" sections use a text-based layered-box description (ASCII) rather than a rendered diagram, since this is a Markdown knowledge base file. Treat each as a blueprint for redrawing in Lucidchart/draw.io/Visio for client-facing deliverables, not as a final artifact.
- **Reference architecture sourcing**: The Retail Banking Customer 360 pattern is informed by Salesforce's published *Customer 360 Guide for Retail Banking* (Reference Architecture and Solution Architecture articles on help.salesforce.com). The other five patterns are practitioner-level compositions of standard FSC capabilities, not literal reproductions of a single official diagram — validate against the latest official reference architecture before using in a client-facing SOW.

---

## 1. Retail Banking Customer 360

**Business Problem**: Retail bank customers interact across branch, contact center, mobile/web banking, and ATM channels. Tellers, bankers, and contact-center agents each see a fragmented slice of the relationship — account balances in one system, service history in another, no shared view of life events or cross-sell opportunity. Customers expect proactive, personalized banking; the bank needs a single engagement layer to reduce onboarding friction, cut handle time, and surface next-best-action without forcing staff to pivot across five systems mid-conversation.

**Architecture Diagram Description**:

```
[Channels]        Branch | Contact Center (IVR/CTI) | Mobile/Web Banking | ATM
                         |
[Integration]     MuleSoft Anypoint APIs <-> Core Banking | Card Processing | Fraud/AML
                         |
[Engagement]      Financial Services Cloud
                     - Person Account (client) + Household (joint/family)
                     - Financial Account + Financial Account Role
                     - Interaction Summary (service/advice log)
                     - Retail Banking Console (banker/teller Lightning app)
                         |
[Unification]      Data Cloud (Data 360)
                     - Financial Account DMO + subtypes (Deposit/Card/Loan)
                     - Identity Resolution (core-banking ID + Person Account + app ID -> Unified Individual)
                     - Calculated Insights (attrition risk, cross-sell propensity)
                         |
[Intelligence]     Agentforce for Financial Services
                     - Banking Service Agent (balance, statement, fee reversal)
                     - Banking Relationship Assistance (meeting wrap-up)
                         |
[Analytics]        Reports/Dashboards, CRM Analytics
```

Layer-by-layer: channel systems push transactional events through a MuleSoft integration layer into the FSC engagement layer, where the Retail Banking Console gives bankers and tellers a single screen per customer; Data Cloud sits underneath as the unification layer, resolving identities across core banking, Salesforce, and digital channels and pushing calculated insights back in; Agentforce sits on top as the intelligence layer, acting on the unified view rather than raw source systems.

**Data Model**: `Account` with `IsPersonAccount = true` (the client); `Account` (Household/Group record type) for joint accounts and family relationships; `FinServ__FinancialAccount__c` or standard `FinancialAccount` (checking, savings, card, loan — confirm generation per org); `FinancialAccountRole` / `FinServ__FinancialAccountRole__c` (owner, joint owner, authorized signer); `InteractionSummary` + `InteractionSummaryParticipant` (service/advice interactions); `PersonLifeEvent` / `LifeEvent` (milestones — marriage, home purchase, retirement); standard `Case` (Service Cloud) for service requests. An External ID field on the Person Account (the core-banking customer ID) drives upsert-based integration and prevents duplicate client records.

**Security**: Field-level security scoped by persona — tellers see balances but not full Financial Account Role detail; bankers see the full relationship; Shield Platform Encryption on SSN/Tax ID/account-number fields; sharing rules scoped by branch or region so staff only see their book of customers; Field Audit Trail for retention where regulatory record-keeping (e.g., FINRA-style multi-year retention) applies; GDPR/local data-residency review mandatory for any non-US deployment.

**Integration**: MuleSoft Anypoint Platform (or equivalent ESB/iPaaS) as the integration layer connecting core banking (deposits/loans), card processing, and fraud/AML screening; real-time balance and transaction sync via API or Platform Events where the business case justifies the cost, batch nightly reconciliation otherwise; External ID upsert pattern (never a name/email match) to avoid duplicate Person Accounts; Named Credentials for every outbound credential — never hardcoded endpoints or secrets.

**Data Cloud**: Financial Account DMO and its subtypes (Deposit Account, Card Account, Loan Account) plus the Financial Account Party DMO, populated via the FSC Data Kit's pre-built mappings; identity resolution unifies the core-banking customer ID, Salesforce Person Account, and digital-banking app ID into one Unified Individual profile; calculated insights (attrition risk, cross-sell propensity) flow back into the Retail Banking Console as Data Actions to ground next-best-action prompts.

**Agentforce**: Banking Service Agent topic handles routine, high-volume requests (balance inquiry, statement request, fee reversal) so contact-center staff focus on complex cases; Banking Relationship Assistance automates post-interaction wrap-up (structure meeting notes, create Interaction Summary, draft follow-up email) so bankers spend less time on admin between customer conversations.

**Trade-offs**: Real-time core-banking integration gives bankers live balances but costs more to build and operate than nightly batch sync, which is cheaper but always slightly stale — the business case (fraud exposure, customer experience expectation) should decide, not architecture preference by default. Adding Data Cloud (Data 360) as a unification layer is powerful for cross-channel insight but is a separate licensed product with real implementation cost — justify it with concrete cross-channel use cases (e.g., digital-to-branch handoff) rather than treating it as automatic. Enabling Person Accounts is an irreversible org-level decision and must be confirmed before any build work starts.

---

## 2. Household Management

**Business Problem**: Family and group banking relationships — joint accounts, dependents, multi-generational households — are invisible when every client is modeled as an isolated individual. Relationship pricing, household-level service tiers, and consolidated reporting all require a structural way to group related clients without duplicating financial data per member.

**Architecture Diagram Description**:

```
[Source Systems]   Core Banking joint-account flags | Wealth platform household feed
                         |
[Matching]         Household formation logic (existing-household match vs. new-household create)
                         |
[Data Model]       Person Account --AccountContactRelation--> Household Account (Group record type)
                                        |                              |
                              FinServ__PrimaryGroup__c        FinServ__AccountAccountRelation__c
                              FinServ__Role__c                 (Group/Member/Peer to other Households
                              FinServ__IncludeInGroup__c         or Business Accounts)
                         |
[Rollup]           Financial Account balances -> Household-level rollup (Flow or declarative rollup)
                         |
[Visualization]    Relationship Map / Actionable Relationship Center (ARC)
```

**Data Model**: `Account` (Household/Group record type) as the household record; `AccountContactRelation` (standard object, extended with `FinServ__PrimaryGroup__c` and `FinServ__Role__c`) linking each member to the Household; `FinServ__IncludeInGroup__c` controlling whether a member's financial data counts toward the rollup; `FinServ__AccountAccountRelation__c` (Association Type: Group/Member/Peer) for Household-to-Household or Household-to-Business links; Financial Account records rolling up through Financial Account Role to the member, and from there to the Household.

**Security**: Household-level sharing must not silently grant members edit (or even view) access to each other's individual financial data — sharing should flow through explicit role-based rules, not implicit cascade from `AccountContactRelation`. Field-level security on any balance fields exposed in rollup components. Audit who can mark/unmark `FinServ__IncludeInGroup__c`, since that flag silently changes what a household total reports.

**Integration**: Household formation is often seeded from a core-banking joint-account flag or a wealth platform's existing household grouping via batch or API; a deterministic matching step (address, last name, existing relationship records) decides whether an incoming client maps to an existing Household or needs a new one — fully automatic matching is risky, so most implementations route ambiguous matches to manual review rather than auto-merging.

**Data Cloud**: Household membership and rollup totals feed Data Cloud (Data 360) party-relationship/household segments (e.g., "households with combined balances above $X") used for marketing segmentation and relationship-pricing eligibility scoring.

**Agentforce**: Banking Relationship Assistance and Financial Advisor Assistance skills can generate household-level summaries by reading the rolled-up Household view instead of stitching together each member's individual record manually.

**Trade-offs**: A client can have only one Primary Group (`FinServ__PrimaryGroup__c`) for rollup purposes — this simplifies the rollup model but cannot natively express a client who is genuinely co-primary across two distinct households without a workaround. Flow-based rollups are flexible and easy for admins to extend but can approach governor limits at high household-member counts; declarative rollup-summary fields are faster but only work on true master-detail relationships, which `AccountContactRelation` is not — most orgs end up on Flow or scheduled batch rollups for this reason.

---

## 3. Wealth Household View

**Business Problem**: Wealth advisors need more than household membership — they need consolidated assets under management (AUM), asset allocation, goals-based progress, and relationship context (centers of influence such as an attorney or accountant) to manage a high-net-worth household as a single, holistic relationship rather than a collection of separate accounts.

**Architecture Diagram Description**:

```
[Household Management pattern]  (Household Account + AccountContactRelation + rollups)
                |
[Holdings]      Financial Account --> Financial Holding (position-level detail)
                                            |
                                  Rollup to Financial Account, then to Household
                |
[Goals]         Financial Plan --> Financial Goal --> FinancialGoalParty (joint goals)
                                            |
                                  Linked Financial Account(s) drive progress %
                |
[Relationships] FinServ__AccountAccountRelation__c (Peer) --> Centers of Influence
                (attorney, CPA, power of attorney) visualized via ARC
                |
[Presentation]  Advisor Workspace (see Pattern 4) surfaces all of the above on one page
```

**Data Model**: Builds directly on the Household Management data model and adds `FinServ__FinancialHolding__c` (position-level detail under a Financial Account), `FinServ__FinancialGoal__c` (the goal record, typically grouped under a Financial Plan) with `FinancialGoalParty` as the junction supporting joint goals between spouses, and `FinancialAccountRole` values such as Trustee and Power of Attorney for fiduciary relationships. Centers-of-influence (attorney, CPA) are modeled as Peer-association `FinServ__AccountAccountRelation__c` records, not as Household members.

**Security**: AUM and holdings data is among the most sensitive data in the org — sharing rules should scope visibility to the assigned advisor/team only, not the whole branch; Shield Platform Encryption on account numbers and holding values where firm policy or regulation requires it; segregation of duties between advisors (who can see and discuss) and back-office operations (who can execute trades/transfers) should be enforced at the permission-set level, not by convention.

**Integration**: Custodial/brokerage data feeds (via MuleSoft or a dedicated ETL pipeline) populate `Financial Holding` on a nightly or intraday cadence — Salesforce is a reporting and engagement layer here, never the system of record for positions. Financial Plan and Financial Goal data, by contrast, typically originates directly in Salesforce from advisor conversations rather than from an external feed.

**Data Cloud**: Holdings feed the Investment Account DMO and related holding-level calculated insights in the FSC Data Kit (asset-allocation drift, concentration risk); goal progress and target data support goals-based segmentation (e.g., "households behind on retirement goal") for advisor work-queue prioritization.

**Agentforce**: Financial Advisor Assistance automates client-meeting preparation — analyzing portfolio performance, asset-allocation drift versus target, and goal progress, then generating a structured agenda and suggested talking points, so the advisor walks into the meeting already briefed.

**Trade-offs**: The richness of a goals-based wealth view is entirely dependent on advisor data-entry discipline (plans and goals must actually be created and linked) — without it, the "wealth household view" degrades to a plain household balance rollup with no goals context. Holdings freshness is bound by the custodial feed's cadence, so any "real-time portfolio view" claim to advisors must be scoped honestly to the actual integration SLA, not assumed to be live.

---

## 4. Advisor Workspace

**Business Problem**: Advisors juggle the CRM, a separate portfolio-management tool, calendar, and compliance/note-taking systems before, during, and after every client meeting — losing preparation time and missing context that's scattered across systems instead of available in one place.

**Architecture Diagram Description**:

```
[Single Lightning App Page: Advisor Workspace]
  +-- Client/Household Overview card  (Person Account + Household summary)
  +-- Relationship Map / ARC card     (relationships, centers of influence)
  +-- Financial Accounts & Holdings   (balances, allocation)
  +-- Life Events & Milestones        (upcoming triggers for outreach)
  +-- Interaction Summary timeline    (past meeting/call history)
  +-- Action Plans card               (open onboarding/servicing checklists)
  +-- Embedded Agentforce panel       (Financial Advisor Assistance / Banking Relationship Assistance)
  +-- Calendar integration            (Einstein Activity Capture or equivalent)
```

**Data Model**: This is a composition pattern, not a new object set — it surfaces `Account`/Person Account, Household, `FinancialAccount`/`FinancialHolding`, `FinancialGoal`, `InteractionSummary`, `Action Plan` and `Action Plan Template` (with Action Plan Items / Document Checklist Items), and standard `Event`/`Task` records on a single Lightning page, assembled via App Builder.

**Security**: Page-level and component-level visibility controlled by permission set per persona (Advisor vs. Associate vs. Branch Manager) — different personas can see different cards on the same page layout. The workspace itself introduces no new access path beyond the underlying objects' existing sharing model, but because it aggregates more data onto one screen than any single record page would, field-level security and sharing rules deserve a fresh audit specifically against this page rather than assuming the per-object reviews already cover it.

**Integration**: Calendar integration (Einstein Activity Capture or an equivalent connector) surfaces upcoming meetings and recent email/calendar activity in context; external portfolio-management widgets can be embedded via Lightning Web Components or a Canvas app if the firm's portfolio system isn't being migrated into Salesforce.

**Data Cloud**: The workspace can surface Data Cloud (Data 360) calculated insights directly as a card — e.g., a "next best action" or "attrition risk" insight rendered alongside the relationship data, rather than requiring the advisor to check a separate analytics tool.

**Agentforce**: An embedded Agentforce panel runs Financial Advisor Assistance before the meeting (prep and agenda), can support live note capture during the meeting, and runs Banking Relationship Assistance after the meeting (structured summary, follow-up tasks, draft email) — all without the advisor leaving the workspace page.

**Trade-offs**: Maximizing how much is visible on one page improves preparation speed but risks both information overload for the advisor and real page-load performance cost from too many components rendering at once — the design has to prioritize above-the-fold cards and lazy-load the rest, rather than trying to put everything in view simultaneously.

---

## 5. Client Onboarding

**Business Problem**: Onboarding a new client — identity verification, KYC/AML screening, document collection, account opening — is a multi-step, compliance-heavy process. Done manually it's slow and error-prone; done with a weak digital flow it drives abandonment before the account is even opened.

**Architecture Diagram Description**:

```
[Guided Experience]   Omniscript (OmniStudio) — step-by-step intake UI
                            |
[Process Automation]  Integration Procedures --> KYC/AML/credit-bureau APIs (external)
                            |
[Data Transform]      DataRaptor / Data Mapper (request/response transform)
                            |
[Task Orchestration]  Action Plan (Document Checklist Items + Tasks) tracks completion
                            |
[Record Creation]     Person Account (from Lead, if prospect-sourced)
                            -> Financial Account (on successful KYC + approval)
                            -> Financial Account Role (Owner)
                            -> Interaction Summary (onboarding interview log)
```

**Data Model**: `Lead` or `Account` (Person Account, if converting an existing prospect record) as the onboarding subject; `Action Plan` + `Action Plan Template` + `Action Plan Item` (tasks and document checklist items driving the onboarding sequence); `ContentDocument`/`ContentVersion` for uploaded KYC documents (ID, proof of address); `FinancialAccount`/`FinServ__FinancialAccount__c` created on successful completion; `FinancialAccountRole` assigning the new client as Owner; `InteractionSummary` logging the onboarding interview itself. The Omniscript, Integration Procedure, and DataRaptor/Data Mapper artifacts are OmniStudio configuration metadata, not client data.

**Security**: KYC documents are highly sensitive — Content Library/folder permissions restrict who can view uploaded ID and proof-of-address files; mask partial SSN/government-ID values in the UI wherever the full value isn't operationally required; all third-party KYC/AML/credit-bureau credentials live in Named Credentials, never embedded in an Integration Procedure or Omniscript configuration.

**Integration**: Integration Procedures call external identity-verification, KYC, and AML-screening APIs synchronously from within the Omniscript for an interactive intake experience; a separate core-banking API call provisions the actual account number on final submission; if a KYC vendor decisions asynchronously, the design needs a webhook or Platform Event callback path rather than assuming every check returns instantly.

**Data Cloud**: Onboarding funnel events (started, document uploaded, KYC passed/failed, completed) can stream into Data Cloud (Data 360) Engagement DMOs, enabling drop-off and funnel analytics across the onboarding journey — identifying exactly which step is losing prospects.

**Agentforce**: Agentforce can pre-fill Omniscript fields from a conversational intake, flag missing or inconsistent documents before submission, and draft the client's welcome/next-steps communication automatically once onboarding completes — reducing both prospect-side friction and back-office follow-up work.

**Trade-offs**: OmniStudio (Omniscript, Integration Procedures, DataRaptor/Data Mapper) is a powerful guided-flow toolkit but is a distinct skill set from core Salesforce Flow, with its own licensing and staffing implications — confirm OmniStudio is provisioned and the team has the skill before committing to this pattern over a plain Flow-based intake. Calling third-party KYC services synchronously inside the guided flow creates a hard UX dependency on vendor latency and uptime; a resilient design needs an async fallback path rather than assuming the vendor call always returns before the prospect gives up.

---

## 6. Referral Management

**Business Problem**: Cross-sell and centers-of-influence referrals — a banker referring a client to wealth management, a satisfied client referring a friend — are easily lost when tracked informally. The business needs a pipeline architecture that captures, scores, routes, and closes the loop on every referral, with reporting back to the referrer.

**Architecture Diagram Description**:

```
[Source]        Banker / Advisor interaction  |  Client-to-client (COI) referral
                       |
[Capture]        Lead (Referral / Person Referral record type)
                       |  governed by ReferralRecordTypeMapper (Custom Metadata)
[Scoring]        Intelligent Need-Based Referrals and Scoring
                       |
[Routing]        Queue / assignment rule (territory, specialty, licensing eligibility)
                       |
[Disposition]    Receiving advisor works the Lead
                       |
[Conversion]     Lead --> Opportunity / new client relationship
                       |
[Closed Loop]    Outcome reported back to referrer (Account/Person Account)
```

**Data Model**: Standard `Lead` object using referral-specific record types ("Referral" and, in more recent releases, "Person Referral" for individual-to-individual referrals); `ReferralRecordTypeMapper` (Custom Metadata Type) governing how legacy and current record types map during upgrades; `Opportunity` created on conversion; `Account`/Person Account for both the referrer and the converted client; an optional `Campaign` if the firm wants to track referral programs/sources distinctly from organic referrals.

**Security**: Lead sharing and queue membership must restrict referral routing to advisors who are actually eligible to receive it — territory, product specialty, and licensing requirements (e.g., series-license rules in wealth referrals) all belong in the routing/assignment logic, not left to manual triage. Field-level security on need-indicator and scoring fields; avoid exposing more of the referrer's PII to the receiving team than the referral actually requires.

**Integration**: Need-based scoring can run natively as a declarative Score/Flow-based calculation, or call an external propensity model via Apex callout if the firm has a more sophisticated model already in production; routing can use standard Queue-based assignment or integrate with Service Cloud Omni-Channel for SLA-bound follow-up on time-sensitive referrals.

**Data Cloud**: Referral and conversion outcomes feed Data Cloud (Data 360) calculated insights for centers-of-influence and referral-network scoring — identifying over time which relationships and referral sources actually generate the highest-value conversions, not just the highest volume.

**Agentforce**: Agentforce can flag a need-based referral opportunity proactively during or after a client interaction (for example, inside a Banking Relationship Assistance wrap-up flow) and draft the referral Lead automatically from the conversation context — reducing the pattern's biggest real-world failure mode, which is staff simply forgetting to log the referral.

**Trade-offs**: Building Referral Management on the standard `Lead` object keeps the pattern lightweight and reuses existing platform automation, but it also means every sales-Lead-oriented validation rule, assignment rule, and automation in the org must be record-type-aware so it doesn't silently break or mis-route referral Leads. Tighter compliance-driven routing rules (licensing/territory checks) improve regulatory safety but add assignment latency — the design has to balance how strict the gating is against how fast a referral reaches a live advisor.

---

## Open Decisions

- **Diagram fidelity**: This file uses text/ASCII architecture diagrams for portability inside a Markdown knowledge base. Decide whether client-facing deliverables need these redrawn in Lucidchart/draw.io/Visio, and if so, standardize on one tool and template.
- **Integration layer assumption**: All six patterns assume MuleSoft (or an equivalent ESB/iPaaS) as the integration layer, following Salesforce's published retail banking reference architecture. Confirm the actual client's integration stack (MuleSoft, Boomi, custom ESB, point-to-point APIs) per engagement before treating the Integration sections as a literal build blueprint.
- **OmniStudio provisioning**: The Client Onboarding pattern assumes OmniStudio (Omniscript, Integration Procedures, DataRaptor/Data Mapper) is licensed and provisioned. Confirm this per org — some FSC editions require separate OmniStudio provisioning — before committing to this pattern over a plain Flow-based onboarding design.

## Next Steps

- Validate each pattern against a specific client's actual core-banking/custodial integration landscape before treating it as a build blueprint rather than a reference starting point.
- Use these six patterns as the architecture layer underpinning `05_Hands_On_Labs.md` and `06_Interview_Questions.md` as those files are populated.
- Revisit Agentforce action/topic names referenced here each release cycle — Agentforce for Financial Services templates are evolving faster than the core data model, consistent with the guidance already captured in `03_Key_Concepts.md`.
