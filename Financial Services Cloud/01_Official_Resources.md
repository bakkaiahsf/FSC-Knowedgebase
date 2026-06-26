# 01_Official_Resources

## Folder
Financial Services Cloud

## Branding Note (read before using this file)
Salesforce is migrating the "Financial Services Cloud" name toward **Agentforce Financial Services** as part of the 2025–2026 Agentforce rebrand. Trailhead module pages now carry the disclaimer: *"Financial Services Cloud is now called Agentforce Financial Services. You may see references to Financial Services Cloud in our application and documentation."* Salesforce Help (`ind.fsc_agents_overview.htm`) and Trailhead (`agentforce-for-financial-services-cloud`) publish under the new name for the AI-agent layer; the core admin/dev docs below still sit under the `fsc_` ID namespace. Treat the two names as the same product line until Salesforce fully retires one — re-confirm current terminology against live Release Notes before each training delivery.

All resources below are first-party Salesforce properties (`help.salesforce.com`, `trailhead.salesforce.com`, `developer.salesforce.com`, `architect.salesforce.com`, `salesforce.com`, or the official `@salesforce` YouTube channel). No community blogs, partner content, or third-party channels are included — items found during research but excluded for failing that bar are listed explicitly so they aren't silently re-added later.

---

## 1. Salesforce Help

#### [Financial Services Cloud](https://help.salesforce.com/s/articleView?id=ind.fsc_admin.htm&language=en_US&type=5)
- **Title:** Financial Services Cloud
- **Description:** Main Salesforce Help landing page for FSC — entry point into the Administrator Guide.
- **Why It Matters:** Canonical starting point; nearly every other admin article on FSC links from here.
- **Recommended Audience:** Admins, Architects, Trainers
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide (developer.salesforce.com)
- **Related Release Notes:** Review the Financial Services Cloud Administrator Guide (restructure note)

#### [Common Capabilities in Financial Services Cloud](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_common_capabilities.htm&language=en_US&type=5)
- **Title:** Common Capabilities in Financial Services Cloud
- **Description:** Baseline capabilities shared across all FSC industry verticals (banking, wealth, insurance).
- **Why It Matters:** Establishes what's "core" vs. vertical-specific — critical for scoping any FSC implementation.
- **Recommended Audience:** Architects, Business Analysts
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics — Explore Financial Services Cloud Sectors
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Plan and Prepare for Your Financial Services Cloud Implementation](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_overview.htm&language=en_US&type=5)
- **Title:** Plan and Prepare for Your Financial Services Cloud Implementation
- **Description:** Pre-implementation planning guidance — licensing, packages, setup sequencing.
- **Why It Matters:** Prevents the most common FSC implementation mistake: installing packages/permission sets out of order.
- **Recommended Audience:** Architects, Admins
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide — Get Started
- **Related Release Notes:** Financial Services Cloud Installation, Quick Start, and Update Guides

#### [Financial Services Cloud Data Models](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_data_model_diagram.htm&language=en_US&type=5)
- **Title:** Financial Services Cloud Data Models
- **Description:** Visual index of FSC data model diagrams (Person Account/Household, Financial Account, etc.).
- **Why It Matters:** Fastest way to see object relationships before writing SOQL or designing automation.
- **Recommended Audience:** Architects, Developers
- **Learning Priority:** Core
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Data Models for Financial Services Cloud](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_data_model.htm&language=en_US&type=5)
- **Title:** Data Models for Financial Services Cloud
- **Description:** Text-based companion to the diagram index above — field-level and relationship detail.
- **Why It Matters:** Confirm exact object/field names here before referencing them in training content — don't rely on memory.
- **Recommended Audience:** Developers, Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Learn About Financial Services Cloud and Explore](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_learn_explore.htm&language=en_US&type=5)
- **Title:** Learn About Financial Services Cloud and Explore
- **Description:** Orientation page pointing new admins/architects to learning paths and explore-org guidance.
- **Why It Matters:** Bridges Help docs to Trailhead — the "what to read first" pointer for new trainees.
- **Recommended Audience:** Admins, New hires
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Financial Services Cloud Developer Center
- **Related Release Notes:** —

