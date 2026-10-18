# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
/init
```

**Qué salió:** 
```
He creado CLAUDE.md en la raíz del repo. No lo he commiteado.

Contiene:
- Qué es el proyecto: backend/ en AdonisJS 7, que en esta sesión se lee pero no se modifica, y frontend/ en React 19 + Vite, que es donde se trabaja. Indica que el frontend sigue siendo la plantilla de Vite: aún no tiene shadcn/ui, Tailwind, router ni formateador. También avisa de que README.md se genera fuera del repo y no se edita a mano.
- Comandos de cada parte: arrancar, lint, typecheck y build. Incluye cómo lanzar una suite, un archivo o un test de Japa sueltos. Todavía no hay ningún test: solo existe tests/bootstrap.ts.
- Arquitectura del backend: cómo se pasa de rutas a controladores, validadores, modelos y transformers; los alias #...; qué archivos son autogenerados (.adonisjs/, database/schema.ts); que todas las respuestas van envueltas en { data }; que los errores llegan siempre en JSON; y la auth con Bearer token oat_.
- Tabla de la API de auth con las reglas reales de backend/app/validators/user.ts. Ahí están justo los huecos del ticket: el registro exige passwordConfirmation y el campo fullName, aunque puede ir a null.
- Convenciones de TypeScript del frontend, sacadas de tsconfig.app.json y de la configuración de oxlint.

No he encontrado reglas de Cursor ni de Copilot, ni configuración de Codex o Gemini.

Una cosa a decidir: el README pide usar el CLAUDE.md de /init tal cual sale. Por eso la tabla de la API, que ya detalla lo que el ticket no dice, se considera parte del harness generado y no un añadido manual. Si prefieres que el harness solo recoja lo que sale de /init sin ese extra, puedo quitar la tabla.
```

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Verify you connect via MCP with Jira https://georgevik-ia.atlassian.net/jira/software/projects/FLOW/boards/2?filter=&groupBy=none
```

**Qué salió:** 
```
No hay conexión con Jira: no tengo configurado ningún servidor MCP de Atlassian.

claude mcp list solo muestra los conectores de claude.ai: Claude Docs, Google Drive, Calendar y Gmail conectados, y Make y Canva pendientes de autenticar. Tampoco existe un .mcp.json en el proyecto. Por eso no puedo ver el tablero de FLOW.

Es la pieza 2 del harness del ejercicio, que va a nivel de proyecto. Puedes añadirla así:

! claude mcp add --transport http --scope project atlassian https://mcp.atlassian.com/v1/mcp

Ese comando crea .mcp.json en la raíz del repo, que luego se commitea con el harness. Después:

1. Reinicia Claude Code, o abre /mcp, y aprueba el servidor del proyecto.
2. En /mcp, autentícate con OAuth en georgevik-ia.atlassian.net desde el navegador.
3. Pídeme de nuevo que lo verifique. Comprobaré que veo el proyecto FLOW y el ticket «Implementar login en el frontend» en «Por hacer».

Si prefieres que lo añada yo, dímelo. Lo has dejado tú para que el prompt quede registrado en prompts.md.
```

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
/mcp
```

**Qué salió:** 
```
Authentication successful. Connected to atlassian.
```

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Let's speak in english. create a new skill /priority-ticket which will return the highest priority TODO ticket assigned to me, summarize the acceptance criteria, use plan mode and propose the implementation. When the plan is approved, move the ticket to "In progress"
```

