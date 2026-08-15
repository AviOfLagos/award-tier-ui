# Direction

Contents: [The attractor states](#the-attractor-states) · [Art direction as a system](#art-direction-as-a-system) · [Technique by technique](#technique-by-technique) · [Interaction budget](#interaction-budget) · [The proposal](#the-proposal)

## The attractor states

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

## Art direction as a system

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

## Technique by technique

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

## Interaction budget

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

## The proposal

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
