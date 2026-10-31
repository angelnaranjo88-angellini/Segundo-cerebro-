---
titulo: Bitácora
tipo: sintesis
estado: activo
actualizado: 2026-10-31
---

# Bitácora

> Registro cronológico, lo más nuevo arriba. Append-only: no se edita el pasado.
> Prefijos: `ingesta` · `sintesis` · `lint` · `decision`.

## [2026-10-31] decision | PDFs verificados, respaldo ampliado y Facial antiacné corregido

1. **PDFs (ventas, 5587862):** Luis Angel subió versiones nuevas sobre los mismos archivos.
   Los 6 IDs descargan como PDF por la Drive API. Fichas técnicas no se actualizó (julio).
2. **Respaldo de PDFs:** los módulos 42 y 43 ahora cubren Kit, Fichas y Catálogo, además de
   las tres listas (`documento` + `switch`). Ver
   [[Make-Lefranm-Cosmeticos-Ventas#Envío de PDFs por WhatsApp]].
3. **Facial antiacné (citas, 5645150):** la promo estaba como línea suelta y chocaba con el
   precio $1,680 del catálogo, protegido por la regla de cita literal. Se alineó catálogo, bloque
   de promos y mapa de calendarios. Ver [[Make-Lefranm-Citas#Arreglo del Facial antiacné (2026-10-31)]].

Los dos blueprints se compararon contra lo enviado después de guardarlos: solo cambió lo
previsto.

## [2026-10-31] ingesta | Envío de PDFs en el agente de ventas Lefranm

Revisión del blueprint del escenario 5587862, pedida por Luis Angel después de arreglar el
envío de PDF. El agente escribe `[ENVIAR_ARCHIVO: URL | nombre]`, el módulo 60 la extrae y el 61
convierte el link `uc?export=download` de Drive en una descarga por la Drive API antes de
mandarlo como `document`. El módulo 43 es un respaldo para las listas de precios y tiene las URL
escritas directamente en él. Con la tabla de IDs y el checklist de cambio, todo queda en
[[Make-Lefranm-Cosmeticos-Ventas#Envío de PDFs por WhatsApp]]. Hallazgos: la API key de
Google está en texto plano en las fórmulas, y la sección de persistencia contradice el blueprint
actual (ya no hay Airtable, ahora es Data Store). Siguiente paso: cambiar los links por los
PDF nuevos.

## [2026-09-05] lint | Primer chequeo de salud del wiki

40 páginas, 37 destinos de enlace distintos. **Cero enlaces rotos** y cero páginas huérfanas
dentro de `wiki/`.

Huérfanas fuera de `wiki/` y aceptadas por diseño: las seis de `plantillas/` (se copian, no se
enlazan) y `README.md` (es la portada de GitHub, no un nodo del grafo).

Los destinos `[[...]]`, `[[Nombre-Del-Archivo]]` y `[[Pagina]]` que aparecen en [[CLAUDE]] y en
las plantillas son ejemplos de sintaxis, no enlaces reales.

Pendiente para el próximo lint: verificar que las métricas con corte 2026-09-05 sigan vigentes;
todas envejecen a diario.

## [2026-09-05] sintesis | Tres páginas de correlación del portafolio

Escritas [[Correlacion-de-Proyectos]], [[Patrones-Reutilizables]] y
[[Riesgos-y-Deuda-Tecnica]] cruzando las cuatro fuentes ingeridas hoy.

Hallazgo principal: **no hay seis proyectos, hay dos patrones aplicados a tres negocios.**
Los tres agentes conversacionales son el mismo escenario de Make con distinta tabla y distinto
prompt; los tres seguimientos son literalmente los mismos tres módulos.

Hallazgo cuantitativo: los escenarios que llaman a un modelo fallan el **8.2%** de las veces y
consumen el **88.6%** de los créditos; los que no lo hacen fallan el **0.1%**. 250 de los 253
errores del entorno están en la capa de IA.

Contradicciones abiertas: persistencia partida entre Airtable y Data Store sin criterio; repo
`Nuevo-Proyecto-Marista` con contenido dental; `(copy)` en producción; Chavarría agenda sin
consultar disponibilidad.

## [2026-09-05] ingesta | Hoja "CUT - FOTOS PARA PUBLICAR"

→ [[Fuente-Hoja-CUT-Fotos]]. La cola de publicación del colegio: seis columnas que son a la vez
backlog, texto generado y bitácora de ids de post.

Detectado que las `URL_IMAGEN` usan el formato `/view?usp=sharing`, que no es descarga
directa — hipótesis principal del 46% de error de
[[Make-CUT-Creacion-de-Contenido-Sheets]].

Actualizó: [[CUT-Contenido-Social]], [[Make-CUT-Creacion-de-Contenido-Sheets]],
[[Colegio-Maria-Chavarria-Vital]], [[Pipeline-de-Contenido-Social]].

## [2026-09-05] ingesta | Catálogo de precios Lefranm

→ [[Fuente-Catalogo-Lefranm]]. ~52 SKUs (`Lf-001`–`Lf-052`), $65–$589 MXN, registro COFEPRIS
`2409165018X00154`. El catálogo ya está organizado por problema de piel, que es como pregunta
el cliente por WhatsApp.

Deuda señalada: vive en un PDF, no en la tabla de Airtable que el agente ya consulta.

Actualizó: [[Lefranm-Cosmeticos]], [[Lefranm-Agente-de-Ventas]].

## [2026-09-05] ingesta | Inventario de escenarios de Make

→ [[Fuente-Inventario-Make]]. 22 escenarios del equipo 1436402: 7 activos, 15 apagados (14 con
cero ejecuciones). 6 079 ejecuciones acumuladas, 25 133 operaciones, 253 errores, ~35 677
créditos.

Creadas las 8 páginas de `wiki/automatizaciones/`, los 6 conceptos, los 6 proyectos y los 3
clientes. Es la ingesta fundacional del wiki.

Descubrimiento lateral: cinco escenarios creados el mismo día (2026-05-12) y ninguno activado.
Dos de ellos —reporte semanal de citas y petición de reseña post-cita— siguen sin sustituto y
son las ideas de mejor retorno por módulo del inventario. Ver [[Escenarios-Inactivos]].

## [2026-09-05] ingesta | LLM Wiki de Andrej Karpathy

→ [[LLM-Wiki-Karpathy]]. Fuente fundacional. Define las tres capas (fuentes crudas · wiki ·
esquema), las tres operaciones (ingesta · consulta · lint) y el papel de `index.md` y `log.md`.

## [2026-09-05] decision | Estructura del vault

Instanciado el patrón para este dominio. Decisiones tomadas:

- **Español en todo el contenido**, nombres de archivo sin acentos para que los enlaces
  `[[...]]` no se rompan entre sistemas de archivos.
- **Frontmatter obligatorio** con `tipo`, `estado` y `actualizado`, para que Dataview pueda
  consultar el wiki en vez de depender de tablas escritas a mano.
- **Cinco carpetas** en `wiki/`: proyectos, clientes, automatizaciones, conceptos, síntesis,
  fuentes. Las automatizaciones tienen carpeta propia porque en este dominio un escenario de
  Make **es** una entidad de primera clase, no un detalle de implementación.
- **Toda métrica lleva fecha de corte.** Los números de este portafolio cambian cada día.
- **Sin secretos en el repo.** Tokens, API keys y datos personales de clientes finales quedan
  fuera; se referencia dónde viven, no su valor.

Ver [[CLAUDE]].
