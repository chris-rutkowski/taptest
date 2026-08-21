# TapTest

Flutter testing framework for user-facing widget and integration tests, with snapshot support.

This repository is a monorepo:

| Package | Role | pub.dev |
| --- | --- | --- |
| [`taptest`](taptest/) | Test API (`tapTest`, actions, snapshots, HTTP mocks) | [taptest](https://pub.dev/packages/taptest) |
| [`taptest_runtime`](taptest_runtime/) | Tiny production dependency (`RuntimeParams`) | [taptest_runtime](https://pub.dev/packages/taptest_runtime) |

Documentation: [https://taptest.dev](https://taptest.dev)

Example app: [`example/`](example/)

## Local development

```bash
cd taptest && flutter pub get
cd ../taptest_runtime && flutter pub get
cd ../example && flutter pub get
```

`taptest/pubspec_overrides.yaml` points `taptest_runtime` at the local path so package tests resolve without publishing.

## Publish (1.0.0)

Publish **runtime first**, then taptest:

```bash
cd taptest_runtime && dart pub publish
cd ../taptest && dart pub publish
```
