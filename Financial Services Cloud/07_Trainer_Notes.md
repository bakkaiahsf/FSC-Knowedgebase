# 07_Trainer_Notes

## Folder

Financial Services Cloud

## Purpose

Delivery guidance for teaching each of the six anchor topics: how to whiteboard the concept, common student mistakes to pre-empt, a presentation outline, a demo sequence, audience-interaction prompts, in-session exercises, and homework. Pair with `05_Hands_On_Labs.md` for the underlying lab steps and `06_Interview_Questions.md` for assessment material.

## Branding Notes

- Where a demo step depends on the current release (e.g., a specific Agentforce skill name or a licensing dependency), say so explicitly to the class and verify against the latest Salesforce Release Notes before presenting it as current.
- Flag the FSC object-model duality (`FinServ__`-namespaced vs. standard objects) at the start of every session, once, rather than re-explaining it per topic — students should check Object Manager in their own practice org before following along.

---

## 1. Retail Banking Customer 360

**Common Student Mistakes**
- Treating Person Account as "just a Contact with extra fields" — misses that it's a merged Account/Contact record type with its own implications for sharing and reporting.
- Forgetting the Financial Account Role record, then being confused why the account looks "ownerless" in reporting.
- Trying to enable Person Accounts in a sandbox without first confirming a Business Account record type exists, then getting blocked mid-demo.

**Whiteboard Explanation**
Draw two boxes: "Account" and "Contact." Show them merging into one box labeled "Person Account." Then draw the Person Account connected to two Financial Account boxes (Checking, Savings), each connected via a small diamond labeled "Financial Account Role" back to the Person Account. This visually answers "why do I need a role record" — the diamond is the only thing carrying "who owns this."

**Presentation Outline**
1. The business problem (banker checks two systems today).
2. Why Person Account specifically (not Account/Contact).
3. The enablement gotcha (irreversible, prerequisite record type).
4. Financial Account + Financial Account Role as a pair, not a single object.
5. Interaction Summary as the service-history layer.
6. Tie it together on one Lightning page.

