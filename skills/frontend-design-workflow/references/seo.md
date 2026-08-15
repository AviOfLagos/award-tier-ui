# SEO and metadata

Contents: [Do this at architecture time](#do-this-at-architecture-time) · [Metadata](#metadata) · [OG images](#og-images) · [Sitemap and robots](#sitemap-and-robots) · [Structured data](#structured-data) · [Core Web Vitals](#core-web-vitals) · [Pre-launch](#pre-launch)

Examples are Next.js App Router; the principles port to any framework that can render HTML on the
server.

## Do this at architecture time

Slugs, folder-as-cluster structure, the trailing-slash and www policy, and the indexation rule for
every route type are architecture decisions. Changing them later means changing URLs, and changing
URLs means redirects forever. Settle them in Phase 3.

Keyword work belongs there too, not after launch: for each route, the primary query it should answer
and the one-sentence answer it gives. That determines the `<h1>`, the title and the first paragraph.
Comparison and pricing pages carry the highest commercial intent, so they get the most attention and
must be indexable.

## Metadata

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

## OG images

Generate at **1200×630** via a file-based `opengraph-image.tsx`. Constraints that bite: flexbox
layout only (no grid), subset TTF fonts loaded explicitly, keep output under ~500KB, and wrap
generation in try/catch with a static fallback — a throwing OG route means every share of that page
renders blank.

Verify the image resolves at a public absolute URL. Unfurlers do not run JavaScript and do not
follow relative paths.

## Sitemap and robots

Ship `sitemap.ts` and `robots.ts` on day one. Real `lastModified` values, canonical URLs only, split
at 50,000 entries.

## Structured data

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

## Core Web Vitals

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

## Pre-launch

- No stray `noindex`; no `Disallow: /` left from staging.
- One `<h1>` per page.
- OG images resolve at absolute public URLs; test a real share into Slack.
- Canonicals correct and self-referencing.
- `sitemap.xml` and `robots.txt` reachable and accurate.
- No indexable content rendered client-only — treat that as a defect.
