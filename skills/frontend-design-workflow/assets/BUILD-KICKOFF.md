# Build kickoff

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
