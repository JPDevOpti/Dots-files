# TELESALUD Code Craft: Write, Review, and Audit Structure

## Description

This skill governs three everyday engineering activities in the LIME Telesalud repository (FastAPI + MongoDB Atlas backend, Next.js feature-sliced frontend): writing new code, reviewing existing or changed code, and auditing the folder structure against the closed architecture inventory defined in `CLAUDE.md`. Its purpose is to make every contribution land in the one correct place, follow the language and comment conventions, respect the binding testing and commit rules, and leave a written trace in Engram so the next session inherits the decisions instead of re-deriving them.

The skill does not replace the repository `CLAUDE.md`; it operationalizes it. Where the two disagree, `CLAUDE.md` wins and this skill must be corrected.

## Trigger

Activate this skill when the user, in Spanish or English, asks for one of these three activities on this repository:

**Write code**
- "escribir código", "escribí", "implementá", "agregá", "creá un componente/endpoint/servicio/hook", "hacé que X haga Y", "write code", "implement", "add a feature", "build the X"

**Review code**
- "revisar código", "revisá", "revisame", "hacé code review", "qué opinás de este cambio", "buscá bugs en", "está bien esto?", "review this", "code review", "look over my diff", "check this PR"

**Analyze folder structure**
- "analizar la estructura en carpetas", "revisá la estructura", "auditá las carpetas", "está bien ubicado este archivo?", "dónde va X?", "hay archivos fuera de lugar?", "analyze the folder structure", "audit the layout", "where should this file live?", "structure review"