#### [Financial Services Cloud Packages](https://help.salesforce.com/s/articleView?id=ind.fsc_admin_packages.htm&language=en_US&type=5)
- **Title:** Financial Services Cloud Packages
- **Description:** Lists the managed packages that make up FSC (core package plus industry-specific add-ons).
- **Why It Matters:** Many implementation defects trace back to a missing or mismatched package version — this is the source of truth.
- **Recommended Audience:** Architects, Release Managers
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide
- **Related Release Notes:** Financial Services Cloud Installation, Quick Start, and Update Guides

#### [Agentforce for Financial Services](https://help.salesforce.com/s/articleView?id=ind.fsc_agents_overview.htm&language=en_US&type=5)
- **Title:** Agentforce for Financial Services
- **Description:** Overview of the Agentforce AI-agent layer purpose-built for FSC (banking/insurance service and collections use cases).
- **Why It Matters:** The active product direction (see branding note above) — required knowledge for any current FSC + Agentforce engagement.
- **Recommended Audience:** Agentforce Architects, Solution Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** Agentforce for Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide — Get Started with Bots
- **Related Release Notes:** Spring '26 Release — Agentforce Voice for Financial Services

---

## 2. Trailhead

#### [Connect with Customers Using Financial Services Cloud](https://trailhead.salesforce.com/content/learn/trails/connect-with-customers-using-financial-services-cloud)
- **Title:** Connect with Customers Using Financial Services Cloud
- **Description:** Primary FSC trail — mortgages, insurance, wealth/advisor portfolio views, relationship graphs, branch management.
- **Why It Matters:** The closest thing to an official curriculum for FSC; should anchor `02_Learning_Path.md`.
- **Recommended Audience:** Admins, Consultants, New hires
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** (this is the trail itself — see modules below)
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide
- **Related Release Notes:** —

#### [Financial Services Cloud Basics](https://trailhead.salesforce.com/content/learn/modules/financial-services-cloud-basics)
- **Title:** Financial Services Cloud Basics *(module — includes units "Explore Financial Services Cloud Sectors" and "Meet Financial Services Cloud")*
- **Description:** Entry-level module covering FSC's purpose and industry sectors (banking, wealth, insurance).
- **Why It Matters:** Lowest-friction starting point for Beginner-track trainees.
- **Recommended Audience:** Beginners
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Connect with Customers Using Financial Services Cloud (trail)
- **Related Developer Documentation:** Financial Services Cloud Developer Center
- **Related Release Notes:** —

#### [Client Management with Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/client-management-with-financial-services-cloud)
- **Title:** Client Management with Financial Services Cloud
- **Description:** Hands-on module on managing clients, households, and relationships inside FSC.
- **Why It Matters:** Maps directly to the Person Account/Household data model — a recurring exam and interview topic.
- **Recommended Audience:** Admins, Consultants
- **Learning Priority:** Core
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Enhance Wealth Management with Financial Services Cloud](https://trailhead.salesforce.com/content/learn/trails/fsc_build_loyalty)
- **Title:** Enhance Wealth Management with Financial Services Cloud
- **Description:** Wealth-management-focused trail — personalized engagement, onboarding, service at scale.
- **Why It Matters:** Covers the Wealth Management vertical specifically — feeds the Wealth Management Expert training hat.
- **Recommended Audience:** Wealth Management consultants
- **Learning Priority:** Core
- **Related Trailhead Modules:** Connect with Customers Using Financial Services Cloud (trail)
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide
- **Related Release Notes:** —

#### [Agentforce for Financial Services Cloud](https://trailhead.salesforce.com/content/learn/modules/agentforce-for-financial-services-cloud)
- **Title:** Agentforce for Financial Services Cloud *(unit: "Understand Agentforce for Financial Services and Its Benefits")*
- **Description:** Module covering Agentforce's prebuilt skills and benefits for banking/insurance use cases.
- **Why It Matters:** Trailhead's own authoritative source for the Agentforce + FSC bridge file proposed in the folder-structure review.
- **Recommended Audience:** Agentforce Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Agentforce for Financial Services (Help)
- **Related Release Notes:** Spring '26 Release — Agentforce Voice for Financial Services

#### [Quick Start: Tour the Sample App Gallery](https://trailhead.salesforce.com/content/learn/projects/quick-start-tour-the-sample-app-gallery)
- **Title:** Quick Start: Tour the Sample App Gallery
- **Description:** Orientation project for navigating Salesforce's official Sample App Gallery, including DreamInvest.
- **Why It Matters:** Shows trainees how to find/run the FSC sample app referenced in Section 6.
- **Recommended Audience:** Developers
- **Learning Priority:** Reference
- **Related Trailhead Modules:** Discover Trailhead Sample Apps
- **Related Developer Documentation:** Sample Apps (developer.salesforce.com)
- **Related Release Notes:** —

---

## 3. Salesforce Developers

#### [Financial Services Cloud Developer Guide (Object Reference)](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_object_reference.meta/financial_services_cloud_object_reference)
- **Title:** Financial Services Cloud Developer Guide
- **Description:** Field-, object-, and Apex-trigger-level reference for everything FSC adds to the platform.
- **Why It Matters:** The single most-referenced doc for FSC SOQL/Apex/integration work — primary source for object/field names.
- **Recommended Audience:** Developers, Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** (this is the primary reference itself)
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Financial Services Cloud Administrator Guide](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_admin_guide.meta/financial_services_cloud_admin_guide)
- **Title:** Financial Services Cloud Administrator Guide
- **Description:** Developer-portal mirror of the Help Administrator Guide — setup, configuration, licensing.
- **Why It Matters:** Same content as Help but versioned/PDF-exportable — useful for offline trainer prep.
- **Recommended Audience:** Admins, Architects
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** Financial Services Cloud Installation, Quick Start, and Update Guides

