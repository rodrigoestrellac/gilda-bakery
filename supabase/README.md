# Supabase — Setup (Fase 1)

Procedimiento para crear y validar el proyecto Supabase que respalda la app. Spec técnica completa en `../ARCHITECTURE.md` (§5 modelo de datos, §8 deploy, §9 seguridad). Estado del trabajo en `../HANDOFF.md`.

## 1. Crear el proyecto

En [supabase.com](https://supabase.com) → **New Project**:

- Nombre: el que se decida (registrar en HANDOFF → Pendientes).
- Plan: **Free**.
- Región: la free más cercana a Argentina (típicamente `sa-east-1` / São Paulo).
- Password de la base: fuerte, guardar en gestor de contraseñas.

## 2. Crear la tabla y las policies

SQL Editor → **New query** → pegar el contenido de [`schema.sql`](./schema.sql) → **Run**.

Confirmá que aparezca la tabla `kv` en Table Editor y que el ícono de RLS esté activado.

## 3. Crear el usuario compartido

Authentication → Users → **Add user** → "Create new user":

- Email y contraseña que vayan a compartir las tres personas. **No** versionar estas credenciales en el repo.
- Marcar **Auto Confirm User** (evita el paso de verificación de email).

## 4. Obtener URL y publishable key

Settings → **API Keys**:

- **Project URL** → ej. `https://abcd1234.supabase.co`
- **Publishable key** → empieza con `sb_publishable_...`

> Supabase reemplazó el modelo viejo (`anon` JWT + `service_role`) por el nuevo (`sb_publishable_*` + `sb_secret_*`). Las legacy siguen vivas hasta fines de 2026 en una pestaña aparte ("Legacy API keys"), pero **usamos las nuevas** para no migrar después. La publishable key es pública por diseño (queda en el HTML en Fase 2) y respeta RLS igual que la `anon`. La `sb_secret_*` ignora RLS — **nunca sale de la consola**.

## 5. Smoke test (RLS funciona)

Reemplazar variables y correr en PowerShell:

```powershell
$URL = "https://<ref>.supabase.co"
$PUB = "sb_publishable_..."

# 1) Lectura anónima → debe devolver [] (RLS bloquea).
curl.exe "$URL/rest/v1/kv?select=*" -H "apikey: $PUB"

# 2) Login con el usuario compartido → devuelve un access_token JWT.
#    (Usamos Invoke-RestMethod porque curl.exe -d "..." mangle las comillas dobles del JSON en PowerShell.)
$body = @{email="<email>"; password="<pass>"} | ConvertTo-Json -Compress
$JWT = (Invoke-RestMethod -Method POST -Uri "$URL/auth/v1/token?grant_type=password" `
  -Headers @{apikey=$PUB; "Content-Type"="application/json"} -Body $body).access_token

# 3) Lectura autenticada → debe devolver [] sin error.
curl.exe "$URL/rest/v1/kv?select=*" -H "apikey: $PUB" -H "Authorization: Bearer $JWT"

# 4) (Opcional pero recomendado) Confirmar RLS con un INSERT:
#    4a) anon → debe dar HTTP 401.
$row = '{"clave":"__smoke_test__","valor":{"ok":true}}'
curl.exe -X POST "$URL/rest/v1/kv" -H "apikey: $PUB" -H "Content-Type: application/json" --data-binary $row
#    4b) auth → debe dar HTTP 201 con la fila.
curl.exe -X POST "$URL/rest/v1/kv" -H "apikey: $PUB" -H "Authorization: Bearer $JWT" `
  -H "Content-Type: application/json" -H "Prefer: return=representation" --data-binary $row
#    Limpieza (en el SQL Editor de Supabase, como owner): delete from kv where clave = '__smoke_test__';
```

**Criterio de éxito:** (1) bloqueada (`[]` o error de autorización), (3) responde `[]` sin error 401/403. Si (1) devuelve datos, las policies están mal configuradas.

## 6. Entregar a Fase 2

La Fase 2 necesita:

- URL del proyecto (paso 4).
- Publishable key `sb_publishable_...` (paso 4).
- Email + contraseña del usuario compartido (paso 3) — para sembrar la pantalla de login durante el desarrollo.

La integración con `mi-reposteria.html` (SDK por CDN, reemplazo de `cargar`/`guardar`, login, siembra de `SEED_INSUMOS`) ocurre en esa fase.
