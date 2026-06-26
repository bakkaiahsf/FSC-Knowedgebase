# 08_Common_Mistakes

## Folder

Financial Services Cloud

## Purpose

A consolidated catalogue of implementation, security, performance, and architecture mistakes, plus exam traps, across the six anchor topics. This file aggregates and extends the Troubleshooting sections already in `05_Hands_On_Labs.md` — use this file when you need the mistake catalogue on its own (e.g., for a pre-go-live review checklist), and the labs file when you need the mistake in the context of the specific configuration steps that caused it.

## Branding Notes

- Mistakes tied to a specific release-dependent feature are marked so — verify against the latest Salesforce Release Notes before assuming the behavior described still applies.
- Several mistakes below stem directly from the `FinServ__`-namespaced vs. standard-object duality; always confirm which generation an org uses before applying a fix written for the other.

---

## Implementation Mistakes

| Mistake | Topic | Consequence | Fix |
|---|---|---|---|
| Creating a Financial Account with no Financial Account Role | Retail Banking Customer 360 | Account is effectively ownerless for reporting | Always pair account creation with a role record in the same transaction/process |
| Creating a new Household instead of searching for an existing one | Household Management | Duplicate household records, fragmented rollups | Search-first discipline before any "New Household" action |
| Setting `FinServ__Role__c` without `FinServ__IncludeInGroup__c` | Household Management | Member's balances silently excluded from rollup | Treat the two fields as a pair in any onboarding checklist or Flow |
| Linking a Financial Goal to a Plan but not to contributing accounts | Wealth Household View | Progress permanently reads 0% regardless of real growth | Make account-linking a required step in the goal-creation guided action's checklist |
| Leaving one of the three ARC Association Types inactive | Wealth Household View | ARC cards fail to render, often for only some users/records | Verify Group, Member, and Peer are all active as a standing health check |
| Applying an Action Plan Template that isn't marked active or assigned to the right object | Client Onboarding | Template doesn't appear in "Apply Action Plan," onboarding stalls | Confirm status and object assignment immediately after template creation, before training users on it |
| Skipping the `Referral Record Type Mapper` custom metadata configuration | Referral Management | Referral automation/scoring silently miscategorizes records | Add this step to any org-upgrade or initial-setup checklist as a named, separately-verified item |

## Security Mistakes

| Mistake | Topic | Consequence | Fix |
|---|---|---|---|
| Editing the original "Financial Services Cloud Extension" permission set directly | Wealth Household View | Future package upgrades can overwrite custom changes; loses the baseline for comparison | Always clone, never edit the original |
| Relying on a Lightning page component visibility rule as the actual access control | Advisor Workspace | Visibility rules are cosmetic — a user with direct object/API access still sees the underlying data | Enforce real restriction via sharing rules and field-level security; treat visibility rules as UX only |
| Granting a Wealth Referral Queue's membership too broadly | Referral Management | Unlicensed or non-territory advisors receive referrals they're not permitted to act on | Scope queue membership explicitly to licensed advisors, and pair with an assignment rule that matches license/territory criteria |
| Assuming a teller-profile and advisor-profile user should see identical Financial Account fields | Retail Banking Customer 360 | Either over-exposes sensitive balance data, or under-exposes data a role needs | Define FLS deliberately per profile rather than inheriting a default |

## Performance Mistakes

| Mistake | Topic | Consequence | Fix |
|---|---|---|---|
| Real-time declarative rollup recalculating Household balances on every Financial Account change at scale | Household Management | Governor-limit risk and degraded transaction performance across thousands of households | Use a scheduled Flow rollup instead, trading immediacy for predictable batch load |
| Loading every Advisor Workspace component above the fold simultaneously | Advisor Workspace | Noticeably slow page load, poor advisor experience during time-sensitive client prep | Sequence components by frequency of use; let lower-priority cards lazy-load on scroll |
| Bulk-creating Financial Accounts/Roles without bulkified patterns | Retail Banking Customer 360 | Risk of hitting governor limits (e.g., DML/SOQL row limits) during data migration or batch onboarding | Use bulkified Apex/Flow patterns with `IN` lists and appropriate `LIMIT` clauses for any batch account/role creation |

## Architecture Mistakes

| Mistake | Topic | Consequence | Fix |
|---|---|---|---|
| Building Referral Management on the standard Lead object without isolating it from sales-Lead automation | Referral Management | Inherited validation rules, conversion mappings, and reporting built for sales prospecting silently miscategorize or reject referral records | Add explicit record-type exclusions to shared automation, or evaluate a dedicated custom object if shared-automation conflicts become frequent |
| Treating ARC and Relationship Map as interchangeable | Wealth Household View / Advisor Workspace | Designing a page around ARC's action-enabled cards, then discovering the org isn't licensed for ARC | Confirm ARC licensing/provisioning before committing a page design to it; design the Relationship Map fallback alongside it from the start |
| Assuming OmniStudio is available without confirming provisioning | Client Onboarding | Onboarding design built around Omniscript/Integration Procedures stalls when the org isn't licensed | Confirm OmniStudio provisioning explicitly before choosing it over the lighter Action Plan pattern |
| Modeling multi-entity, multi-currency clients without an explicit legal-entity mapping layer | Retail Banking Customer 360 (extends to enterprise patterns) | Month-end consolidation and per-entity reporting become unreliable | Use a custom metadata type mapping each store/branch to its owning legal entity, stamped onto every relevant transaction/journal record at creation time |

## Exam Traps

- **"Person Accounts can be disabled later if needed."** False — enablement is irreversible at the org level. Exams frequently test whether you know this before recommending it.
- **"Any household membership counts toward the balance rollup."** False — only the Primary Group relationship counts, not every household a client belongs to.
- **"ARC works the same on the legacy Individual Model as on Person Accounts."** False — ARC requires the Person Account model.
- **"Action Plans can branch based on a live API response mid-flow."** False — that requires Flow/OmniStudio orchestration around the Action Plan, not the Action Plan itself.
- **"The Referral record type is called 'Referral' everywhere a user sees it."** Partially false — the API name is `Referral`, but the UI label for individual-to-individual referrals is "Person Referral"; exam questions sometimes test this naming gap directly.

## Open Decisions

- **Granularity vs. duplication with `05_Hands_On_Labs.md`**: This file deliberately repeats some Troubleshooting content from the labs file in table form for standalone use. Confirm this duplication is acceptable, or consider linking instead of repeating in a future revision.
- **Confidentiality guardrail**: This repo is public. Examples and fixes above are deliberately written as generic patterns rather than referencing any specific client engagement or its internal field/object names — keep that boundary in mind for future folders given the active client delivery work this knowledge base sits alongside.

## Next Steps

- Use this file as the basis for a pre-go-live review checklist once a real FSC implementation reaches UAT.
- Expand the Security Mistakes section once the `Security` folder is populated, to avoid duplicating org-wide security guidance prematurely.
