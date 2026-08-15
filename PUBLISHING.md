# Publishing checklist

Everything here is a one-time setup. Steps 1–2 are required; the rest are distribution.

## 1. Create the GitHub repo

```bash
gh repo create AviOfLagos/award-tier-ui --public \
  --description "Discovery-to-build workflow that stops AI from building the same anonymous website every time." \
  --source . --push
```

If `gh` isn't set up, create `award-tier-ui` on github.com, then:

```bash
git remote add origin https://github.com/AviOfLagos/award-tier-ui.git
git branch -M main && git push -u origin main
```

Then set the repo topics — directories index on these:
`agent-skills`, `claude-skill`, `ai-agents`, `web-design`, `frontend`, `design-system`, `ux`, `seo`

## 2. Publish and release

`gh skill publish` validates against the spec, adds the `agent-skills` topic for you, and cuts the
release in one flow:

```bash
gh skill publish skills/frontend-design-workflow --dry-run
gh skill publish skills/frontend-design-workflow --tag v1.0.0
```

Then attach both archive formats to the release

```bash
gh release create v1.0.0 frontend-design-workflow.skill frontend-design-workflow.zip \
  --title "v1.0.0" \
  --notes "First release. Seven-phase workflow, eight references, four templates, 34-issue quality backlog, verification and issue-creation scripts."
```

The `.skill` file is what Claude apps upload directly.

## 3. Distribution, in order of value

**skills.sh** — the one that matters, because it ranks by install count and agents query it to
*find* skills. Correcting something I said earlier: it does **not** crawl GitHub. A skill enters the
index through anonymous telemetry when someone runs `npx skills add`, and there is no submission
form (`skills.sh/submit` is a 404). Distribution drives listing, not the other way round.

Two consequences. Installs are the only currency, so the promotion steps below are what create the
listing rather than decorating it. And telemetry auto-disables in CI, so automated installs count for
nothing — no seeding.

`skills.sh.json` at the repo root controls how your page groups and renders; it is already there.

**Curated awesome-lists** — the hardest bar and therefore the best signal.
`travisvn/awesome-claude-skills` requires: a clear documented use case, adherence to skill best
practices, a functional tested implementation, **substance beyond a single file**, and **at least 10
GitHub stars**. It auto-rejects anything needing a paid API, anything promotional, and PRs written by
AI — so submit the PR yourself, in your own words. Get the stars first.

**Auto-crawled aggregators** — SkillsMP indexes any public repo containing a `SKILL.md`, so it
requires nothing. claudemarketplaces.com and skillsclaude.org are similar.

**Reviewed directories** — Skills Directory and Agensi take submissions and run automated security
scans before publishing. This skill will clear them: the two scripts make no network calls, read no
credentials, and `create-issues.sh` now prints its target repository and asks before creating
anything.

**Claude Code plugin marketplace** — the repo already works with
`/plugin marketplace add AviOfLagos/award-tier-ui`.

## 4. What to say when you post it

Lead with the problem, not the feature list. The line that lands:

> Every AI-built site looks the same because the agent starts writing markup before anyone decided
> what it should look like. This makes the decisions happen first — competitor and adjacent-niche
> research, a validated reference pool, page architecture before stack choice — and then verifies
> the result by screenshotting every route instead of trusting that the build passed.

Then the one differentiator most people won't have heard framed this way: **direct competitors are
constraints, not inspiration.** Copying your competitors is how you end up looking like them; the
novelty comes from structurally similar problems in other industries.

If you publish install-count or before/after evidence later, that becomes the strongest credibility
signal available — almost nobody does it.

## 5. Keeping it honest

The one claim to re-check periodically is the reference list in `references/direction.md` and
`discovery.md`. The method doesn't age; the specific sites do. Re-run the research sweep once a year
and bump the minor version.
