# Frontend design workflow — build instructions

> Paste this alongside your PRD in any coding session. It covers *how* to arrive at a design
> direction, an architecture and a stack, and how to verify the result — the part a PRD never
> specifies. Nothing here is project-specific.
>
> Installable skill version, with runnable verification and issue-creation scripts:
> https://github.com/AviOfLagos/award-tier-ui

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


---

# Appendix — the reference material


## Discovery

Contents: [Intake](#intake) · [Competitors](#competitors) · [Adjacent niches](#adjacent-niches) · [Validating a reference](#validating-a-reference) · [Mining user reviews](#mining-user-reviews)

### Intake

Read everything the user has before searching for anything: PRD, spec, pitch deck, existing site,
brand assets, résumé, competitor list. Connected tools (Drive, Notion, GitHub) often hold the real
brief. Ask for what's missing only if the user is present and the gap is load-bearing.

Then write the frame — product, audience, primary task, trust posture, interaction budget tier —
*before* looking at a single reference. Design fixation is well documented: exposure to examples
causes designers to reproduce their features unconsciously, including their flaws. The frame is what
you filter references through, so it has to exist first.

### Competitors

Identify 5–8 direct competitors. Propose the list back to the user and ask whether any major one is
missing or should be dropped — they know their market and it takes them ten seconds.

Extract only two things:

- **Conventions you must not break.** Nav position, primary flow order, form patterns, what the
  pricing page is called. Jakob's Law: users spend most of their time on other sites, so yours
  should work the way those do. Breaking a learned affordance costs comprehension and buys nothing.
- **The category's visual default.** What everyone in this niche looks like. You need it named
  precisely so you can decide, deliberately, how far from it to sit. Going too far off costs
  credibility in conservative categories and wins attention in creative ones.

Label the list **constraints, not inspiration**, cap the time you spend here, and do not return to
it during ideation. Near-field examples maximise fixation and minimise novelty.

### Adjacent niches

The uncommon step, and the one that produces the ideas competitors don't have. It's an established
practice — design-by-analogy, grounded in structure-mapping theory and tested experimentally by Fu,
Chan, Cagan, Kotovsky and Schunn. Their finding, in shape: distant examples raise the novelty of
what you produce but cost you output volume, because the mapping takes work. *Uncommon* examples
raise novelty, volume and breadth together, with no such penalty. Distant-and-uncommon is strongest.
The practical read: **uncommonness is the cheaper lever than distance** — an unusual example from a
moderately adjacent field beats a random pick from a very distant one.

Rank candidate donor domains by:

1. **Isomorphic user task.** Same underlying structure, different industry. Irreversible high-stakes
   commitment: airline booking ↔ fintech transfer ↔ insurance purchase. Comparison across options
   with incomparable attributes: real estate ↔ B2B software ↔ hotel booking. Progressive trust:
   dating ↔ marketplaces ↔ freelancer platforms. Dense-data monitoring: cockpits ↔ trading terminals
   ↔ observability.
2. **Higher stakes than yours.** Failure costs more there, so the patterns are more refined.
3. **Older and more competitive.** E-commerce checkout has twenty years of A/B testing behind it,
   which is why it's the standard donor for any conversion flow.
4. **Regulatory pressure.** Gov, healthcare and banking were forced to solve clarity problems your
   category hasn't.

Then **write the structural map explicitly**:

```
their entity        → our entity
their constraint    → our constraint
their success metric → our success metric
```

Anything that doesn't map is surface. Copying surface is the fixation failure in its purest form.

**The counterweight:** apply analogy to structure, sequencing, tone, information density and
moments of delight. Do not apply it to the location of the nav, the shape of the cart icon or form
conventions. Novelty in the primary affordances is just cost.

### Validating a reference

Search results for "best design inspiration" are dominated by affiliate listicles, and award sites
have their own biases — juries weight visual craft far above usability, and submission is paid,
which selects for agencies with marketing budgets. So a reference earns its place only on evidence.

Require **at least 3 of 6**:

1. Independent sightings across venues that don't share a curator.
2. A jury award with disclosed criteria (Awwwards publishes weights and eliminates outlier scores).
3. A named practitioner citing it. Search `site:news.ycombinator.com "<domain>"` and the same on
   reddit.com. Adversarial venues surface the performance and accessibility problems jury sites miss.
4. Corroboration in a shipped-flow library (Mobbin, Refero, Page Flows) — proof it's a real product,
   not a concept shot.
5. Survives a Lighthouse run and a keyboard-only pass.
6. Still live and structurally unchanged 12+ months on. Anything that lasted is load-bearing.

Sort survivors into two buckets and keep them separate:

- **Benchmark** — borrow structure, flow and interaction.
- **Visual reference only** — borrow art direction; ignore its UX entirely.

Conflating these is how a site ends up beautiful and unusable.

### Mining user reviews

Only when the product or its competitors have users. This is where feature decisions stop being
guesses.

1. **Frame the sample first.** Sources, date window (last two product versions — older reviews
   describe a product that no longer exists), rating strata, target N.
2. **Stratify; never use the default sort.** Platform default is ranked by helpfulness, which is
   popularity. Sample across 1★–5★ and **oversample 2★ and 4★** — they carry the most diagnostic
   detail. 1★ skews to rage and billing; 5★ to content-free praise.
3. **Pull every source, not just app stores.** App Store and Play for product friction; G2,
   Capterra, TrustRadius for B2B buying criteria and switching reasons; Trustpilot for billing,
   support and trust; **Reddit and Discord for the most honest signal**, including what people
   switched *to*; public issue trackers for reproducible bugs.
4. **Open-code first.** Code 100–150 reviews inductively, cluster into themes, freeze the codebook,
   then classify at scale. Track an unclassified residual; above ~10% the codebook is wrong.
5. **Tag four axes:** theme, sentiment, severity (0–4, as frequency × impact × persistence), and
   frequency. Tag lifecycle stage separately — the same complaint means different things during
   evaluation versus cancellation.
6. **Rank by severity × frequency**, then read the verbatims of the top themes. Counts tell you
   where; verbatims tell you why.
7. **Weight competitor 2★–3★ reviews highest.** Unmet demand from people already in-market, in their
   own words. Competitor 5★ reviews give you the table stakes you cannot omit.

Pitfalls worth stating in your writeup: reviews are J-shaped by self-selection, so the mean rating
is not the mean experience; churned users don't review, so the corpus systematically excludes the
people whose problems were fatal; incentivised reviews are common enough that regulators wrote rules
about them (watch for date bursts, single-review accounts, identical phrasing, generic praise naming
no feature); rating is not severity, so code the text rather than the star; and English-only
sampling drops exactly the markets with the worst localisation.

Report frequencies as rates against corpus size, never raw counts, and triangulate any theme against
analytics or a few interviews before it becomes a roadmap item.


## Direction

Contents: [The attractor states](#the-attractor-states) · [Art direction as a system](#art-direction-as-a-system) · [Technique by technique](#technique-by-technique) · [Interaction budget](#interaction-budget) · [The proposal](#the-proposal)

### The attractor states

Name what you are avoiding, precisely. "Be creative" does nothing; knowing the specific gravity well
does. AI-generated interfaces converge on a small set of looks:

- Warm cream ground near `#F4F1EA`, high-contrast serif display, terracotta accent near `#D97757`.
  That last value is Anthropic's own accent — on a user's brief it reads as a tell.
- Tailwind defaults untouched: `indigo-500` primary, default spacing scale, default shadow ramp.
- High-saturation purple-to-blue mesh gradient blobs.
- Corporate Memphis illustration.
- Three feature cards with outline icons, centred hero, dark section, footer.

If your draft matches any of these, you defaulted rather than decided. The test is blunt: **could
this be any other product's site?** If yes, start the direction again.

### Art direction as a system

The diagnostic separating "slapped together" from "alive" is not which effects are used. It is
whether surface treatments come from **one coherent system** or are decorations applied per-section.

Slapped together looks like: default framework spacing, untreated stock photography, one flat colour
behind every section, an accent that appears nowhere in the imagery, shadows with inconsistent light
sources.

Alive looks like: a consistent light direction, a treatment applied to *every* image, background
layers that establish depth, and the accent echoed in the imagery.

So pick **one signature move** and execute it to a high standard — a photography grade, an
illustration system, a single 3D or generative hero, a distinctive type pairing. Then define the
supporting system that everything else obeys: light direction, background layer strategy, global
grain, gradient role, image treatment rule. Restraint plus one exceptional move beats five trends
applied at sixty percent.

**Consistency is not uniformity.** Contrasting shape decisions are good — a pill CTA against
hard-cornered cards reads as deliberate — provided the system underneath holds: one stroke weight,
one shadow light source, one surface ramp, one rule for where the accent lands. What makes a site
feel amateur is a varying *system*, not varying shapes.

### Technique by technique

| Treatment | Works when | Reads cheap when |
|---|---|---|
| Noise / grain | Global layer at 2–6% opacity, unifying gradients and killing banding. Strongest on dark UI | Per-section "texture"; heavy enough to notice; animated (expensive); over body text |
| Mesh gradients | Large, low-contrast, low-saturation, as ambient light behind content. Paired with grain | Saturated purple-blue blobs; gradient text on body copy; anything that fights foreground contrast |
| Neo-brutalism | Deliberate positioning against category norms — dev tools, indie products, agencies | It is now a convention, not a rebellion. Hard shadow + thick black border + chartreuse is as templated as the gradient blob |
| Collage, cutouts, imperfection | The strongest current direction, because it reads as visible human labour | Executed with AI-generated "collage elements", which defeats the entire point |
| 3D / WebGL | The 3D object *is* the product, or one hero moment with a static fallback | Decorative floating shapes; anything pushing LCP past 2.5s. This is usually where the performance budget dies |
| Photography | A system: consistent grade, crop logic, duotone or overlay tied to the palette, consistent grain | Untreated stock; smiling-team-in-loft; visible AI artifacts, which are now an active trust liability |
| Illustration | One system with defined stroke weight, palette subset, perspective, figure style — reused across empty states, onboarding, docs | Mixed sources; generic flat-vector corporate style |
| Generative canvas | It encodes something real — live data, user input, a metaphor for the product's mechanism | Random particles reacting to the cursor. High CPU, zero information |
| Neumorphism | Rarely, and never on interactive controls — it depends on low-contrast soft shadows and fails contrast requirements | Any button. Treat its appearance in trend lists as a red flag |
| Dark mode | Baseline expectation. Offer light, dark and system | Dark as the only option, or a dark theme that is light tokens inverted with unadjusted shadows and imagery |

Two forces define current practice: flight from AI-default aesthetics toward evidence of human
craft, and performance discipline, because visual maximalism collides with Core Web Vitals — a large
share of mobile origins fail at least one of the three, and heavy hero treatments are usually why.

### Interaction budget

Set by product type, not preference. The user's task load is the constraint: the more they are
thinking about their own problem, the less you can spend on motion.

| Product type | Budget | Rules |
|---|---|---|
| Portfolio / agency | Highest — motion *is* the artifact | Experimental navigation and heavy WebGL are defensible here and almost nowhere else. Still ship reduced-motion |
| Marketing / brand | High | Substantial hero moment. Scroll-reveal on secondary graphics only, once, never on headline copy. Above the fold must read with JS disabled |
| E-commerce | Low-medium, asymmetric | Generous on product imagery, zoom, variants. Near-zero in cart and checkout, where every distraction is measurable revenue |
| Onboarding / first run | Medium, time-boxed | The one place teaching justifies motion. Skippable, never repeats |
| SaaS dashboard | Very low | Seen 50× a day, so any animation is a 50× tax. Feedback and state-change only. No scroll-triggered anything |
| Docs / support | Near zero | Users arrive mid-problem. Scroll-reveal actively breaks in-page search and anchor links |
| Fintech / health / gov | Lowest | Motion reads as unserious, and unserious reads as untrustworthy. Trust is the conversion driver |

Exact durations live in `references/motion.md`; the short version is that animations are far more
often too long than too short, and anything the user is waiting on has a hard 500ms ceiling.

Every animation should do one of four jobs — feedback, state-change communication, spatial
navigation metaphor, or signifier enhancement — or be a deliberate, budgeted brand moment. Nothing
in between. Attention-hijacking motion is a dark pattern.

The rule most violated on modern marketing sites: **scroll-reveal on primary text**. Users
experience it as loading delay regardless of the actual cause, and say so unprompted in testing.
Reveal secondary graphics, once, and never re-trigger.

### The proposal

One recommendation, not a menu. Structure:

```
Who I studied        4–6 links, one line each on the signature move
What I'm rejecting   the pole, and why it's wrong for this brief
The DNA blend        ≈50% A's skeleton and motion, ≈30% B's content model, ≈20% C's polish
Art direction        the one signature move + the supporting system
Interaction budget   tier and what it permits
One question         usually mood — dark and cinematic, bright and editorial, brutalist and loud
```

Colour, type scale and easing are yours to decide and defend. If research was done properly you have
a reason for each, and the user never has to think about hex codes.

**Then critique it before building.** Work the brief a second time as if fresh; if you arrive
somewhere similar the direction is sound, and if you land on an attractor state you defaulted.


## Architecture

Contents: [Page inventory](#page-inventory) · [Content model](#content-model) · [The rendering question](#the-rendering-question) · [Stack table](#stack-table) · [Decision record](#decision-record)

Architecture comes before stack. Choosing a framework before knowing the pages is how a project
discovers in week three that it needs server rendering and rebuilds.

### Page inventory

Derive from competitor research plus the user's goals. For every route:

| Route | Job | Primary action | Content source | Public? | Notes |
|---|---|---|---|---|---|
| `/` | ... | ... | static / CMS / DB | yes | |

"Job" is one sentence about what the visitor should be able to do or understand. A route without a
job is a route you should not build.

Typical inventories by product type — treat as a starting checklist, not a template:

- **Portfolio / personal:** home, work index, work detail (templated), about, writing index, writing
  detail, contact. Plus 404, and OG images per route.
- **Marketing / SaaS:** home, product (one per major capability), pricing, comparison / "vs"
  pages, customers or case studies, blog index and detail, docs entry, about, careers, contact,
  legal (terms, privacy), changelog. Comparison and pricing pages carry the highest commercial
  intent, so they must be indexable.
- **Dashboard / app:** marketing shell separate from app shell, auth (sign in, sign up, reset,
  verify), onboarding, the core object list and detail, settings (profile, team, billing,
  integrations), empty and first-run states as first-class screens.

Then decide **indexation policy per route** before creating any of them: which are canonical, which
are `noindex` (utility, filters, drafts, internal search), and how pagination and facets behave.
Retrofitting this after the routes exist means changing URLs, which means redirects forever.

### Content model

One module holds every piece of copy, every record, every stat. Components read from it; nobody
hardcodes a string.

This is not tidiness. It is what makes adding an item update the index, the detail route, the nav,
the search palette and the "next item" link at once, and what lets the user edit their own copy
without touching a component. Sketch the shape now — entity names, fields, which fields are
optional — because it determines the routes and the metadata.

### The rendering question

**Will any URL be read by a machine that does not run JavaScript?**

Those machines are social unfurlers (Slack, Discord, iMessage, LinkedIn, X), `GPTBot`, `ClaudeBot`,
`PerplexityBot`, Bingbot, and every scraper feeding an LLM index. Googlebot does render JS, but on a
deferred second pass. Everything else in the discovery stack reads raw HTML only.

If the answer is yes for even one URL, the initial HTML for that URL must contain the content.

Score these signals — **2 or more rules out a client-only SPA**:

1. Any page is reachable without logging in.
2. Links will be pasted into Slack, X, LinkedIn or iMessage.
3. Content count will grow — blog, docs, changelog, catalogue, case studies.
4. Content comes from a CMS or database rather than being hard-coded.
5. Anyone has said "we'll do SEO later", "content marketing", "programmatic pages", or "we're
   running ads to it".
6. Multi-locale is plausible within 18 months.
7. Pricing or comparison pages are planned.
8. You want the product recommended by an LLM — AI crawlers execute no JavaScript.
9. Marketing and app will share a codebase.
10. Anything depends on link previews rendering correctly.

Migrating later is expensive because routing, data fetching, auth and metadata all move at once, and
because the URLs that accumulated links are the ones you have to preserve.

### Stack table

| Choose | When |
|---|---|
| **Next.js (App Router)** | Marketing and app share a codebase; mixed static and dynamic; you need per-route metadata, OG generation, sitemap and JSON-LD with minimal ceremony. The safe default for most web products |
| **Astro** | More than ~70% of pages are prose or content — docs, blogs, marketing sites. Ships near-zero JS by default; islands for the interactive parts |
| **SvelteKit** | Team already writes Svelte, or bundle size is a first-order constraint |
| **Remix / React Router** | Heavily form- and mutation-driven apps where nested routing and progressive enhancement are the core need |
| **Nuxt** | Team writes Vue |
| **TanStack Start** | Already deep in TanStack Query/Router and want type-safe full-stack continuity |
| **Vite SPA** | Every route is behind authentication and there are zero public URLs. Internal tools, admin panels |

Two rules worth stating plainly. **Match the team's existing language before optimising for
benchmarks** — a framework nobody knows costs more than it saves. And **split marketing from app by
subdomain** rather than forcing one rendering model onto both; static marketing plus an SPA app is
often better than compromising either.

Treat `ssr: false` or a dynamic import with SSR disabled on any indexable content as a defect
rather than a workaround.

### Decision record

Write it into the repo README or `docs/adr/`:

```
Rendering: SSG + selective SSR (Next.js App Router)
Signals: public routes (1), link sharing (2), growing content (3), pricing page (7), LLM
         discoverability (8) — score 5
Rejected: Vite SPA — every signal above fails
Consequence: all indexable content must render server-side; client-only data fetching is
         permitted only inside authenticated routes
```

This is what "we'll add SEO later" gets answered with.


## SEO and metadata

Contents: [Do this at architecture time](#do-this-at-architecture-time) · [Metadata](#metadata) · [OG images](#og-images) · [Sitemap and robots](#sitemap-and-robots) · [Structured data](#structured-data) · [Core Web Vitals](#core-web-vitals) · [Pre-launch](#pre-launch)

Examples are Next.js App Router; the principles port to any framework that can render HTML on the
server.

### Do this at architecture time

Slugs, folder-as-cluster structure, the trailing-slash and www policy, and the indexation rule for
every route type are architecture decisions. Changing them later means changing URLs, and changing
URLs means redirects forever. Settle them in Phase 3.

Keyword work belongs there too, not after launch: for each route, the primary query it should answer
and the one-sentence answer it gives. That determines the `<h1>`, the title and the first paragraph.
Comparison and pricing pages carry the highest commercial intent, so they get the most attention and
must be indexable.

### Metadata

Set on the first commit, in the root layout: `metadataBase`, a `title.template` plus `default`, and
a default `openGraph`/`twitter` block.

```ts
export const metadata: Metadata = {
  metadataBase: new URL('https://example.com'),
  title: { default: 'Name — Role', template: '%s — Name' },
  description: '...',
  openGraph: { type: 'website', siteName: 'Name' },
  twitter: { card: 'summary_large_image' },
}
```

Use the static `metadata` object unless a value depends on route params or a fetch — then
`generateMetadata`. Note that a child's `openGraph` **replaces** the parent's object entirely rather
than merging, which is the usual cause of pages that lose their OG image.

Emit a self-referencing absolute canonical on every indexable page, and `noindex` every utility,
filter, draft and internal-search page.

### OG images

Generate at **1200×630** via a file-based `opengraph-image.tsx`. Constraints that bite: flexbox
layout only (no grid), subset TTF fonts loaded explicitly, keep output under ~500KB, and wrap
generation in try/catch with a static fallback — a throwing OG route means every share of that page
renders blank.

Verify the image resolves at a public absolute URL. Unfurlers do not run JavaScript and do not
follow relative paths.

### Sitemap and robots

Ship `sitemap.ts` and `robots.ts` on day one. Real `lastModified` values, canonical URLs only, split
at 50,000 entries.

### Structured data

Inject JSON-LD from a server component as a single `@graph` with absolute `@id` values, escaping any
`<` in the serialised JSON as `\\u003c`, so a value containing markup cannot break out of the
script tag.

| Page type | Schema |
|---|---|
| Any site | `Organization` (or `Person` for personal sites) + `WebSite` |
| Every page with a path | `BreadcrumbList` |
| Blog post, article | `Article` / `BlogPosting` |
| Product, pricing | `Product` with `Offer` |
| App or tool | `SoftwareApplication` |
| FAQ section | `FAQPage` |
| Portfolio piece, case study | `CreativeWork` |

### Core Web Vitals

Targets at p75 field data: **LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1.** INP measures responsiveness to *every*
interaction, not just the first.

What actually breaks them:

- **LCP** — the hero image not marked priority, or lazy-loaded; render-blocking fonts; a 3D or video
  hero. Mark exactly one above-the-fold image as priority and never lazy-load the LCP element.
- **INP** — long tasks from heavy client components and third-party scripts. Push `'use client'` to
  leaf components; keep layouts and pages on the server where possible.
- **CLS** — images and embeds without dimensions, banners injected above existing content, fonts
  swapping to a different metric. Give every image explicit dimensions or an aspect ratio.

Measure from field data, not only a lab Lighthouse run on your laptop.

### Pre-launch

- No stray `noindex`; no `Disallow: /` left from staging.
- One `<h1>` per page.
- OG images resolve at absolute public URLs; test a real share into Slack.
- Canonicals correct and self-referencing.
- `sitemap.xml` and `robots.txt` reachable and accurate.
- No indexable content rendered client-only — treat that as a defect.


## Design system

Contents: [Three layers](#three-layers) · [Colour](#colour) · [Theming](#theming) · [Type](#type) · [Layout and depth](#layout-and-depth) · [The reskin test](#the-reskin-test)

### Three layers

Tokens go primitive → semantic → component. Components reference **semantic** tokens only, never a
raw value and never a primitive.

```css
:root {
  /* 1. primitive — raw values, named by what they are */
  --lime-400: oklch(0.90 0.20 122);
  --neutral-950: oklch(0.15 0 0);
  --neutral-50: oklch(0.97 0.005 100);

  /* 2. semantic — named by role. this is the only layer components touch */
  --bg: var(--neutral-950);
  --bg-soft: oklch(0.19 0.005 280);
  --ink: var(--neutral-50);
  --muted: oklch(0.65 0.01 280);
  --accent: var(--lime-400);
  --line: oklch(0.97 0.005 100 / 0.10);
}
```

If adding a theme requires editing components, the token layer is wrong. That is the whole test.

**OKLCH is worth using** where support allows. It is perceptually uniform, so a lightness change
looks like the same amount of change across hues — which HSL does not give you, and which is exactly
what you need when deriving hover and muted variants.

The trap is gamut. Maximum sRGB chroma varies sharply by hue and lightness: around 0.11–0.14 for
blues, higher for yellows and greens, and lower at both very dark and very light values. There is no
single safe chroma number. A value outside gamut is silently clamped by the browser, so the colour
you specified is not the colour that renders — and any contrast check you ran against the nominal
value is unreliable. Verify each token in a gamut-aware picker, or wrap wide-gamut values in
`@supports (color: color(display-p3 1 1 1))` with an sRGB fallback. Derive hover and muted states
with relative colour syntax rather than hand-picking new values.

### Colour

**One accent, and mean it.** A single accent used consistently — links, primary CTA, active nav,
the number that matters — reads as a deliberate system. Two accents read as a template with a theme
picker. Per-item colour is different and fine: giving each project card its own hue is *data*,
expressed through a local variable, not a second system colour.

**Never pure black or pure white.** `#000` has no headroom beneath it, so nothing recedes and
shadows have nowhere to go. Large areas of `#fff` cause glare. Shift both a few points inward and
the surface gains depth for free.

**Derive hairlines from the ink colour at low alpha** rather than picking a grey. A derived line
sits correctly on any ground you later swap in; a fixed `#222` does not.

### Theming

Light, dark and system is a baseline expectation, and retrofitting it means touching every
component — so build it in Phase 4, not later.

A theme is one block of semantic overrides:

```css
[data-theme='light'] {
  --bg: var(--neutral-50);
  --ink: var(--neutral-950);
  --muted: oklch(0.50 0.01 280);
  --accent: oklch(0.72 0.16 122);  /* re-tuned per theme, and gamut-checked */
  color-scheme: light;
}
```

Two things people get wrong:

**Accents need re-tuning per theme.** An accent that sings on near-black usually fails contrast on
near-white. Check every semantic pair in every theme — perceptual lightness is not a contrast
guarantee.

**The flash of wrong theme.** A `useEffect` runs after paint, so the user sees the wrong theme first.
Prevent it with a synchronous inline script in `<head>` plus `suppressHydrationWarning` on `<html>`:

```tsx
<script dangerouslySetInnerHTML={{ __html: `
  try {
    var t = localStorage.getItem('theme') ||
      (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    document.documentElement.dataset.theme = t;
  } catch (e) {}
` }} />
```

**Other modes matter too.** Windows High Contrast and similar force their own palette via
`forced-colors: active` — your custom properties are overridden, so anything conveying meaning
purely through background colour disappears. Test it, use `system-color` keywords where you must
intervene, and never remove borders that are carrying meaning. Respect `prefers-contrast: more` by
raising border and text contrast rather than ignoring it. For multi-brand theming, add brand as a
second data attribute on the same semantic layer rather than a parallel token set.

Provide a `@media (prefers-color-scheme: dark)` fallback in CSS as well as the JS toggle, so the
site is still correct before hydration and with JavaScript disabled.

Set `color-scheme` per theme so form controls and scrollbars follow. Store in `localStorage` by
default, which preserves static prerendering; use a cookie only when the server must render the
theme class. And never branch rendered markup on the theme during first render — render both states
and switch with CSS, or you get hydration mismatches.

### Type

Two families: a display face and a mono. The mono is load-bearing — uppercase, tracked out, small,
muted, it says "this is metadata" without a badge or a border.

```css
.hero        { font-size: clamp(2.7rem, 11vw, 10rem);  letter-spacing: -0.045em; line-height: 0.88; }
.page-title  { font-size: clamp(2.6rem, 8vw, 6.5rem);  letter-spacing: -0.04em;  line-height: 0.94; }
.section     { font-size: clamp(2rem, 5vw, 3.6rem);    letter-spacing: -0.03em;  line-height: 1; }
.lede        { font-size: clamp(1.05rem, 1.7vw, 1.3rem); line-height: 1.6; }
.mono        { font-size: 0.72rem; letter-spacing: 0.14em; text-transform: uppercase; }
```

**Negative tracking on display sizes is not optional.** Type is drawn with sidebearings tuned for
body copy; at 160px those gaps become chasms. This single property is the most reliable tell of
considered versus unconsidered typography.

Self-host with a font package rather than a CSS `@import` of a web font — an imported font blocks
render and then reflows the page when it lands. Preload the primary face, `display: swap`, at most
two weights.

### Layout and depth

Two widths cover almost everything: a wide container for layout, a narrow one for prose. Past ~70
characters per line the reader loses the return sweep, which is why the narrow one exists.

```css
.container { width: min(1240px, calc(100% - 3rem)); margin-inline: auto; }
.narrow    { width: min(760px, calc(100% - 3rem)); margin-inline: auto; }
.section   { padding-block: clamp(5rem, 12vh, 9rem); }
```

On dark grounds, layered shadows turn to mud. Get depth from a surface shift (`--bg` → `--bg-soft`
on raised or hovered elements), hairlines at low alpha, and exactly one long shadow reserved for
genuinely floating elements.

### The reskin test

When the tokens are right, changing the accent and the two ground colours reskins the entire site
with no other edit, and adding a theme is one block of overrides. If you find yourself hunting hex
values inside components, the token layer was incomplete — fix it then, not later.


## Motion

Contents: [Values](#values) · [Primitives](#primitives) · [Smooth scroll](#smooth-scroll) · [Failure modes](#failure-modes) · [Reduced motion](#reduced-motion)

Budget comes from `direction.md`. This file is how to execute within it.

### Values

Two classes, with different ceilings. **Response motion** is anything the user is waiting on — they
acted, and the interface has not finished answering. **Ambient motion** is decorative entrance that
does not block reading or interaction. Response motion has a hard ceiling of 500ms because beyond
that users describe it as a drag. Ambient entrance can run longer because nothing is queued behind
it, but it must never delay the reading of content.

```
RESPONSE  (ceiling 500ms — the user is waiting)
  Feedback: toggle, checkbox, button        ~100ms
  Screen change: modal, drawer, panel       200–300ms
  Large cross-screen movement               ≤400ms
  Pointer tracking                          spring, stiffness 320–400, damping 26–30
  Magnetic pull                             spring, stiffness 180, damping 14

AMBIENT  (not blocking — may exceed 500ms)
  Scroll-reveal entrance                    600–850ms  ease [0.22, 1, 0.36, 1]
  Stagger between siblings                  40–70ms
  Page transition curtain                   400–700ms  ease [0.76, 0, 0.24, 1]
```

If an entrance animation is the reason a user cannot yet read the sentence, it is response motion
and the 500ms ceiling applies.

**Springs for anything responding to a pointer** — it reads as an object with mass. **Duration and
curve for anything entering** — an entrance is a transition, not a response, and springs make
entrances wobble.

An ease-out curve starts fast and settles slowly. That asymmetry is why it feels expensive; linear
and ease-in-out both read as mechanical.

**Animate only `transform` and `opacity`.** Non-composited animation is the usual cause of jank, and it is
common — a large fraction of pages animate layout properties somewhere. Anything animating layout properties will drop frames on a
mid-tier phone.

### Primitives

Define these once, use only these. Consistency is most of what reads as designed.

#### Reveal — masked line rise

```tsx
export function Reveal({ children, delay = 0, y = '110%' }) {
  // The observer sits on the MASK, not the inner element. An element translated fully
  // outside an overflow:hidden parent never intersects the viewport, so observing it
  // directly means the animation never fires — the most common silent break in this pattern.
  return (
    <motion.span className="line-mask"          // overflow: hidden; display: block
      initial="hidden" whileInView="visible" viewport={{ once: true, amount: 0.4 }}>
      <motion.span style={{ display: 'block' }}
        variants={{ hidden: { y },
          visible: { y: 0, transition: { duration: 0.8, delay, ease: [0.22, 1, 0.36, 1] } } }}>
        {children}
      </motion.span>
    </motion.span>
  )
}
```

#### FadeUp — the workhorse

```tsx
<motion.div
  initial={{ opacity: 0, y: 32 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true, margin: '-8%' }}
  transition={{ duration: 0.7, delay: i * 0.06, ease: [0.22, 1, 0.36, 1] }} />
```

#### Magnetic — leans toward the cursor

Two or three per site. On everything it becomes noise.

```tsx
const x = useMotionValue(0), y = useMotionValue(0)
const sx = useSpring(x, { stiffness: 180, damping: 14 })
const sy = useSpring(y, { stiffness: 180, damping: 14 })
const onMove = (e) => {
  const r = ref.current.getBoundingClientRect()
  x.set((e.clientX - r.left - r.width / 2) * 0.35)
  y.set((e.clientY - r.top  - r.height / 2) * 0.35)
}
const onLeave = () => { x.set(0); y.set(0) }
```

#### Cursor-following preview

Makes a list of links feel like a designed object.

```tsx
const px = useSpring(x, { stiffness: 160, damping: 20 })   // the lag IS the effect
const py = useSpring(y, { stiffness: 160, damping: 20 })
// container: onMouseMove={(e) => { x.set(e.clientX + 28); y.set(e.clientY - 120) }}
<motion.div className="preview"   /* position: fixed; top: 0; left: 0  — both required */
  style={{ x: px, y: py }}
  initial={{ opacity: 0, scale: 0.75, rotate: -4 }}
  animate={{ opacity: 1, scale: 1, rotate: 0 }}
  exit={{ opacity: 0, scale: 0.75, rotate: 4 }}
  transition={{ type: 'spring', stiffness: 380, damping: 26 }} />
```

#### Marquee — scroll-velocity strip

Drifts continuously, speeds and reverses with scroll. Cheap, and it makes a page feel alive without
an ambient loop competing for attention.

```tsx
const baseX = useMotionValue(0)
const velocity = useSpring(useVelocity(useScroll().scrollY), { damping: 50, stiffness: 320 })
const factor = useTransform(velocity, [-1200, 0, 1200], [-4, 0, 4])
useAnimationFrame((_t, delta) => {
  const v = factor.get()
  if (v !== 0) direction.current = v < 0 ? -1 : 1
  let move = direction.current * -1.6 * (delta / 1000)
  move += move * Math.abs(v)
  baseX.set(baseX.get() + move)
})
// render 3–4 duplicate sets; wrap x with a modulo so the loop is seamless
```

Because it loops forever it must stop under reduced motion — see below.

#### CountUp

```tsx
const inView = useInView(ref, { once: true, margin: '-10%' })
useEffect(() => {
  if (!inView) return
  const c = animate(0, value, { duration: 1.4, ease: [0.22, 1, 0.36, 1],
                                onUpdate: v => setDisplay(Math.round(v)) })
  return () => c.stop()
}, [inView, value])
```

Set `font-variant-numeric: tabular-nums` or the number jitters as digit widths change.

### Smooth scroll

```tsx
if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
const lenis = new Lenis({ lerp: 0.1, smoothWheel: true })
```

`lerp: 0.1` is the ceiling. Heavier smoothing reads as input lag, and to anyone who scrolls fast it
reads as broken.

### Failure modes

**`whileInView` never fires.** The observed element is translated outside an `overflow: hidden`
parent, so it never intersects. Put the observer on the mask.

**Fixed element lands off-screen.** `position: fixed` needs explicit `top: 0; left: 0` when you
position it with motion `x`/`y`. Without them it anchors to its static document position — it
compiles, it renders, it's just a scroll-height away.

**Preloader replays on every navigation.** Guard with `sessionStorage`.

**Hover handlers don't fire under test.** Playwright's `mouse.move` jumps; use `{ steps: 12 }` so
real `mousemove` events are emitted.

**Body scroll leaks behind a modal or preloader.** Set `overflow: hidden` while open and clear it in
the cleanup, not only in the close handler.

**Chart or list re-animates on every filter change.** Animate on mount only; re-animating on data
change destroys comprehension and annoys daily users.

### Reduced motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;   /* or an infinite loop keeps running, 0.01ms at a time */
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

`animation-iteration-count` is the line people omit, and it is the one that matters most: without it
a marquee, spinner or looping background keeps cycling — a vestibular hazard and a CPU burn.

Reduce to opacity fades or nothing — do not merely shorten durations. Skip smooth-scroll
initialisation entirely, since a CSS override cannot stop a JS scroll loop, and hijacked scrolling is
precisely what someone with vestibular sensitivity is asking you not to do. Over half of pages now
implement this; omitting it puts you below median.


## Quality gates

Contents: [Accessibility](#accessibility) · [Four states](#four-states) · [Error boundaries](#error-boundaries) · [State management](#state-management) · [Types](#types) · [Security](#security) · [Performance](#performance) · [Testing](#testing)

These are what gets skipped when building fast. The user may choose to skip them — but that should
be a decision they make, not an omission they discover. Generate the backlog (`assets/backlog.md`)
so each becomes tracked work.

### Accessibility

Build to WCAG 2.2 AA by default; scoping exemptions is not worth the retrofit risk, and in several
jurisdictions commercial sites are now legally required to comply.

- Native HTML before ARIA. A `<div>` with a click handler is a defect, and no ARIA beats bad ARIA.
- Visible `:focus-visible` indicator with `outline-offset`, plus `scroll-margin-top` so sticky
  headers never obscure the focused element.
- Hit areas ≥ 24×24 CSS px, achieved with padding. Every drag interaction needs a click or keyboard
  alternative.
- Skip link, one `<main>`, one `<h1>`, labelled landmarks, programmatic `<label for>` on every input.
- Contrast ≥ 4.5:1 for body text, ≥ 3:1 for large display and UI boundaries — in every theme.
- Honour `prefers-reduced-motion`, and never gate content behind an animation.
- Allow paste and password managers on auth fields.
- **Focus management**, the most common real failure in SPA and App Router stacks: on client-side
  route change, move focus to the new page's heading or a skip target, or the screen-reader user
  stays silently parked in the old page. Trap focus inside modals, restore it to the trigger on
  close, and prefer native `<dialog>` which does both for free.
- **Announce what changes.** A visual four-state pattern is invisible to a screen reader unless the
  region is `aria-live="polite"`. Form errors need programmatic association with their field and an
  announcement; a red border communicates nothing to anyone not looking at it.
- `lang` on `<html>`, correct for the content. Headings in order with none skipped — they are the
  primary navigation mechanism for screen-reader users.
- Alt text policy: describe function, not appearance; decorative images get `alt=""` rather than a
  filename; complex images get a longer description nearby.
- `forced-colors: active` and `prefers-contrast: more` handled — see `references/design-system.md`.

Automated tools catch roughly a third of issues. Run axe in CI across opened modals and form error
states, and still do a keyboard-only pass and a screen-reader pass before release.

### Four states

**Every data surface renders four states: loading, empty, error, populated.** No exceptions. This is
the single most common gap in fast-built apps, and the failure is silent — the user sees a blank
region and nobody is told.

- Skeletons match final layout dimensions, and delay ~200ms to avoid flicker on fast responses.
- Zero-data and zero-results are different copy. "You haven't added anything yet" with a primary CTA
  is not "No results for that filter" with a clear-filters action.
- Every error surface carries a copyable error or correlation ID wired to the error tracker.

### Error boundaries

In the App Router, `error.tsx` catches render errors in its segment and everything nested below —
but **not** its own segment's layout. To catch a layout's failures the boundary must live in the
*parent* segment; root layout errors need `global-error.tsx`, which must render its own `<html>` and
`<body>`.

Ship a designed `not-found.tsx` with the brand shell and at least a few navigation escape hatches.
The framework default is a white page with black text and no way out.

Centralise retry policy. Never auto-retry non-idempotent mutations, and never retry 4xx except 408
and 429. Every optimistic mutation implements cancel → snapshot → apply → rollback on error →
invalidate on settled.

### State management

The mistake almost everyone makes is conflating server cache with client state. Classify first:

| Kind | Home |
|---|---|
| Server data | TanStack Query, or RSC. One cache, one key per resource |
| Shareable UI state — filters, search, sort, pagination, tabs, open panel | URL `searchParams` |
| Local UI state | `useState` |
| Low-frequency global — theme, locale, session identity, flags | Context |
| Frequently-updating global client state | Zustand |
| Fine-grained derived graphs | Jotai |
| Anything else | Needs a written reason |

Record the split as a short decision note in the repo. This is one of the backlog items, because
the failure is invisible until the app is large enough that untangling it is expensive.

Never store server data in a client store. Default to `useState` and escalate only when a second,
non-descendant consumer appears. Keep form state in a form library. Ban mirroring props or query
data into state via `useEffect` — derive during render.

### Types

Enable `strict`, `noUncheckedIndexedAccess` and `exactOptionalPropertyTypes`. Run `tsc --noEmit` as a
required CI job, and make sure `typescript.ignoreBuildErrors` and `eslint.ignoreDuringBuilds` are
absent from the config — they are how type errors reach production.

Validate with a schema at every trust boundary: environment variables, route handlers, server
actions, webhooks, third-party responses, URL params. Treat every server action as a public HTTP
endpoint, because it is one: validate input and re-check authorisation inside it.

Read `process.env` in exactly one typed module that fails fast at boot listing every missing
variable.

### Security

AI-generated code has a well-documented vulnerability rate, and the failures cluster:

- **Authorisation.** Scope every query by owner or tenant *in the query*, never by filtering after
  fetch and never by hiding UI. Route DB access through one data-access layer that verifies session
  and authorisation. Middleware alone is not an authorisation boundary.
- **Secret leakage.** Audit every `NEXT_PUBLIC_` variable; add `import 'server-only'` to modules
  touching secrets; grep the build output for secret patterns in CI; enable push protection.
- **Headers.** HSTS, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`,
  `X-Frame-Options`, COOP. Add CSP in report-only first, then enforce.
- **Injection.** Never interpolate user input into SQL, shell or `dangerouslySetInnerHTML`.
- **SSRF.** Any feature fetching a user-supplied URL needs a host allowlist, private-IP rejection
  after DNS resolution, no redirect following, and a timeout.
- **Sessions.** `httpOnly`, `secure`, `sameSite`, explicit `maxAge`, rotation on privilege change,
  server-side invalidation on logout, rate limits on auth endpoints, and login responses that don't
  distinguish unknown user from wrong password.

### Performance

One priority image above the fold, nothing lazy-loaded there. Fonts via the framework's font module
with `display: swap`, subsetting, preload on the primary face, at most two weights. Explicit
dimensions on every image and embed. Virtualise lists past ~100 rows. Bundle analysis on every
release with a per-route JS budget enforced in CI. Every third-party script needs a named owner, a
measured cost, and a non-blocking loading strategy.

### Testing

Proportionate to what the thing is. A marketing site needs a build check, a Lighthouse budget and a
link check. An app needs more:

- 5–10 critical-path E2E journeys, no more. Signup → first action, login → core CRUD → logout, and a
  tenant-isolation test proving user A cannot see user B's data.
- Role and label-based locators with auto-retrying assertions; no fixed timeouts.
- Unit tests for pure logic that is expensive to get wrong — money, permissions, dates, parsers.
  Don't test the framework.
- Required CI checks: typecheck, lint at zero warnings, tests, build. Lighthouse and a11y budgets set
  at the target rather than the status quo.


## Verification

The step that catches what re-reading your own code cannot. You wrote it, so you already believe it
works.

### Run it

```bash
node scripts/verify.mjs http://localhost:3000 /            /work /about /contact
```

The script screenshots each route at desktop and mobile, exercises hover on the first interactive
row, scrolls with real wheel events, and reports console page errors. Then **read the images**.

### Inspect rather than guess

When something looks wrong, ask the page:

```js
await page.evaluate(() => {
  const el = document.querySelector('.thing')
  if (!el) return 'not in DOM'
  const cs = getComputedStyle(el), r = el.getBoundingClientRect()
  return { position: cs.position, transform: cs.transform, opacity: cs.opacity,
           x: r.x, y: r.y, scrollY: window.scrollY }
})
```

A rect at `y: 2275` when the viewport is 900 tall tells you instantly that a fixed element is
anchored wrong. No amount of re-reading CSS gets there as fast.

### Defects in frequency order

Check these first, because they are what actually goes wrong:

1. **Content stuck off-screen** — a reveal that never fired. Scroll down and confirm.
2. **Text overflow or clipping** at some breakpoint, usually large display type on mobile.
3. **Hover states not responding** — move the mouse in steps, not a single jump.
4. **Contrast failures**, especially the accent on a light theme.
5. **Horizontal scroll on mobile** from a fixed-width child.
6. **Console page errors.**
7. **Routes that 404**, or links pointing at routes that don't exist.
8. **Motion ignoring `prefers-reduced-motion`.**

### Pre-ship

- [ ] Every route renders; hero visible; no blank first screen
- [ ] Reveals fire; nothing stuck translated out of frame
- [ ] Hover and focus states respond
- [ ] Mobile 390×844: nav collapses, type fits, no horizontal scroll
- [ ] Every theme checked, not just the default
- [ ] Zero console page errors
- [ ] Keyboard: tab reaches everything, focus ring visible, no traps
- [ ] `prefers-reduced-motion` honoured
- [ ] Contrast ≥ 4.5:1 body, ≥ 3:1 large, in every theme
- [ ] Fonts self-hosted; no layout shift on load
- [ ] Metadata, OG image and canonical per route; share into Slack to confirm
- [ ] Production build succeeds

### Two things about this loop

**You are the worst reviewer of your own output.** After staring at the generating code you see what
you intended rather than what rendered. Look at the images cold, or hand them to a subagent with the
checklist and no context.

**It terminates.** The first render usually has a few real defects. Fix those, re-check what you
changed, and stop. Perpetual polishing is not verification.

### Sandbox note

If Playwright's browser download is unavailable, point at a preinstalled Chromium:

```js
chromium.launch({ executablePath: process.env.CHROME_PATH, args: ['--no-sandbox'] })
```


## Brief — <project>

> Phase 0. Fill this before looking at a single reference. Keep it in the repo as `docs/BRIEF.md`.

### What this is
One paragraph. What the product does, in the words a user would use.

### Who it's for
Primary audience. Secondary audience if it changes any decision.

### Primary user task
The one thing a visitor must be able to do or understand. If there are three, rank them.

### Trust posture
Does this category convert on **excitement** or on **credibility**? Fintech, health and gov convert
on credibility; consumer, creative tools and agencies convert on excitement. This sets how far from
category convention you can sit.

### Interaction budget tier
One of: portfolio/agency (highest) · marketing (high) · e-commerce (low-medium, asymmetric) ·
onboarding (medium, time-boxed) · dashboard (very low) · docs (near zero) · fintech/health/gov
(lowest). See `references/direction.md`.

### Stated style preference
Anything the user already wants — a colour, a reference site, a mood. Record it verbatim. Phase 2
honours it and adds evidence about what the category's leaders do, so the choice is informed.

### Constraints
Brand assets that already exist, stack requirements, deadlines, team skills, budget, compliance.

### Success looks like
How will we know this worked? A number if there is one.

### Explicitly out of scope
What we are not building. This is as useful as what we are.


## Direction — <project>

> Phase 2. The proposal, and the record of what was decided.

### References studied

| Site | Signature move | Worth stealing | Over-engineered here | Validated by |
|---|---|---|---|---|
| | | | | |

Validation: apply the 3-of-6 evidence test in `references/discovery.md` before a reference earns a
row here.

### Adjacent-niche donors

| Donor domain | Why isomorphic | Structural map | What we take |
|---|---|---|---|
| | their entity → ours; their constraint → ours | | |

### What users actually say

From review mining (`references/discovery.md`). Rank by severity × frequency; report frequency as a
rate against corpus size.

| Theme | Source | Severity 0–4 | Frequency | Verbatim that captures it |
|---|---|---|---|---|
| | competitor 2★ | | | |

**Recommendations that follow.** Each becomes a route, section or feature in `ARCHITECTURE.md`, or
is explicitly declined here with a reason.

| Theme | What we do about it | Where it lands |
|---|---|---|
| | | |

### Conventions we will not break
From direct competitors. Jakob's Law constraints only.

### The pole we are rejecting
Name it and say why.

### DNA blend
≈__% from A (skeleton and motion grammar) · ≈__% from B (content model and legibility) ·
≈__% from C (micro-interaction polish)

### Art direction
- **Signature move:**
- **Light direction:**
- **Background layer strategy:**
- **Grain / texture:**
- **Gradient role:**
- **Image treatment rule** (applied to every asset):

### Tokens

| Role | Value | Notes |
|---|---|---|
| `--bg` | | never pure black/white |
| `--bg-soft` | | raised surfaces |
| `--ink` | | |
| `--muted` | | |
| `--accent` | | exactly one; re-tuned per theme |
| Display face | | |
| Mono face | | |

Themes shipped: light · dark · system · `<any brand or high-contrast variants>`
Also handled: `forced-colors: active` · `prefers-contrast: more`

### Interaction budget
Tier: ______ . What that permits, and what it forbids.

### Open question for the user
Usually mood. One question, not five.


## Architecture — <project>

> Phase 3. Pages first, stack second.

### Page inventory

| Route | Job | Primary action | Content source | Public | Indexation |
|---|---|---|---|---|---|
| `/` | | | | yes | index, canonical self |

Do not forget the routes that later force rework: legal (terms, privacy), 404, analytics and
consent, locale routing, auth and onboarding, and the empty and first-run states of every core
surface.

### Responsive strategy

Breakpoints, and how the signature visual move degrades on small screens rather than being hidden.

### Content model

```ts
// lib/content.ts — one module, every string. Components read; nobody hardcodes.
export type Entity = {
  slug: string
  // ...
}
```

### Rendering decision

**Will any URL be read by a machine that does not run JavaScript?** ______

Signals scored (2+ rules out a client-only SPA):

- [ ] 1. Public routes exist
- [ ] 2. Links pasted into Slack / X / LinkedIn
- [ ] 3. Content count will grow
- [ ] 4. Content from CMS or DB
- [ ] 5. Someone said "SEO later" / "content marketing" / "running ads to it"
- [ ] 6. Multi-locale plausible within 18 months
- [ ] 7. Pricing or comparison pages planned
- [ ] 8. Want LLM discoverability
- [ ] 9. Marketing and app share a codebase
- [ ] 10. Link previews must render

**Score:** __ / 10

### Decision record

```
Rendering:   
Framework:   
Signals:     
Rejected:    
Consequence: 
```

### Metadata plan

| Route | Title | Description | OG image | JSON-LD |
|---|---|---|---|---|

### Quality scope

Which gates are in for v1, and which are deliberately deferred (see `assets/backlog.md`):

- [ ] Accessibility WCAG 2.2 AA
- [ ] SEO / metadata / OG / sitemap / JSON-LD
- [ ] Error boundaries, 404, four states
- [ ] Types strict + boundary validation
- [ ] Security headers, authz, secrets
- [ ] Performance budgets
- [ ] E2E on critical paths


## Build kickoff

> Fill the blanks and paste this into the building session. It carries every decision forward so the
> builder never has to re-derive them — and never has to guess.

---

If a specialist frontend, design-system or accessibility skill is available in this environment,
invoke it with this brief rather than working from general knowledge.

Build `<project>` from the decisions below. They are settled; do not re-litigate them. If something
here is genuinely unworkable, say so and stop rather than silently substituting.

**Brief.** `<paste docs/BRIEF.md, or the four sentences: product, audience, primary task, trust posture>`

**Direction.** `<paste the DNA blend, art direction and signature move from docs/DIRECTION.md>`

**Tokens.** Implement exactly these as CSS custom properties in three layers — primitive, semantic,
component. Components reference semantic tokens only, never raw values.

```
<paste the token table>
```

Themes: `<light / dark / system / …>`. Prevent flash-of-wrong-theme with a synchronous inline script
in `<head>`; a `useEffect` runs too late.

**Stack.** `<framework>`, chosen because `<signals>`. Do not substitute. All indexable content
renders server-side; client-only data fetching is permitted only inside authenticated routes.

**Pages.** Build these routes, in this order:

```
<paste the page inventory>
```

**Content model.** Every string lives in `<lib/content.ts>`. No hardcoded copy in components.

**Motion.** Budget tier: `<tier>`. Define the primitives once and use only those: Reveal, FadeUp,
Magnetic, Marquee, CountUp, and a cursor-following preview if the tier permits it. Scroll entrances
run 600–850ms with ease `[0.22, 1, 0.36, 1]`; anything the user is waiting on has a hard 500ms
ceiling; pointer responses use springs. Animate only `transform` and `opacity`. Reveals fire once
and never re-trigger. Scroll-reveal never touches primary headline copy. Under
`prefers-reduced-motion`, set `animation-iteration-count: 1` too, or looping elements keep running.

**Build order.** Tokens → layout shell → content model → routes → components → motion → metadata.
Get one route completely finished before starting the next; a half-built system repeated eight times
is harder to fix than one route done properly and copied.

**Non-negotiable while building.**

- Every data surface renders four states: loading, empty, error, populated.
- `error.tsx`, `global-error.tsx` and a designed `not-found.tsx` exist before launch.
- Metadata, canonical and OG image per route. `sitemap.ts` and `robots.ts` on day one.
- WCAG 2.2 AA: visible focus, 24px hit areas, one `<h1>` and ordered headings, `lang` set, labelled
  inputs, intentional alt text, `prefers-reduced-motion` honoured.
- Focus moves to the new page on client-side navigation; modals trap focus and restore it on close.
- Loading, empty and error regions are `aria-live="polite"` — a visual state alone is silent.
- `strict` TypeScript; schema validation at every trust boundary.

**When you finish a milestone**, screenshot every route at 1440×900 and 390×844, read the images,
and work the checklist in `references/verification.md`. Do not ship while there is a console page
error, unreadable text at any breakpoint, a 404 route, invisible keyboard focus, or motion that
ignores reduced-motion preference.

**Everything not scoped for v1** — the deferred items in `docs/ARCHITECTURE.md` — goes into the
issue tracker via `scripts/create-issues.sh` rather than being silently dropped.


## Quality backlog

Issues covering what gets skipped. `scripts/create-issues.sh` reads this file and creates
them via `gh`. Edit before running — delete what doesn't apply, adjust milestones.

Format per line: `TITLE :: LABELS :: MILESTONE :: ACCEPTANCE`

```
a11y: add skip link, landmarks and single h1 per page :: area/a11y,priority/P0 :: v0-launch :: Skip link is first focusable element and reveals on focus. Exactly one <main>, one <h1> per route. Landmarks labelled. Verified with axe and a manual tab pass.
a11y: guarantee visible focus states and 24px hit areas :: area/a11y,priority/P0 :: v0-launch :: Every interactive element has a :focus-visible ring with outline-offset. scroll-margin-top prevents sticky-header obscuring. All targets >= 24x24 CSS px via padding. Keyboard-only pass reaches every control.
a11y: verify contrast in every theme :: area/a11y,priority/P0 :: v0-launch :: Body text >= 4.5:1, large display and UI boundaries >= 3:1, checked in light, dark and any custom theme. Accent re-tuned per theme where it fails.
a11y: honour prefers-reduced-motion :: area/a11y,priority/P0 :: v0-launch :: Reduced-motion users get opacity fades or nothing, not merely shortened durations. Smooth-scroll library is not initialised. No content is gated behind an animation.
a11y: manage focus on route change and in modals :: area/a11y,priority/P0 :: v0-launch :: Client-side navigation moves focus to the new page heading or skip target. Modals trap focus, return it to the trigger on close, and close on Escape. Verified with a keyboard-only pass across every route and dialog.
a11y: announce async and error states to assistive tech :: area/a11y,priority/P1 :: v1-hardening :: Loading, empty and error regions are aria-live polite. Form errors are programmatically associated with their fields and announced. Verified with one screen-reader pass.
a11y: set lang, heading order and alt-text policy :: area/a11y,priority/P1 :: v0-launch :: html lang correct. No skipped heading levels on any route. Every image has intentional alt text; decorative images use empty alt. Policy documented for future contributors.
a11y: support forced-colors and prefers-contrast :: area/a11y,priority/P2 :: v1-hardening :: Site remains usable in Windows High Contrast; no meaning is carried by background colour alone; borders that carry meaning survive. prefers-contrast more raises text and border contrast.
state: document and enforce the server-cache versus client-state split :: area/types,priority/P1 :: v1-hardening :: A decision note records the split and chosen libraries. No server-fetched data is held in a client store. Filters, search, sort and pagination live in URL params and survive refresh and back/forward, covered by one E2E test.
ux: define responsive strategy and degrade the signature move :: area/a11y,priority/P1 :: v0-launch :: Breakpoints documented. Display type fits at 320px with no horizontal scroll. The signature visual move has a defined small-screen behaviour rather than being hidden. Verified by screenshots at 390x844 and 320px.
arch: add consent, analytics and locale decisions to the page inventory :: area/seo,priority/P2 :: v1-hardening :: Consent banner reserves its space rather than shifting content. Analytics loads without blocking. If multi-locale is planned, routing and hreflang are decided before routes are built, or explicitly deferred with the cost noted.
a11y: run axe in CI and add a screen-reader pass to release :: area/a11y,priority/P1 :: v1-hardening :: axe-core runs in E2E across default views, opened modals and form error states; serious and critical violations fail the build. Release checklist includes one manual screen-reader pass.
resilience: add error.tsx and global-error.tsx :: area/resilience,priority/P0 :: v0-launch :: Root error boundary renders the brand shell, a reset action and a copyable error ID. global-error.tsx renders its own html and body. Both verified with a deliberately thrown error.
resilience: design not-found.tsx :: area/resilience,priority/P0 :: v0-launch :: 404 renders header and footer, at least three contextual links and a search or home escape hatch. Request to a missing path returns HTTP 404. Screenshot attached to PR.
resilience: implement four states on every data surface :: area/resilience,priority/P1 :: v0-launch :: An inventory lists every list, table and grid with its loading, empty, error and populated states. Zero-data copy differs from zero-results copy. Every empty state has a primary CTA. Skeletons match final dimensions and delay ~200ms.
resilience: centralise retry and offline handling :: area/resilience,priority/P2 :: v1-hardening :: One module defines retry counts and backoff, excludes non-idempotent mutations and 4xx except 408/429. Offline state is surfaced to the user. No ad-hoc retry loops remain.
seo: set metadataBase, title template and default OG in root layout :: area/seo,priority/P0 :: v0-launch :: metadataBase set to the production origin. title.template and default present. Default openGraph and twitter blocks present. Child routes that override openGraph re-declare the image.
seo: add per-route metadata and self-referencing canonicals :: area/seo,priority/P0 :: v0-launch :: Every indexable route has a unique title and description and an absolute self-referencing canonical. Utility, filter, draft and internal-search routes are noindex.
seo: generate OG images per route :: area/seo,priority/P1 :: v0-launch :: opengraph-image renders 1200x630, flexbox-only, subset fonts, under 500KB, wrapped in try/catch with a static fallback. A real share into Slack renders correctly.
seo: ship sitemap.ts and robots.ts :: area/seo,priority/P0 :: v0-launch :: sitemap.xml lists canonical URLs only with real lastModified values. robots.txt allows production crawling and contains no leftover Disallow from staging. Both reachable in production.
seo: add JSON-LD structured data :: area/seo,priority/P1 :: v1-hardening :: One @graph per page with absolute @id values, injected from a server component, with < escaped. Organization or Person plus WebSite sitewide; BreadcrumbList on nested routes; Article, Product or CreativeWork as applicable. Validates in a structured-data test.
seo: map primary query and answer per route :: area/seo,priority/P1 :: v1-hardening :: Each indexable route records its primary query and one-sentence answer. h1, title and opening paragraph reflect it. Comparison and pricing pages exist and are indexable.
perf: fix LCP element and font loading :: area/perf,priority/P1 :: v0-launch :: Exactly one above-the-fold image marked priority; nothing above the fold lazy-loaded. Fonts self-hosted with display swap, subsetting, preload on the primary face, at most two weights. Lab LCP <= 2.5s on the three most-trafficked routes on throttled mobile.
perf: eliminate layout shift :: area/perf,priority/P1 :: v0-launch :: Every image and embed has explicit dimensions or aspect-ratio. Nothing is inserted above existing content after first paint. CLS <= 0.1 in Lighthouse on all key routes.
perf: add bundle analysis and a per-route JS budget :: area/perf,priority/P2 :: v1-hardening :: Bundle analyzer wired to an env flag. A size budget per route group fails CI on regression. The three largest dependencies are listed with the action taken for each.
perf: inventory and defer third-party scripts :: area/perf,priority/P2 :: v1-hardening :: Every third-party script has a documented owner, purpose and measured cost. Non-essential scripts load lazily or on interaction. Any script without an owner is removed.
types: enable strict compiler options :: area/types,priority/P0 :: v0-launch :: strict, noUncheckedIndexedAccess and exactOptionalPropertyTypes enabled. tsc --noEmit exits 0 in CI. ignoreBuildErrors and ignoreDuringBuilds absent from the framework config.
types: add a typed env module :: area/types,priority/P0 :: v0-launch :: A single module is the only reader of process.env, with an explicit server/client split. Missing variables fail the build listing all of them. .env.example documents every key.
types: validate every trust boundary with a schema :: area/types,area/security,priority/P0 :: v0-launch :: Route handlers, server actions, webhooks, third-party responses and URL params parse input with a schema before use. Invalid input returns a field-level error. At least one rejection test per schema.
security: add baseline security headers and CSP :: area/security,priority/P0 :: v0-launch :: HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, X-Frame-Options and COOP returned on all HTML responses. CSP shipped report-only first, then enforced after a clean reporting window.
security: enforce authorization in a single data access layer :: area/security,priority/P0 :: v0-launch :: All database access goes through one layer that verifies session and scopes every query by owner or tenant in the query itself. No authorization decisions live only in middleware. A test proves user A cannot read user B's resource.
security: eliminate secret leakage :: area/security,priority/P0 :: v0-launch :: Every public env var is listed and justified. Secret-touching modules import server-only. CI greps the build output for secret patterns. Secret scanning with push protection enabled; any secret ever committed is rotated.
testing: add E2E for critical paths and required CI checks :: area/testing,priority/P1 :: v1-hardening :: Five to ten journeys covered with role-based locators and no fixed waits. Typecheck, lint at zero warnings, tests and build are required checks on every PR. Lighthouse budgets asserted against the preview URL.
```