Do **not** activate for:
- Pure explanations of a concept with no code artifact requested ("qué es TanStack Query?").
- Deployment, infrastructure, or `run.sh` operations.
- Requests to run or write tests (those are governed exclusively by the user's explicit request in that turn; this skill never initiates them).
- Git operations by themselves ("hacé commit", "push") unless bundled with a write task; even then, commit and push happen only when the user asks in that turn.
- Design or UI critique work that belongs to the `impeccable` or `ui-ux-pro-max` skills, unless the request also involves placing or writing code files.

If a request matches more than one mode (for example, "revisá y arreglá"), run the review mode first, report findings, and only enter write mode if the user explicitly authorized changes in the same request.

## Instructions

### Step 0: Establish mode and change authority

1. Classify the request into exactly one primary mode: **WRITE**, **REVIEW**, or **STRUCTURE**.
2. Determine whether the user explicitly authorized mutation. REVIEW and STRUCTURE are read-only by default. A phrase like "revisá" alone never authorizes edits. A phrase like "revisá y corregí" does.
3. If change intent is ambiguous, ask one question and stop. Do not write a file while waiting.

### Step 1: Load context before touching anything

1. Call `mem_context` to recover recent session history, then `mem_search` with the feature or module name. Read any hit that names a decision or convention for the same area with `mem_get_observation`.
2. For structural or "how does X work" questions, use CodeGraph first (`codegraph_explore` when available; otherwise the read-only `codegraph` CLI commands). Only fall back to filesystem search if CodeGraph fails, and say so.
3. Read the domain neighbors of any file you will touch. Editing `clinical/router.py` means reading `clinical/models/` and `clinical/schemas.py` first. Editing a module component means reading that module's `types.ts`, `index.ts`, and the sibling components in the same screen folder.
4. Identify the placement rule that governs the target before writing. State the layer out loud in your reply: "Esto va en `modules/clinical/lib/` porque es lógica de dominio sin JSX."

### Step 2A: WRITE mode

1. **Name the layer first.** For every new file, point to the exact folder that owns it under the closed inventory (`app/`, `modules/<feature>/{components,hooks,services,lib,store}`, `components/{ui,form,layout,charts}`, `core/`, `styles/`; backend `core/` or `domains/<domain>/{router,models,schemas,services}.py`). If you cannot, stop and propose a placement in Spanish, then wait.
2. **Route the work by size.** One mechanical, already-understood file stays inline. Two or more non-trivial files, or reading that prepares a write across four or more files, go to one delegated writer agent with a short synthesized handoff. Never spawn parallel writers on the same tree.
3. **Follow the language contract.** Identifiers, routes, DB fields, and file names in English. Comments and the file header comment in neutral Spanish. Every new file opens with a two-to-five-line header comment explaining what it is and how it works. Comment blocks, not lines; comment the why, never the what.
4. **Respect the hard technical rules.** No `any` in TypeScript. No `fetch` or `axios` outside `modules/<feature>/services/*.service.ts` and only through `core/api-client.ts`. Server data in TanStack Query, ephemeral state in Zustand. One `Button`, one `Modal`, `DetailRow` for detail views, `cn()` for class composition, design tokens only, no `dark:` variants, no raw hex in `.tsx`. Backend: raise the custom exceptions from `core/exceptions.py`, DB access only in models and services, every DB call `async`, register new `Document`s in `core/database.py`, mount new routers in `main.py`.
5. **Cross-module imports** go through the barrel `@/modules/<feature>` only. Before adding one, name the dependency direction and confirm the reverse edge does not already exist.
6. **Specialty models.** If you touch a `specialty_<name>.py` or `specialty-<name>.ts`, regenerate the OpenAPI contract in the documented order and let `npm run typecheck` prove both sides agree.
7. **Verify without the suites.** Run `cd frontend && npm run typecheck` after every batch. Read the diff. Run targeted searches for dangling references. Do not run `npm test`, `vitest`, `pytest`, or `npm run build`. Do not create a test file.
8. **Report** in Spanish: files created, modified, and deleted, what was checked, what was not, and how the user can verify the rest manually.

### Step 2B: REVIEW mode

1. Scope the review target: the working diff (`git diff` plus untracked files), a named file, a branch, or a PR number. Confirm which one you are reviewing in the first line of the report.
2. Read the changed code and its immediate neighbors. Do not review from the diff alone when the change touches a contract (types, schemas, barrels, permissions).
3. Evaluate in this order and report findings in this order, most severe first:
   - **Correctness**: wrong behavior, broken contracts, missed edge cases, async misuse, unhandled `ApiError`.
   - **Security and data**: RBAC gaps, Atlas URI leaks, credentials in logs, unvalidated input on the server.
   - **Architecture compliance**: file in the wrong layer, deep import instead of barrel, `components/` importing from `modules/`, HTTP outside services, a second primitive, a hand-rolled modal, `fixed inset-0` inside `modules/`.
   - **Conventions**: language contract violations, missing or lying header comments, `any`, raw hex, `dark:`, decorative comments, commented-out code.
   - **Simplification**: duplicated logic that an existing primitive or `core/` helper already solves.
4. Each finding names the file and line, states the defect in one sentence, and gives a concrete failure scenario. Do not pad with praise or generic advice.
5. If the user asked for fixes in the same turn, apply only confirmed findings, then run `npm run typecheck`. Otherwise stop after the report.
6. If the user invokes the native review lifecycle or `judgment-day`, defer to those skills for the verdict and use this skill only for the placement and convention checks.

### Step 2C: STRUCTURE mode

1. Enumerate the target scope with `eza --tree` or `fd`, scoped to what the user named. Never audit the whole repo when the user asked about one module.
2. Check each folder and file against the closed inventory and report violations by category:
   - **Extra top-level folder** in `frontend/src/` or `backend/app/`.
   - **Parallel layer**: `utils/`, `helpers/`, `shared/`, `common/`, `lib/` at `src/` root, or a fifth element in a backend domain.
   - **Grouping folder holding a single file** in `components/`. Mandated sublayers (`modules/<feature>/{components,hooks,services,lib,store}`, `components/form/{fields,choice,controls}`) are exempt and must not be flagged.
   - **Non-`.tsx` file** inside a `components/` sublayer.
   - **Deep import** across modules or `components/` importing `modules/`. Confirm with `rg` and show the line.
   - **Oversized element** that qualifies for the package exception (over 400 lines and a real responsibility seam) or a package that no longer qualifies.
   - **Tests inside `src/`** or in `__tests__/` folders instead of `frontend/tests/` mirroring `src/`.
   - **Orphans**: files nothing imports. Prove it with a search and show the command.
3. For each violation, state the rule it breaks, the correct location, and whether the move is pre-authorized under refactor mode or needs approval (anything crossing layers, adding a sublayer, or changing a dependency direction needs approval).
4. Do not move anything in STRUCTURE mode unless the user declared refactor mode with a scope. When they do, batch small, run `npm run typecheck` after every batch, and report file by file.

### Step 3: Close the loop in Engram

Before composing the final reply, save what the next session would otherwise re-derive.

**PROACTIVE SAVE TRIGGERS** (call `mem_save` immediately, do not wait for the end of the task):
- A placement decision that was not obvious from `CLAUDE.md` (which layer a new piece landed in and why).
- A new cross-module dependency and its direction.
- A structural violation found and whether it was fixed or deferred.
- A convention discovered in the code that the docs do not state.
- A bug found in review, with its root cause and the file.
- Any application of the oversized-element package exception.
- A design rule the user stated or rejected during the task (for example, "no icons in vital tiles").
- A `typecheck` failure whose cause was non-obvious.

Use `capture_prompt: false` for automated artifacts. Call `mem_session_summary` before saying the work is done. If a memory call fails, deliver the reply anyway; memory never blocks the answer.

## Rules

1. **Never run a test suite, a build, or write a test file unless the user asked for it in that turn.** `npm run typecheck` is the only verification that runs unprompted.
2. **Never commit or push unless the user asks in that turn.** When they do, one `git add -A`, one commit with a conventional Spanish message, immediate push, no questions.
3. **Never point any MongoDB operation at `localhost`.** Verify the effective URI before running anything that touches the database; if it resolves locally, stop and report.
4. **Never create a file without naming its layer first.** If no layer owns it, stop and propose in Spanish.
5. **Never create a sixth folder in `frontend/src/`, a fifth element in a backend domain, or a parallel layer** (`utils/`, `helpers/`, `shared/`, `common/`).
6. **Never import a module's internals.** Cross-module imports use `@/modules/<feature>` only. `components/` never imports from `modules/`.
7. **Never place HTTP calls outside `modules/<feature>/services/*.service.ts`** or bypass `core/api-client.ts`.
8. **Never write `any`, raw hex, arbitrary units, or `dark:` in `.tsx`.** Never hand-roll a modal or a detail row.
9. **Never edit `api-types.generated.ts` or `backend/openapi.json` by hand.**
10. **Never leave a purge half done.** Removing a feature means UI, client logic, backend, permissions, docs, and tests all go, followed by a dangling-reference search.
11. **Never restructure as a side effect of feature work.** Moves happen only in declared, scoped refactor mode.
12. **Never claim green suites that were not run.** State what was checked and what was not.
13. **Code artifacts in English, comments and replies in neutral Spanish.** No regional slang in any generated artifact.
14. **Review findings are evidence-based.** Every finding cites a file and line and a concrete failure scenario. No speculative or stylistic-only findings labeled as defects.
15. **Read-only modes stay read-only.** REVIEW and STRUCTURE write nothing unless the user explicitly authorized changes in the same request.
16. **One writer at a time.** Delegate broad reads and multi-file writes to a single bounded agent; never run parallel writers on the same tree.
17. **Engram saves are bookkeeping, never the reply.** The turn ends with the complete user-facing answer.

## Examples

### Example 1: Write mode, new component with a clear layer

**User:** "Agregá un chip de estado a la lista de solicitudes que muestre si la solicitud está vencida."

**Agent behavior:**
1. Calls `mem_context` and `mem_search "care-requests estado vencida"`. Finds a prior decision that status colors come from `core/status.ts`.
2. Runs `codegraph_explore` on `RequestsTable` to see how the row renders and which `Badge` variant is used.
3. States the placement: "Esto va dentro de `modules/care-requests/components/RequestsTable/` porque es UI específica del dominio; el color sale de `core/status.ts` y la etiqueta usa `Badge variant="light"`."
4. Edits the existing row component inline (one file, mechanical), adds the overdue computation to `modules/care-requests/lib/` if it is more than a one-liner, with a Spanish header comment explaining the cutoff rule.
5. Runs `cd frontend && npm run typecheck`.
6. Calls `mem_save` with the decision on where the overdue rule lives and why.
7. Reports in Spanish: files touched, what typecheck covered, that no suite was run.

### Example 2: Review mode, no fix authorized

**User:** "Revisá el diff que tengo sin commitear en clinical."

**Agent behavior:**
1. Confirms scope: "Reviso el diff de trabajo de `frontend/src/modules/clinical/` más los archivos nuevos sin trackear."
2. Reads the diff and the neighbors (`types.ts`, `index.ts`, the section components).
3. Reports findings most severe first, for example:
   - `attention-form/ExamSection.tsx:214`: the BMI reading divides by height in centimeters without converting to meters; a patient of 170 cm and 70 kg yields a BMI near zero.
   - `attention-form/fields.tsx:88`: `StaticValue` takes `value: any`; violates the no-`any` rule and hides a nullable string.
   - `components/AttentionsList.tsx:41`: imports `@/modules/patients/lib/format-age` by deep path instead of the barrel.
4. Does not edit anything. Ends with: "No apliqué cambios porque solo pediste revisión. Si querés, los corrijo."
5. Saves the BMI bug to Engram as a discovery, since the review found it even though it was not fixed.

### Example 3: Structure mode, single-file folder that is actually exempt

**User:** "Analizá la estructura de `modules/cups`, creo que hay carpetas con un solo archivo."

**Agent behavior:**
1. Runs `eza --tree frontend/src/modules/cups`.
2. Finds `services/cups.service.ts` alone in `services/`.
3. Reports: "`services/` con un solo archivo **no** es defecto: es una subcapa obligatoria del inventario cerrado y se nombra por la regla, no por lo que contiene. Aplanarla rompería la regla en vez de cumplirla. La carpeta con un solo archivo que sí sería defecto es una carpeta de agrupación dentro de `components/`, y acá no hay ninguna."
4. Checks imports with `rg "from '@/modules/cups/" frontend/src` to confirm nobody deep-imports the module.
5. Saves nothing new to Engram unless the audit exposed a convention not already recorded.

### Example 4: Write mode, ambiguous placement

**User:** "Necesito una función que formatee el número de documento con puntos de miles, la usan pacientes y profesionales."

**Agent behavior:**
1. Recognizes the piece is shared by two unrelated domains, so it cannot live in either module.
2. Checks `core/format.ts` and `core/validators.ts` for an existing helper. Finds none.
3. Stops and proposes: "Esto lo usan dos dominios sin relación, así que no puede vivir en `modules/`. Propongo `core/format.ts`, junto a `formatDate`, porque es formato de presentación sin lógica de dominio. ¿Avanzo?"
4. Waits for the answer before writing a line.

### Example 5: Review bundled with a fix request

**User:** "Revisá `scheduling/services/availability.py` y corregí lo que encuentres."

**Agent behavior:**
1. Runs review mode first, reads `availability.py`, `models.py`, `schemas.py`, and the router.
2. Reports findings with lines and scenarios.
3. Because the user authorized fixes, applies only the confirmed correctness and architecture findings, not stylistic preferences.
4. Does not run `pytest`. Says so: "No corrí la suite del backend; verifiqué leyendo el diff y buscando referencias colgantes."
5. Saves each fixed bug to Engram with root cause and file.

### Example 6: Request outside the trigger

**User:** "Explicame qué es un discriminated union en TypeScript."

**Agent behavior:** Does not activate this skill. Answers the concept directly with no code artifact placement, no review, and no structural audit.