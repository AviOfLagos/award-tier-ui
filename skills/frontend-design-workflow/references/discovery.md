# Discovery

Contents: [Intake](#intake) · [Competitors](#competitors) · [Adjacent niches](#adjacent-niches) · [Validating a reference](#validating-a-reference) · [Mining user reviews](#mining-user-reviews)

## Intake

Read everything the user has before searching for anything: PRD, spec, pitch deck, existing site,
brand assets, résumé, competitor list. Connected tools (Drive, Notion, GitHub) often hold the real
brief. Ask for what's missing only if the user is present and the gap is load-bearing.

Then write the frame — product, audience, primary task, trust posture, interaction budget tier —
*before* looking at a single reference. Design fixation is well documented: exposure to examples
causes designers to reproduce their features unconsciously, including their flaws. The frame is what
you filter references through, so it has to exist first.

## Competitors

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

## Adjacent niches

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

## Validating a reference

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

## Mining user reviews

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
