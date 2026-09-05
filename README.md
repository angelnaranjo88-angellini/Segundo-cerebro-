# Segundo Cerebro

Wiki personal mantenido por un LLM, construido sobre el patrón
[LLM Wiki de Andrej Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f),
y usado desde **Obsidian**.

La idea del patrón: en vez de re-descubrir el conocimiento en cada consulta (como hace un RAG
clásico sobre documentos crudos), el LLM **construye y mantiene un wiki persistente** de markdown
interconectado. Tú curas y diriges; el LLM resume, cruza referencias, archiva y lleva la
contabilidad — que es justo la parte que hace que los humanos abandonen sus wikis.

## Cómo abrirlo

1. Obsidian → *Open folder as vault* → elegir esta carpeta.
2. Plugins recomendados: **Dataview** (consultas sobre el frontmatter) y **Obsidian Web Clipper**
   (para meter artículos a `fuentes-crudas/`).
3. La *graph view* muestra la topología: los nodos con más aristas son tus patrones reales.

## Por dónde empezar

- **[[index]]** — catálogo completo de páginas.
- **[[Correlacion-de-Proyectos]]** — qué comparten de verdad tus proyectos actuales.
- **[[Patrones-Reutilizables]]** — lo que ya construiste dos veces y conviene estandarizar.
- **[[Riesgos-y-Deuda-Tecnica]]** — dónde se está yendo el dinero y dónde fallan las cosas.
- **[[log]]** — bitácora de cómo creció este wiki.
- **[[CLAUDE]]** — el esquema: reglas, estructura y convenciones. Léelo antes de escribir.

## Cómo trabajar con él

| Quiero… | Digo… |
|---|---|
| Meter una fuente nueva | «Ingesta esto: <archivo o enlace>» |
| Preguntar | «¿Qué comparten Lefranm y CUT en el manejo de citas?» |
| Revisar salud | «Corre un lint del wiki» |
| Archivar una respuesta | «Guarda esa respuesta como página de síntesis» |

## Estructura

```
CLAUDE.md          El esquema. Reglas del juego.
index.md           Catálogo por categoría.
log.md             Bitácora cronológica.
wiki/              Lo que el LLM escribe.
fuentes-crudas/    Lo que tú aportas. El LLM no lo toca.
plantillas/        Plantillas de página para Obsidian.
```
