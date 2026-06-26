# 09_Whats_New

## Folder

Financial Services Cloud

## Purpose

A snapshot of recent Salesforce release-note items relevant to Financial Services Cloud, Data 360, and Agentforce for Financial Services, with notes on what each means for training content and architecture in this folder. **This is a snapshot, not a live feed** — Salesforce ships releases on a fixed cadence (currently Winter/Spring/Summer per year, with Data 360 features shipping as often as monthly) and this file will drift out of date. Always verify against the latest official Salesforce Release Notes before presenting any item below as current.

## Branding Notes

- Items below are tagged by release (Winter '26, Spring '26, Summer '26) as found in search results current as of this file's authoring (June 2026). Salesforce's naming convention ties a release name to the calendar season/year it ships in, not to when this file was written.
- "Agentforce for Financial Services" is the current branding for FSC's AI-agent capability layer; "Data 360" is the current branding for what was "Data Cloud" prior to October 14, 2025.

---

## Winter '26

**Agentforce for Financial Services: Collections Assistance** — Scales debt recovery with AI-assisted automation: orchestrates customer outreach, answers routine questions, and works to secure payment commitments, deflecting routine collections calls so specialists can focus on complex settlements.

- *Impact on training*: Adds a seventh candidate anchor topic (Collections) alongside the six already built in this folder — worth a future lab once provisioning/licensing for Collections-specific Agentforce skills is confirmed.
- *Impact on architecture*: Suggests Agentforce skill design for FS is expanding beyond the two skills already documented in `04_Architecture_Patterns.md` (Financial Advisor Assistance, Banking Relationship Assistance) — treat the skill list there as a snapshot, not exhaustive.
- *Impact on certifications*: Collections-specific Agentforce configuration is plausible new exam surface for Agentforce-for-Financial-Services-focused credentials; verify against the current exam guide before teaching it as in-scope.

## Spring '26

**Flexible Hierarchies for Financial Services** — Lets reps map complex B2B corporate hierarchies (parent companies to subsidiaries) for a full financial picture, helping relationship managers visualize risk and uncover revenue across a corporate family tree. Ships with a Connect REST API to validate that a flexible hierarchy is in Draft status and meets data model constraints before processing.

- *Impact on training*: This is a Commercial/Corporate Banking capability, not Retail/Wealth — it extends this folder's scope beyond the six anchor topics (which are retail/wealth-leaning) into commercial relationship management. Candidate for a seventh anchor topic or a dedicated Commercial Banking sub-section.
- *Impact on architecture*: Suggests a hierarchy-aware data model is now a first-class FSC capability rather than something architects had to bolt on with custom Account-Account relationships — worth reassessing whether `04_Architecture_Patterns.md`'s patterns should reference this directly for any future B2B/commercial pattern.

**Agentforce Voice for Financial Services** — Voice AI integrated with Service Cloud Voice, allowing deployment of AI agents to resolve common banking and collections inquiries by phone at scale, operating within FSC's security model (consent management, audit trails, controlled access to sensitive financial data) rather than a traditional IVR menu-tree experience.

- *Impact on training*: Voice-channel Agentforce is now real and FS-specific, not just a generalized Agentforce Service capability — worth a dedicated lab/demo once a trial org has Voice provisioned.
- *Impact on architecture*: Reinforces that Agentforce design work in this domain must explicitly account for consent management and audit-trail requirements at the voice-channel layer, not just the chat/text layer already covered in this folder's Agentforce notes.

**Banking Service Assistance Agent Templates** — A significant expansion of pre-built Agentforce-for-Financial-Services capability, described as nearly doubling out-of-the-box coverage across employee productivity, digital self-service, and voice channels in one release.

- *Impact on training*: The "two skills documented" framing in `04_Architecture_Patterns.md` is likely understating current out-of-the-box Agentforce-for-FS coverage — flag this explicitly when teaching that file until it's refreshed with the expanded template list.
- *Impact on certifications*: Broader template coverage likely means broader exam surface for Agentforce-for-Financial-Services-specific assessments going forward.

## Summer '26

**Multi-Agent Orchestration (GA)** — Lets multiple Agentforce agents work together as a unified team on complex, end-to-end workflows, giving the customer one point of contact with shared context across channels rather than having to find "the right agent."

- *Impact on training*: Directly relevant to Advisor Workspace (Topic 4) and any future Collections/Voice topics — an advisor-facing or client-facing experience could plausibly be backed by multiple specialized agents (e.g., one handling portfolio summary, another handling compliance checks) orchestrated together rather than one monolithic agent.
- *Impact on architecture*: Raises a new design question for this folder's Agentforce sections: should a given anchor topic's Agentforce design assume a single agent/skill, or a small orchestrated team? Worth revisiting `04_Architecture_Patterns.md`'s Agentforce subsections once Multi-Agent Orchestration's FS-specific guidance is verified.

**Agentforce Voice with SIP (GA)** — Calls route to an Agentforce Service agent over SIP instead of PSTN-only, treating voice as just another channel on the Omni-Channel routing layer; described as cheaper and more flexible than the prior PSTN-only path.

- *Impact on architecture*: For any FS voice-channel design (see Spring '26 item above), SIP-based routing is now the GA path — worth confirming this is the routing architecture referenced if/when a Voice-specific lab is added to this folder.

**Data 360 — Real-Time Data Processing, Data Harmonization, Unified Customer Profiles, Enhanced Audience Segmentation** — Continued investment in faster ingestion, consistent cross-system customer profiles, and real-time behavior-based segmentation under the Data 360 umbrella.

- *Impact on architecture*: Directly relevant to this folder's Data Cloud Mapping notes in `04_Architecture_Patterns.md` (identity resolution, DLO/DMO mapping) — the "Unified Customer Profiles" framing reinforces that Data 360 is the intended unification layer beneath FSC's engagement layer, consistent with the reference architecture already cited there.

**Data 360 — Dataspace-aware SOQL and currency reporting** — SOQL queries can now specify Data 360 dataspaces and control NULL/empty-string handling for Data 360 data lake objects; currency reporting added for financial insights within Data 360.

- *Impact on training*: Currency reporting in Data 360 is directly relevant to this folder's multi-currency consolidation concerns (the same category of problem as month-end USD consolidation patterns referenced elsewhere in your own delivery work) — worth a dedicated note once the `Data Cloud` folder is populated.

## Open Decisions

- **Cadence mismatch**: Data 360 ships features as often as monthly, while this file is structured around named seasonal releases (Winter/Spring/Summer). Decide whether to add a lighter-weight "monthly Data 360 watch" sub-section in a future revision rather than waiting for the next seasonal refresh of this file.
- **Scope creep beyond six anchor topics**: Both Flexible Hierarchies (commercial banking) and Collections Assistance (collections) point outside this folder's current six anchor topics. Decide whether to formally add a seventh/eighth anchor topic now or treat them as forward-looking watch items until the population order revisits this folder.

## Next Steps

- Re-verify every item in this file against the live Salesforce Release Notes the next time this folder is revisited — treat anything here older than one release cycle as unconfirmed.
- Feed the Multi-Agent Orchestration and Voice-with-SIP items into `04_Architecture_Patterns.md`'s Agentforce subsections as candidate updates, pending your review.

## Sources

- [Salesforce Announces Spring 2026 Product Release](https://www.salesforce.com/news/stories/spring-2026-product-release-announcement/)
- [Salesforce Announces Winter 2026 Product Release](https://www.salesforce.com/news/stories/winter-2026-product-release-announcement/)
- [Financial Services Cloud Release Notes (Salesforce Help)](https://help.salesforce.com/s/articleView?id=release-notes.rn_fsc.htm&language=en_US&release=244&type=5)
- [Summer '26 Release: 10 Innovations Bringing the Agentic Enterprise to Life](https://www.salesforce.com/news/stories/summer-2026-product-release-announcement/)
- [About Data 360 Releases (Salesforce Help)](https://help.salesforce.com/s/articleView?id=data.c360_a_dc_releases.htm&language=en_US&type=5)
- [Spring '26 Banking Service Assistance Agent Templates — Vantage Point](https://vantagepoint.io/blog/sf/spring-26-banking-service-assistance-agent-templates-agentforce-fsc)
