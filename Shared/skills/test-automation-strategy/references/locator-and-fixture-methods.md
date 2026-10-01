# Locator and Fixture Methods

## Conditional locator choices

| Situation | Useful choice | Check |
|---|---|---|
| Control has meaningful role/name | Semantic role and accessible name | Unique within the intended region; action matches the control |
| Form field has an associated label | Label relation | Correct field association, not nearby unrelated text |
| Stable text is the observable content | Text locator/assertion | Expected locale, ambiguity and dynamic content |
| Semantics are insufficient or content changes | Stable test ID / explicit hook | Hook identifies the intended element without pretending to validate semantics |
| Repeated items | Scope by stable parent/user relation | Avoid selecting the first match just to silence ambiguity |
| Incidental CSS or deep DOM ancestry | Prefer a stable semantic/hook contract | A structural selector may be justified locally, never a default brittle path |

No row is a fixed ranking that fits all providers. Preserve the test's purpose
when an implementation changes. A passing locator is not an accessibility audit.

## Playwright-specific illustration

Use only with the project's installed compatible Playwright API; no dependency
or browser installation is implied. These examples demonstrate distinct choices,
not a mandatory sequence:

```javascript
page.getByRole('button', { name: '儲存', exact: true });
page.getByLabel('電子郵件');
page.getByText('已儲存', { exact: true });
page.getByTestId('canvas-export');
```

Playwright recommends user-facing attributes and explicit contracts. Its locators
support role/name, label, text and test IDs; test IDs can suit an explicit testing
contract while role/text checks reflect user-visible meaning. Long CSS/XPath
chains are vulnerable to implementation changes. Verify version-specific details
against [official Playwright locators](https://playwright.dev/docs/locators)
(checked 2026-09-15). This is provider guidance, not a universal framework rule.

## Stable setup and failure evidence

Use the project's actual isolation boundary: fresh session, scoped test account,
transaction rollback, unique resource names or controlled in-memory state as
appropriate. Establish data before the action, await the selected observable
transition and restore owned temporary state after the case. Do not rely on
prior tests, arbitrary delays or fixed global accounts to make a case pass.

For a timeout, distinguish readiness, wrong locator and a product transition that
never happened. For an assertion mismatch, compare the accepted contract before
editing the expectation. Record relevant action/locator, expected/actual state,
timing and provider diagnostics. Any repair follows the existing owner and scope.
