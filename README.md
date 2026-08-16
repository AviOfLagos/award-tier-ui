# frontend-design-workflow

**Stops AI from building the same anonymous website every time.** A discovery-to-build workflow that
forces the design, architecture and stack decisions to happen *before* the first line of markup, and
grounds each of them in evidence rather than defaults.

Handed a PRD, a coding agent starts writing components immediately. A thousand design decisions then
get made implicitly — spacing, weight, easing, accent colour, rendering model — each at the moment
of least information. The result is competent and interchangeable: centred hero, three feature
cards, `indigo-500`, a gradient nobody chose. This skill reorders the work so those decisions are
made deliberately, with references, and verified with screenshots at the end.

## What it actually does

| Phase | Output |
|---|---|
| 0 · Frame | `docs/BRIEF.md` — product, audience, task, trust posture, interaction budget |
| 1 · Research | Direct competitors as *constraints*; **adjacent-niche donors** for novelty; references validated 3-of-6 against evidence, not listicles; user reviews mined and converted to recommendations |
| 2 · Direction | `docs/DIRECTION.md` — one proposal, DNA as a ratio, art direction system, tokens, one question |
| 3 · Architecture | `docs/ARCHITECTURE.md` — page inventory and content model **before** the stack, then a ten-signal rendering decision |
| 4 · Design system | Three-layer tokens, theming including forced-colors, type scale, depth |
| 5 · Build | A filled kickoff prompt, plus a tracked backlog for everything descoped |
| 6 · Verify | Screenshot sweep across routes, breakpoints, themes and reduced-motion |

## What makes it different from other design skills

Most UI skills are a style guide: use this spacing scale, these shadows, this type ramp. They
produce a consistent look, which is precisely the problem — everyone using them arrives at the same
place. This one is a **method**, and it differs in five specific ways:

1. **Adjacent-niche research.** Direct competitors are treated as *constraints you must not break*,
   then deliberately set aside, because the design-fixation literature shows near-field examples
   suppress novelty. Ideas come from structurally similar problems in other industries — the
   practice known as design-by-analogy — with an explicit entity-to-entity structural map so you
   borrow mechanism rather than surface.
2. **References must survive an evidence test.** Search results for design inspiration are dominated
   by affiliate content, so a reference earns its place only on 3 of 6 signals: independent
   multi-sighting, a jury award with disclosed criteria, a named practitioner citing it,
   shipped-flow corroboration, surviving a Lighthouse and keyboard pass, and still being live and
   unchanged a year on.
3. **Architecture before stack.** The page inventory comes first, then the question that actually
   decides the framework: *will any URL be read by a machine that doesn't run JavaScript?* Ten
   scored signals; two rule out a client-only SPA. This exists because choosing React-plus-Vite and
   discovering the SEO requirement in week three is the single most expensive avoidable mistake in
   web projects.
4. **Nothing is silently skipped.** Accessibility, SEO, error boundaries, four states, state
   management, types, security, performance and tests either get built or become 34 tracked issues
   with real acceptance criteria. Descoping is a decision the user makes, not an omission they find
   in production.
5. **Verification is looking at pixels.** A passing build proves syntax compiled. The bundled script
   sweeps every route at desktop and mobile, in each theme, checks horizontal overflow, console
   errors and whether `prefers-reduced-motion` is actually honoured — then tells you to read the
   screenshots, because no script can see a layout.

## Install

**Any agent that supports the open Agent Skills format:**

```bash
npx skills add AviOfLagos/frontend-design-workflow
```

**Claude Code** (this repo ships a plugin manifest, so the marketplace command works):

```bash
/plugin marketplace add AviOfLagos/frontend-design-workflow
/plugin install frontend-design-workflow
```

**GitHub CLI:**

```bash
gh skill install AviOfLagos/frontend-design-workflow frontend-design-workflow
```

**Gemini CLI:**

```bash
gemini skills install https://github.com/AviOfLagos/frontend-design-workflow.git --consent
```

**Cursor:** Customize → Rules → Add Rule → Remote Rule (GitHub) → paste the repo URL.

**Manually** — copy `skills/frontend-design-workflow/` into `~/.claude/skills/`, `~/.agents/skills/`,
or whichever skills directory your tool reads.

**Claude apps** — download the `.zip` from the releases page and upload it under
Settings → Capabilities.

**No skill support in your tool?** [`FRONTEND-DESIGN-WORKFLOW.md`](./FRONTEND-DESIGN-WORKFLOW.md) is the whole thing as one
file. Paste it alongside your PRD.

## When it triggers

"build me a site for X" · "make this look better" · "this looks generic / AI-generated" · "what
stack should I use" · "plan the pages" · "add some animation" · "here's the PRD, build the frontend"
· naming a site as the feel they want.

It deliberately does **not** trigger for isolated component tweaks inside a mature design system,
backend-only work, or chart styling where a data-visualisation skill fits better.

## What's in the box

```
skills/frontend-design-workflow/
├── SKILL.md                      the workflow — 7 phases with exit conditions
├── references/
│   ├── discovery.md              competitors, adjacent niches, reference validation, review mining
│   ├── direction.md              attractor states to avoid, art direction, interaction budget by product type
│   ├── architecture.md           page inventory, content model, ten-signal stack decision
│   ├── seo.md                    metadata, OG images, sitemap, JSON-LD, Core Web Vitals
│   ├── design-system.md          three-layer tokens, theming, FOUC, type, depth
│   ├── motion.md                 primitives with code, timing values, the bugs that cost hours
│   ├── quality-gates.md          WCAG 2.2, four states, state management, types, security, testing
│   └── verification.md           defects in frequency order, pre-ship checklist
├── assets/
│   ├── BRIEF.md  DIRECTION.md  ARCHITECTURE.md      templates → your repo's docs/
│   ├── BUILD-KICKOFF.md          the prompt that starts the building session
│   └── backlog.md                34 issues with acceptance criteria
└── scripts/
    ├── verify.mjs                Playwright sweep: routes × breakpoints × themes
    └── create-issues.sh          backlog → GitHub issues, idempotent, --dry-run
```

## Requirements

The workflow needs nothing — every phase can be run by hand. The two scripts are optional:
`verify.mjs` needs Node and Playwright, `create-issues.sh` needs the GitHub CLI. Neither script
phones anywhere; both are short enough to read before running.

## Provenance

Built from three things: a real project where this sequence produced a site the client approved
without a single direction change; a survey of what the highest-installed published skills do
structurally; and the research literature on design fixation, design-by-analogy, app-review mining,
animation duration and Core Web Vitals. Where a claim comes from research it says so; where it comes
from experience it says that too.

## Licence

MIT. Built by [David Olatunji](https://avi.nexprove.com).

---

## Repo metadata (for maintainers)

GitHub search indexes the **repo name, About description and topics** — not the README. So those
three fields are the entire default search surface.

**About:** Frontend/web design skill for AI coding agents — stops AI-generated sites from looking
generic. Research → art direction → architecture → design tokens → verified build.

**Topics:** `agent-skills` `claude-skill` `claude-code` `cursor` `codex` `skills` `web-design`
`frontend` `ui-design` `design-system` `ux` `seo` `ai-agents`

`agent-skills` is the canonical one — `gh skill publish` adds it automatically.
