---
name: frontend-design-workflow
description: >-
  Stops AI-generated websites from looking generic. Runs the frontend design and web design workflow
  before any markup exists: competitor and adjacent-niche research, a validated reference pool, user
  review mining, art direction, information architecture, the SSR/SSG/SPA rendering and stack
  decision, design system tokens with theming, accessibility, SEO and metadata, then a build-kickoff
  prompt and a tracked quality backlog. Use it whenever someone is starting, redesigning, restyling
  or planning a web product, site, landing page, dashboard or app UI, and especially when a PRD or
  feature list arrives with no design direction. Trigger on casual phrasings too, such as "build me
  a site for X", "make this look better", "this looks generic or AI-generated", "add some
  animation", "what stack should I use", or when a site is named as the feel they want. Do not use
  it for isolated tweaks inside a mature design system, for backend-only work, or for chart styling
  where a data-visualisation skill fits better.
license: MIT
compatibility: >-
  Tool-agnostic. Every phase can be run by hand. The optional scripts need Node with Playwright
  (verification) and the GitHub CLI (issue creation); skip either without losing the workflow.
metadata:
  author: David Olatunji
  version: 1.0.0
  homepage: https://github.com/AviOfLagos/frontend-design-workflow
---

# Frontend design workflow

An agent handed a PRD starts writing markup, and a thousand design decisions get made implicitly,
each at the moment of least information. The output is competent and anonymous. This skill moves
those decisions in front of the code and grounds them in evidence. The blunt test at every stage:
**could this be any other product's site?** If yes, you defaulted rather than decided —
`references/direction.md` names the specific attractor states to check against.

## Routing

| Situation | Go to |
|---|---|
| New project, or a PRD arrived | Phase 0, run the loop |
| Redesign | Phase 0 with the current site as a competitor; skip Phase 3 if the stack is fixed |
| "What stack should this be?" | `references/architecture.md` → *The rendering question* |
| "Why does my site look generic?" | `references/direction.md` → *The attractor states* |
| Direction agreed, ready to build | Phase 5, then `assets/BUILD-KICKOFF.md` |
| Built, wants it checked | Phase 6, and `scripts/verify.mjs` |

## Precedence

Higher wins: **the user's explicit instruction** → **an existing codebase's conventions** → **this
skill's defaults**. If they want purple and brutalist, build purple and brutalist and spend your
judgement on doing it well. Say once what you'd have chosen and why, then commit.

## Working style

Decide and disclose rather than asking. Gate on the user only for irreversible actions, facts you
cannot obtain, and the single direction question in Phase 2. If the user is absent, make the call,
state it in the deliverable, and continue.

---

## Phase 0 — Frame the brief

**Goal:** one page that every later decision is filtered through. Writing it before looking at any
reference is what prevents design fixation — the documented effect where exposure to examples makes
you unconsciously reproduce them, flaws included.

Read what exists first: PRD, spec, deck, current site, brand assets, connected Drive or Notion docs.
Then fill `assets/BRIEF.md` — product, audience, primary task, trust posture (does this category
convert on excitement or credibility?), interaction budget tier, constraints, what success looks
like, what is out of scope.

**Exit:** `docs/BRIEF.md` written; you can state product, user, task and budget tier without hedging.

## Phase 1 — Research

**Goal:** a validated reference pool and a problem model. Full method in `references/discovery.md`.

Three passes in order:

1. **Direct competitors as constraints.** Name 5–8 and **propose the list back to the user, asking
   whether any major one is missing or should be dropped** — they know their market and it costs
   them ten seconds. Extract the conventions you must not break and the category's visual default.
   Then set the list aside: near-field examples maximise fixation and minimise novelty.
2. **Adjacent-niche donors.** 2–3 domains with an isomorphic user task, ideally higher-stakes,
   older or under more regulatory pressure. Fintech studies aviation and insurance; a marketplace
   studies hotel booking; any conversion flow studies e-commerce checkout. Write the structural map
   explicitly — their entity → ours, their constraint → ours. Anything that doesn't map is surface,
   and copying surface is the fixation failure. This is the uncommon step and the highest-leverage
   one.
