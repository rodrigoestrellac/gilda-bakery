-- Gilda Bakery · Esquema de base
-- Fuente de verdad: ARCHITECTURE.md §5
-- Ejecutar una vez en el SQL Editor de Supabase, en el proyecto recién creado.

create table kv (
  clave       text primary key,
  valor       jsonb not null,
  actualizado timestamptz default now()
);

alter table kv enable row level security;

-- Espacio único compartido: cualquier usuario autenticado accede a todo.
create policy "auth lee"     on kv for select using (auth.role() = 'authenticated');
create policy "auth escribe" on kv for insert with check (auth.role() = 'authenticated');
create policy "auth edita"   on kv for update using (auth.role() = 'authenticated');
