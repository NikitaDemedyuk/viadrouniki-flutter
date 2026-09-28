<!--
Title: <type>(<scope>): <summary> — Conventional Commits, lowercase, imperative, no period, ≤ 72 chars.
Branch prefix → type: feature/ → feat, fix/ → fix, chore/ → chore|refactor|test|build|style, docs/ → docs.
Base branch: develop. Leave out optional sections that don't apply, rather than writing "N/A".
-->

## Summary
<!-- What changed and why, in 1–3 bullets. -->

## Changes
<!-- Grouped bullets. For multi-commit PRs, one entry per commit with its short SHA. -->

## Screenshots
<!-- UI changes only: before/after, or light/dark × ru/be in a table. -->

## Reviewer notes
<!-- Optional: non-obvious decisions, trade-offs, intentional oddities, where to start reading. -->

## Verification
- [ ] `fvm dart format --set-exit-if-changed .`
- [ ] `fvm flutter analyze` (0 issues)
- [ ] `fvm flutter test` (N passed)
- [ ] Ran on iOS Simulator / Android emulator
- [ ] `CLAUDE.md` still matches the code (updated in this PR if not)
<!-- Plus any API assumptions checked with curl against the live API. -->
