# GrowRig catalog — release helper.
#
# The catalog is pure content; validation runs in CI (.github/workflows) and,
# locally, via the platform repo's `make test` with this repo checked out at
# catalog/. This Makefile only wraps the release flow.
#
#   make release VERSION=0.2.0   promote CHANGELOG, tag vX.Y.Z, and push (CI cuts the Release)

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^#   make' Makefile | sed 's/^#   /  /'

.PHONY: release
release:
	@VERSION=$(VERSION) scripts/release.sh
