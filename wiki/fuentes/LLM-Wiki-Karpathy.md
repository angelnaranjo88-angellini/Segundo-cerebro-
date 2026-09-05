---
titulo: LLM Wiki (Andrej Karpathy)
tipo: fuente
estado: activo
origen: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
fecha_ingesta: 2026-09-05
tags: [metodo, pkm, obsidian, fundacional]
actualizado: 2026-09-05
---

# LLM Wiki (Andrej Karpathy)

> La fuente fundacional de este repositorio. Un gist que describe un patrón para construir
> bases de conocimiento personales mantenidas por un LLM.

## Resumen

Frente al RAG tradicional —que recupera de documentos crudos en cada consulta y **redescubre
el conocimiento una y otra vez**— el patrón propone que el LLM construya y mantenga
incrementalmente un **wiki persistente**: una colección estructurada e interconectada de
archivos markdown entre tú y las fuentes.

La diferencia clave: *"el wiki es un artefacto persistente que se acumula"*. Las referencias
cruzadas ya existen. Las contradicciones ya están señaladas. La síntesis refleja todo lo que
has leído. El wiki se vuelve más rico con cada fuente y cada pregunta.

Tú buscas y exploras; el LLM mantiene: resume, cruza referencias, archiva y lleva la
contabilidad. Un lado corre Obsidian; el otro tiene al LLM editando según la conversación.

## Ideas clave

**Tres capas.** Fuentes crudas (inmutables, el LLM lee pero nunca modifica) · el wiki
(markdown generado por el LLM, que lo posee por completo) · el esquema (`CLAUDE.md`, que
define estructura y convenciones, y que humano y LLM co-evolucionan).

**Tres operaciones.** *Ingesta*: entra una fuente, el LLM la lee, la comenta, escribe su
resumen, actualiza el índice, revisa las páginas de entidad y concepto afectadas y añade la
entrada al log — una sola fuente puede tocar de 10 a 15 páginas. *Consulta*: preguntar contra
el wiki, responder con citas, y archivar las buenas respuestas como páginas nuevas, de modo
que las exploraciones se acumulan. *Lint*: revisión periódica de contradicciones, obsolescencia,
páginas huérfanas, referencias faltantes y huecos de datos.

**Índice y bitácora.** `index.md` como catálogo por categoría, actualizado en cada ingesta.
`log.md` como registro cronológico append-only, con prefijos consistentes
(`## [2026-04-02] ingest | Título`) para que sea parseable.

**Por qué funciona.** *"La parte tediosa de mantener una base de conocimiento no es leer ni
pensar: es la contabilidad."* Los humanos abandonan sus wikis porque el costo de mantenimiento
supera al valor percibido. Los LLM no se cansan, no olvidan referencias cruzadas ni pierden
consistencia entre páginas. El LLM mantiene; el humano cura, dirige el análisis y piensa en el
significado.

**Genealogía.** La idea es el Memex de Vannevar Bush (1945) —un almacén personal y curado de
conocimiento con rutas asociativas— resolviendo el problema que Bush no pudo: *quién lo
mantiene*.

## Aplicaciones que enumera

Personal (metas, salud, psicología) · investigación · lectura · wikis internos de equipo
alimentados por Slack y transcripciones · análisis (investigación competitiva, due diligence).

## Consejos que recoge

Obsidian Web Clipper para convertir artículos a markdown · descargar las imágenes localmente ·
la *graph view* de Obsidian para ver la topología · Marp para presentaciones desde markdown ·
Dataview para consultar el frontmatter · qmd como buscador local híbrido BM25/vectorial cuando
el wiki crece · y **el wiki es un repo de git**: historial, ramas y colaboración incluidos.

## Qué páginas actualizó esta ingesta

Toda la estructura del repositorio: [[CLAUDE]] (el esquema), `README.md`, [[index]], [[log]],
`plantillas/` y la separación `fuentes-crudas/` ↔ `wiki/`.

## Preguntas que abre

- ¿Vale la pena montar `qmd` cuando el wiki pase de ~100 páginas?
- El gist sugiere Marp: ¿los reportes semanales a clientes podrían salir directo de aquí?
  Se cruza con la idea huérfana del reporte semanal en [[Escenarios-Inactivos]].

## Nota

El documento es deliberadamente abstracto: estructura de directorios, convenciones, formatos y
herramientas dependen del dominio. La instancia concreta para este dominio —automatizaciones
con IA para negocios locales— está en [[CLAUDE]].