#### [Financial Services Cloud Developer Center](https://developer.salesforce.com/developer-centers/financial-services-cloud)
- **Title:** Financial Services Cloud Developer Center
- **Description:** Landing hub aggregating FSC developer content and official docs links.
- **Why It Matters:** One bookmark for "what's new for FSC developers."
- **Recommended Audience:** Developers
- **Learning Priority:** Reference
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Object Reference; Financial Services Cloud Administrator Guide
- **Related Release Notes:** —

#### [Flow for Financial Services Cloud](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_object_reference.meta/financial_services_cloud_object_reference/fsc_meta_visual_workforce.htm)
- **Title:** Flow for Financial Services Cloud
- **Description:** Documents FSC's Flow-related metadata and considerations.
- **Why It Matters:** Confirms what's natively flow-supported in FSC vs. requiring Apex — directly relevant to flow-first delivery patterns.
- **Recommended Audience:** Developers, Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Developer Guide (Object Reference)
- **Related Release Notes:** —

#### [Get Started — Agentforce Bots for Financial Services Cloud](https://developer.salesforce.com/docs/atlas.en-us.financial_services_cloud_admin_guide.meta/financial_services_cloud_admin_guide/fsc_bots_getstarted.htm)
- **Title:** Get Started (Agentforce Bots for FSC)
- **Description:** Setup steps for enabling Agentforce bots within an FSC org.
- **Why It Matters:** The concrete "how" companion to the Agentforce-for-FSC overview articles above.
- **Recommended Audience:** Agentforce Architects, Admins
- **Learning Priority:** Core
- **Related Trailhead Modules:** Agentforce for Financial Services Cloud
- **Related Developer Documentation:** Agentforce for Financial Services (Help)
- **Related Release Notes:** Spring '26 Release — Agentforce Voice for Financial Services

---

## 4. Salesforce Architects

#### [Financial Services Cloud Overview — Data Model Gallery](https://architect.salesforce.com/diagrams/data-models/financial-services-cloud/financial-services-overview)
- **Title:** Financial Services Cloud Overview
- **Description:** Entry diagram for the FSC section of Salesforce's official Data Model Gallery.
- **Why It Matters:** Visual-first onboarding to FSC's object graph — pairs with the Help data-model articles above.
- **Recommended Audience:** Architects
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** —

