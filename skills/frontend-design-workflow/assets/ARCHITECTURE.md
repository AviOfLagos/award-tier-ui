# Architecture — <project>

> Phase 3. Pages first, stack second.

## Page inventory

| Route | Job | Primary action | Content source | Public | Indexation |
|---|---|---|---|---|---|
| `/` | | | | yes | index, canonical self |

Do not forget the routes that later force rework: legal (terms, privacy), 404, analytics and
consent, locale routing, auth and onboarding, and the empty and first-run states of every core
surface.

## Responsive strategy

Breakpoints, and how the signature visual move degrades on small screens rather than being hidden.

## Content model

```ts
// lib/content.ts — one module, every string. Components read; nobody hardcodes.
export type Entity = {
  slug: string
  // ...
}
```

## Rendering decision

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

## Decision record

```
Rendering:   
Framework:   
Signals:     
Rejected:    
Consequence: 
```

## Metadata plan

| Route | Title | Description | OG image | JSON-LD |
|---|---|---|---|---|

## Quality scope

Which gates are in for v1, and which are deliberately deferred (see `assets/backlog.md`):

- [ ] Accessibility WCAG 2.2 AA
- [ ] SEO / metadata / OG / sitemap / JSON-LD
- [ ] Error boundaries, 404, four states
- [ ] Types strict + boundary validation
- [ ] Security headers, authz, secrets
- [ ] Performance budgets
- [ ] E2E on critical paths
