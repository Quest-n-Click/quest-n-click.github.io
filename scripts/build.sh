#!/usr/bin/env bash
# Builds the organization site into out/:
#   /          the landing page (site/)
#   /play/     the sample game and the Studio demo, built from a signed engine release tag
#   /docs/     the versioned documentation, assembled from the engine's released archives (checked against their
#              sums and attestations by the engine's own `wiki pages`)
# Usage: scripts/build.sh [tag]   (default: the engine's latest release). Needs node 22, git, gh (GH_TOKEN in CI).
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$PWD"
ENGINE_REPO="${ENGINE_REPO:-Quest-n-Click/quest-n-click}"
TAG="${1:-$(gh release view -R "$ENGINE_REPO" --json tagName --jq .tagName)}"
WORK="${WORK:-$ROOT/.cache/engine}"
DOCS_CACHE="${DOCS_CACHE:-$ROOT/.cache/docs-releases}"
OUT="$ROOT/out"

echo "engine $ENGINE_REPO $TAG"
rm -rf "$WORK" "$OUT" && mkdir -p "$WORK" "$OUT"
git -C "$WORK" init -q
git -C "$WORK" fetch -q --depth 1 "https://github.com/$ENGINE_REPO.git" "refs/tags/$TAG:refs/tags/$TAG"
# The trust root is this repository's allowed_signers, never the tag's own copy.
git -C "$WORK" -c gpg.format=ssh -c gpg.ssh.allowedSignersFile="$ROOT/allowed_signers" verify-tag "$TAG"
git -C "$WORK" -c advice.detachedHead=false checkout -q "$TAG"

(cd "$WORK" && npm ci --no-audit --no-fund --loglevel=error)
(cd "$WORK" && BASE_PATH=/play/ STUDIO=1 VITE_STUDIO_DEMO=1 npx vite build --outDir "$OUT/play" --emptyOutDir)
(cd "$WORK" && npm run -s wiki -- pages --repo "$ENGINE_REPO" --cache "$DOCS_CACHE" --out "$OUT/docs")

cp -R "$ROOT/site/." "$OUT/"
docs=$(cd "$OUT/docs" && find . -maxdepth 1 -mindepth 1 -type d | sed 's#./##' | sort -V | paste -sd, -)
printf '{"engine":"%s","engineRepo":"%s","docs":[%s]}\n' "$TAG" "$ENGINE_REPO" \
  "$(echo "$docs" | sed 's/[^,][^,]*/"&"/g')" > "$OUT/site.json"
cat "$OUT/site.json"
