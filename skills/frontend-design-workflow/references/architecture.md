# Architecture

Contents: [Page inventory](#page-inventory) · [Content model](#content-model) · [The rendering question](#the-rendering-question) · [Stack table](#stack-table) · [Decision record](#decision-record)

Architecture comes before stack. Choosing a framework before knowing the pages is how a project
discovers in week three that it needs server rendering and rebuilds.

## Page inventory

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

## Content model

One module holds every piece of copy, every record, every stat. Components read from it; nobody
hardcodes a string.

This is not tidiness. It is what makes adding an item update the index, the detail route, the nav,
the search palette and the "next item" link at once, and what lets the user edit their own copy
without touching a component. Sketch the shape now — entity names, fields, which fields are
optional — because it determines the routes and the metadata.

## The rendering question

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

## Stack table

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

## Decision record

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