**Qué salió:** 
```
I created the /priority-ticket skill at .claude/skills/priority-ticket/SKILL.md. I haven't run it yet, so it's untested against your Jira.

It uses the Atlassian MCP server from .mcp.json and works in four steps:

1. Find the ticket: it searches Jira with assignee = currentUser() AND statusCategory = "To Do" ORDER BY priority DESC, created ASC and takes the first result, so the highest priority wins and the oldest ticket breaks ties. You can limit it to one project by passing the project key, like /priority-ticket FS.
2. Summarize: it shows the key, title, priority and link, plus the acceptance criteria as a checklist and any open questions. If the ticket has no explicit acceptance criteria, it works them out from the description and says so.
3. Plan: it switches to plan mode and looks through the code, following CLAUDE.md (the backend is only read for the API rules; the work happens in frontend/). The plan links each acceptance criterion to the steps that satisfy it and lists the files to change, any new dependencies, how to check the result, and assumptions. If you reject the plan, it revises it and the ticket stays where it is.
4. Move to "In Progress": only after you approve the plan. It asks Jira for the ticket's available status changes and picks the one leading to "In Progress", rather than using a fixed ID. If there isn't one, it lists the options instead of guessing. Then it starts implementing.

You may need to restart Claude Code before /priority-ticket shows up. The first run will also need you to sign in to Atlassian if you haven't already.
```


## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
create a new skill /priority-ticket which will return the highest priority TODO ticket assigned to me, summarize the acceptance criteria, use plan mode and propose the implementation. When the plan is approved, move the ticket to "In progress"
```

**Respuesta:**

I've created the skill at `.claude/skills/priority-ticket/SKILL.md`. I haven't run it yet, so it hasn't touched Jira.

When you type `/priority-ticket`, it does this:

1. **Finds the ticket:** it gets your Jira site from the Atlassian MCP and searches with `assignee = currentUser() AND statusCategory = "To Do" ORDER BY priority DESC, created ASC`. It takes the first result, so when two tickets have the same priority it picks the older one. If nothing comes back, it says so and stops.
2. **Summarizes it:** it shows the key, title, priority and link, a short summary of the description, and the acceptance criteria as a checklist. It recognizes English and Spanish headings ("Acceptance criteria", "Criterios de aceptación") and Given/When/Then blocks. If the ticket has no explicit criteria, it works them out from the description and labels them as inferred.
3. **Plans the work:** it switches to plan mode, reads the code and `CLAUDE.md` (so it keeps the backend read-only and uses shadcn/ui), and maps each acceptance criterion to specific file changes and a way to check it.
4. **Moves the ticket:** only after you approve the plan, it moves the ticket to "In Progress" ("En curso" and "En progreso" also count). If you reject the plan, the ticket stays as it is. If no matching status exists, it lists the available ones and asks you which to use.

The skill's `allowed-tools` list lets it use the Jira and plan-mode tools without asking each time, including the one that moves the ticket. That's fine here because the skill only moves it after you approve the plan.

You may need to restart Claude Code before `/priority-ticket` shows up.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
create the skill /commit which is an usual commit `tipo(scope): descripción` from proposed changes
```

**Respuesta:**

I created the /commit skill at .claude/skills/commit/SKILL.md. I haven't run it yet, and it may only appear as a command in a new session.

When you run it, it:

1. Checks the changes: what's modified, the diffs, the last 10 commits (to copy their style) and the current branch. If you're on main, it asks before committing.
2. Picks what to commit:
   - If you've already staged files, it commits only those.
   - Otherwise it adds the related files one by one by name, never everything at once.
   - It refuses to add .env, *.sqlite3, tmp/, node_modules/ or settings.local.json.
   - If the changes cover unrelated things, it suggests splitting them into separate commits.
3. Writes the message as tipo(scope): descripción:
   - The description is in Spanish, starts lowercase, has no final period, and the whole line stays under about 72 characters.
   - The scope reuses ones already in the log, such as docs(s1): ....
   - It follows your global rules: one line only, no body, no Co-Authored-By or other attribution.
4. Commits with no --no-verify, no amend and no push, then shows the new commit.

You can add a hint, for example /commit feat(auth) signup form, and it will follow it.

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
create a subagent "adversial-reviewer", reviews a pull request trying to break it, not approve it, without editing anything.
```

**Respuesta:**

```
I created the subagent at .claude/agents/adversarial-reviewer.md. I named it adversarial-reviewer, fixing the typo in "adversial"; tell me if you want the original spelling. I haven't tried it on a PR yet.

