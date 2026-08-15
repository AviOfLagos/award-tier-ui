# Motion

Contents: [Values](#values) · [Primitives](#primitives) · [Smooth scroll](#smooth-scroll) · [Failure modes](#failure-modes) · [Reduced motion](#reduced-motion)

Budget comes from `direction.md`. This file is how to execute within it.

## Values

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

## Primitives

Define these once, use only these. Consistency is most of what reads as designed.

### Reveal — masked line rise

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

### FadeUp — the workhorse

```tsx
<motion.div
  initial={{ opacity: 0, y: 32 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true, margin: '-8%' }}
  transition={{ duration: 0.7, delay: i * 0.06, ease: [0.22, 1, 0.36, 1] }} />
```

### Magnetic — leans toward the cursor

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

### Cursor-following preview

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

### Marquee — scroll-velocity strip

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

### CountUp

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

## Smooth scroll

```tsx
if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
const lenis = new Lenis({ lerp: 0.1, smoothWheel: true })
```

`lerp: 0.1` is the ceiling. Heavier smoothing reads as input lag, and to anyone who scrolls fast it
reads as broken.

## Failure modes

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

## Reduced motion

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
