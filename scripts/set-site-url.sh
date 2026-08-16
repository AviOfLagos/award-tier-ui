#!/usr/bin/env bash
# Set the project's public website URL in one place and propagate it.
#
#   scripts/set-site-url.sh https://notgeneric.dev
#   scripts/set-site-url.sh --dry-run https://notgeneric.dev
#   scripts/set-site-url.sh --check
#
# Why this exists
#   SKILL.md, marketplace.json and the docs are consumed as static files by third parties
#   (skills.sh, Claude Code, directory scrapers). There is no build step that could template a
#   variable in, so the URL has to be physically written into each file. This script is the only
#   thing that writes it; site.config.json is the only thing that records it.
#
# Why it is pattern-anchored rather than a string replace
#   siteUrl and repoUrl are currently the same string. A blind find-and-replace would rewrite
#   `git clone <repoUrl>.git` and `gemini skills install <repoUrl>.git` into the website URL and
#   silently break every install instruction. Each edit below is therefore anchored to the exact
#   field that means "the project's website" and nothing else.
#
# Safe to re-run. Idempotent. Never touches .git/.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CONFIG="site.config.json"
DRY_RUN=0
CHECK_ONLY=0
NEW_URL=""

usage() {
  cat <<'USAGE'
Usage:
  scripts/set-site-url.sh <new-url>             Set the website URL and propagate it
  scripts/set-site-url.sh --dry-run <new-url>   Show what would change, write nothing
  scripts/set-site-url.sh --check               Verify every site-URL slot matches the config

URL must include https:// and must not end in a slash.
Repo/clone URLs are deliberately left alone; change repoUrl in site.config.json by hand if the
repository itself ever moves.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --check)   CHECK_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*)        echo "Unknown flag: $1" >&2; usage; exit 2 ;;
    *)         NEW_URL="$1"; shift ;;
  esac
done

[ -f "$CONFIG" ] || { echo "error: $CONFIG not found" >&2; exit 1; }

CURRENT_URL="$(sed -n 's/.*"siteUrl"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG" | head -1)"
[ -n "$CURRENT_URL" ] || { echo "error: could not read siteUrl from $CONFIG" >&2; exit 1; }

# Each slot is: file :: python regex :: replacement using \1 and {URL}
# The regex must capture everything up to the URL so the field itself is what gets rewritten.
SLOTS=(
  "skills/frontend-design-workflow/SKILL.md::^(\s*homepage:\s*)\S+$::{URL}"
  ".claude-plugin/marketplace.json::(\"homepage\"\s*:\s*\")[^\"]*(\")::{URL}"
  "FRONTEND-DESIGN-WORKFLOW.md::^(> )https?://\S+$::{URL}"
)

run_slots() {
  local mode="$1" target_url="$2"
  python3 - "$mode" "$target_url" "${SLOTS[@]}" <<'PY'
import re, sys
mode, target = sys.argv[1], sys.argv[2]
total = 0
for spec in sys.argv[3:]:
    path, pattern, _tmpl = spec.split('::')
    try:
        src = open(path, encoding='utf-8').read()
    except FileNotFoundError:
        print('  %-52s skipped (not found)' % path); continue
    rx = re.compile(pattern, re.M)
    hits = rx.findall(src)
    n = len(hits)
    if n == 0:
        print('  %-52s NO MATCH  <-- check this slot' % path)
        continue
    total += n
    print('  %-52s %d slot(s)' % (path, n))
    if mode == 'write':
        def sub(m):
            groups = m.groups()
            head = groups[0] if groups else ''
            tail = groups[1] if len(groups) > 1 else ''
            return head + target + tail
        open(path, 'w', encoding='utf-8').write(rx.sub(sub, src))
print('TOTAL=%d' % total)
PY
}

if [ "$CHECK_ONLY" -eq 1 ]; then
  echo "Canonical siteUrl: $CURRENT_URL"
  echo
  echo "Site-URL slots:"
  run_slots report "$CURRENT_URL" | sed '/^TOTAL=/d'
  echo
  status=0
  echo "Slot values now:"
  grep -n "^  homepage:" skills/frontend-design-workflow/SKILL.md || status=1
  grep -n '"homepage"' .claude-plugin/marketplace.json || status=1
  sed -n '8p' FRONTEND-DESIGN-WORKFLOW.md
  echo
  if ! grep -qF "$CURRENT_URL" skills/frontend-design-workflow/SKILL.md; then
    echo "MISMATCH: SKILL.md homepage does not equal siteUrl"; status=1
  fi
  if ! grep -qF "$CURRENT_URL" .claude-plugin/marketplace.json; then
    echo "MISMATCH: marketplace.json homepage does not equal siteUrl"; status=1
  fi
  if stale=$(grep -rn "avi\.nexprove\.com" --include='*.md' --include='*.json' \
       --exclude-dir=.git --exclude-dir=growth . || true); [ -n "$stale" ]; then
    echo "Personal-site references still present (fine in an author byline, not as the project URL):"
    echo "$stale"
  fi
  [ $status -eq 0 ] && echo "OK — all site-URL slots agree with $CONFIG."
  exit $status
fi

[ -n "$NEW_URL" ] || { usage; exit 2; }
case "$NEW_URL" in
  https://*|http://*) ;;
  *) echo "error: URL must start with https:// or http://" >&2; exit 2 ;;
esac
case "$NEW_URL" in
  */) echo "error: drop the trailing slash" >&2; exit 2 ;;
esac

if [ "$NEW_URL" = "$CURRENT_URL" ]; then
  echo "siteUrl is already $NEW_URL — nothing to do."; exit 0
fi

echo "Website URL"
echo "  from: $CURRENT_URL"
echo "    to: $NEW_URL"
echo
if [ "$DRY_RUN" -eq 1 ]; then
  run_slots report "$NEW_URL" | sed '/^TOTAL=/d'
  echo
  echo "Dry run — nothing written."
  exit 0
fi

run_slots write "$NEW_URL" | sed '/^TOTAL=/d'

python3 - "$CONFIG" "$CURRENT_URL" "$NEW_URL" <<'PY'
import sys
path, old, new = sys.argv[1:4]
s = open(path, encoding='utf-8').read()
s = s.replace('"siteUrl": "%s"' % old, '"siteUrl": "%s"' % new)
open(path, 'w', encoding='utf-8').write(s)
PY

echo
echo "Done. Verify with: scripts/set-site-url.sh --check"
echo
echo "Still manual (the script cannot reach these):"
echo "  1. Repo Website field:  gh repo edit AviOfLagos/frontend-design-workflow --homepage $NEW_URL"
echo "  2. Rebuild + re-upload the release archives:"
echo "       (cd skills && zip -qr ../frontend-design-workflow.zip frontend-design-workflow) && \\"
echo "       cp frontend-design-workflow.zip frontend-design-workflow.skill"
