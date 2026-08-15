# Verification

The step that catches what re-reading your own code cannot. You wrote it, so you already believe it
works.

## Run it

```bash
node scripts/verify.mjs http://localhost:3000 /            /work /about /contact
```

The script screenshots each route at desktop and mobile, exercises hover on the first interactive
row, scrolls with real wheel events, and reports console page errors. Then **read the images**.

## Inspect rather than guess

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

## Defects in frequency order

Check these first, because they are what actually goes wrong:

1. **Content stuck off-screen** — a reveal that never fired. Scroll down and confirm.
2. **Text overflow or clipping** at some breakpoint, usually large display type on mobile.
3. **Hover states not responding** — move the mouse in steps, not a single jump.
4. **Contrast failures**, especially the accent on a light theme.
5. **Horizontal scroll on mobile** from a fixed-width child.
6. **Console page errors.**
7. **Routes that 404**, or links pointing at routes that don't exist.
8. **Motion ignoring `prefers-reduced-motion`.**

## Pre-ship

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

## Two things about this loop

**You are the worst reviewer of your own output.** After staring at the generating code you see what
you intended rather than what rendered. Look at the images cold, or hand them to a subagent with the
checklist and no context.

**It terminates.** The first render usually has a few real defects. Fix those, re-check what you
changed, and stop. Perpetual polishing is not verification.

## Sandbox note

If Playwright's browser download is unavailable, point at a preinstalled Chromium:

```js
chromium.launch({ executablePath: process.env.CHROME_PATH, args: ['--no-sandbox'] })
```
