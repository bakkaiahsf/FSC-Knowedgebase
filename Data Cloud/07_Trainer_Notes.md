# 07_Trainer_Notes

## Folder
Data Cloud

## Purpose
Delivery guidance for teaching this module to Salesforce developers, admins, business analysts, and solution architects. Assumes a half-day to full-day session; adjust pacing notes if your session length differs.

## Branding Notes
- Open every session by naming the rebrand up front ("Data Cloud is now called Data 360 — same product") so it doesn't become a distracting tangent mid-session when a learner notices inconsistent screenshots/docs.

## Session Structure (assumes ~4 hours; halve for a 2-hour primer, double for a 2-day workshop)
| Block | Duration | Content |
|---|---|---|
| 1. Why Data Cloud exists | 20 min | Fragmented data problem, Customer 360 vision, where Data Cloud sits relative to CRM clouds and FSC |
| 2. Ingestion & Modeling | 45 min | DLO → DMO → Data Spaces; live demo of Lab 1 |
| 3. Identity Resolution | 45 min | Match rules, deterministic vs. probabilistic, reconciliation; live demo of Lab 2 |
| 4. Break | 15 min | |
| 5. Insight, Segmentation, Activation | 60 min | Calculated Insights, segments, Activation-Triggered Flows; live demo of Lab 3 |
| 6. Zero Copy & Governance | 30 min | Federation, Data Spaces as access boundary, masking; walkthrough of Lab 4 |
| 7. AI Grounding & What's New | 30 min | Agentforce grounding pattern, Winter '26/Spring '26 highlights |
| 8. Wrap-up & Interview Questions | 15 min | Spot-check with `06_Interview_Questions.md` Beginner tier |

## Concepts That Need Extra Time
- **DLO vs. DMO**: learners conflate these constantly. Anchor it with a physical metaphor — DLO is the inbox/loading dock (raw, as-received), DMO is the filed, labeled version everyone actually works from.
- **Deterministic vs. probabilistic matching**: use the Lab 2 household scenario live — it's the clearest way to show why a shared address alone is dangerous for individual-level matching but fine for household-level grouping.
- **Credits/consumption model**: don't get pulled into quoting exact multipliers (sensitive, changes often) — teach the *shape* of the cost curve (Identity Resolution is the expensive operation; federation avoids re-running it) rather than specific numbers.
- **Zero Copy direction confusion**: learners often think "zero copy" means "no data ever leaves Salesforce." Clarify there are two directions (Data Cloud querying out, external platforms querying in) and neither involves a persisted duplicate.

## Live-Demo Risk Notes
- Lab 1–3 are safe to live-demo in a trial/sandbox org with sample data prepared in advance — don't build sample data live, it eats time and risks a typo derailing the identity-resolution result.
- Lab 4 (Zero Copy) is high risk to live-demo without a pre-provisioned warehouse trial — default to the walkthrough/discussion format from `05_Hands_On_Labs.md` unless you've personally tested the exact connection in advance.
- Never demo against a production org with real customer data, even read-only — Identity Resolution test runs can alter Unified Profile state.

## Audience-Specific Framing
- **Developers**: lean into Data Processing Engine, Code Extension (Beta), and the Ingestion API — they want to know what they can build, not just configure.
- **Admins**: lean into Data Streams, mapping, and segment-building UI — declarative-first framing.
- **Business Analysts**: lean into Calculated Insights and segmentation business value — translate "match rule" into "how confident are we this is the same customer."
- **Solution Architects**: lean into `04_Architecture_Patterns.md` and the Zero Copy cost tradeoff — this audience wants the "when do I NOT ingest" decision framework, not just feature tour.

## Common Questions to Pre-empt
- "Is Data Cloud the same as Marketing Cloud?" — No; clarify Marketing Cloud is one possible Activation target, not the same product, and that Data Cloud's CDP roots came partly from a since-renamed Marketing Cloud CDP product (naming history in `00_README.md`).
- "Do we need Data Cloud if we already have a data warehouse?" — Reframe: Data Cloud's value is identity resolution + native activation into Salesforce/Agentforce, not warehousing per se; Zero Copy federation explicitly lets the warehouse stay the warehouse.
- "Does this replace MuleSoft?" — No; in the banking pattern referenced in `04_Architecture_Patterns.md`, FSC is the engagement layer, Data Cloud is the unification layer, and MuleSoft (or another integration layer) still does point-to-point integration underneath.

## Trainer Tips
- Use the same six anchor scenarios across this entire folder (see `00_README.md`) — learners build a mental map faster when every section returns to a familiar scenario rather than a new example each time.
- Keep the FSC tie-ins explicit if this cohort already completed the Financial Services Cloud folder — call back to specific FSC objects (LoyaltyProgramMember, household/relationship model) by name.
- For the "What's New" block, explicitly tell learners which features are GA vs. Beta (Code Extension is Beta as of Spring '26) — teaching a Beta feature as if it's guaranteed-stable sets wrong expectations.

## Open Decisions
- Session-length assumption (4 hours) may not match the actual cohort's allotted time — confirm before finalizing an agenda, same flag as raised in the Financial Services Cloud folder's trainer notes.
- Whether to require trainees to have personal Data Cloud trial orgs before the session (recommended) or rely solely on instructor live-demo — affects whether Labs 1–3 can be done hands-on during the session or only watched.

## Next Steps
- Build `08_Common_Mistakes.md`, cross-referencing the "Concepts That Need Extra Time" section above.