**Demo Sequence**
1. Show Setup → Person Accounts toggle (don't click it live unless using a fresh trial org — irreversible).
2. Show an already-enabled org: open a Person Account, point out merged fields.
3. Create a Financial Account live; create its Role; show the related list update.
4. Add an Interaction Summary; show it appear on the page.

**Audience Interaction**
Ask: "What would break in your current org's reporting if every Financial Account had zero Role records?" — let a few people answer before revealing the "ownerless for reporting" issue.

**Exercises**
- Create a second Person Account and a joint Checking account with two Financial Account Roles (both Owner). Confirm both clients see it.

**Homework**
- In a personal trial org, enable Person Accounts, create one client, two accounts, and one Interaction Summary, and screenshot the final Lightning page for next session's review.

---

## 2. Household Management

**Common Student Mistakes**
- Creating a new Household record from scratch instead of searching for an existing one first — leads to duplicate households.
- Setting `FinServ__Role__c` but forgetting `FinServ__IncludeInGroup__c`, then being confused why the rollup is short.
- Confusing "member of a household" with "Primary Group" — assuming any membership counts toward rollups.

**Whiteboard Explanation**
Draw a Household box in the center. Draw two Person Account boxes around it, each connected by a line labeled `AccountContactRelation`. On each line, mark two checkboxes: "Primary Group?" and "IncludeInGroup?" Visually show that the rollup arrow only originates from relationships where both are checked.

**Presentation Outline**
1. The business problem (advisor checks two client records instead of one family view).
2. Household as an Account with a special record type — not a new object.
3. `AccountContactRelation` as the join, and its two critical fields.
4. The Primary Group constraint (only one per client) and why it exists.
5. Rollup mechanics — scheduled vs. real-time trade-off.
6. Relationship Map as the visualization layer.

**Demo Sequence**
1. From an existing Person Account, launch New Household.
2. Add a second member; set role and IncludeInGroup.
3. Open Edit Relationship on each member; set Primary Group.
4. Run (or show the schedule for) the rollup; show the total.
5. Add the Relationship Map component live.

**Audience Interaction**
Ask: "Why might a bank deliberately choose not to auto-include every household member's accounts in the rollup?" — surface privacy/consent reasons (e.g., a dependent's account a parent shouldn't see combined into a shared total).

**Exercises**
- Break the rollup intentionally (uncheck IncludeInGroup on one member), observe the total change, then fix it — building the diagnostic muscle for the real troubleshooting scenario.

**Homework**
- Document, in their own words, the difference between "member of a household" and "Primary Group," using a household-with-a-divorce scenario as the example.

---

## 3. Wealth Household View

**Common Student Mistakes**
- Assuming ARC works for any org once Person Accounts are enabled — forgetting the permission set clone + "Access Actionable Relationship Center" step.
- Cloning the "Financial Services Cloud Extension" permission set but leaving its auto-populated API Name unedited, then losing track of which clone is which.
- Linking a Financial Goal to a Financial Plan but forgetting to link the contributing Financial Accounts, then being confused why progress reads 0%.

**Whiteboard Explanation**
Draw a Financial Goal box with a progress bar at 0%. Draw a dotted line from it to a Financial Account box, labeled "contributing account — must be explicit." Separately, draw three small circles labeled Group / Member / Peer next to an ARC graph icon, all needing to be "lit up" (active) for the graph to render — a visual cue for the most common ARC failure mode.

**Presentation Outline**
1. The business problem (advisor needs assets + goals + relationships in one place).
2. Financial Holdings under an Investment Financial Account.
3. Financial Plan/Goal and the explicit-linking requirement for progress.
4. `FinancialGoalParty` for joint goals.
5. Peer relationships (centers of influence) via Account-Account Relation.
6. ARC: permission set cloning discipline, the three Association Types, and graph configuration.

**Demo Sequence**
1. Add an Investment Financial Account and two Holdings.
2. Create a Financial Plan and Goal; deliberately skip linking an account — show 0% progress.
3. Link the account; show progress update.
4. Add a Peer relationship to an "attorney" Account.
5. Clone the permission set live, enable the ARC permission, assign it.
6. Build and show the ARC graph.

**Audience Interaction**
Ask: "If an ARC card disappears for one user but not another, what's your first move?" — drive toward checking that specific user's FLS/object access before assuming a config bug.

**Exercises**
- Intentionally deactivate one Association Type value, observe ARC fail to render, then reactivate it and confirm recovery — this is the single most common real-world ARC support ticket.

**Homework**
- Write a one-paragraph explanation, for a non-technical stakeholder, of why holdings data should ideally come from an integration rather than manual entry.

---

## 4. Advisor Workspace

**Common Student Mistakes**
- Building a workspace page with every available component above the fold, then being surprised by load-time complaints.
- Confusing "the card is hidden by a visibility rule" with "the user lacks sharing access" when troubleshooting a missing card.
- Forgetting to set visibility-rule criteria precisely (wrong permission/profile referenced), leaving a sensitive card visible to the wrong audience.

**Whiteboard Explanation**
Draw a vertical page outline. Mark the top third "above the fold — daily-use only" and shade it. Mark the rest "scroll zone — occasional use." Next to the ARC card specifically, draw a small padlock icon tied to a permission name, visually distinguishing "rule-based hiding" from a second icon (a slashed eye) representing "no data access at all."

**Presentation Outline**
1. The business problem (advisor checks five tabs before every meeting).
2. App Builder composition fundamentals — record page vs. app page.
3. Component selection mapped back to Labs 1-3's data.
4. Conditional components for licensed features (ARC, Agentforce panel).
5. Visibility rules — what they are, and what they are not (not a security boundary).
6. Performance trade-offs of "everything on one page."

**Demo Sequence**
1. Open App Builder; clone or create the workspace page.
2. Add components in priority order, narrating the above-the-fold decision each time.
3. Add a visibility rule restricting the ARC card to the ARC permission.
4. Preview as two different test users to show the rule working.

**Audience Interaction**
Ask: "What's the actual security risk if you rely on a visibility rule alone to protect sensitive data, instead of sharing/FLS?" — surface that visibility rules are cosmetic, not access control.

**Exercises**
- Given a list of eight candidate components, have students rank them above/below the fold for a specific persona (e.g., a junior associate vs. a senior advisor) and justify the ranking.

**Homework**
- Sketch (on paper or in a tool of choice) a workspace layout for a persona not covered in this lab — e.g., a branch manager — and list which of the six anchor topics' components they'd include.

---

## 5. Client Onboarding

**Common Student Mistakes**
- Building the Action Plan Template but forgetting to mark it active or assign it to the right object — then it doesn't appear in "Apply Action Plan."
- Assuming Action Plans can branch based on a live integration response — they can't; that requires Flow or OmniStudio orchestration around them.
- Marking a KYC task complete with no actual evidence attached, treating the checklist as the control instead of a record of the control.

**Whiteboard Explanation**
Draw a horizontal timeline with four boxes: Collect ID → KYC Check → Open Account → Welcome Call. Under "KYC Check," draw a small attached document icon with a question mark, prompting the question "what actually proves this happened?" — this becomes the anchor for the compliance-risk discussion.

**Presentation Outline**
1. The business problem (no client should skip a step, but OmniStudio isn't always provisioned).
2. Action Plan Template anatomy: Items vs. Document Checklist Items.
3. Applying a template to a record and watching the runtime Action Plan generate.
4. The evidence gap — completion vs. proof.
5. Where this design's ceiling is, and when OmniStudio becomes necessary instead.

**Demo Sequence**
1. Build the template live: four tasks, two document checklist items.
2. Apply it to a prospect record.
3. Walk through marking tasks complete.
4. Discuss (don't necessarily build) the Flow that would auto-create the Financial Account on completion.

**Audience Interaction**
Ask: "Who's accountable if a task gets marked complete in error and an account gets auto-opened as a result?" — there's no single right answer; the point is surfacing the governance question before automating.

**Exercises**
- Add a validation rule (conceptually, on a whiteboard or in a sandbox) that blocks marking "Run KYC Check" complete unless a KYC-result field is populated.

**Homework**
- Compare, in a short write-up, what this lab's design gives up versus a full OmniStudio Omniscript-based onboarding flow, and identify one real scenario where that trade-off would no longer be acceptable.

---

## 6. Referral Management

**Common Student Mistakes**
- Creating the Referral Lead record type but forgetting the `Referral Record Type Mapper` custom metadata step — referrals then get mis-scored or mis-routed.
- Letting an existing sales-Lead validation rule silently block referral Leads, then disabling the rule for everyone instead of scoping an exclusion.
- Routing referrals to a generic queue instead of one scoped to licensed advisors, creating downstream compliance exposure.

**Whiteboard Explanation**
Draw a funnel labeled "Lead." Inside it, draw a smaller labeled box "Person Referral (record type)." Next to the funnel, draw a small gear icon labeled "Referral Record Type Mapper" with an arrow pointing into the funnel — visually reinforcing that the mapper is a required wiring step, not optional metadata.

**Presentation Outline**
1. The business problem (referrals tracked in email get lost or mis-routed).
2. The Referral record type and its "Person Referral" UI label.
3. The Referral Record Type Mapper — what it does and why skipping it causes silent mis-scoring.
4. Need-indicator fields and (conditionally) Intelligent Need-Based Referral Scoring.
5. Queue + assignment rule for licensed-advisor-only routing.
6. Conversion and closing the loop back to the referrer.

**Demo Sequence**
1. Create the Referral record type live (or show it pre-built); assign to Lead Process and profiles.
2. Configure the Referral Record Type Mapper custom metadata record.
3. Create a referral Lead from a Person Account using "New Lead and Referral."
4. Show queue routing; convert the Lead; trace back to the referrer.

**Audience Interaction**
Ask: "Why might 'move referrals faster' and 'route only to licensed advisors' feel like they're in tension, and how do you resolve that for a stakeholder who only cares about speed?" — drive toward risk-adjusted speed framing.

**Exercises**
- Given a sample org-wide Lead validation rule, have students write the record-type exclusion clause needed to let Person Referral Leads through without disabling the rule for sales Leads.

**Homework**
- Write the post-upgrade checklist item that would have caught a missing `Referral Record Type Mapper` configuration before it caused a production issue.

---

## Open Decisions

- **Session length assumption**: This file assumes each anchor topic gets roughly one teaching session; confirm against your actual curriculum's time allocation and split topics 3 and 4 further if more time is needed given their conditional-feature density.
- **Live-demo risk**: Several demo steps (enabling Person Accounts, cloning permission sets) are irreversible or org-wide; confirm whether you'll demo live in a disposable trial org versus walking through screenshots in a shared training org.

## Next Steps

- Build matching slide decks per topic once this folder's content is reviewed and approved.
- Cross-link each topic's homework into `06_Interview_Questions.md`'s Scenario-Based questions for a closed-loop assessment cycle.