3. **Craft references,** validated rather than collected. Search results for design inspiration are
   dominated by affiliate listicles, so `references/discovery.md` gives a 3-of-6 evidence test.
   Apply it before a reference earns a place, and sort survivors into *benchmark* versus *visual
   reference only*.

If the product or its competitors have users, **mine reviews** and carry the result forward:
competitor 2★–3★ reviews are unmet demand in the user's own words. Rank themes by severity ×
frequency, then **convert the top themes into named feature or content recommendations** that land
in `assets/DIRECTION.md` and become routes or sections in Phase 3. Research that stops at findings
was wasted.

**Exit:** 8–12 validated references with signature move / worth stealing / over-engineered here; a
named pole you are rejecting; ranked review themes converted to recommendations.

## Phase 2 — Direction

**Goal:** one proposal the user can accept in thirty seconds. Not five options — they came to you
for judgement.

Fill `assets/DIRECTION.md`: references studied, donors and their structural maps, conventions you
won't break, the pole you're rejecting, the DNA blend as a ratio, the art direction (one signature
move plus the supporting system — light direction, background layers, grain, gradient role, image
treatment rule), the token table, themes shipped, and the interaction budget.

If the user stated a style preference, honour it, and add one paragraph of evidence about what the
category's leaders actually do — so they're choosing to differ rather than not knowing. Detail and
the anti-pattern list: `references/direction.md`.

Close with **one question**, usually mood, because that is the genuinely subjective axis. Colour,
type scale and easing are yours to decide and defend.

Then **critique the proposal before building**: work the brief a second time as if fresh. Landing on
an attractor state means you defaulted.

**Exit:** `docs/DIRECTION.md` written; direction agreed, or stated and proceeding.

## Phase 3 — Architecture, then stack

**Goal:** the page inventory before the framework. Choosing a stack first is how projects discover
in week three that they need server rendering and rebuild. Fill `assets/ARCHITECTURE.md`.

**Page inventory** from competitor research, user goals and the review-derived recommendations:
every route, its job, its primary action, content source, whether it is public, and its indexation
rule. Include the ones that get forgotten and later force rework — legal, analytics and consent,
locale routing, auth and onboarding screens, empty and first-run states.

**Content model** next: the shape of the data behind those routes, in one module, so nobody
hardcodes a string.

**Then the stack.** The deciding question: *will any URL be read by a machine that does not run
JavaScript?* Social unfurlers and AI crawlers read raw HTML only. If yes for even one URL, the
initial HTML must contain the content — a rendering decision that is free on day 0 and expensive on
day 200. `references/architecture.md` has the ten-signal score and the framework table; two signals
rule out a client-only SPA. Record the decision and its signals in the README.

Also settle here, because all three are architecture rather than polish: **metadata and keyword
plan per route** (`references/seo.md`), **which quality gates are in scope for v1**
(`references/quality-gates.md`), and **responsive strategy** — how the signature move degrades on
small screens.

**Exit:** `docs/ARCHITECTURE.md` written with page inventory, content model, stack decision record,
metadata plan and scoped quality gates.

## Phase 4 — Design system

**Goal:** tokens locked before the first component, in three layers — primitive → semantic →
component — where components reference semantic tokens only. Read `references/design-system.md`.

Cover colour (one accent), type (two families, fluid sizing, negative tracking on display sizes),
spacing, and **theming from the start**: light, dark and system are baseline expectation, and
retrofitting means touching every component. Include the forced-colors and high-contrast cases.

Consistency is what reads as designed, and it is not uniformity. Contrasting shape decisions are
fine — a pill CTA beside hard-cornered cards reads as deliberate — provided the system underneath
holds: one stroke weight, one shadow light source, one surface ramp, one rule for the accent.

**Exit:** changing the accent and the two ground colours reskins the site with no other edit; every
theme passes contrast.

