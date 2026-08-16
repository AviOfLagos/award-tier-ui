#!/usr/bin/env bash
# Create the quality backlog as GitHub issues.
# Idempotent: skips any issue whose exact title already exists (open or closed).
#
#   ./create-issues.sh --dry-run                 # show what would be created
#   ./create-issues.sh                           # create them
#   ./create-issues.sh --file custom-backlog.md  # use a different backlog
#   ./create-issues.sh --filter seo              # only issues whose title starts with a prefix
#   ./create-issues.sh --repo owner/name         # target an explicit repository
set -euo pipefail

BACKLOG="$(cd "$(dirname "${BASH_SOURCE[0]}")/../assets" && pwd)/backlog.md"
DRY_RUN=0
FILTER=""
REPO=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --file)    BACKLOG="$2"; shift 2 ;;
    --filter)  FILTER="$2"; shift 2 ;;
    --repo)    REPO="$2"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

command -v gh >/dev/null 2>&1 || { echo "gh CLI not found. Install it and run 'gh auth login'." >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh is not authenticated. Run 'gh auth login'." >&2; exit 1; }

# Filing 30+ issues into the wrong repository is the expensive mistake here, so resolve the
# target explicitly and show it before doing anything.
GH_ARGS=()
if [[ -n "$REPO" ]]; then
  GH_ARGS=(--repo "$REPO"); TARGET="$REPO"
else
  TARGET="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)"
  [[ -n "$TARGET" ]] || { echo "Not inside a GitHub repo and --repo not given." >&2; exit 1; }
fi
echo "Target repository: $TARGET"
if [[ $DRY_RUN -eq 0 ]]; then
  read -r -p "Create issues in $TARGET? [y/N] " ok
  [[ "$ok" == "y" || "$ok" == "Y" ]] || { echo "aborted"; exit 0; }
fi
[[ -f "$BACKLOG" ]] || { echo "backlog not found: $BACKLOG" >&2; exit 1; }

# Existing titles, so re-running is safe.
existing="$(gh issue list "${GH_ARGS[@]}" --state all --limit 500 --json title --jq '.[].title' 2>/dev/null || true)"

created=0; skipped=0
while IFS= read -r line; do
  [[ "$line" == *"::"* ]] || continue

  title="${line%%::*}"
  rest="${line#*::}"
  labels="${rest%%::*}"; rest="${rest#*::}"
  milestone="${rest%%::*}"
  acceptance="${rest#*::}"

  # trim
  title="$(echo "$title" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  labels="$(echo "$labels" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  milestone="$(echo "$milestone" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  acceptance="$(echo "$acceptance" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  [[ -n "$FILTER" && "$title" != "$FILTER"* ]] && continue

  if grep -Fxq "$title" <<<"$existing"; then
    echo "skip (exists): $title"; skipped=$((skipped+1)); continue
  fi

  body=$(cat <<EOF
## Why
Part of the launch quality baseline. Skipping this is a decision to make deliberately, not an
omission to discover in production.

## Acceptance criteria
- [ ] ${acceptance}

## Out of scope
Anything not named above. Open a separate issue.

---
Generated from \`assets/backlog.md\` by the frontend-design-workflow skill.
EOF
)

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "would create: $title  [$labels]  ($milestone)"
  else
    # Labels and milestones may not exist yet; retry without them rather than failing the run.
    if ! gh issue create "${GH_ARGS[@]}" --title "$title" --body "$body" \
          --label "$labels" --milestone "$milestone" >/dev/null 2>&1; then
      gh issue create "${GH_ARGS[@]}" --title "$title" --body "$body" >/dev/null
      echo "created (no label/milestone): $title"
    else
      echo "created: $title"
    fi
    created=$((created+1))
  fi
done < <(sed -n '/^```$/,/^```$/p' "$BACKLOG" | grep '::')

echo
echo "created: $created   skipped: $skipped"
[[ $DRY_RUN -eq 1 ]] && echo "(dry run — nothing was created)"
echo "Triage these within a day: close what does not apply to this project."