#### [Financial Account — Data Model](https://architect.salesforce.com/diagrams/data-models/financial-services-cloud/financial-account)
- **Title:** Financial Account
- **Description:** Entities and relationships around FinancialAccount, Party Profile, and Account/Product objects.
- **Why It Matters:** FinancialAccount is the most-queried FSC object in production orgs — this is its canonical diagram.
- **Recommended Audience:** Architects, Developers
- **Learning Priority:** Core
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** New and Changed Financial Services Cloud Object Fields

#### [Customer — Data Model](https://architect.salesforce.com/diagrams/data-models/financial-services-cloud/customer)
- **Title:** Customer
- **Description:** Entities and relationships for modeling the FSC customer (Person Account, Household, Relationship Groups).
- **Why It Matters:** Foundational for member-uniqueness and household-sharing design questions.
- **Recommended Audience:** Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** Client Management with Financial Services Cloud
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** —

#### [Business Client Engagement — Data Model](https://architect.salesforce.com/diagrams/data-models/financial-services-cloud/business-client-engagement)
- **Title:** Business Client Engagement
- **Description:** Entities and relationships for applications, identity verification, and party screening (commercial banking).
- **Why It Matters:** Covers B2B/commercial banking — a gap most retail-skewed FSC training misses.
- **Recommended Audience:** Architects (commercial banking focus)
- **Learning Priority:** Advanced
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** —

#### [Financial Deal — Template Gallery](https://architect.salesforce.com/diagrams/template-gallery/financial-services-cloud-deal-data-model)
- **Title:** Financial Deal
- **Description:** Objects used to manage a financial deal lifecycle with Compliant Data Sharing (CDS).
- **Why It Matters:** CDS/deal-team sharing is one of the more advanced, exam-relevant FSC security topics.
- **Recommended Audience:** Architects (Advanced)
- **Learning Priority:** Advanced
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** —

#### [Mortgage — Template Gallery](https://architect.salesforce.com/diagrams/template-gallery/financial-services-cloud-mortgage-data-model)
- **Title:** Mortgage
- **Description:** Residential Loan Application, Loan Applicant, Title Holder, and related lending objects.
- **Why It Matters:** Core to the Lending/Mortgage sub-vertical of Retail Banking — frequently asked in interviews.
- **Recommended Audience:** Architects, Lending SMEs
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** —

#### [Well-Architected Guide — Overview](https://architect.salesforce.com/docs/architect/well-architected/guide/overview.html)
- **Title:** Well-Architected Guide
- **Description:** Salesforce's general cross-cloud architecture framework (not FSC-specific).
- **Why It Matters:** Apply this framework when validating any FSC reference architecture for trust, scale, and adaptability — generic but mandatory context. Candidate to relocate to a cross-cutting `/Architecture/` reference rather than live here (see Open Decisions).
- **Recommended Audience:** Architects
- **Learning Priority:** Reference
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** —
- **Related Release Notes:** —

---

## 5. Release Notes

#### [Financial Services Cloud (Release Notes index)](https://help.salesforce.com/s/articleView?id=release-notes.rn_fsc.htm&language=en_US&type=5)
- **Title:** Financial Services Cloud (Release Notes)
- **Description:** Per-release index of all FSC release-note entries.
- **Why It Matters:** Canonical "what changed" source — required check before publishing any FSC training content, per the repo's own MASTER_INSTRUCTIONS.md rule.
- **Recommended Audience:** Everyone maintaining this repo
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** —
- **Related Release Notes:** (this is the index itself)

#### [Salesforce Release Notes — full index](https://help.salesforce.com/s/articleView?language=en_US&id=release-notes.salesforce_release_notes.htm&type=5)
- **Title:** Salesforce Release Notes
- **Description:** Master release-notes hub for the current release across all clouds.
- **Why It Matters:** Parent link — navigate from here to the FSC-specific section of whichever release is current.
- **Recommended Audience:** Everyone
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** —
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

#### [Review the Financial Services Cloud Administrator Guide (restructure note)](https://help.salesforce.com/s/articleView?id=release-notes.rn_fsc_admin_guide_restructure.htm&language=en_US&release=226&type=5)
- **Title:** Review the Financial Services Cloud Administrator Guide
- **Description:** Notes a structural reorganization of the FSC Administrator Guide (Release 226).
- **Why It Matters:** Explains why older bookmarks/links into the Admin Guide may have moved.
- **Recommended Audience:** Anyone maintaining links into Help docs
- **Learning Priority:** Reference
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

