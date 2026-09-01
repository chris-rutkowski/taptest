#!/usr/bin/env bash
# Run example widget tests in the pinned linux/amd64 Flutter image so
# committed goldens match CI. Args are forwarded to flutter test.
#
#   scripts/containerised_test.sh
#   scripts/containerised_test.sh --update-goldens
#   scripts/containerised_test.sh test/widgets/foo_test.dart
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE="${PACKAGE:-example}"
IMAGE="${FLUTTER_IMAGE:-ghcr.io/adrianjagielak/flutter:3.47.0@sha256:19a67f5db67497cc5537060fde9ba0b4506b98e32dcaae0fd8891561ca88b6eb}"

docker run --rm --platform linux/amd64 \
  -v "$ROOT:/app" \
  -v /app/.dart_tool \
  -v /app/build \
  -v "/app/${PACKAGE}/.dart_tool" \
  -v "/app/${PACKAGE}/build" \
  -v /app/taptest/.dart_tool \
  -v /app/taptest/build \
  -v /app/taptest_runtime/.dart_tool \
  -v pubcache:/pub-cache \
  -e PUB_CACHE=/pub-cache \
  -w "/app/${PACKAGE}" \
  "$IMAGE" \
  bash -lc 'flutter pub get && flutter test --reporter=failures-only "$@"' _ "$@"
