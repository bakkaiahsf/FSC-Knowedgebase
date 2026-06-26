# 09_Whats_New

## Folder
Data Cloud

## Purpose
Recent release highlights for Data Cloud / Data 360, current as of June 2026. Verify against the live release notes (`01_Official_Resources.md`) before teaching — this is the fastest-moving file in the folder.

## Branding Notes
- **The headline change**: Data Cloud was renamed **Data 360** on October 14, 2025, at Dreamforce, as part of the **Agentforce 360** platform umbrella. This is a rename plus a strategic repositioning — Data 360 is now framed as the live data/context layer that fuels Agentforce, not a standalone customer data platform. Functionality carried over unchanged at the moment of rename; subsequent releases (Winter '26, Spring '26) then added genuinely new capability on top.
- Product naming history for context: Customer 360 Audiences (2020) → Salesforce CDP (2021) → Marketing Cloud Customer Data Platform (2022) → Salesforce Genie (2022) → Data Cloud (2023) → **Data 360** (2025).

## Winter '26 Highlights
- **Segmentation & real-time triggers**: enhanced segmentation tooling and real-time trigger support, plus sandbox availability for testing segmentation logic before production rollout.
- **Data Cloud for Commerce**: hyperpersonalized B2C commerce experiences powered by Data Cloud.
- **Data Cloud One / Data Spaces**: centralizing and partitioning data to power AI models and predictive apps more efficiently across batch and real-time use cases.
- **Analytics enhancements**: updates across Tableau Next, Lightning reports/dashboards, Data Cloud reports and dashboards, CRM Analytics, and Intelligent Apps.
- **Data Processing Engine**: ability to debug CRM Analytics jobs (Beta), write transformation output back to Data Model Objects, and new formula functions (`coalesce`, `array_join`, `MD5`).
- Rollout window: phased from mid-September through early October 2025, ahead of the October 14, 2025 Data 360 rebrand announcement.

## Spring '26 Highlights
- **Ready-to-use Data Lake Objects**: pre-mapped to standard CRM fields, reducing manual mapping effort and project setup time.
- **Code Extension (Beta)**: run custom Python logic directly inside Data 360 for advanced transformation, enrichment, matching, and modeling beyond declarative Data Processing Engine transforms.
- **Clean Rooms (GA)**: governed collaboration environment for joint analysis across two organizations' data without exposing raw underlying records to the partner.
- **Notebook AI (GA)**: a workspace blending files, links, and Data Cloud sources for more natural, conversational exploration of blended context.
- **Query limits**: SOQL query results against Data 360 are now capped at 12 MB per query; queries exceeding this are rejected and must be paginated via "query more."
- **Tableau Semantics & Intelligent Context**: help Agentforce agents reason over unstructured data alongside structured DMOs through a governed semantic layer.

## Pricing Model Notes (verify before quoting)
- As of early 2026, three pricing models are referenced publicly: credit-based consumption, profile-based SKUs, and flex credits. Specific multipliers and per-profile rates are commercially sensitive and change — do not reuse any number from this file in a client-facing quote without checking the live pricing page.
- Identity Resolution remains, directionally, the most expensive per-row operation type in the credit model — this shapes the "federate vs. ingest" architecture guidance throughout this folder (`03_Key_Concepts.md` Section 11, `04_Architecture_Patterns.md` Pattern 4).

## What This Means for the Six Anchor Scenarios
- **Pattern 4 (Zero Copy Federation)** gets more attractive with each release as the Zero Copy Partner Network and federation tooling mature — re-confirm currently-certified partners each release.
- **Pattern 6 (Data-Grounded Agentforce Actions)** is the clearest beneficiary of the Data 360 rebrand's strategic framing — Notebook AI, Intelligent Context, and Tableau Semantics are all explicitly positioned as making agent grounding richer.
- **Pattern 5 (Calculated Insights)** benefits from Data Processing Engine's expanded write-back and formula capability — more insight logic can now stay declarative rather than requiring external compute.

## Open Decisions
- **Release cadence mismatch**: this file will be stale within one Salesforce release (three per year) by construction — recommend a standing trainer task to re-run the `01_Official_Resources.md` release-notes searches each season rather than treating this file as evergreen.
- **Scope creep beyond the six anchor topics**: Data Cloud for Commerce and Tableau Next/CRM Analytics depth extend beyond this folder's banking/wealth-leaning anchor scenarios — flagged here rather than expanded inline, consistent with the same flag raised in the Financial Services Cloud folder's equivalent file.

## Sources
- [Salesforce Data Cloud Renamed to 'Data 360' As Part of 'Agentforce 360' - Salesforce Ben](https://www.salesforceben.com/salesforce-data-cloud-renamed-to-data-360-as-part-of-agentforce-360/)
- [Salesforce Renamed Data Cloud to Data 360 - Apex Hours](https://www.apexhours.com/salesforce-renamed-data-cloud-to-data-360/)
- [Salesforce Help — Data 360 Rebrand Release Note](https://help.salesforce.com/apex/HTViewHelpDoc?id=release-notes.rn_cdp_2026_winter_data360_rebrand.htm)
- [Salesforce Winter '26 Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm&language=en_US&release=258&type=5)
- [Winter '26 Release: 10 Breakthrough Innovations - Salesforce News](https://www.salesforce.com/news/stories/winter-2026-product-release-announcement/)
- [The Salesforce Developer's Guide to the Winter '26 Release - Salesforce Developers Blog](https://developer.salesforce.com/blogs/2025/09/winter26-developers)
- [Salesforce Spring '26 Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm&language=en_US&release=260&type=5)
- [Spring '26 Breakdown: The Data 360 Updates You Shouldn't Ignore - Palladin Technologies](https://palladintech.com/blog/spring-26-breakdown-the-data-360-updates-you-shouldnt-ignore/)
- [Explore New Features of Agentforce and Data 360 Solutions - Trailhead](https://trailhead.salesforce.com/content/learn/modules/spring-26-release-highlights/see-whats-new-agentforce-data-360-agentforce-sales)
- [Salesforce Data 360 Credit Optimization Guide - jitendrazaa.com](https://www.jitendrazaa.com/blog/salesforce/salesforce-data-360-credit-optimization-guide-march-2026/)
- [Data 360 Pricing - Salesforce](https://www.salesforce.com/data/pricing/)

## Next Steps
- Build `10_Enterprise_Use_Cases.md` — the folder's deep-format capstone file.
