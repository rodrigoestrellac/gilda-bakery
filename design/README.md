# Gilda Bakery — Design System

**Handoff para Claude Code · v1.0 · Mayo 2026**

Este paquete contiene el sistema de diseño completo de **Gilda Bakery**, listo para usar en el desarrollo de la app. La app es una calculadora de costos por receta e ingreso por hora para una cocinera/panadera, y debe funcionar tanto en celular como en PC (100% responsive).

---

## 📦 ¿Qué hay en este paquete?

| Archivo | Para qué sirve |
|---|---|
| `tokens.css` | Variables CSS (custom properties) con todos los tokens del DS: paleta, roles M3, tipografía, shape, elevation, motion y spacing. **Importar primero.** |
| `components.css` | Clases `.md-*` con los estilos de todos los componentes (botones, chips, cards, text fields, navigation, dialogs, etc.). |
| `Sistema de Diseño.html` | Documentación visual interactiva. Abrila en el browser para ver cada componente en uso. **Es referencia visual, no código de producción.** |
| `README.md` | Este archivo. |

> ⚠️ **Importante**: el `Sistema de Diseño.html` es una **referencia visual** del DS — no copies su markup. La tarea es **implementar la app real** usando los tokens y componentes (`.md-*`) en el framework que elijas (React, Vue, Svelte, vanilla JS, etc.).

---

## 🧱 Base del sistema

