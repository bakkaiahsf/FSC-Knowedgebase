# 00_README

## Folder
Data Cloud

## Purpose
This folder is the Data Cloud module of the Salesforce Trainer Operating System (STOS). It teaches Data Cloud (rebranded **Data 360** as of October 14, 2025) as the unification and AI-context layer that sits underneath every Salesforce cloud — Sales, Service, Marketing, Commerce, and Financial Services Cloud (FSC). It is written so a Salesforce Architect, Consultant, or Trainer can go from zero to enterprise-ready on Data Cloud, with a deliberate lean toward financial-services scenarios that continue the Customer 360 narrative started in the Financial Services Cloud folder.

## Branding Notes
- **Data Cloud → Data 360**: Salesforce renamed Data Cloud to **Data 360** on October 14, 2025, at Dreamforce, as part of the broader **Agentforce 360** platform positioning. During the transition, both names appear across the UI, Trailhead, and documentation — functionality is unchanged, only the name and surrounding narrative shifted (Data 360 is now framed as the data/context layer that feeds Agentforce, not a standalone CDP).
- **Product naming history** (context only, do not test learners on superseded names): Customer 360 Audiences (2020) → Salesforce CDP (2021) → Marketing Cloud Customer Data Platform (2022) → Salesforce Genie (2022) → Data Cloud (2023) → Data 360 (2025).
- This folder uses **Data Cloud and Data 360 interchangeably**, defaulting to Data 360 for anything released Winter '26 or later, and noting where a feature predates the rebrand.

## File List
| File | Contents |
|---|---|
| `00_README.md` | This file — folder map, anchor scenarios, depth model |
| `01_Official_Resources.md` | Verified Trailhead trails, certification guide, Salesforce Help/Architect Center links |
| `02_Learning_Path.md` | Beginner → Intermediate → Advanced learning sequence |
| `03_Key_Concepts.md` | DLO, DMO, DSO, Identity Resolution, Calculated Insights, Segmentation, Activation, Data Spaces |
| `04_Architecture_Patterns.md` | Reference architectures across the six anchor scenarios |
| `05_Hands_On_Labs.md` | Step-by-step labs (Objective → Scenario → Prerequisites → Steps → Validation → Troubleshooting → Discussion) |
| `06_Interview_Questions.md` | Beginner/Intermediate/Advanced interview Q&A |
| `07_Trainer_Notes.md` | Delivery guidance for teaching this module |
| `08_Common_Mistakes.md` | Implementation pitfalls and how to avoid them |
| `09_Whats_New.md` | Winter '26 / Spring '26 release highlights, cited |
| `10_Enterprise_Use_Cases.md` | Deep-dive use cases across banking, insurance, wealth, retail, and service |

## Depth Model (carried over from Financial Services Cloud folder)
Files `00`–`09` use the **lighter, category-level format**: one file covers a theme across all six anchor scenarios rather than repeating a 12-section deep-dive per topic. `10_Enterprise_Use_Cases.md` is the exception — it uses the full 13-facet treatment (Business Problem → Assessment Questions) per use case. This asymmetry mirrors the Financial Services Cloud folder and is intentional: `10` is the folder's reference depth; `00`–`09` are the on-ramp.

## The Six Anchor Scenarios
To keep this folder coherent and to continue the narrative from Financial Services Cloud, every file builds on the same six scenarios:

1. **Unified Customer Profile** — Retail Banking Customer 360 (continues FSC's anchor of the same name)
2. **Household Identity Resolution** — resolving Individuals into Households across systems (continues FSC's Household Management)
3. **Next-Best-Action Segmentation & Activation** — wealth/retail cross-sell and retention segments activated into Marketing Cloud, Advertising, and Agentforce
4. **Zero-Copy Federation with Core Systems** — querying core banking, policy admin, or data-warehouse data (Snowflake, Databricks, BigQuery, Redshift) without duplicating it into Data Cloud
5. **Calculated Insights for Risk & Engagement Scoring** — churn risk, attrition, lifetime value, engagement scores computed on unified profiles
6. **Data-Grounded Agentforce Actions** — Agentforce agents (service copilot, advisor copilot) reading unified profiles and Calculated Insights as grounding context

## How to Use This Folder
- New to Data Cloud → start at `02_Learning_Path.md`, Beginner tier
- Need terminology fast → `03_Key_Concepts.md`
- Designing a solution → `04_Architecture_Patterns.md`, then `10_Enterprise_Use_Cases.md` for the closest matching scenario
- Running a lab/workshop → `05_Hands_On_Labs.md`
- Prepping for an interview or certification → `06_Interview_Questions.md` + `01_Official_Resources.md`
- Teaching this module → `07_Trainer_Notes.md`

## Open Decisions
- **Scope boundary**: Should this folder stay financial-services-leaning (continuing the FSC narrative) or broaden equally to retail/commerce/healthcare? Current draft leans financial services in examples but keeps concepts industry-neutral.
- **Pricing/credits content**: Credit-consumption multipliers and SKU pricing change frequently and are commercially sensitive — flagged in `09_Whats_New.md` as "verify against current pricing page before quoting to a client."

## Next Steps
- Build `01_Official_Resources.md` through `10_Enterprise_Use_Cases.md` in sequence.
- Hold for user review before starting the Agentforce folder, per the master prompt's stop-after-each-folder rule.