Can't edit: it only has Read, Grep, Glob and Bash, with no Edit or Write. The prompt limits Bash to commands that only read:
- Allowed: reading git history and diffs, viewing the PR and its checks with gh, and the type and lint checks.
- Forbidden: changing branches, committing, pushing, leaving PR comments, npm install, build, test (it writes the database) and migrations.

That Bash limit is only an instruction in the prompt. If you want it to be impossible, I can add deny rules in the settings.

Input: a PR number (it uses gh pr view and gh pr diff), a branch (diffed against main), or nothing (your current branch plus uncommitted changes). If the PR mentions a Jira ticket, it attacks that ticket's acceptance criteria.

What it attacks:
- whether requests and responses match the backend's routes and validators
- the acceptance criteria
- edge cases
- auth and security
- React bugs
- the project's TypeScript rules
- changes to files that shouldn't be touched: backend/, auto-generated files and README.md

Output:
- It starts with BLOCK or NEEDS CHANGES and never approves.
- Each finding has a severity, the file and line, a concrete way to make it fail, and evidence.
- It ends with a "Not verified" list of anything it couldn't check.

To use it, ask something like "review PR #3 with adversarial-reviewer". It may only show up in a new session.  
```

## Prompt 8

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
We need a hook to format the front end when an agent modifies a file. The frontend doesnt have a formatter by default. Install prettier in frontend/ and apply into /frontend/src/**
```

**Respuesta:**

```
Prettier is installed in frontend/, the whole of frontend/src is formatted, and a hook now formats any file an agent edits or writes there. I tested the hook by hand with a sample file and it formatted it; it hasn't run inside a real session yet. Build and lint still pass.

Prettier in frontend/
- Installed prettier@3.9.10 as a dev dependency, pinned to that exact version.
- Settings in .prettierrc.json match the Vite template's existing style: no semicolons, single quotes, trailing commas, 100-character lines.
- .prettierignore skips dist and node_modules.
- New scripts: npm run format (formats src) and npm run format:check (only checks).
- Formatting src changed App.tsx, App.css and index.css; main.tsx already matched. Use npm run format rather than prettier "src/**": the glob also picks up the images in src/assets and errors on them.

The hook
- .claude/hooks/format-frontend.sh runs after every Edit or Write and formats the changed file, but only if it's under frontend/src/. Anything else, including backend/, is left alone.
- It never blocks the agent: if Prettier fails, the edit still goes through.
- It's registered in .claude/settings.json, which is meant to be committed, so it applies to the whole team (unlike settings.local.json).
- You may need to open /hooks or restart Claude Code before it picks up the new hook.

None of this is committed yet. The changes sit in frontend/ (package.json, package-lock.json, src/, the two Prettier files) and .claude/ (settings.json, hooks/). You can commit them with /commit.
```

## Prompt 9

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
the development rules should be at the end of Claude.md. Create a new branch on new implementatation, close the branch with /commit and create the PR with gr pr create. Then the reviewer subagent will review the PR and drop in the chat only the URL of the PR
```

**Respuesta:**

```
I added a "Reglas de desarrollo" section at the end of CLAUDE.md, written in Spanish like the rest of the file. I read "gr pr create" as gh pr create. From now on, every new implementation follows this flow:

1. New branch before touching any code, named tipo/descripcion-corta (for example feat/signup-form). Never work directly on main.
2. Close the branch with /commit.
3. Open the PR with git push -u origin <rama> and then gh pr create. The PR title is the commit message, and the description says briefly what changes and how to check it.
4. Review: the adversarial-reviewer subagent reviews the new PR. It only reads and doesn't comment on GitHub.
5. Only the PR URL goes in the chat. If the reviewer says BLOCK, the problem gets fixed on the same branch (new /commit and push) and the PR is reviewed again before the URL is shared.

None of today's work is committed yet: the Prettier setup and hook, the /commit skill, the reviewer subagent, and these rules. Should I run the new flow on it now? That means a branch like chore/tooling-claude, a commit, a push to the remote, and a PR against s1/start. One thing to decide: CLAUDE.md and .mcp.json are untracked right now. Do you want them in that PR too?
```

