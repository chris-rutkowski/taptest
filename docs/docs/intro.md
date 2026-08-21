---
sidebar_position: 1
---

# TapTest

TapTest is a Flutter testing framework for **user-facing** widget and integration tests. Tests tap widgets, type into fields, assert labels, and take snapshots.

Because tests go through the UI, they usually survive refactors as long as the interface stays the same.

## Two packages

| Package | Where | Why |
| --- | --- | --- |
| `taptest_runtime` | `dependencies` | Tiny. Gives your app `RuntimeParams` (theme, locale, route). |
| `taptest` | `dev_dependencies` | The test API. Not shipped in release builds. |

## Next

- [Install](./install.md)
- [First test](./first-test.md)
- [Actions](./actions/index.md)
