## PARTE A
1. **Qué archivos propone tocar**, contados.
- Con harness
```
 - New: frontend/components.json, src/lib/{api,utils}.ts, src/components/ui/* (shadcn), src/auth/{AuthContext.tsx,useAuth.ts,RequireAuth.tsx}, src/pages/{LoginPage,SignupPage,ProfilePage}.tsx.
 - Changed: vite.config.ts, tsconfig.json, tsconfig.app.json, src/main.tsx, src/App.tsx, src/index.css, package.json/lock.
 - Deleted: src/App.css, src/assets/*.
 - Backend: not touched.
 ```
- Sin harness
```
 - Nuevos:
   - src/lib/api.ts, src/lib/errors.ts, src/lib/utils.ts (shadcn)
   - src/auth/AuthContext.tsx
   - src/pages/{Login,Signup,Profile}Page.tsx
   - src/components/ui/* (shadcn)
   - components.json
 - Modificados:
   - vite.config.ts, tsconfig.json, tsconfig.app.json
   - src/index.css, src/App.tsx, src/main.tsx
   - index.html, package.json
 - Borrados: src/App.css y los assets que no se usen.
```

2. **Qué convenciones del proyecto respetó y cuáles no**, nombrándolas una a una. Si en un lado no había ninguna escrita en ninguna parte, esa es la respuesta y vale.
- Con harness
```
- UI text in Spanish.
```
- Sin harness

3. **Cuántas veces tuviste que intervenir**: corregir, aclarar, repetir el encargo o pararlo en seco.
- Con harness
Ninguna. Realizo el plan sin preguntas
- Sin harness
Ninguna. Realizo el plan sin preguntas

4. **Qué te tocaría arreglar a mano** antes de enseñarle eso a alguien de tu equipo.
- Con harness
```
El agente propone algunas assumptions/open questions a aclarar. Esto tendria que indicarselo

  - Sign-up doesn't ask for a name (the ticket says email + password); fullName: null is sent.
 - Token kept in localStorage (simple; XSS risk accepted for this exercise).
 - Logout and the session-required redirect go beyond the ticket, but they cost little and complete the flow.
 - UI text in Spanish.
 - Native fetch instead of Tuyau (backend/registry), to avoid a cross-package dependency. It could be migrated later.
```
- Sin harness
```
No me indica ninguna pregunta
```

## PARTE B
1. **Hasta qué pieza llegaste, y cuál te costó más de lo que esperabas.** El número de la lista, y en qué se te fue el rato de verdad.

Me dio tiempo a realizar todos los pasos.

El paso que mas me costo fue la de iniciar harness porque me encontre con un error de Safeguard en Opus. Fue un false-positive pero me hizo reiniciar todo

2. **La primera diferencia que viste entre las dos salidas, y en qué te fijaste para verla.** Ojo, no cuál fue mejor: **qué** salió distinto, concretamente, y dónde estabas mirando cuando lo notaste. Si tuviste que abrir un archivo para verlo, dilo.

La que no tenia harness estaba mas esquematizada que con harness (mas verbose). Realmente, ambas me parecen igual de validas. Ambas realsaban los huecos del ticket y proponian solucion. 

Quizas en el orden de los pasos y el anuncio de inclusion de dependencias hizo que la de harness destacara algo mas

3. **Algo que dejaste escrito en el harness y que el agente no cumplió igualmente.** El matiz es todo: no es lo que hizo mal la copia pelada. Es lo que tú habías dejado negro sobre blanco en el lado bueno y aun así no pasó.

No sabria decir, en principio se cumplio todo