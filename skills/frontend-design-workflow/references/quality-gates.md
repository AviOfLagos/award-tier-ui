# Quality gates

Contents: [Accessibility](#accessibility) · [Four states](#four-states) · [Error boundaries](#error-boundaries) · [State management](#state-management) · [Types](#types) · [Security](#security) · [Performance](#performance) · [Testing](#testing)

These are what gets skipped when building fast. The user may choose to skip them — but that should
be a decision they make, not an omission they discover. Generate the backlog (`assets/backlog.md`)
so each becomes tracked work.

## Accessibility

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

## Four states

**Every data surface renders four states: loading, empty, error, populated.** No exceptions. This is
the single most common gap in fast-built apps, and the failure is silent — the user sees a blank
region and nobody is told.

- Skeletons match final layout dimensions, and delay ~200ms to avoid flicker on fast responses.
- Zero-data and zero-results are different copy. "You haven't added anything yet" with a primary CTA
  is not "No results for that filter" with a clear-filters action.
- Every error surface carries a copyable error or correlation ID wired to the error tracker.

## Error boundaries

In the App Router, `error.tsx` catches render errors in its segment and everything nested below —
but **not** its own segment's layout. To catch a layout's failures the boundary must live in the
*parent* segment; root layout errors need `global-error.tsx`, which must render its own `<html>` and
`<body>`.

Ship a designed `not-found.tsx` with the brand shell and at least a few navigation escape hatches.
The framework default is a white page with black text and no way out.

Centralise retry policy. Never auto-retry non-idempotent mutations, and never retry 4xx except 408
and 429. Every optimistic mutation implements cancel → snapshot → apply → rollback on error →
invalidate on settled.

## State management

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

## Types

Enable `strict`, `noUncheckedIndexedAccess` and `exactOptionalPropertyTypes`. Run `tsc --noEmit` as a
required CI job, and make sure `typescript.ignoreBuildErrors` and `eslint.ignoreDuringBuilds` are
absent from the config — they are how type errors reach production.

Validate with a schema at every trust boundary: environment variables, route handlers, server
actions, webhooks, third-party responses, URL params. Treat every server action as a public HTTP
endpoint, because it is one: validate input and re-check authorisation inside it.

Read `process.env` in exactly one typed module that fails fast at boot listing every missing
variable.

## Security

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

## Performance

One priority image above the fold, nothing lazy-loaded there. Fonts via the framework's font module
with `display: swap`, subsetting, preload on the primary face, at most two weights. Explicit
dimensions on every image and embed. Virtualise lists past ~100 rows. Bundle analysis on every
release with a per-route JS budget enforced in CI. Every third-party script needs a named owner, a
measured cost, and a non-blocking loading strategy.

## Testing

Proportionate to what the thing is. A marketing site needs a build check, a Lighthouse budget and a
link check. An app needs more:

- 5–10 critical-path E2E journeys, no more. Signup → first action, login → core CRUD → logout, and a
  tenant-isolation test proving user A cannot see user B's data.
- Role and label-based locators with auto-retrying assertions; no fixed timeouts.
- Unit tests for pure logic that is expensive to get wrong — money, permissions, dates, parsers.
  Don't test the framework.
- Required CI checks: typecheck, lint at zero warnings, tests, build. Lighthouse and a11y budgets set
  at the target rather than the status quo.
