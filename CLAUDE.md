# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Proyecto

FlowSync es el proyecto de ejercicio de un curso (cohorte 202610-seniors-I). Monorepo TypeScript de punta a punta con dos apps independientes, cada una con su propio `package.json` y `node_modules`:

- `backend/`: API AdonisJS 7 (Lucid + SQLite, VineJS, auth por access tokens). **En la sesión 1 el backend ya existe y no se modifica**: solo se lee para saber qué exige la API.
- `frontend/`: React 19 + Vite 8, todavía la plantilla por defecto de Vite. Aquí es donde se trabaja. El curso usa shadcn/ui (componentes copiados al repo, no instalados como dependencia), aunque aún no está configurado: no hay Tailwind, ni router, ni cliente HTTP, ni formateador.

`README.md` es la lección del ejercicio, generada fuera del repo: no se edita a mano. `prompts.md` es una plantilla que rellena el alumno.

Requiere **Node.js 24+** (con versiones anteriores el backend falla con `Unknown file extension ".ts"`).

## Comandos

Backend (desde `backend/`):

```bash
npm install && cp .env.example .env && node ace generate:key   # primera vez
node ace migration:run      # crea tmp/db.sqlite3 y regenera database/schema.ts
npm run dev                 # http://localhost:3333 con HMR
npm run lint                # eslint
npm run typecheck           # tsc --noEmit
npm run format              # prettier (@adonisjs/prettier-config)
npm test                    # node ace test (Japa)
node ace test functional    # una sola suite (unit | functional)
node ace test --files=tests/functional/auth.spec.ts   # un solo archivo
node ace test --tests="nombre del test"               # un solo test
```

Todavía no hay tests: solo `tests/bootstrap.ts`. Las suites esperan `tests/unit/**/*.spec.ts` y `tests/functional/**/*.spec.ts`; la suite `functional` arranca el servidor HTTP. En test se usa `.env.test` (`SESSION_DRIVER=memory`).

Frontend (desde `frontend/`, en otra terminal con el backend corriendo):

```bash
npm run dev       # http://localhost:5173
npm run build     # tsc -b && vite build (es también la comprobación de tipos)
npm run lint      # oxlint
```

## Arquitectura del backend

Capas de AdonisJS, de fuera hacia dentro: `start/routes.ts` → `app/controllers` → `app/validators` (VineJS) → `app/models` (Lucid) → `app/transformers` (qué se devuelve al cliente).

- **Imports con alias** `#controllers/*`, `#models/*`, `#validators/*`, etc. (definidos en `imports` de `backend/package.json`), siempre con extensión `.js` en la resolución.
- **Rutas**: los controladores se referencian vía `controllers` de `#generated/controllers`, no importándolos directamente. Todo lo de `.adonisjs/` y `database/schema.ts` es **autogenerado** (por los hooks de `adonisrc.ts` y por `migration:run`): no se edita a mano. Los modelos extienden las clases de `database/schema.ts`; los cambios de esquema van en una migration nueva.
- **Respuestas**: los controladores devuelven `serialize(...)` (añadido a `HttpContext` en `providers/api_provider.ts`), que envuelve todo en `{ "data": ... }`. `UserTransformer` expone `id, fullName, email, createdAt, updatedAt, initials`; nunca el password.
- **Siempre JSON**: `force_json_response_middleware` fuerza `Accept: application/json`, así que los errores (validación, credenciales, auth) también llegan como JSON con un array `errors`.
- **Auth**: guard por defecto `api` (access tokens en BD, prefijo `oat_`). El cliente manda `Authorization: Bearer <token>`. CORS permite cualquier origen en desarrollo.
- **Tuyau**: `generateRegistry()` genera un registro tipado de rutas en `.adonisjs/client/`, exportado como `backend/registry` y `backend/data` para un cliente type-safe desde el frontend.

### API de auth (`/api/v1`)

| Ruta | Body | Respuesta |
|---|---|---|
| `POST /auth/signup` | `fullName` (string o `null`, el campo debe ir), `email` (único, máx. 254), `password` (8-32), `passwordConfirmation` (igual a `password`) | `{ data: { user, token } }` |
| `POST /auth/login` | `email`, `password` | `{ data: { user, token } }` |
| `GET /account/profile` | — (requiere token) | `{ data: user }` |
| `POST /account/logout` | — (requiere token) | `{ message }` |

Las reglas exactas están en `backend/app/validators/user.ts`: el ticket de producto del ejercicio no las detalla todas (p. ej. `passwordConfirmation` y `fullName`), así que hay que leerlas ahí antes de construir formularios.

## Frontend

- TypeScript estricto en `tsconfig.app.json` (`noUnusedLocals`, `noUnusedParameters`, `verbatimModuleSyntax`, `erasableSyntaxOnly`): usa `import type` para tipos y evita `enum`/`namespace`.
- Los imports locales llevan extensión `.tsx`/`.ts` (`allowImportingTsExtensions`), como en `src/main.tsx`.
- oxlint con `react/rules-of-hooks` como error.

## Reglas de desarrollo

Cada implementación nueva sigue este flujo, sin saltarse pasos:

1. **Rama nueva** antes de tocar código, desde la rama base actual: `git switch -c <tipo>/<descripcion-corta>` (p. ej. `feat/signup-form`). Nunca se trabaja directamente en `main`.
2. **Cerrar la rama con `/commit`**: el commit sigue `tipo(scope): descripción` en una sola línea, sin atribuciones.
3. **Crear el PR con `gh pr create`**: `git push -u origin <rama>` y después `gh pr create` contra la rama base, con título igual al commit y una descripción breve de qué cambia y cómo verificarlo.
4. **Revisión adversarial**: lanzar el subagente `adversarial-reviewer` sobre el PR recién creado. Es de solo lectura y no comenta en GitHub.
5. **En el chat se deja solo la URL del PR**: ni el resumen del cambio ni el informe del revisor. Si el revisor da **BLOCK**, se corrige antes en la misma rama (nuevo `/commit` y push) y se vuelve a revisar.
