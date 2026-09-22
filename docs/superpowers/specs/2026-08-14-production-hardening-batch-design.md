# Production Hardening Batch Design

## Goal

Deliver one reversible production-hardening batch that keeps Barii's existing
publication, identity, persistence, reader, WebView, Unicode, accessibility,
and licensing behavior while making book processing responsive, startup
failures recoverable, schema upgrades verifiable, and validation repeatable.

## Constraints

- Reuse the locked Flutter/Dart dependencies and repository patterns.
- Do not change fingerprints, bite IDs, canonical locators, progress, notes,
  highlights, bookmarks, or schema behavior.
- Do not replace the canonical publication model or add native/Rust code.
- Preserve loopback-token and path-traversal protections in original EPUB mode.
- Keep each implementation milestone independently testable and reversible.
- Derive archive limits from the current eager dependency behavior and recorded
  Android performance baseline, with one adjustable policy and explicit tests.

## Book Processing

Introduce a small immutable resource-limit policy used by import, canonical
backfill, and original EPUB opening. EPUB preflight inspects archive metadata
before package parsing and rejects excessive source bytes, entry count,
individual expanded entries, aggregate expanded bytes, and suspicious
compression ratios. Normal repository fixtures must produce the same canonical
publication, sections, bites, assets, fingerprints, and identifiers as before.

Move the existing pure-Dart hashing, EPUB/TXT parsing, canonical projection, and
bite generation work to a worker isolate. The worker returns the existing
parsed/generated value objects; filesystem and Drift writes remain in
`BookImportService` so transaction and cleanup behavior stays local. The worker
has an explicit cancel operation and can be terminated when cooperative
cancellation cannot interrupt a dependency call. Intermediate byte/archive
references are scoped tightly and released before database insertion.

Library import, focused reader loading, and original EPUB opening expose clear
loading states. A failure produces a stable explanation and Retry/Return action
instead of an indefinite spinner or process-closing error. Existing imported
books continue to open from persisted data without reprocessing.

## Startup Recovery

`main()` initializes Flutter and immediately renders a small bootstrap widget.
The widget owns the existing directory, database, preferences, and initial
library validation sequence. Success constructs the existing `BariiApp` with
the same database and storage directory. Failure renders a non-destructive
recovery screen with Retry, Return/Exit where the platform supports it, and
sanitized diagnostic details suitable for copying. Retry closes only resources
created by the failed attempt. It never deletes, recreates, downgrades, restores,
or overwrites the database.

Library and reader `FutureBuilder`/async states distinguish waiting, data, and
error. Recovery actions retry the same operation or safely return to the
library. Diagnostics omit book contents, notes, reading history, and full paths.

## Migration Verification

Use Drift's schema export and verifier support with focused snapshots derived
from repository commits that introduced meaningful schema versions. Prefer
authentic generated snapshots; where an old toolchain cannot regenerate one,
record that limitation rather than silently substituting a hand approximation.

Populate the earliest applicable tables for each tested version, migrate to
v12, and verify books, sections/bites, progress, notes, highlights, vocabulary,
bookmarks, preferences, view modes, canonical publication data, foreign keys,
and reopen behavior. Tests exercise migration behavior as written and do not
modify migrations merely to satisfy fixtures. Do not commit redundant generated
application output.

## Continuous Integration

Add a minimal validation workflow using the repository's locked SDK constraints
and commit-pinned GitHub Actions. Pull-request CI performs enforced lockfile
resolution, format verification, analysis, all tests including migration tests,
an unsigned Android release compilation check, and a Linux release build with
runtime-linkage diagnostics. Production keystores and signing credentials are
not available to this workflow. Failure diagnostics and practical build outputs
are retained as workflow artifacts.

## Testing and Visual Evidence

Follow red-green-refactor for behavior changes. Add fast generated hostile ZIP
fixtures proving bounded rejection without storing large binaries. Add parser
compatibility tests for current normal fixtures, worker/cancellation tests,
bootstrap retry tests, library/reader error-state tests, and historical migration
tests. Run formatting, analysis, unit/widget tests, integration tests when a
device is available, and practical platform build checks.

Capture deterministic screenshots for bootstrap loading, successful startup,
and recoverable startup failure. Prefer a short Android demo only when a usable
device/emulator and capture tooling are available.

## Rollback

Each milestone is isolated: remove the worker/limit wiring to restore the old
processing path; remove bootstrap wiring to restore direct app construction;
remove schema fixtures without affecting the database; remove CI without
affecting runtime. No schema or stored identifier change is part of this batch,
so runtime rollback does not require data conversion.
