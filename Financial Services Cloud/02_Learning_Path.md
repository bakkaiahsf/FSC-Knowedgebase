# 02_Learning_Path

## Folder
Financial Services Cloud

## Purpose
A complete, sequenced roadmap from Salesforce Beginner through Certified Technical Architect (CTA) level, scoped to Financial Services Cloud (FSC) and its surrounding stack (Data Cloud, Agentforce). Each topic is independently study-able but ordered to respect real prerequisite chains — don't skip a level's foundation objects/concepts before moving to the vertical built on top of them.

## Branding Notes (read before using this file)
1. **Financial Services Cloud → Agentforce Financial Services.** Salesforce is migrating the product name as part of the 2025–2026 Agentforce rebrand. Trailhead module pages carry the disclaimer: *"Financial Services Cloud is now called Agentforce Financial Services. You may see references to Financial Services Cloud in our application and documentation."* This file uses "Financial Services Cloud" / "FSC" throughout for continuity with `01_Official_Resources.md` — re-confirm current terminology against live Release Notes before each training delivery.
2. **Data Cloud → Data 360.** As of October 14, 2025, Salesforce rebranded Data Cloud to **Data 360**. Module/trail URLs below still largely sit under the `data-cloud-*` slug namespace; on-page titles increasingly say "Data 360." Treat the two names as the same product until Salesforce fully retires one.

All resources cited below are first-party Salesforce properties (`trailhead.salesforce.com`, `help.salesforce.com`, `developer.salesforce.com`, `architect.salesforce.com`). No community blogs, partner content, or third-party channels — consistent with the bar set in `01_Official_Resources.md`.

## How to Use This Roadmap
- **Sequencing:** Levels 1–2 are strictly linear (you need the platform and FSC core before any vertical makes sense). Levels 3–5 (Retail Banking, Wealth Management, Insurance) can run in parallel or in any order once Level 2 is complete — pick the vertical matching your current engagement first. Levels 6–7 (Data Cloud, Agentforce) assume Level 2 at minimum and are far more useful with at least one vertical (3, 4, or 5) already done. Level 8 assumes all prior levels plus real implementation experience.
- **Study time:** Estimates assume focused, hands-on study (not passive reading) at a pace of roughly 5–8 hours/week. Double the estimate if you're new to Salesforce generally (Level 1) or new to AI/data-platform concepts (Levels 6–7).
- **Hands-on exercises:** Assume access to a Trailhead Playground or Developer Edition org for Levels 1–2; FSC, Data Cloud, and Agentforce features in Levels 2–8 require either a partner/internal FSC-licensed sandbox or the relevant Trailhead hands-on org provisioned by the module itself (most Trailhead modules provision a temporary org automatically).
- **Certifications are checkpoints, not the goal.** They're flagged per level as an optional but recommended way to validate the level before moving on — exam costs and retake fees are noted where they're non-trivial (Level 8 in particular).

---

## Level 1 — Salesforce Platform Fundamentals

Prerequisite for everything else in this file. If you already hold Salesforce Administrator certification and have 1+ years of hands-on config experience, skim this level and move to Level 2.

