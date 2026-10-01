# UI Language And Interface Examples

Examples support `Shared/policies/ui-ux-standards.md`; they are not independent
gates. Approved project context and the actual audience constrain their use.

## Audience and error examples

End users generally need intent language; operators may need domain terms;
developers/system administrators may need technical details. Translate the
meaning rather than applying a universal forbidden-word list without context.

| Internal description | User-oriented example |
|---|---|
| User Entity Created | Account created successfully |
| Authorization Pending | Awaiting approval |
| Failed to fetch / Timeout | Connection unstable. Please try again later. |
| Invalid JWT Token | For your security, please log in again. |
| Database Deadlock | We're processing your request. Please wait. |

Traditional Chinese examples include 「系統暫時無法處理，請稍後再試」、「目前連線不穩定，請稍後再試」
and 「為了您的安全，請重新登入」. Choose messages that reflect the actual failure and
available recovery; a generic reassuring message must not hide a different state.
Use project localization keys and conventions instead of adding a new i18n system
merely because a UI changes.

## Surface and density examples

| Surface | Useful inspection questions |
|---|---|
| Web | Responsive layout, overflow and relevant browser interaction |
| Desktop GUI | Minimum/common window sizes, dialogs, font scaling, keyboard and scroll behavior |
| IDE/plugin panel | Narrow/expanded widths, themes, command feedback and confirmation states |
| Terminal/TUI | Wrapping, errors, exit codes and non-interactive behavior |
| Mixed | Distinct evidence for each affected surface |

Operational dashboards, trading terminals and administration tools often need
dense organized information, stable controls and low visual noise. Marketing
surfaces may prioritize brand and narrative hierarchy. Use the actual operator
goal; do not force sparse marketing composition onto a dense operational task.

## State, component and visual heuristics

Skeletons are one loading technique; meaningful empty states can offer an
appropriate next action. Inspect hover, focus, disabled, error and overflow
states. Existing tokens help keep palette and spacing consistent; raw primary
colors should be evaluated against the design role, not silently changed when
they are an intentional product requirement.

Classify component decisions as reuse, extend, create or establish. With no
existing UI, describe candidate primitives instead of claiming an inventory.
Use already-approved screenshots, slices or context as DNA; generated references
remain direction material. Detailed evidence methods remain in
`workflow-review-visual-evidence.md`. Open visual direction is handled by
`Shared/workflows/ui-design-exploration.md`, not another UI governance Skill.