#### [Financial Services Cloud Installation, Quick Start, and Update Guides](https://help.salesforce.com/s/articleView?id=release-notes.rn_fsc_guide_updates.htm&language=en_US&release=244&type=5)
- **Title:** Financial Services Cloud Installation, Quick Start, and Update Guides
- **Description:** Points to the current Installation/Quick Start/Update guides for the named release.
- **Why It Matters:** Confirms which guide version is current — installation steps change release to release.
- **Recommended Audience:** Architects, Release Managers
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Administrator Guide
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

#### [New and Changed Financial Services Cloud Object Fields](https://help.salesforce.com/s/articleView?id=release-notes.rn_fsc_new_and_changed_financial_services_cloud_object_fields.htm&language=en_US&release=246&type=5)
- **Title:** New and Changed Financial Services Cloud Object Fields
- **Description:** Per-release diff of new/changed FSC object fields.
- **Why It Matters:** Confirms whether an object/field exists in the release a client is actually on — prevents teaching features not yet in their org.
- **Recommended Audience:** Developers, Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** Financial Services Cloud Object Reference
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

#### [Industries Cloud Release Schedule](https://help.salesforce.com/s/articleView?id=000384140&language=en_US&type=1)
- **Title:** Industries Cloud Release Schedule
- **Description:** Publishes the release cadence specifically for Industries clouds (FSC included), which can differ from the core platform schedule.
- **Why It Matters:** FSC sometimes ships on a different cadence than core Salesforce — this is the only confirmed source for that.
- **Recommended Audience:** Release Managers, Architects
- **Learning Priority:** Core
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** —
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

#### [Spring '26 Product Release Announcement](https://www.salesforce.com/news/stories/spring-2026-product-release-announcement/)
- **Title:** Salesforce Announces Spring 2026 Product Release
- **Description:** Official Salesforce Newsroom announcement naming Agentforce Voice for Financial Services and Flexible Hierarchies for Financial Services as headline FSC features.
- **Why It Matters:** Source for the branding/feature claims used in the note at the top of this document — verify against the Help release notes above before teaching as fact.
- **Recommended Audience:** Everyone
- **Learning Priority:** Reference
- **Related Trailhead Modules:** Agentforce for Financial Services Cloud
- **Related Developer Documentation:** —
- **Related Release Notes:** Financial Services Cloud (Release Notes index)

---

## 6. Sample Applications

#### [DreamInvest](https://github.com/trailheadapps/dreaminvest)
- **Title:** DreamInvest
- **Description:** Official Salesforce sample app (Sample App Gallery) — financial-services use case, mutual-fund selector.
- **Why It Matters:** Only first-party, runnable FSC-adjacent sample code in the official `trailheadapps` GitHub org.
- **Recommended Audience:** Developers
- **Learning Priority:** Core
- **Related Trailhead Modules:** Quick Start: Tour the Sample App Gallery
- **Related Developer Documentation:** Sample Apps (developer.salesforce.com)
- **Related Release Notes:** —

#### [DreamInvest LWC](https://github.com/trailheadapps/dreaminvest-lwc)
- **Title:** DreamInvest LWC
- **Description:** Lightning Web Components version of DreamInvest.
- **Why It Matters:** Same use case as DreamInvest, modern LWC patterns — better fit for current-stack training.
- **Recommended Audience:** Developers
- **Learning Priority:** Core
- **Related Trailhead Modules:** Quick Start: Tour the Sample App Gallery
- **Related Developer Documentation:** Sample Apps (developer.salesforce.com)
- **Related Release Notes:** —

#### [Sample App Gallery](https://trailhead.salesforce.com/sample-gallery)
- **Title:** Sample App Gallery
- **Description:** Official hub listing all Salesforce sample apps, filterable by use case (Financial Services is a listed category).
- **Why It Matters:** Re-check this list each time this file is revisited for newly published FSC samples.
- **Recommended Audience:** Developers
- **Learning Priority:** Reference
- **Related Trailhead Modules:** Quick Start: Tour the Sample App Gallery; Discover Trailhead Sample Apps
- **Related Developer Documentation:** —
- **Related Release Notes:** —

