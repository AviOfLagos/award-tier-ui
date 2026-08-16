# Push and publish — copy-paste

The sandbox cannot push to this repo (see *Why* below), so these three blocks are yours to run.
Everything is committed locally already; nothing needs editing first.

## 1. Create the repo and push

```bash
cd ~/26/frontend-design-workflow

gh repo create AviOfLagos/frontend-design-workflow --public --source . --push \
  --description "Frontend/web design skill for AI coding agents — stops AI-generated sites from looking generic. Research → art direction → architecture → design tokens → verified build."
```

## 2. Set topics

GitHub search indexes the repo name, About description and topics — **not** the README. These are
your entire default search surface.

```bash
gh repo edit AviOfLagos/frontend-design-workflow --add-topic agent-skills \
  --add-topic claude-skill --add-topic claude-code --add-topic cursor \
  --add-topic codex --add-topic skills --add-topic web-design \
  --add-topic frontend --add-topic ui-design --add-topic design-system \
  --add-topic ux --add-topic seo --add-topic ai-agents
```

## 3. Publish the skill and cut the release

```bash
gh skill publish skills/frontend-design-workflow --dry-run      # validates against the spec
gh skill publish skills/frontend-design-workflow --tag v1.0.0   # publishes + adds agent-skills topic

gh release upload v1.0.0 frontend-design-workflow.skill frontend-design-workflow.zip
```

Both archive formats are attached deliberately: `.skill` is what Claude Code and the skill CLIs
expect, while claude.ai's documented upload format is a plain `.zip`.

## 4. Verify before you promote anything

Do this on a clean machine or a fresh directory. A broken install command in a launch post is
unrecoverable.

```bash
npx skills add AviOfLagos/frontend-design-workflow
gh skill install AviOfLagos/frontend-design-workflow frontend-design-workflow
# and in Claude Code:
#   /plugin marketplace add AviOfLagos/frontend-design-workflow
#   /plugin install frontend-design-workflow
```

---

## Why I could not push this myself

Not a connector problem, so re-adding the GitHub connector will not fix it. Three separate checks
confirm the same boundary:

| Check | Result |
|---|---|
| `GET /user` | `AviOfLagos` — the connector is authenticated and working |
| `POST /user/repos` | 403: *"sessions are bound to their configured repositories"* |
| `git push` | 403 from the git proxy: *"not in this session's authorized repository set"* |

This cloud session can only reach GitHub repositories that were attached as **sources when the task
was created**. Connector settings and repository permissions are a different layer and do not
change it. Repo creation is blocked outright at the API level regardless.

**If you want me pushing directly in future:** create the repo first, then start a Cowork task with
that repository attached as a source. I can then commit and push to it for the rest of the session.
That is also why the portfolio work went through your local clone instead.
