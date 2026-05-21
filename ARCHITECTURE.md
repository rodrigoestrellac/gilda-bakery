# ARCHITECTURE — Gilda Bakery

> **Referencia técnica estable.** El *qué* y el *cómo* del sistema. Cambia poco; todo cambio se registra en `HANDOFF.md` → Decisiones. Estado del trabajo y fases: ver `HANDOFF.md`.

## 1. Qué es

App web de una sola página (**Gilda Bakery**) que calcula el costo de producción de productos de repostería y la ganancia por hora. Frontend vanilla JS sin build (`index.html`). Funciones: insumos con rinde (costo por g/ml/u), recetas con parser de texto pegado (costo por unidad, ganancia total, ganancia por hora, simulador inverso de precio), ajustes (gas del horno como proxy, pago por hora deseado).

## 2. Objetivo

Acceso desde internet (celular y PC) para tres personas que **comparten un mismo login y los mismos datos** (suegra, novia, cuñada). Recetas e insumos persisten entre sesiones. **Cero costo, sin servidor propio que mantener, aislado de la infra de Rodriguin/Fulbito.** Proyecto chico: no se diseña para escalar a otras bakeries.

## 3. Arquitectura

```
[ navegador ] ──HTTPS──> [ GitHub Pages: index.html estático ]
                                │  SDK de Supabase (publishable key, pública)
                                ▼
                         [ Supabase ]
                           ├─ Auth (un usuario compartido)
                           ├─ Postgres (tabla kv)
                           └─ RLS (reglas de acceso)
                                ▲
        [ GitHub Actions cron ] ─┘  ping ~2x/semana (anti-pausa)
```

- **Sin backend propio.** El frontend habla directo con Supabase vía su SDK. Supabase aporta auth, base y API automática.
- **Always-on efectivo.** El free tier de Supabase pausa proyectos tras 7 días de inactividad; un cron de GitHub Actions que pinguea la base un par de veces por semana lo mantiene despierto, gratis.
- **Es Postgres** (familiar para Rodrigo), no NoSQL.

## 4. Stack

| Pieza | Elección | Nota |
|---|---|---|
| Frontend | HTML estático en GitHub Pages | el `index.html` actual, ya migrado |
| Backend | ninguno propio | Supabase (BaaS) |
| DB | Postgres (Supabase) | tabla key-value |
| Auth | Supabase Auth, email+contraseña | **un único usuario compartido** |
| Acceso | Row Level Security (RLS) | autenticados leen/escriben todo |
| SDK | `@supabase/supabase-js@2` por CDN (esm.sh) | sin build, encaja con vanilla JS; usa la **publishable key** (`sb_publishable_*`, modelo nuevo) |
| Anti-pausa | GitHub Actions cron | ping a la REST API de Supabase |

## 5. Modelo de datos

El frontend ya habla key-value con claves `insumos`, `recetas`, `config`. Mapea a una tabla:

```sql
create table kv (
  clave       text primary key,
  valor       jsonb not null,
  actualizado timestamptz default now()
);
alter table kv enable row level security;

-- Espacio único compartido: cualquier usuario autenticado accede a todo.
create policy "auth lee"    on kv for select using (auth.role() = 'authenticated');
create policy "auth escribe" on kv for insert with check (auth.role() = 'authenticated');
create policy "auth edita"  on kv for update using (auth.role() = 'authenticated');
```

Una fila por clave. No se separa por usuario: las tres comparten el mismo espacio a propósito.

## 6. Contrato del frontend

La capa key-value ya está aislada — `cargar(clave, def)` / `guardar(clave, val)`. La migración reemplaza solo esa capa por llamadas al SDK:

- `cargar(k)` → `supabase.from('kv').select('valor').eq('clave', k).maybeSingle()`
- `guardar(k, v)` → `supabase.from('kv').upsert({ clave: k, valor: v, actualizado: new Date() })`

El SDK persiste la sesión en `localStorage` solo: la usuaria se loguea una vez por dispositivo y queda dentro. El resto (cálculos, parser, UI) no se toca.

Agrega: pantalla de login (email + contraseña compartidos), y siembra de los 9 insumos (`SEED_INSUMOS`) cuando la tabla viene vacía la primera vez.

## 7. Diseño / UI

El frontend sigue el **design system armado en Claude Design**. *(Pendiente de incorporar al `index.html`: requiere el archivo exportado — ver HANDOFF → Pendientes.)* Estos docs no describen la UI; la fuente de verdad del diseño es ese sistema.

## 8. Deploy

1. **Supabase:** crear proyecto (región más cercana disponible en free), correr el SQL de §5, crear el usuario compartido en Auth, copiar URL del proyecto + **publishable key** (`sb_publishable_*`, en Settings → API Keys).
2. **Frontend:** poner URL + publishable key en `index.html`, push del repo, activar GitHub Pages.
3. **Anti-pausa:** workflow de GitHub Actions (cron, ~cada 3 días) que hace un `GET` trivial a la REST API de Supabase con la publishable key.

## 9. Seguridad

- **En el frontend va SOLO la publishable key** (`sb_publishable_*`, pública por diseño). **NUNCA la `sb_secret_*`** — esa bypassa RLS y sería el equivalente a dejar la base abierta. *(El modelo legacy era `anon` + `service_role`; Supabase los deprecó en 2025 y elimina fines de 2026. Usamos las nuevas desde el arranque.)*
- **RLS activado siempre.** Sin RLS, la publishable key da acceso total. Las policies de §5 son la barrera real — la regla `auth.role() = 'authenticated'` sigue válida con el nuevo modelo de keys.
- Login compartido: aceptable porque el dato no es sensible (recetas) y son tres personas de confianza. La barrera de login evita que un random que tropiece con la URL toque los datos.
- El email/contraseña compartido lo crea Rodrigo directamente en Supabase; no se hardcodea en el repo.
- HTTPS lo dan GitHub Pages y Supabase de fábrica.

## 10. Límites conocidos del free tier

- **Pausa a los 7 días de inactividad** → resuelto con el cron anti-pausa (§3, §8).
- **Sin backups automáticos** (son del plan Pro) → mitigar con un botón de exportar/importar JSON en la app, como respaldo manual (ver HANDOFF → post-MVP).
