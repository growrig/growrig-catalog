# Changelog

Versioned snapshots of the GrowRig official catalog. This file follows
[Keep a Changelog](https://keepachangelog.com/); the version is the git tag
(`vX.Y.Z`). The platform embeds this repo as the `catalog/` submodule and only
releases against the latest catalog tag, so cutting a release here is what lets
new content ship in a platform release.

Add entries under `## Unreleased` as you change content. `make release
VERSION=X.Y.Z` moves them into a dated section, tags, and pushes.

## Unreleased

## 0.1.0 — 2026-07-14

- Initial catalog: devices, integrations, species, inventory categories and
  vendors shipped with GrowRig.
