# HANDOFF — Gilda Bakery

> Doc vivo de coordinación entre Rodrigo y los agentes. Estado del trabajo, no spec técnica (esa está en `ARCHITECTURE.md`). Crece con el proyecto: mantenerlo corto.

## ▶ Próximo paso
**Fase 2 — Frontend → Supabase.** Agregar el SDK por CDN a `mi-reposteria.html`, pantalla de login (email+password contra Auth de Supabase), reemplazar `cargar`/`guardar` por llamadas al SDK (`from('kv').select`/`upsert`), y sembrar `SEED_INSUMOS` cuando `kv` está vacía. URL y publishable key disponibles en el proyecto Supabase (Settings → API Keys); van hardcoded en el HTML (anon-equivalente, pública por diseño).

## Estado
Fase **1 cerrada** ✅ — proyecto Supabase creado, `kv` con RLS funcionando, usuario compartido en Auth, smoke test verde (incluye INSERT anon HTTP 401 + INSERT auth HTTP 201). Fase **3 hecha** ✅ — `mi-reposteria.html` migrado al design system (`design/tokens.css` + `design/components.css`) manteniendo localStorage; sin errores de consola; screenshots en `screenshots/`. Pendientes: **2** frontend → Supabase · **4** deploy GitHub Pages · **5** cron anti-pausa · **6** export/import.

## Decisiones tomadas
- **Supabase (BaaS) en vez de backend propio.** Supersede el plan anterior de FastAPI + Cloud Run + Mongo: menos código, sin servidor que mantener, sin cold start (con anti-pausa). *(2026-05-21)*
- **Postgres de Supabase**, no Mongo: encaja con el stack que Rodrigo ya conoce. *(2026-05-21)*
- **Frontend estático en GitHub Pages.** *(2026-05-21)*
- **Un único usuario compartido**, no multiusuario: las tres personas comparten login y datos. Mata toda la complejidad de registro/PIN/JWT. *(2026-05-21)*
- **Anti-pausa con cron de GitHub Actions** (free tier pausa a los 7 días de inactividad). *(2026-05-21)*
- **Restricciones fijas:** cero costo, aislado de Rodriguin/Fulbito, proyecto chico (no escalar a otras bakeries). *(2026-05-21)*
- **Design system armado en Claude Design**, archivos en `design/` y ya aplicado al frontend. *(aplicado 2026-05-21)*
- **Publishable keys (`sb_publishable_*`), no `anon` legacy.** Supabase deprecó el modelo viejo en 2025 y lo elimina a fines de 2026; proyecto nuevo arranca con el modelo nuevo desde el día 0. La RLS con `auth.role() = 'authenticated'` no cambia. *(2026-05-21)*
- **Fase 3 aplicada con localStorage**: al migrar a Supabase (Fase 2) sólo se reemplaza la capa `cargar`/`guardar`. *(2026-05-21)*

## Pendientes de Rodrigo
- [x] ~~Pasar el design system de Claude Design~~ — archivos en `design/`, Fase 3 aplicada al HTML.
- [x] ~~Crear proyecto Supabase + ejecutar `schema.sql` + usuario compartido en Auth~~ — hecho.
- [x] ~~Pasarme URL + publishable key + credenciales~~ — smoke test verde 2026-05-21.
- [ ] Limpiar la fila de prueba que dejó el smoke test: en SQL Editor → `delete from kv where clave = '__smoke_test__';`
- [ ] Nombre del repo de GitHub (para Fase 4 deploy).

## Para revisar antes de producción (NO ahora)
Concurrencia (dos personas editando a la vez con login compartido → last-write-wins; bajo riesgo) · sin backups en free → export/import JSON como respaldo · versionado del esquema de estado.

## Bitácora
> Nueva entrada arriba: fecha · agente · qué se hizo · dónde retomar.

- **2026-05-21 · Claude Code (smoke test):** Rodrigo creó proyecto Supabase, ejecutó `schema.sql` y creó usuario compartido. Smoke test corrido entero y verde: GET anon `[]` HTTP 200; login OK; GET auth `[]` HTTP 200; **INSERT anon HTTP 401** (RLS bloquea como esperado); INSERT auth HTTP 201; GET anon tras insert sigue `[]` (RLS oculta filas); GET auth ve la fila. Quedó fila de prueba `__smoke_test__` para limpiar manualmente en SQL Editor. También: actualizado `supabase/README.md` §5 con la sintaxis PowerShell correcta (curl.exe + Invoke-RestMethod para el POST, porque `curl.exe -d "..."` mangle las dobles en JSON). Retomar en Fase 2.
- **2026-05-21 · Claude Code:** Fase 1 — creados `supabase/schema.sql` (DDL de §5 ejecutable) y `supabase/README.md` (procedimiento + smoke test). Fase 3 — `mi-reposteria.html` migrado al design system (`design/tokens.css` + `design/components.css`), preservando 1:1 la lógica JS y la capa `cargar`/`guardar` con localStorage; validado en Chrome vía MCP, sin errores de consola; screenshots en `screenshots/01..07-*.png`. Verificado contra docs de Supabase que `anon` es legacy (deprecado, removido fines 2026) → actualizada la terminología a publishable keys (`sb_publishable_*`) en `supabase/README.md`, `ARCHITECTURE.md` (§3, §4, §8, §9) y en este doc (Decisiones).
- **2026-05-21 · Claude (chat):** se descartó el plan FastAPI+Cloud Run+Mongo y se rediseñó sobre Supabase + GitHub Pages tras acotar el alcance (un login compartido, tres personas, cero costo). Reescritos `ARCHITECTURE.md` y este doc. Verificado: free tier de Supabase pausa a los 7 días → se resuelve con cron. Retomar en Fase 1.

## Cómo actualizar
Al cerrar sesión: sumá una línea a Bitácora y reescribí "Próximo paso". Decisión de arquitectura nueva → una línea en Decisiones (y editá `ARCHITECTURE.md` si cambia la spec). Algo se da por hecho solo si está probado y commiteado.
