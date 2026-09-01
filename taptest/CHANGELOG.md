## 1.0.0

First stable release of TapTest.

* Requires Flutter 3.47. `ThemeMode` and Material widgets come from `package:material_ui`, matching host apps that have migrated off `package:flutter/material.dart`.

* `tapTest` for widget and integration tests
* Snapshot testing across theme modes and locales
* HTTP request mocking for fast, deterministic widget tests
* Companion `taptest_runtime` package for production-safe `RuntimeParams`