> **Excluded:** `sfdx-isv/fsc-demo-pack` surfaced in research but is published under a Salesforce ISV-partner-enablement org, not the core FSC product or `trailheadapps` — it's scratch-org scaffolding tooling, not an official FSC sample app. Excluded per the "official Salesforce resources only" requirement; recorded here so it isn't silently re-added later.

---

## 7. Official Videos

#### [Meet the New Financial Services Cloud](https://www.youtube.com/watch?v=-jcfMdX2A_I)
- **Title:** Meet the New Financial Services Cloud
- **Description:** Official Salesforce YouTube (`@salesforce`) overview of FSC's purpose for financial institutions.
- **Why It Matters:** Verified first-party channel — safe to embed/cite directly in trainer materials.
- **Recommended Audience:** Beginners, Business stakeholders
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Financial Services Cloud Basics
- **Related Developer Documentation:** —
- **Related Release Notes:** —

#### [Build Trusted Customer Relationships: Wealth Management, Banking, Lending & Insurance](https://www.youtube.com/watch?v=OAE6b4gSun4)
- **Title:** Build Trusted Customer Relationships: Wealth Management, Banking, Lending & Insurance
- **Description:** Official Salesforce YouTube (`@salesforce`) video covering FSC across all four core verticals.
- **Why It Matters:** Verified first-party channel; strong single video to open a Beginner-track session spanning all FSC sub-domains.
- **Recommended Audience:** Beginners, Business stakeholders
- **Learning Priority:** Foundational
- **Related Trailhead Modules:** Connect with Customers Using Financial Services Cloud
- **Related Developer Documentation:** —
- **Related Release Notes:** —

#### [Watch the Salesforce Financial Services Cloud Demo (request form)](https://www.salesforce.com/financial-services/demos/financialservices-demo-form/)
- **Title:** Watch the Salesforce Financial Services Cloud Demo
- **Description:** Official salesforce.com product-demo page; the demo video is gated behind a short lead-capture form.
- **Why It Matters:** First-party source, but not freely embeddable — note this constraint before using in a public-facing training deck.
- **Recommended Audience:** Architects, Sales-facing trainers
- **Learning Priority:** Reference
- **Related Trailhead Modules:** —
- **Related Developer Documentation:** —
- **Related Release Notes:** —

> **Excluded (verified via YouTube oEmbed API, not the official `@salesforce` channel):** "Salesforce Financial Services Cloud Demo | Tutorial" (channel: Salesforce Hulk), "Salesforce Financial Services Cloud FSC - Top Features" and "Sales Cloud and FSC Demo for Wealth and Asset Management" (channel: Fostering LLC — a Salesforce *partner*, not Salesforce itself), "Demo Salesforce Financial Services Cloud (Español)" (channel: Intellect Systems), "Introduction to Salesforce Financial Services Cloud" (channel: Salesforce Apex Hours). All excluded per the "no community content" requirement; recorded here so they aren't silently re-added later.

---

## Verification Method
Help, Trailhead, Developer, and Architect URLs above were returned directly by web search against their official domains and spot-checked live. Every YouTube entry was independently verified via YouTube's oEmbed API (`youtube.com/oembed`) to confirm `author_name`/`author_url` resolves to the official `@salesforce` channel before inclusion — title and channel name alone were not trusted.

## Open Decisions
1. Branding — keep this folder/file under "Financial Services Cloud" naming, or begin tagging new content "Agentforce Financial Services" going forward?
2. The Well-Architected Guide entry (Section 4) is generic, not FSC-specific — keep here, or move to a cross-cutting `/Architecture/` reference per the horizontal/vertical split established by `SEARCH_RULES.md`?
3. Keep the "Excluded" callouts in this file permanently as a checked-and-rejected record, or strip them before this goes live for trainees?

## Next Steps
- Confirm the three Open Decisions above.
- On your go-ahead, commit/push this file to `Financial Services Cloud/01_Official_Resources.md` on GitHub (same web-UI commit flow used for `SEARCH_RULES.md`).
- Re-run this research pass each release cycle — several Help URLs are release-stamped (`release=244`, `release=246`, etc.) and will drift.
