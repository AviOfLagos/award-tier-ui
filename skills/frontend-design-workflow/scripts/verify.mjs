#!/usr/bin/env node
/**
 * Screenshot and stop-ship sweep for a running dev/preview server.
 *
 *   node verify.mjs http://localhost:3000 / /work /about
 *   CHROME_PATH=/path/to/chrome node verify.mjs http://localhost:3000 /
 *   THEMES=light,dark node verify.mjs http://localhost:3000 /
 *
 * Writes PNGs to ./.verify/ and checks the automatable stop-ship conditions:
 * console errors, HTTP status, horizontal overflow, and that reduced-motion is respected.
 * Everything else needs your eyes — that is the point of the screenshots.
 */
import { chromium } from 'playwright'
import { mkdir } from 'node:fs/promises'

// Timings are settle windows, not magic: SETTLE_MS must outlast a typical intro sequence
// (preloader ~1.1s + staggered hero reveal ~1.2s) so the frame is representative.
const SETTLE_MS = Number(process.env.SETTLE_MS ?? 2800)
const HOVER_SETTLE_MS = 700
const WHEEL_STEPS = 18          // ~5700px, enough to pass the first two or three sections
const WHEEL_DELTA = 320
const WHEEL_PAUSE_MS = 70       // real wheel cadence, so smooth-scroll libraries behave
const MOUSE_STEPS = 14          // a single jump often fires no mousemove handler at all

const [, , base = 'http://localhost:3000', ...routes] = process.argv
const paths = routes.length ? routes : ['/']
const themes = (process.env.THEMES ?? 'dark,light').split(',').map((t) => t.trim()).filter(Boolean)
const OUT = '.verify'

const slug = (p) => (p === '/' ? 'home' : p.replace(/^\//, '').replace(/\//g, '-'))

const launchOpts = process.env.CHROME_PATH
  ? { executablePath: process.env.CHROME_PATH, args: ['--no-sandbox'] }
  : {}

let browser
try {
  browser = await chromium.launch(launchOpts)
} catch (err) {
  console.error('Could not launch a browser.')
  console.error(err.message.split('\n')[0])
  console.error('\nFix one of these:')
  console.error('  npx playwright install chromium     (download the bundled browser)')
  console.error('  CHROME_PATH=/path/to/chrome ...     (use one already installed)')
  process.exit(2)
}

await mkdir(OUT, { recursive: true })
const findings = []
const note = (route, ctx, msg) => findings.push({ route, ctx, msg })

const VIEWPORTS = [
  { name: 'desktop', width: 1440, height: 900 },
  { name: 'mobile', width: 390, height: 844 },
]

for (const vp of VIEWPORTS) {
  for (const theme of themes) {
    const ctxName = `${vp.name}-${theme}`
    const context = await browser.newContext({
      viewport: { width: vp.width, height: vp.height },
      colorScheme: theme === 'light' ? 'light' : 'dark',
    })
    const page = await context.newPage()
    page.on('pageerror', (e) => note('(page)', ctxName, 'pageerror: ' + String(e).split('\n')[0]))
    page.on('console', (m) => m.type() === 'error' && note('(page)', ctxName, 'console: ' + m.text()))

    for (const p of paths) {
      try {
        // 'load' rather than 'networkidle': a dev server holds an open HMR socket, so
        // networkidle can never settle and every route would time out.
        const res = await page.goto(base + p, { waitUntil: 'load', timeout: 30000 })
        if (res && res.status() >= 400) note(p, ctxName, `HTTP ${res.status()}`)
      } catch (e) {
        note(p, ctxName, 'navigation failed: ' + e.message.split('\n')[0])
        continue
      }
      await page.waitForTimeout(SETTLE_MS)
      await page.screenshot({ path: `${OUT}/${ctxName}-${slug(p)}.png` })

      const overflow = await page.evaluate(
        () => document.documentElement.scrollWidth - window.innerWidth,
      )
      if (overflow > 1) note(p, ctxName, `horizontal overflow: ${overflow}px`)

      if (vp.name === 'desktop' && theme === themes[0]) {
        for (let i = 0; i < WHEEL_STEPS; i++) {
          await page.mouse.wheel(0, WHEEL_DELTA)
          await page.waitForTimeout(WHEEL_PAUSE_MS)
        }
        await page.waitForTimeout(HOVER_SETTLE_MS)
        await page.screenshot({ path: `${OUT}/${ctxName}-${slug(p)}-scrolled.png` })

        const row = page.locator('a, button, [role="listitem"]').first()
        try {
          const box = await row.boundingBox({ timeout: 2000 })
          if (box) {
            await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2, { steps: MOUSE_STEPS })
            await page.waitForTimeout(HOVER_SETTLE_MS)
            await page.screenshot({ path: `${OUT}/${ctxName}-${slug(p)}-hover.png` })
          }
        } catch { /* nothing hoverable on this route; not a failure */ }
      }
    }
    await context.close()
  }
}

// Reduced motion: if a page animates identically with the preference set, it is being ignored.
{
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 },
    reducedMotion: 'reduce',
  })
  const page = await context.newPage()
  for (const p of paths) {
    try {
      await page.goto(base + p, { waitUntil: 'load', timeout: 30000 })
    } catch { continue }
    await page.waitForTimeout(600)
    const running = await page.evaluate(
      () => document.getAnimations().filter((a) => a.playState === 'running').length,
    )
    if (running > 0) note(p, 'reduced-motion', `${running} animation(s) still running`)
    await page.screenshot({ path: `${OUT}/reduced-motion-${slug(p)}.png` })
  }
  await context.close()
}

await browser.close()

if (findings.length === 0) {
  console.log('No automated stop-ship conditions triggered.')
} else {
  console.log('Findings:\n')
  for (const f of findings) console.log(`  ${f.ctx.padEnd(18)} ${f.route.padEnd(18)} ${f.msg}`)
}

console.log(`\nScreenshots in ${OUT}/ — now read them. No script can see a layout.`)
console.log('Look for: content stuck off-screen from a reveal that never fired, text clipping,')
console.log('contrast failures in each theme, and hover states that did not respond.')
process.exit(findings.length ? 1 : 0)