#### 1.1 Platform Navigation & Data Modeling
- **Objectives:** Understand the object/field/record model; differentiate standard vs. custom objects; build object relationships (lookup, master-detail); use Schema Builder.
- **Prerequisites:** None.
- **Estimated study time:** 4–6 hours.
- **Hands-on exercises:** In a Trailhead Playground, create 2 custom objects with a lookup relationship between them; import 20 sample records via Data Import Wizard; visualize the result in Schema Builder.
- **Recommended official resources:** [Admin Beginner](https://trailhead.salesforce.com/content/learn/trails/force_com_admin_beginner) (trail); [Data Modeling](https://trailhead.salesforce.com/content/learn/modules/data_modeling) (module).
- **Expected outcomes:** Can describe the object/field/record model from memory and build a simple two-object schema with a working relationship.

#### 1.2 Data Security & Access Model
- **Objectives:** Org-wide defaults (OWD), role hierarchy, profiles vs. permission sets, sharing rules — and when each tool is the right one.
- **Prerequisites:** 1.1.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Set OWD on a custom object to Private; build a role hierarchy 2 levels deep; create one sharing rule and one permission set; verify access with two test users.
- **Recommended official resources:** [Data Security](https://trailhead.salesforce.com/content/learn/modules/data_security) (module).
- **Expected outcomes:** Can design a least-privilege access model for a simple multi-role scenario and explain the difference between role-hierarchy access and a sharing rule.

#### 1.3 Process Automation with Flow
- **Objectives:** Build record-triggered and screen flows; understand Flow's limits and when Apex becomes necessary (e.g., callouts, complex transaction logic).
- **Prerequisites:** 1.1.
- **Estimated study time:** 6–8 hours.
- **Hands-on exercises:** Build a record-triggered flow that enforces a business rule on save; build a screen flow that guides a user through multi-step data entry with branching logic.
- **Recommended official resources:** [Build Flows with Flow Builder](https://trailhead.salesforce.com/content/learn/trails/build-flows-with-flow-builder) (trail).
- **Expected outcomes:** Can automate a realistic multi-step business process without writing code, and can articulate why a given requirement would or wouldn't be a good fit for Flow.

#### 1.4 Apex Fundamentals (architect/developer track)
- **Objectives:** Variables, control structures, SOQL, basic triggers; recognize the boundary where Flow hands off to Apex.
- **Prerequisites:** 1.3.
- **Estimated study time:** 8–10 hours.
- **Hands-on exercises:** Write a simple Apex trigger that enforces a rule Flow can't (e.g., a recursive bulk calculation); write 3 SOQL queries against your Level 1.1 objects in Developer Console.
- **Recommended official resources:** [Apex Basics & Database](https://trailhead.salesforce.com/content/learn/modules/apex_database) (module).
- **Expected outcomes:** Can read and write basic Apex, and can justify in writing why a given requirement needs Apex rather than Flow.

**Optional checkpoint:** [Salesforce Certified Administrator](https://trailhead.salesforce.com/credentials/administrator) credential.

---

## Level 2 — Financial Services Cloud Fundamentals

Prerequisite for every vertical and integration level that follows.

#### 2.1 FSC Overview, Sectors & Packages
- **Objectives:** Explain FSC's value proposition; understand the three core sectors (Retail Banking, Wealth Management, Insurance); know what's in the core managed package vs. industry add-on packages.
- **Prerequisites:** Level 1.
- **Estimated study time:** 3–4 hours.
- **Hands-on exercises:** Work through the "Explore Financial Services Cloud Sectors" and "Meet Financial Services Cloud" units; review the Financial Services Cloud Packages list and identify which packages a Retail Banking-only client would need vs. a multi-sector client.
- **Recommended official resources:** [Financial Services Cloud Basics](https://trailhead.salesforce.com/content/learn/modules/financial-services-cloud-basics) (module); [Financial Services Cloud Packages](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_packages.htm&language=en_US&type=5) (Help).
- **Expected outcomes:** Can explain FSC's purpose and package architecture to a client in non-technical terms.

#### 2.2 FSC Core Data Model (Person Accounts, Households, Financial Accounts)
- **Objectives:** PersonAccount as the member model; Household/Relationship Groups; FinancialAccount object and its roles; how these map to real client relationships.
- **Prerequisites:** 2.1.
- **Estimated study time:** 6–8 hours.
- **Hands-on exercises:** Build a household containing 2 member PersonAccounts; create a FinancialAccount and attach a Financial Account Role to each member; confirm rollups (e.g., total holdings) calculate correctly at the household level.
- **Recommended official resources:** [Client Management with Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/client-management-with-financial-services-cloud) (module); [Financial Services Cloud Data Models](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_data_model_diagram.htm&language=en_US&type=5) (Help); [Financial Services Cloud Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_object_reference.meta/financial_services_cloud_object_reference) (Developer).
- **Expected outcomes:** Can model a multi-member household with linked financial accounts and explain the FSC object graph from memory.

#### 2.3 Compliant Data Sharing (CDS) & FSC Security
- **Objectives:** CDS participants and participant roles; when CDS is needed over standard sharing rules; supported objects.
- **Prerequisites:** 2.2.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Set up Compliant Data Sharing on a Financial Deal record; configure 2 participant roles with different access levels; verify a third user without a participant role is correctly denied access.
- **Recommended official resources:** [Compliant Data Sharing in Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/compliant-data-sharing-in-financial-services-cloud) (module).
- **Expected outcomes:** Can configure record-level compliant sharing for sensitive deal/client data and explain why CDS exists alongside standard sharing rules.

#### 2.4 FSC Sample App Exploration
- **Objectives:** See FSC data-model and UI patterns in a working reference implementation rather than just documentation.
- **Prerequisites:** 2.2.
- **Estimated study time:** 2–3 hours.
- **Hands-on exercises:** Deploy the DreamInvest LWC sample to a scratch org; walk through its Lightning Web Components and note which FSC-style objects/patterns it reuses vs. simplifies.
- **Recommended official resources:** [DreamInvest LWC](https://github.com/trailheadapps/dreaminvest-lwc) (sample app); [Quick Start: Tour the Sample App Gallery](https://trailhead.salesforce.com/content/learn/projects/quick-start-tour-the-sample-app-gallery) (project).
- **Expected outcomes:** Has a working, inspectable reference implementation and can point to specific components when explaining FSC patterns to a developer.

---

## Level 3 — Retail Banking

#### 3.1 Retail Banking Data Model & Branch Management
- **Objectives:** Branch hierarchy; assigning employees/partners to branches; tracking activity and performance by branch.
- **Prerequisites:** Level 2.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Configure a 2-tier branch hierarchy; assign 2 employees to different branches; confirm branch-scoped reporting reflects the assignment.
- **Recommended official resources:** [Branch Management in Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/branch-management-in-financial-services-cloud) (module); ["Deliver Specialized Banking Services"](https://trailhead.salesforce.com/content/learn/modules/financial-services-cloud-basics/deliver-specialized-banking-services) unit (Financial Services Cloud Basics).
- **Expected outcomes:** Can configure branch-based structure and service routing for a retail bank client.

#### 3.2 Service Process Studio for Banking
- **Objectives:** Smart intake forms; real-time integration patterns with core banking systems; consistent service-rep workflows.
- **Prerequisites:** 3.1.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Build one guided intake process for a common banking service request type (e.g., card dispute) using Service Process Studio.
- **Recommended official resources:** [Service Process Studio Foundations](https://trailhead.salesforce.com/content/learn/modules/service-process-studio-foundations) (module).
- **Expected outcomes:** Can design a guided, consistent service-intake experience for a banking call center.

#### 3.3 Discovery Framework for Banking Data
- **Objectives:** Structured discovery and capture of customer financial data ahead of a service or sales conversation.
- **Prerequisites:** 3.1.
- **Estimated study time:** 3–4 hours.
- **Hands-on exercises:** Configure the Discovery Framework for one data category (e.g., income sources) and walk through the resulting guided capture experience.
- **Recommended official resources:** [Discovery Framework Basics for Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/discovery-framework-basics-for-financial-services-cloud) (module).
- **Expected outcomes:** Can configure systematic, repeatable client-data discovery rather than ad hoc note-taking.

#### 3.4 Lending & Mortgage Objects (architect-level)
- **Objectives:** Residential Loan Application, Loan Applicant, Title Holder, and related lending objects and their relationships.
- **Prerequisites:** 3.1.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Diagram a mortgage application's full object chain from applicant to title holder using your own org or the reference diagram.
- **Recommended official resources:** [Mortgage — Data Model](https://architect.salesforce.com/diagrams/template-gallery/financial-services-cloud-mortgage-data-model) (Architect Template Gallery).
- **Expected outcomes:** Can map a mortgage lifecycle to FSC objects without referring to the diagram.

---

## Level 4 — Wealth Management

#### 4.1 Wealth Management Overview
- **Objectives:** Advisor portfolio views; personalized client engagement; onboarding and service-at-scale patterns for advisors.
- **Prerequisites:** Level 2.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Configure an advisor portfolio view for a sample client and walk through the onboarding flow an advisor would see on day one.
- **Recommended official resources:** [Enhance Wealth Management with Financial Services Cloud](https://trailhead.salesforce.com/content/learn/trails/fsc_build_loyalty) (trail).
- **Expected outcomes:** Can demo a wealth advisor's core day-to-day experience end to end.

#### 4.2 Financial Goals & Household Wealth Planning
- **Objectives:** The Financial Goals object; linking goals to accounts and households; household-level rollups for planning conversations.
- **Prerequisites:** 4.1, Level 2.2.
- **Estimated study time:** 4 hours.
- **Hands-on exercises:** Create a financial goal linked to 2 financial accounts within a household; confirm progress-to-goal calculates correctly as account values change.
- **Recommended official resources:** ["Learn to Create and Manage Households"](https://trailhead.salesforce.com/content/learn/modules/client-management-in-financial-services-cloud/build-households-and-groups) unit (Client Management in Financial Services Cloud); [Financial Services Cloud Data Models](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_data_model_diagram.htm&language=en_US&type=5) (Help).
- **Expected outcomes:** Can build and present a goals-based household planning view.

#### 4.3 Financial Deal Management (investment banking-adjacent wealth)
- **Objectives:** Deal team structures; handling material non-public information (MNPI) via Compliant Data Sharing.
- **Prerequisites:** 2.3, 4.1.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Configure one Financial Deal record with 2 CDS participant roles representing different deal-team functions.
- **Recommended official resources:** [Optimize Financial Deal Management & Data Sharing](https://trailhead.salesforce.com/content/learn/trails/manage-financial-deals) (trail); [Financial Deal — Data Model](https://architect.salesforce.com/diagrams/template-gallery/financial-services-cloud-deal-data-model) (Architect Template Gallery).
- **Expected outcomes:** Can configure a compliant, role-based deal workspace for sensitive wealth/investment-banking scenarios.

---

## Level 5 — Insurance

#### 5.1 Insurance Data Model
- **Objectives:** Policy, coverage, and claim objects and how they relate to each other and to the household/customer model.
- **Prerequisites:** Level 2.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Model one policy with 2 coverages and a linked claim; trace the relationship chain back to the policyholder's household record.
- **Recommended official resources:** [Insurance for Financial Services Cloud Data Model](https://trailhead.salesforce.com/content/learn/modules/insurance-for-financial-services-cloud-data-model) (module).
- **Expected outcomes:** Can describe the policy → coverage → claim chain from memory and locate each object in an org.

#### 5.2 Insurance Admin Essentials
- **Objectives:** Baseline setup steps required to stand up insurance-specific FSC capability in an org.
- **Prerequisites:** 5.1.
- **Estimated study time:** 5 hours.
- **Hands-on exercises:** Complete the Admin Essentials setup sequence end-to-end in a trial/Trailhead-provisioned org.
- **Recommended official resources:** [Insurance for Financial Services Cloud Admin Essentials](https://trailhead.salesforce.com/content/learn/modules/insurance-for-financial-services-cloud-admin-essentials) (module).
- **Expected outcomes:** Can stand up a working base insurance org configuration unassisted.

#### 5.3 Insurance Advanced Features (Life Events & Milestones)
- **Objectives:** Life-event-triggered service moments; business milestone tracking for proactive engagement.
- **Prerequisites:** 5.2.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Configure one life-event trigger (e.g., a policy renewal window) and verify the resulting proactive service prompt.
- **Recommended official resources:** [Insurance for Financial Services Cloud Admin Advanced Features](https://trailhead.salesforce.com/content/learn/modules/insurance-for-financial-services-cloud-admin-advanced-features) (module); [Deliver Personalized Insurance Service with Financial Services Cloud](https://trailhead.salesforce.com/content/learn/trails/deliver-personalized-insurance-service-with-financial-services-cloud) (trail).
- **Expected outcomes:** Can configure proactive, life-event-driven insurance service rather than purely reactive claims handling.

---

## Level 6 — Data Cloud Integration

Data Cloud was rebranded **Data 360** in October 2025 — see Branding Notes above.

#### 6.1 Data Cloud / Data 360 Fundamentals
- **Objectives:** Data streams, Data Model Objects (DMOs), mapping, and harmonization across source systems.
- **Prerequisites:** Level 2.
- **Estimated study time:** 6–8 hours.
- **Hands-on exercises:** Ingest one CSV data stream into a Data Cloud org and map its fields to a Data Model Object.
- **Recommended official resources:** [Unlock Your Data with Data Cloud](https://trailhead.salesforce.com/content/learn/trails/unlock-your-data-with-data-cloud) (trail); [Salesforce Data 360: Quick Look](https://trailhead.salesforce.com/content/learn/modules/salesforce-genie-quick-look) (module).
- **Expected outcomes:** Can ingest and map a new data source into Data Cloud without guidance.

#### 6.2 Identity Resolution & Unified Profiles
- **Objectives:** Match and reconciliation rules; building a single unified customer profile from multiple source records.
- **Prerequisites:** 6.1.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Build an identity resolution ruleset across 2 data sources and confirm the resulting unified profile correctly merges matching records.
- **Recommended official resources:** [Data and Identity in Salesforce CDP](https://trailhead.salesforce.com/content/learn/modules/data-and-identity-in-salesforce-cdp) (module).
- **Expected outcomes:** Can produce a single, accurate unified customer profile from two previously siloed sources.

#### 6.3 Calculated Insights for Financial Metrics
- **Objectives:** Build calculated and streaming insights to derive financial metrics from unified data.
- **Prerequisites:** 6.2.
- **Estimated study time:** 4–5 hours.
- **Hands-on exercises:** Build one calculated insight (e.g., total assets under management per household) and use it in a segment.
- **Recommended official resources:** [Data Cloud Insights & Use Cases](https://trailhead.salesforce.com/content/learn/modules/customer-data-platform-insights) (module).
- **Expected outcomes:** Can produce a derived financial metric ready for activation, segmentation, or agent grounding.

#### 6.4 Data Cloud's Financial Services Data Model
- **Objectives:** Understand the prebuilt core-banking and insurance Data Model Objects Data Cloud ships with, and how they relate to FSC's own objects.
- **Prerequisites:** 6.1.
- **Estimated study time:** 4 hours.
- **Hands-on exercises:** Review one prebuilt Financial Services DMO and map it against the FSC object(s) it would typically receive data from.
- **Recommended official resources:** [Financial Services Overview](https://developer.salesforce.com/docs/platform/data-models/guide/data-cloud-financial-services-overview.html) (Data Model Gallery, Developer); [Financial Services Cloud category](https://developer.salesforce.com/docs/platform/data-models/guide/financial-services-cloud-category.html) (Data Model Gallery, Developer).
- **Expected outcomes:** Can explain how FSC's transactional objects and Data Cloud's prebuilt financial-services data model relate and where each is the system of record.

**Optional checkpoint:** [Salesforce Certified Data Cloud Consultant](https://trailhead.salesforce.com/credentials/datacloudconsultant) credential.

---

## Level 7 — Agentforce Integration

#### 7.1 Agentforce Fundamentals
- **Objectives:** Agents, topics, actions, and the reasoning engine — the core vocabulary of the platform.
- **Prerequisites:** Level 2.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Complete the Agentforce Basics module's hands-on org steps and identify each concept (agent/topic/action) inside the provisioned org.
- **Recommended official resources:** [Agentforce Basics](https://trailhead.salesforce.com/content/learn/modules/einstein-copilot-basics) (module); [Agentblazer](https://trailhead.salesforce.com/agentblazer) learning path.
- **Expected outcomes:** Can explain the agent/topic/action architecture without notes.

#### 7.2 Agent Builder Hands-On
- **Objectives:** Build and customize an agent using Agent Builder's tooling.
- **Prerequisites:** 7.1.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Build one custom topic with one custom action in Agent Builder and test it end-to-end in the conversation preview.
- **Recommended official resources:** [Introduction to Agent Builder](https://trailhead.salesforce.com/content/learn/modules/introduction-to-agent-builder) (module).
- **Expected outcomes:** Can ship a working custom agent topic unassisted.

#### 7.3 Agentforce for Financial Services
- **Objectives:** Prebuilt FSC-specific agent skills for banking and insurance service and collections use cases.
- **Prerequisites:** 7.2, and at least one of Level 3 or Level 5.
- **Estimated study time:** 5–6 hours.
- **Hands-on exercises:** Enable one prebuilt Agentforce-for-FSC skill in a trial org and run it through a representative banking or insurance service scenario.
- **Recommended official resources:** [Agentforce for Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/agentforce-for-financial-services-cloud) (module); [Agentforce for Financial Services](https://help.salesforce.com/s/articleView?id=ind.fsc_agents_overview.htm&language=en_US&type=5) (Help); [Get Started — Agentforce Bots for FSC](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_admin_guide.meta/financial_services_cloud_admin_guide/fsc_bots_getstarted.htm) (Developer).
- **Expected outcomes:** Can configure a vertical-specific agent skill end-to-end for a real banking or insurance scenario.

#### 7.4 Agentforce + Data Cloud Grounding
- **Objectives:** How agent actions and responses ground themselves in live Data Cloud data rather than static configuration.
- **Prerequisites:** 7.3, Level 6.
- **Estimated study time:** 4 hours.
- **Hands-on exercises:** Ground one agent action in a Data Cloud calculated insight built in 6.3 and verify the agent's response reflects live data changes.
- **Recommended official resources:** ["Review Data Cloud for Agentforce"](https://trailhead.salesforce.com/content/learn/modules/cert-prep-agentforce-specialist/review-data-cloud-for-agentforce) unit (Agentforce Specialist exam prep).
- **Expected outcomes:** Can connect an agent action to live Data Cloud data and explain the grounding mechanism to a client.

**Optional checkpoint:** [Salesforce Certified Agentforce Specialist](https://trailhead.salesforce.com/credentials/agentforcespecialist) credential.

---

## Level 8 — Enterprise Architecture

This level assumes all prior levels plus real, sustained implementation experience (typically 2+ years) — it is not purely a study exercise.

#### 8.1 Salesforce Well-Architected Framework
- **Objectives:** Apply the Trusted / Easy / Adaptable pillars to an FSC reference architecture.
- **Prerequisites:** Level 7.
- **Estimated study time:** 6–8 hours.
- **Hands-on exercises:** Run one real or sample FSC org through the Well-Architected review checklist and document 3 findings per pillar.
- **Recommended official resources:** [Well-Architected Framework](https://architect.salesforce.com/docs/architect/well-architected/overview) (Architect Center); [Well-Architected Guide — Overview](https://architect.salesforce.com/docs/architect/well-architected/guide/overview.html).
- **Expected outcomes:** Can produce a Well-Architected assessment for a live FSC org.

#### 8.2 Data 360 & Agentic Enterprise Architecture
- **Objectives:** Enterprise architecture patterns spanning FSC, Data Cloud/Data 360, and Agentforce as a single connected system.
- **Prerequisites:** 8.1, Level 6, Level 7.
- **Estimated study time:** 6–8 hours.
- **Hands-on exercises:** Draft one reference architecture diagram connecting an FSC org, Data 360, and an Agentforce agent, with data flow direction labeled at each integration point.
- **Recommended official resources:** [Data 360 Architecture](https://architect.salesforce.com/fundamentals/data-360-architecture) (Architect Center); [The Agentic Enterprise — IT Architecture for the AI-Powered Future](https://architect.salesforce.com/docs/architect/fundamentals/guide/agentic-enterprise-it-architecture.html) (Architect Center).
- **Expected outcomes:** Can present an end-to-end FSC + Data 360 + Agentforce architecture to technical and business stakeholders.

#### 8.3 Architect Credential Path (System → Application → CTA)
- **Objectives:** Understand the credential prerequisite chain, exam structure, and review-board format leading to CTA.
- **Prerequisites:** 8.1.
- **Estimated study time:** Variable — budget 40–60 hours of structured prep per Architect Designer credential, beyond hands-on experience.
- **Hands-on exercises:** Complete at least one Architect Designer certification (System Architect or Application Architect) as a verifiable checkpoint.
- **Recommended official resources:** [Architect Overview](https://trailhead.salesforce.com/credentials/architectoverview) (credential); [System Architect](https://trailhead.salesforce.com/credentials/systemarchitect) (credential); [Application Architect](https://trailhead.salesforce.com/credentials/applicationarchitect) (credential); [Certified Technical Architect](https://trailhead.salesforce.com/credentials/technicalarchitect) (credential).
- **Expected outcomes:** Holds at least one Architect Designer certification and has a scoped, dated plan toward CTA Review Board eligibility (both System Architect and Application Architect are prerequisites for the CTA exam).

#### 8.4 CTA Review Board Preparation
- **Objectives:** Synthesize a multi-cloud (FSC + Data 360 + Agentforce) scenario into a review-board-ready solution under time pressure.
- **Prerequisites:** 8.3 — both System Architect and Application Architect credentials held.
- **Estimated study time:** 100+ hours over several months; most candidates report 6–18 months of sustained preparation including mock boards.
- **Hands-on exercises:** Produce one full mock review-board solution (architecture diagram, justification narrative, trade-off analysis, presentation) for an FSC-based enterprise scenario; present it to peers or a study group and incorporate critique.
- **Recommended official resources:** [Architect Review Board](https://trailhead.salesforce.com/credentials/architectreviewboard) (credential detail); [Certified Technical Architect](https://trailhead.salesforce.com/credentials/technicalarchitect) (credential).
- **Expected outcomes:** Ready to register for the CTA Review Board Exam.
- **Cost note:** The CTA Review Board Exam registration fee is $1,500 USD plus applicable taxes, with a $750 USD retake fee — budget for this before scheduling (verify current pricing on the credential page, as Salesforce updates exam fees independently of this document).

---

## Cumulative Study Time Summary

| Level | Topics | Estimated structured study time |
|---|---|---|
| 1 — Salesforce Platform Fundamentals | 4 | 22–29 hrs |
| 2 — Financial Services Cloud Fundamentals | 4 | 15–20 hrs |
| 3 — Retail Banking | 4 | 16–20 hrs |
| 4 — Wealth Management | 3 | 12–14 hrs |
| 5 — Insurance | 3 | 14–16 hrs |
| 6 — Data Cloud Integration | 4 | 19–23 hrs |
| 7 — Agentforce Integration | 4 | 19–22 hrs |
| 8 — Enterprise Architecture | 4 | 12–16 hrs structured + 100+ hrs sustained CTA prep (variable) |
| **Total (Levels 1–7, structured)** | **26** | **≈117–144 hrs** |

Level 8 is intentionally excluded from the structured total — CTA readiness is paced by real-world delivery experience, not study hours alone.

## Open Decisions
1. Levels 3–5 (Retail Banking, Wealth Management, Insurance) are presented as parallel/order-flexible once Level 2 is done — confirm this matches how you actually want to sequence trainee cohorts, or whether one vertical should be mandatory-first given current client mix (Avolta is Loyalty, not a banking/wealth/insurance vertical match — confirm this file should stay generic-FSC rather than Avolta-specific).
2. Level 6/7 ordering — this file assumes Data Cloud (6) before Agentforce (7) because 7.4 depends on a Data Cloud insight from 6.3. Confirm that dependency should hold, or whether some trainees should learn Agentforce first and treat 7.4 as a forward-reference to revisit later.
3. Should the "Optional checkpoint" certifications (Administrator, Data Cloud Consultant, Agentforce Specialist) be made mandatory gates between levels rather than optional, given this is positioned as a trainer curriculum rather than a personal study plan?

## Next Steps
- Confirm the three Open Decisions above.
- On your go-ahead, commit/push this file to `Financial Services Cloud/02_Learning_Path.md` on GitHub (same web-UI commit flow used for `01_Official_Resources.md`).
- Re-verify Level 6–7 resource URLs each release cycle — Data Cloud/Data 360 and Agentforce are the two fastest-moving product areas in this roadmap and module slugs have already shifted once (Data Cloud → Data 360, October 2025).
