# 00_README

## Folder

Financial Services Cloud

## Purpose

Index and orientation page for this folder. Read this first — it tells you what each file covers, the order they were built in, and how they depend on each other, before you go looking for a specific fact in the wrong file.

## What This Folder Is

This folder is the Financial Services Cloud knowledge domain inside the Salesforce Trainer Operating System (STOS). It trains a Salesforce professional from "what is FSC" through architect-level pattern design, hands-on configuration, interview readiness, classroom delivery, and staying current — all anchored to one consistent set of six topics so the material reinforces itself instead of repeating in isolation.

## The Six Anchor Topics

Every file in this folder (03 onward) is organized around the same six topics, introduced as architecture patterns in `04_Architecture_Patterns.md` and then carried through every subsequent file:

1. Retail Banking Customer 360
2. Household Management
3. Wealth Household View
4. Advisor Workspace
5. Client Onboarding
6. Referral Management

## File Index

| File | Covers | Status |
|---|---|---|
| `00_README.md` | This index | Done |
| `01_Official_Resources.md` | Curated links to official Salesforce documentation, Trailhead, and release notes for FSC | Done |
| `02_Learning_Path.md` | An 8-level learning sequence from platform fundamentals to enterprise architecture | Done |
| `03_Key_Concepts.md` | Glossary of 11 core FSC concepts (objects, relationships, security model) | Done |
| `04_Architecture_Patterns.md` | The 6 anchor topics as architecture patterns — business problem through trade-offs | Done |
| `05_Hands_On_Labs.md` | The 6 anchor topics as step-by-step labs in a trial/Developer org | Done |
| `06_Interview_Questions.md` | Beginner through CTA-style interview questions across the 6 anchor topics | Done |
| `07_Trainer_Notes.md` | How to teach each anchor topic — whiteboard explanations, demo sequences, exercises | Done |
| `08_Common_Mistakes.md` | Implementation, security, performance, and architecture mistakes, plus exam traps | Done |
| `09_Whats_New.md` | Recent Salesforce release notes relevant to FSC, Data 360, and Agentforce | Done |
| `10_Enterprise_Use_Cases.md` | Full enterprise use cases across banking, insurance, wealth, and AI/Data Cloud/Agentforce lenses | Done |

## How to Use This Folder

- **New to FSC?** Start at `02_Learning_Path.md`, keep `03_Key_Concepts.md` open as a glossary.
- **Designing a solution?** Go straight to `04_Architecture_Patterns.md`, then `10_Enterprise_Use_Cases.md` for the industry-specific version of the same pattern.
- **Building a demo or trial org?** Use `05_Hands_On_Labs.md`.
- **Prepping to teach this material?** Use `07_Trainer_Notes.md` alongside `05_Hands_On_Labs.md`.
- **Prepping for an interview or exam?** Use `06_Interview_Questions.md` and `08_Common_Mistakes.md` together.
- **Checking if something changed recently?** Use `09_Whats_New.md` — and verify against the latest official Salesforce Release Notes regardless, since this file is a snapshot, not a live feed.

## Standing Rules for This Folder (inherited from `MASTER_INSTRUCTIONS.md` and `SEARCH_RULES.md`)

- Never invent Salesforce capabilities. If a capability depends on the current release, this folder says so explicitly and points you to verify against the latest Salesforce Release Notes.
- FSC has two coexisting object generations — legacy `FinServ__`-namespaced managed-package objects and newer namespace-less standard objects. Confirm which your org uses via Object Manager before treating any field/object name below as gospel.
- Branding is in motion: "Financial Services Cloud" capabilities are increasingly marketed under "Agentforce Financial Services," and "Data Cloud" was rebranded "Data 360" effective October 14, 2025. Both names are used interchangeably across this folder depending on what the cited source called it at the time.

## Open Decisions

- **Depth model**: This folder deliberately keeps 01-05 in the lighter, category-level format already shipped, and layers `10_Enterprise_Use_Cases.md` on top for the deeper, per-industry treatment, rather than rewriting 01-05 into a full per-topic deep-dive template. Revisit if the lighter format proves insufficient once this folder is used in an actual training session.
- **New folders not yet in this file set**: `LWC` and a duplicate-looking `FSC-Knowledgebase` folder exist at the repo root but aren't part of the 19-folder population order in `MASTER_INSTRUCTIONS.md`/the STOS master prompt — flagging for your review on whether they're stray scaffolding or intentional.

## Next Steps

- Treat this folder as complete per the STOS "stop after each folder" rule. Hold here for review before starting `Data Cloud` (the next folder in the population order).
- If review approves the depth model above, apply the same 11-file pattern (00 + 01-10) to each subsequent folder for consistency.
