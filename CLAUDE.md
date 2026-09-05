# Esquema del Segundo Cerebro

Este repositorio es un **wiki personal mantenido por un LLM**, siguiendo el patrón
*LLM Wiki* de Andrej Karpathy ([[LLM-Wiki-Karpathy]]). Se abre como **vault de Obsidian**.

Dueño: Luis Angel Sanchez Naranjo (`angelnaranjo88@aragon.unam.mx`).
Dominio: automatizaciones con IA para negocios (Make, WhatsApp Business Cloud, Airtable,
Google Workspace, Meta Ads) más los sitios y landings que las acompañan.

---

## 1. Las tres capas

| Capa | Carpeta | Quién escribe |
|---|---|---|
| **Fuentes crudas** | `fuentes-crudas/` | Solo el humano. El LLM **lee pero nunca modifica**. |
| **El wiki** | `wiki/` | Solo el LLM. Resúmenes, entidades, conceptos, síntesis. |
| **El esquema** | `CLAUDE.md` (este archivo) | Los dos, en colaboración. |

Fuera de esas capas viven `index.md` (catálogo), `log.md` (bitácora) y `plantillas/`.

## 2. Estructura del wiki

```
wiki/
├── proyectos/          Un archivo por proyecto vivo o archivado
├── clientes/           Un archivo por cliente / marca / entidad
├── automatizaciones/   Un archivo por escenario de Make (u otra automatización)
├── conceptos/          Patrones y piezas reutilizables, agnósticos del cliente
├── sintesis/           Páginas que CORRELACIONAN varias fuentes. El valor real.
└── fuentes/            Resumen de cada fuente cruda ingerida
```

## 3. Convenciones de página

- **Nombre de archivo**: `Kebab-Case-Descriptivo.md`, sin acentos ni signos (para que los
  enlaces `[[...]]` no se rompan entre sistemas de archivos). El acento vive en el `titulo`
  del frontmatter y en el `# H1`.
- **Frontmatter obligatorio** en toda página del wiki:

```yaml
---
titulo: Nombre legible con acentos
tipo: proyecto | cliente | automatizacion | concepto | sintesis | fuente
estado: activo | pausado | archivado | prototipo | idea
clientes: [Nombre-Cliente]
tags: [make, whatsapp, airtable]
actualizado: 2026-09-05
---
```

  `tipo`, `estado` y `actualizado` son obligatorios; el resto según aplique. El frontmatter
  existe para que **Dataview** pueda consultarlo: no inventes campos nuevos sin añadirlos aquí.
- **Enlaces**: siempre `[[Nombre-Del-Archivo]]`. Cada página nueva debe quedar enlazada desde
  al menos otra; si no, es una página huérfana y el lint la marca.
- **Secciones sugeridas** por tipo: ver `plantillas/`.
- **Datos duros con fecha**: cuando cites métricas (ejecuciones, errores, créditos), anota la
  fecha de corte. Los números envejecen; el texto sin fecha miente.
- **Incertidumbre explícita**: si algo es inferencia y no dato verificado, escríbelo como
  `> [!warning] Inferencia sin verificar`. Nunca presentes una suposición como hecho.

## 4. Operaciones

### Ingesta
1. El humano deja un archivo en `fuentes-crudas/` (o señala una fuente externa: un escenario
   de Make, un repo, una hoja de Drive).
2. El LLM la lee, la comenta con el humano y escribe `wiki/fuentes/<Fuente>.md`.
3. Actualiza las páginas de entidad, proyecto y concepto que toque (una fuente típica
   mueve entre 5 y 15 páginas).
4. Añade la fila en `index.md` y la entrada en `log.md`.

### Consulta
Preguntar contra el wiki, no contra las fuentes. Las respuestas se dan **con citas a páginas**
(`[[Pagina#Sección]]`). Si una respuesta resultó valiosa, se archiva como página nueva en
`wiki/sintesis/`.

### Lint
Revisión periódica de salud. Comprobar:
- Contradicciones entre páginas (mismo dato, dos valores).
- Páginas obsoletas (`actualizado` con más de 60 días en un proyecto `activo`).
- Páginas huérfanas (sin enlaces entrantes).
- Enlaces rotos (`[[...]]` que no apunta a ningún archivo).
- Escenarios de Make activos sin página propia en `wiki/automatizaciones/`.
- Métricas sin fecha de corte.

Comando sugerido para huérfanos y enlaces rotos:
```bash
grep -rhoE '\[\[[^]|#]+' wiki | sed 's/\[\[//' | sort -u   # destinos enlazados
find wiki -name '*.md' -exec basename {} .md \; | sort -u  # páginas existentes
```

## 5. Bitácora e índice

- `index.md` — catálogo por categoría. Cada entrada: enlace + una línea + estado. Se actualiza
  en **toda** ingesta.
- `log.md` — append-only, orden cronológico inverso (lo más nuevo arriba). Prefijos fijos para
  que sea parseable:
  `## [YYYY-MM-DD] ingesta | Título`, `## [YYYY-MM-DD] sintesis | Título`,
  `## [YYYY-MM-DD] lint | Título`, `## [YYYY-MM-DD] decision | Título`.

## 6. Reglas para el LLM

1. **Nunca edites `fuentes-crudas/`.** Es la memoria inmutable.
2. **No borres páginas del wiki**: márcalas `estado: archivado` y explica por qué.
3. **Correlaciona siempre.** Al escribir sobre un proyecto, pregunta qué otro proyecto comparte
   patrón, cliente, stack o riesgo — y enlázalo. El wiki vale por sus aristas, no por sus nodos.
4. **Señala contradicciones** en vez de resolverlas en silencio. Bloque `> [!warning]`.
5. **Sin secretos.** Tokens, API keys, contraseñas y datos personales de clientes finales
   (teléfonos, correos, nombres de pacientes/prospectos) **no entran al repo**. Referencia
   dónde viven, no su valor. Los teléfonos públicos de negocio sí pueden estar.
6. **Cierra el ciclo**: toda sesión de trabajo termina con `index.md` y `log.md` al día.
