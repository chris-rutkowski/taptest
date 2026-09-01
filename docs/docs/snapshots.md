# Snapshots

`tt.snapshot(name)` captures the app (or a keyed widget) and compares it to goldens.

By default it cycles **every** `config.themeModes` × `config.locales` combination.

```dart
await tt.snapshot('home');
await tt.snapshot('tile', key: AppKeys.productTile);
await tt.snapshot('current_only', variations: false);
```

## Parameters

| Parameter | Default | Notes |
| --- | --- | --- |
| `name` | required | File name fragment |
| `variations` | `true` | If `false`, uses the current theme and locale only |
| `key` | full `AppWrapper` | Snapshot a subtree |
| `themeModes` / `locales` | from `Config` | Must be subsets of config |
| `acceptableDifference` | from `SnapshotConfig` (default `0`) | Exact match at `0` (Flutter's stock comparator). Slack + skip rewrite when `> 0` |
| `prePumpAndSettle` | `true` | Settle before the first frame |

## Path template

Default:

```
goldens/[suite]/[test]/[name]-[theme]-[locale]-[platform].png
```

Placeholders: `[suite]`, `[test]`, `[name]`, `[theme]`, `[locale]`, `[device]`, `[platform]`.

Widget tests use platform/device `headless`. Integration tests use the OS and device model.

## Updating goldens

Committed `test/` goldens must rasterize on the same **linux/amd64** Flutter image as CI. Never use host `flutter test --update-goldens` for those PNGs — macOS / non-container Skia will fail CI.

Pinned image (digest, not a floating tag), same one CI uses:

```
ghcr.io/adrianjagielak/flutter:3.47.0@sha256:19a67f5db67497cc5537060fde9ba0b4506b98e32dcaae0fd8891561ca88b6eb
```

### Local wrapper

`scripts/containerised_test.sh` forwards args to `flutter test`:

```bash
scripts/containerised_test.sh                                    # verify
scripts/containerised_test.sh --update-goldens                   # regenerate in place
scripts/containerised_test.sh test/widgets/foo_test.dart
scripts/containerised_test.sh --update-goldens test/widgets/foo_test.dart
```

What the script does:

```bash
docker run --rm --platform linux/amd64 \
  -v "$REPO:/app" \                 # bind-mount so written goldens land on the host
  -v /app/.dart_tool \              # anonymous volume: hide host .dart_tool
  -v /app/build \                   # same for host build/ (macOS kernel dills
                                    # crash linux/amd64 frontend_server)
  -v pubcache:/pub-cache \          # persist pub deps across runs
  -w /app \
  "$IMAGE" \
  bash -lc 'flutter pub get && flutter test --reporter=failures-only "$@"' _ "$@"
```

Rules:

- Run tests first; only `--update-goldens` on suites that fail.
- Do not bulk-regenerate matching snapshots.

### No local Docker

Dispatch the **Goldens** GitHub Action (`goldens.yml`) on the PR branch. It runs the same image. The job never commits. On failure, download the `updated-goldens` artifact, copy the PNGs in, review, and commit.

## Deferred widgets

`SnapshotConfig.deferredKeys` must be absent (e.g. image placeholders) before a snapshot is taken.