## Phase 5 — Build

Fill `assets/BUILD-KICKOFF.md` with the decisions from Phases 0–4 and hand off. If the environment
has specialist build skills available — a frontend or design-system skill, a UI/UX or accessibility
skill — invoke them now with the kickoff content as their brief, rather than restating the work
here. This skill's job ends where their expertise begins.

Build order: tokens → layout shell → content model → routes → components → motion → metadata.
Finish one route completely before starting the next; a half-built system repeated eight times is
harder to fix than one route done properly and copied.

Motion vocabulary, timings and failure modes: `references/motion.md`. Accessibility, error and empty
states, state management, types, security, performance and testing: `references/quality-gates.md`.
Both are load-bearing during this phase, not optional reading.

**Everything not scoped for v1 becomes tracked work rather than silent omission** — accessibility,
SEO, security, error boundaries, four states, state management, types, performance budgets, tests.
Run `scripts/create-issues.sh` against `assets/backlog.md`, or, where no issue tracker exists, split
the backlog by area and brief one subagent per area with the relevant reference file plus the
acceptance criteria. Skipping is a decision the user makes; unmentioned is not.

**Exit:** the scoped routes build and render; the deferred backlog exists as issues or briefed work.

## Phase 6 — Verify

**Screenshot it and read the images.** A passing build proves syntax compiled, not that a fixed
element landed on screen or that a reveal ever fired.

Run `scripts/verify.mjs`, then the checklist in `references/verification.md`, which orders defects by
how often they actually occur. Two things govern this loop: you are the worst reviewer of your own
output, so look cold or hand the images to a subagent; and it terminates — fix the real defects,
re-check what you changed, and stop.

**Do not ship while** any of these holds: a console page error, unreadable text at any breakpoint,
a route that 404s, keyboard focus that disappears, contrast below threshold in any theme, or motion
that ignores `prefers-reduced-motion`.

**Exit:** the stop-ship list is clear and the pre-ship checklist passes.

---

## Reference files

Mutually exclusive by phase — read the one you need.

| File | Phase |
|---|---|
| `references/discovery.md` | 1 — competitors, adjacent niches, reference validation, review mining |
| `references/direction.md` | 2 — attractor states, art direction, imagery, interaction budget |
| `references/architecture.md` | 3 — page inventory, content model, rendering and stack decision |
| `references/seo.md` | 3 and 5 — metadata, OG images, sitemap, JSON-LD, Core Web Vitals |
| `references/design-system.md` | 4 — tokens, theming, type, depth |
| `references/motion.md` | 5 — primitives, timings, failure modes |
| `references/quality-gates.md` | 5 — accessibility, four states, state, types, security, testing |
| `references/verification.md` | 6 — screenshot loop and pre-ship checklist |

## Assets and scripts

| Path | Purpose |
|---|---|
| `assets/BRIEF.md` | Phase 0 → `docs/BRIEF.md` |
| `assets/DIRECTION.md` | Phase 2 → `docs/DIRECTION.md` |
| `assets/ARCHITECTURE.md` | Phase 3 → `docs/ARCHITECTURE.md` |
| `assets/BUILD-KICKOFF.md` | Phase 5 — the prompt that starts the building session |
| `assets/backlog.md` | The quality backlog with acceptance criteria |
| `scripts/create-issues.sh` | Creates the backlog via `gh`; idempotent, `--dry-run` supported |
| `scripts/verify.mjs` | Playwright sweep: routes × breakpoints × themes, reduced-motion, overflow, console errors |

The three `docs/` files are the deliverable a user can start from, and they are what a building
session in another tool needs in order to produce the same result.

## Framework note

Phase 3 can legitimately choose Astro, SvelteKit, Nuxt, Remix or a plain SPA. Code examples in
`seo.md`, `quality-gates.md`, `design-system.md` and several backlog items use Next.js App Router
conventions because it is the most common choice. The **principles** port; the file names do not.
When another framework is chosen, translate the mechanism and keep the requirement.