El DS está construido sobre **Material Design 3** (https://m3.material.io/), conservando:
- Roles semánticos de color (primary, secondary, tertiary, error, surface tiers…)
- Type scale (display / headline / title / body / label)
- Shape scale (none → full)
- Elevation (level 0 → 5)
- State layers (hover / focus / pressed)
- Navigation bar (mobile) + navigation rail (desktop)
- Componentes M3 canónicos (FAB, chips, text fields, segmented buttons…)

…con una **piel artesanal** sobre encima: paleta tierra (terracota, mantequilla, chocolate, salvia), tipografía Pacifico para titulares decorativos, sombras tintadas con chocolate.

---

## 🚀 Quickstart

### 1. Copiá los archivos CSS

```
src/
├── styles/
│   ├── tokens.css        ← copiá del paquete
│   └── components.css    ← copiá del paquete
└── main.{js,jsx,ts,tsx}  ← importá ambos acá
```

### 2. Importalos (tokens primero)

```html
<link rel="stylesheet" href="/styles/tokens.css">
<link rel="stylesheet" href="/styles/components.css">
```

O en JS/TS:
```js
import './styles/tokens.css';
import './styles/components.css';
```

Las fuentes de Google (Pacifico, Lato, Material Symbols Rounded) ya están en el `@import` al principio de `tokens.css`. Si preferís self-host, removelas y agregalas a tu pipeline.

### 3. Usá los componentes

```html
<button class="md-button filled">
  <span class="material-symbols-rounded">add</span>
  Nueva receta
</button>

<span class="md-chip status success">
  <span class="material-symbols-rounded">check_circle</span>
  Disponible
</span>
```

### 4. Usá los tokens en tus propios estilos

**Nunca** uses los hex de marca directamente. Usá los roles M3:

```css
/* ❌ MAL */
.mi-card { background: #C4673A; color: white; }

/* ✅ BIEN */
.mi-card {
  background: var(--md-sys-color-primary);
  color: var(--md-sys-color-on-primary);
}
```

Esto te deja re-temar el sistema en el futuro (dark mode, otra marca) cambiando solo un archivo.

---

## 🎨 Tokens — referencia rápida

### Colores

**Paleta de marca** (no usar directo en componentes):

| Token | Hex | Para qué |
|---|---|---|
| `--brand-terracota` | `#C4673A` | Acento principal cálido |
| `--brand-mantequilla` | `#F5E6C8` | Container del primary |
| `--brand-chocolate` | `#3D2314` | Texto principal, sombras |
| `--brand-fondo` | `#FBF7F0` | Fondo de la app |
| `--brand-salvia` | `#7A9E7E` | Acento verde / éxito |
| `--brand-muted` | `#EDE3D3` | Surface tonal |
| `--brand-muted-fg` | `#8B6B52` | Texto secundario |
| `--brand-destructivo` | `#B83232` | Error / eliminar |
| `--brand-exito` | `#D4EAD6` | Container de éxito |
| `--brand-advertencia` | `#FFF0D4` | Container de warning |

**Roles M3** (usar siempre estos en componentes):

| Rol | Hex | Cuándo |
|---|---|---|
| `--md-sys-color-primary` | `#C4673A` | Acciones primarias, FAB, links |
| `--md-sys-color-on-primary` | `#FFFFFF` | Texto sobre primary |
| `--md-sys-color-primary-container` | `#F5E6C8` | Fondos sutiles del primary |
| `--md-sys-color-on-primary-container` | `#3D2314` | Texto sobre primary-container |
| `--md-sys-color-secondary` | `#7A9E7E` | Acciones secundarias, chips OK |
| `--md-sys-color-secondary-container` | `#D4EAD6` | Container del secondary |
| `--md-sys-color-tertiary` | `#8B6B52` | Acentos neutros cálidos |
| `--md-sys-color-tertiary-container` | `#EDE3D3` | — |
| `--md-sys-color-error` | `#B83232` | Validación, destructivo |
| `--md-sys-color-error-container` | `#F8D7D7` | — |
| `--md-sys-color-success` *(ext)* | `#5C7E60` | Stock OK, ganancia |
| `--md-sys-color-warning` *(ext)* | `#B07A1A` | Stock crítico |
| `--md-sys-color-background` | `#FBF7F0` | Fondo de la app |
| `--md-sys-color-on-background` | `#3D2314` | Texto sobre el fondo |
| `--md-sys-color-surface` | `#FBF7F0` | Igual que background |
| `--md-sys-color-on-surface` | `#3D2314` | Texto sobre surface |
| `--md-sys-color-surface-variant` | `#EDE3D3` | Variante tonal |
| `--md-sys-color-on-surface-variant` | `#8B6B52` | Texto secundario |
| `--md-sys-color-surface-container-lowest` | `#FFFFFF` | Cards más altas |
| `--md-sys-color-surface-container-low` | `#F7F0E2` | Cards default |
| `--md-sys-color-surface-container` | `#F2E8D2` | Container neutral |
| `--md-sys-color-surface-container-high` | `#ECDFC0` | Highlighted blocks |
| `--md-sys-color-surface-container-highest` | `#E5D5AE` | Text field background |
| `--md-sys-color-outline` | `#8B6B52` | Bordes fuertes |
| `--md-sys-color-outline-variant` | `#D5C4A6` | Dividers |
| `--md-sys-color-inverse-surface` | `#2A1A0E` | Snackbars, tooltips |
| `--md-sys-color-inverse-on-surface` | `#FBF7F0` | — |
| `--md-sys-color-scrim` | `rgba(42,26,14,.45)` | Overlay de modales |

### Tipografía

- **Display** → `'Pacifico'` (decorativa, brush). **Solo** para nombres de productos y titulares hero. No usar en headers funcionales.
- **Headline / Title / Body / Label** → `'Lato'` (300, 400, 700, 900).

| Estilo | Tamaño / line-height / peso |
|---|---|
| `display-large` | 57 / 64 · 400 |
| `display-medium` | 45 / 52 · 400 |
| `display-small` | 36 / 44 · 400 |
| `headline-large` | 32 / 40 · 900 |
| `headline-medium` | 28 / 36 · 900 |
| `headline-small` | 24 / 32 · 700 |
| `title-large` | 22 / 28 · 700 |
| `title-medium` | 16 / 24 · 700 |
| `title-small` | 14 / 20 · 700 |
| `body-large` | 16 / 24 · 400 |
| `body-medium` | 14 / 20 · 400 |
| `body-small` | 12 / 16 · 400 |
| `label-large` | 14 / 20 · 700 |
| `label-medium` | 12 / 16 · 700 |
| `label-small` | 11 / 16 · 700 |

Usalas como clase utilitaria: `<h1 class="display-medium">…</h1>` o vía variable: `font-size: var(--md-sys-typescale-headline-large-size)`.

### Shape (border-radius)

| Token | Valor | Para qué |
|---|---|---|
| `--md-sys-shape-corner-none` | 0 | Ninguno |
| `--md-sys-shape-corner-extra-small` | 4px | Text field, snackbar |
| `--md-sys-shape-corner-small` | 8px | Chips |
| `--md-sys-shape-corner-medium` | 12px | **Cards (default)** |
| `--md-sys-shape-corner-large` | 16px | FAB, hero cards |
| `--md-sys-shape-corner-extra-large` | 28px | Dialogs, bottom sheets |
| `--md-sys-shape-corner-full` | 9999px | Botones, pill |

### Elevation

| Token | Cuándo |
|---|---|
| `level0` | Flat |
| `level1` | Cards, chips elevated |
| `level2` | Cards hover |
| `level3` | FAB, snackbar |
| `level4` | Nav drawer |
| `level5` | Modales |

### Spacing

Escala de 4px: `--md-sys-spacing-{1,2,3,4,5,6,8,10,12,16,20,24}` (4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64 / 80 / 96).

**Reglas**: padding de card = 16. Margen lateral de pantalla = 16 mobile / 40 desktop. Gap entre items de lista = 8.

### Motion

Duraciones: `short1` (50ms) → `long2` (500ms).
Easings: `standard`, `emphasized`, y sus variantes accelerate/decelerate.

---

## 🧩 Componentes — referencia rápida

Todos los componentes usan la convención `.md-{nombre}` y modificadores como clases adicionales.

### Buttons (`.md-button`)

```html
<button class="md-button filled">Filled</button>
<button class="md-button tonal">Tonal</button>
<button class="md-button outlined">Outlined</button>
<button class="md-button text">Text</button>
<button class="md-button elevated">Elevated</button>
<button class="md-button destructive">Destructivo</button>

<!-- Tamaños -->
<button class="md-button filled size-sm">Pequeño</button>
<button class="md-button filled size-lg">Grande</button>

<!-- Con ícono -->
<button class="md-button filled">
  <span class="material-symbols-rounded">add</span>
  Nueva receta
</button>
```

### Icon Button & FAB (`.md-icon-button`, `.md-fab`)

```html
<button class="md-icon-button"><span class="material-symbols-rounded">edit</span></button>
<button class="md-icon-button tonal"><span class="material-symbols-rounded">favorite</span></button>

<button class="md-fab"><span class="material-symbols-rounded">add</span></button>
<button class="md-fab primary extended">
  <span class="material-symbols-rounded">add</span>
  Nueva receta
</button>
```

### Chips (`.md-chip`)

```html
<!-- Filter / assist -->
<button class="md-chip">Panadería</button>
<button class="md-chip selected">
  <span class="material-symbols-rounded">check</span>
  Pastelería
</button>

<!-- Input (con cerrar) -->
<span class="md-chip input">
  Sin gluten
  <span class="close"><span class="material-symbols-rounded" style="font-size:14px">close</span></span>
</span>

<!-- Suggestion -->
<button class="md-chip suggestion">
  <span class="material-symbols-rounded">bakery_dining</span>
  Pan de masa madre
</button>

<!-- Status (no interactivo) -->
<span class="md-chip status success">Disponible</span>
<span class="md-chip status warning">Últimas 3</span>
<span class="md-chip status error">Sin stock</span>
<span class="md-chip status info">Novedad</span>
<span class="md-chip status neutral">Más vendido</span>
```

### Text fields (`.md-text-field`)

```html
<div class="md-text-field">
  <input class="md-text-field__input" id="x" placeholder=" ">
  <label class="md-text-field__label" for="x">Nombre de la receta</label>
  <span class="md-text-field__support">Ayuda opcional</span>
</div>

<!-- Outlined -->
<div class="md-text-field outlined">
  <input class="md-text-field__input" id="y" placeholder=" ">
  <label class="md-text-field__label" for="y">Proveedor</label>
</div>

<!-- Con prefijo de moneda -->
<div class="md-text-field with-prefix">
  <span class="md-text-field__prefix">$</span>
  <input class="md-text-field__input" type="number" id="z" placeholder=" ">
  <label class="md-text-field__label" for="z">Precio</label>
</div>

<!-- Estado de error -->
<div class="md-text-field error">…</div>
```

> **Nota para React**: el label flotante usa `:placeholder-shown`. Asegurate de que el `<input>` siempre tenga `placeholder=" "` (un espacio) para que el truco funcione. Alternativamente, agregá clase `has-value` cuando el campo tenga contenido.

### Cards (`.md-card`)

```html
<div class="md-card elevated">
  <div class="md-card__header"><h4 class="title-large">Título</h4></div>
  <div class="md-card__body">Contenido</div>
  <div class="md-card__actions">
    <button class="md-button text">Cancelar</button>
    <button class="md-button filled">Confirmar</button>
  </div>
</div>

<!-- Variantes -->
<div class="md-card filled">…</div>
<div class="md-card outlined">…</div>
```

### List item (`.md-list-item`)

```html
<ul class="md-list">
  <li class="md-list-item">
    <span class="material-symbols-rounded md-list-item__leading">bakery_dining</span>
    <div class="md-list-item__content">
      <div class="md-list-item__headline">Pan de masa madre</div>
      <div class="md-list-item__supporting">Rinde 2 panes · $358 / pan</div>
    </div>
    <span class="material-symbols-rounded md-list-item__trailing">chevron_right</span>
  </li>
  <hr class="md-divider">
  …
</ul>
```

### Top app bar (`.md-top-app-bar`)

```html
<header class="md-top-app-bar">
  <button class="md-icon-button"><span class="material-symbols-rounded">arrow_back</span></button>
  <h1 class="md-top-app-bar__title">Recetas</h1>
  <button class="md-icon-button"><span class="material-symbols-rounded">search</span></button>
</header>

<!-- Variantes -->
<header class="md-top-app-bar medium">…</header>
<header class="md-top-app-bar large">…</header>
<header class="md-top-app-bar center">…</header>
```

### Navigation bar (`.md-nav-bar`) — **mobile, < 1024px**

```html
<nav class="md-nav-bar">
  <button class="md-nav-bar__item active">
    <span class="md-nav-bar__indicator">
      <span class="material-symbols-rounded">restaurant_menu</span>
    </span>
    Recetas
  </button>
  <button class="md-nav-bar__item">…</button>
  …
</nav>
```

### Navigation rail (`.md-nav-rail`) — **desktop, ≥ 1024px**

```html
<nav class="md-nav-rail">
  <button class="md-fab"><span class="material-symbols-rounded">add</span></button>
  <button class="md-nav-rail__item active">
    <span class="md-nav-bar__indicator">
      <span class="material-symbols-rounded">restaurant_menu</span>
    </span>
    Recetas
  </button>
  …
</nav>
```

### Otros

- **Segmented buttons** (`.md-segmented`): filtros, switches de vista (lista/grid).
- **Switch** (`.md-switch`), **Checkbox** (`.md-checkbox`): formularios y settings.
- **Progress** (`.md-progress`): barras de stock; modificadores `.success / .warning / .error`.
- **Snackbar** (`.md-snackbar`): feedback transitorio post-acción.
- **Dialog** (`.md-dialog`): confirmaciones destructivas, edición compleja.
- **Badge** (`.md-badge`): contadores sobre íconos.

Todos están en el `Sistema de Diseño.html` con ejemplos visuales.

---

## 📐 Responsive — reglas del sistema

La app debe funcionar en **mobile (≥ 360px) y desktop (≥ 1024px)** sin grandes diferencias funcionales.

### Breakpoints

| Breakpoint | Cambia |
|---|---|
| **< 600px** | 1 columna. Cards full-width. Navigation bar abajo. |
| **600 – 1023px** | 2 columnas para grids de cards. Navigation bar abajo. |
| **≥ 1024px** | Navigation rail a la izquierda (80px). Contenido en 2-3 columnas. Padding lateral 40px. |

### Patrones clave

- **Cards crecen, no se duplican.** En desktop, una grid de 3 cards. En mobile, una columna.
- **Top app bar** se mantiene en mobile y desktop, pero en desktop puede integrarse al header de contenido.
- **FAB** en mobile flota; en desktop entra al header como botón filled normal (o como FAB anclado al rail).
- **Modales / dialogs** se vuelven bottom sheets en mobile (< 600px) si lo necesitás.

---

## 🖼️ Iconografía

**Material Symbols Rounded** (variable font, ya cargada en `tokens.css`).

```html
<span class="material-symbols-rounded">restaurant_menu</span>
<span class="material-symbols-rounded filled">favorite</span>   <!-- weight 500, FILL 1 -->
```

Catálogo: https://fonts.google.com/icons

**Reglas**:
- Pesos: 400 (default) y 500 (active / selected).
- Filled (`.filled`) solo cuando el ítem está activo o seleccionado.
- Tamaño por defecto 24px; en chips 18px; en empty states 64px.

**Íconos recomendados para la app**:
- `restaurant_menu` — recetas
- `bakery_dining` — pan
- `cake` — pastelería
- `inventory_2` — insumos
- `scale` — pesar / cantidad
- `payments` — costos / ventas
- `schedule` — tiempo / horas
- `trending_up` — ganancias
- `settings`, `add`, `edit`, `delete`, `search`, `filter_list`, `check_circle`, `warning`

---

## 🏗️ Arquitectura sugerida de la app

Basado en el alcance funcional definido:
> "Calcular los costos de cada producto en base a las recetas y a los insumos comprados. Cargar las horas dedicadas al mes y la cantidad de productos cocinados al mes para tener un aproximado del ingreso por hora."

### Vistas principales

1. **Recetas** — lista + detalle + crear/editar
2. **Insumos** — lista de ingredientes con su costo unitario; crear/editar
3. **Ganancias** — vista mensual con horas trabajadas + productos cocinados + ingreso por hora
4. **Ajustes** — config general (gas, mano de obra deseada, etc.)

### Modelo de datos

```ts
type Insumo = {
  id: string;
  nombre: string;
  categoria?: string;        // "harinas" | "lácteos" | ...
  costoCompra: number;       // $ pagado
  cantidad: number;          // cuánto compró
  unidad: 'kg'|'g'|'l'|'ml'|'u';
  proveedor?: string;
  ultimoIngreso?: string;    // ISO date
};

type Receta = {
  id: string;
  nombre: string;
  categoria: 'panaderia'|'pasteleria'|'viennoiserie'|'bebidas';
  rinde: number;             // cantidad que da una tanda
  unidadRinde: string;       // "pan", "unid", "porc", etc.
  tandas: number;            // tandas necesarias
  horasProceso: number;      // tiempo de elaboración
  precioVenta: number;       // $ por unidad
  ingredientes: Array<{
    insumoId: string;
    cantidad: number;
    unidad: 'kg'|'g'|'l'|'ml'|'u';
  }>;
};

type RegistroMes = {
  mes: string;               // "2026-05"
  horasTrabajadas: number;
  productosCocinados: Array<{ recetaId: string; cantidad: number }>;
};
```

### Cálculo de costo por receta

```ts
function costoPorBase(ins: Insumo): number {
  // $ por unidad base (g, ml, o unidad)
  const total = ins.cantidad * factorAUnidadBase(ins.unidad);
  return total > 0 ? ins.costoCompra / total : 0;
}

function costoReceta(r: Receta, insumos: Insumo[]): number {
  return r.ingredientes.reduce((sum, ing) => {
    const ins = insumos.find(i => i.id === ing.insumoId);
    if (!ins) return sum;
    return sum + ing.cantidad * factorAUnidadBase(ing.unidad) * costoPorBase(ins);
  }, 0);
}
```

### Ingreso por hora

```ts
function ingresoPorHora(mes: RegistroMes, recetas: Receta[]): number {
  const ingresos = mes.productosCocinados.reduce((sum, p) => {
    const r = recetas.find(x => x.id === p.recetaId);
    return r ? sum + r.precioVenta * p.cantidad : sum;
  }, 0);
  return mes.horasTrabajadas > 0 ? ingresos / mes.horasTrabajadas : 0;
}
```

---

## ✅ Checklist para empezar

- [ ] Copiar `tokens.css` y `components.css` al proyecto, importarlos en orden.
- [ ] Abrir `Sistema de Diseño.html` en el browser como referencia visual permanente.
- [ ] Definir modelo de datos (`Insumo`, `Receta`, `RegistroMes`) y almacenamiento (localStorage / IndexedDB / backend).
- [ ] Implementar navigation bar (mobile) + navigation rail (desktop) con las 4 vistas.
- [ ] Vista **Recetas**: lista con `md-list-item` + chip de ingreso/hora, FAB para nueva.
- [ ] Vista **Insumos**: cards de stock con `md-card outlined` y `md-progress` semántico.
- [ ] Vista **Ganancias**: hero result + breakdown del mes en `md-card filled`.
- [ ] Form de receta/insumo con `md-text-field` (filled + with-prefix `$` para precios).
- [ ] Dialog destructivo para eliminar (`md-dialog` + `md-button destructive`).
- [ ] Snackbar para feedback de "Guardado", "Eliminado", etc.

---

## 🎨 Convenciones que el DS asume

1. **Pacifico solo para display + nombres de productos.** Nunca en cuerpo o UI.
2. **Roles M3 por sobre brand hex.** Si necesitás un color que no está, definí un rol nuevo, no agregues un hex suelto.
3. **Sombras siempre tintadas con chocolate.** Las variables ya lo hacen.
4. **Números tabulares** en costos/cantidades (`font-variant-numeric: tabular-nums`) — los componentes `stat__value` ya lo aplican.
5. **Mobile-first.** Escribí estilos mobile y agregá `@media (min-width: …)` para desktop.

---

## 📞 Soporte

Si necesitás extender el sistema (dark mode, nuevos componentes, nuevos roles semánticos), seguí la convención M3: agregá la variable en `tokens.css` con el prefijo `--md-sys-color-*` o `--md-sys-typescale-*` y usá esa variable en el componente.

Cualquier ajuste sobre tokens es **un cambio de un solo archivo**.

---

**Hecho con ❤️ para Gilda.**
