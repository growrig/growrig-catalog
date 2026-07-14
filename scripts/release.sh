#!/usr/bin/env bash
# Cut a GrowRig catalog release. The catalog is pure content, so a release is a
# validated, tagged snapshot — there is no build. The git tag vX.Y.Z is the
# version.
#
#   make release VERSION=0.2.0        (or: scripts/release.sh 0.2.0)
#
# The platform embeds this repo as the catalog/ submodule and its release
# workflow refuses to ship against anything but the latest catalog tag, so a
# release here is what unblocks a platform release that includes new content.
#
# What it does:
#   1. validates VERSION (X.Y.Z) and that the tag does not already exist
#   2. requires a clean tree on the default branch, up to date with origin
#   3. moves "## Unreleased" CHANGELOG entries into "## X.Y.Z — <today>"
#   4. commits "release: vX.Y.Z", creates annotated tag vX.Y.Z, pushes both
set -euo pipefail

VERSION="${VERSION:-${1:-}}"
CHANGELOG="CHANGELOG.md"
DEFAULT_BRANCH="main"

die() { echo "release: $*" >&2; exit 1; }

[ -n "$VERSION" ] || die "set VERSION, e.g. make release VERSION=0.2.0"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "VERSION must be X.Y.Z (got '$VERSION')"

TAG="v$VERSION"
cd "$(git rev-parse --show-toplevel)"

[ -f catalog.yaml ] || die "missing catalog.yaml — run from the growrig-catalog repo"
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && die "tag $TAG already exists"

branch="$(git rev-parse --abbrev-ref HEAD)"
[ "$branch" = "$DEFAULT_BRANCH" ] || die "on '$branch'; release from '$DEFAULT_BRANCH'"
[ -z "$(git status --porcelain)" ] || die "working tree is dirty; commit or stash first"

git fetch --quiet origin "$DEFAULT_BRANCH"
[ "$(git rev-parse HEAD)" = "$(git rev-parse "origin/$DEFAULT_BRANCH")" ] \
  || die "local $DEFAULT_BRANCH is not in sync with origin/$DEFAULT_BRANCH"

grep -q '^## Unreleased' "$CHANGELOG" || die "no '## Unreleased' section in $CHANGELOG"

echo "release: preparing $TAG"

# Promote Unreleased -> dated version section, leaving Unreleased empty.
today="$(date +%Y-%m-%d)"
awk -v ver="$VERSION" -v date="$today" '
  /^## Unreleased/ && !done {
    print
    print ""
    print "## " ver " — " date
    done = 1
    next
  }
  { print }
' "$CHANGELOG" > "$CHANGELOG.tmp" && mv "$CHANGELOG.tmp" "$CHANGELOG"

git add "$CHANGELOG"
git commit -m "release: $TAG"
git tag -a "$TAG" -m "GrowRig catalog $TAG"
git push origin "HEAD:$DEFAULT_BRANCH" --follow-tags

echo "release: pushed $TAG — CI will validate and cut the GitHub Release."
echo "release: to ship this content in the platform, update its catalog/ submodule to $TAG and release the platform."
