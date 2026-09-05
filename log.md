---
titulo: Bitácora
tipo: sintesis
estado: activo
actualizado: 2026-09-05
---

# Bitácora

> Registro cronológico, lo más nuevo arriba. Append-only: no se edita el pasado.
> Prefijos: `ingesta` · `sintesis` · `lint` · `decision`.

## [2026-09-05] decision | La ruta ahora se abre en Google Maps, y la Jornada 3 cambió de sentido

Añadidos a [[Ruta-Prospeccion-Periferico-Culhuacan-Coapa]]: seis enlaces de ruta a pie de
Google Maps (dos por jornada; el formato de URL solo admite 9 escalas) y un CSV hermano,
`Ruta-Prospeccion-Periferico-Culhuacan-Coapa.csv`, importable a Google My Maps con una columna
de enlace por parada.

**Decisión de trazo:** invertí la Jornada 3. Iba de poniente a oriente sobre Calz. del Hueso y
dejaba el ramal de Canal de Miramontes como apéndice suelto. Ahora va de oriente a poniente
(990 → 126) y gira al norte sobre Miramontes (3160 → 2706), que es donde la numeración sigue
bajando: los dos tramos se encadenan sin regresar sobre los pasos. Entraron a la secuencia el
Colegio Alejandro Guillot y el predio Miramontes 2769 (dos dentales y una estética en un solo
edificio); salieron a suplentes Silk Skin, Cautiva Lashes y Vanity House.

El trazo es **inferencia a partir de numeración y colonias**, no un recorrido medido. Queda
marcado como tal en la página, junto con la advertencia de que Maps geocodifica desde texto y
algunos pines caerán a media cuadra.

## [2026-09-05] sintesis | Ruta de prospección a pie: Periférico Oriente → Culhuacán → Coapa

Escrita [[Ruta-Prospeccion-Periferico-Culhuacan-Coapa]]: 50 negocios en tres jornadas
caminables (Av. Tláhuac en Iztapalapa, Av. Carlota Armero en CTM Culhuacán, Calz. del Hueso y
Canal de Miramontes en Coapa), más ~20 suplentes.

Método: búsqueda web contra agregadores. **Ningún dominio de directorio se pudo abrir
directamente** —Facebook, Instagram, Fresha, Booksy y Doctoralia están bloqueados por el proxy
de red—, así que todo sale de resultados de búsqueda y queda marcado como verificable en calle.
12 entradas quedan *(sin nombre público)*: el agregador publica dirección y giro pero oculta el
nombre comercial.

Hallazgo aprovechable: **estar listado en Fresha/Booksy/AgendaPro segmenta el pitch.** Quien ya
paga una app de citas no compra agendamiento; compra WhatsApp que contesta y recordatorios
([[Seguimiento-por-Sondeo]]). Quien no aparece en ningún lado compra presencia antes que
automatización ([[Pipeline-de-Contenido-Social]]).

Correlación con el portafolio: la Jornada 1 recorre la misma avenida donde ya opera
[[Lefranm-Cosmeticos]] (Av. Tláhuac 4746). El caso de referencia está a pie de ruta, y hay un
caso propio para cada giro objetivo: estética → [[Make-Lefranm-Citas]], escuela →
[[Asistente-Chavarria]], dental → [[Sonrisas-Para-Todos-Nosotros]].

Contradicción abierta y sin resolver: la numeración de Av. Tláhuac es coherente en el tramo
4746→3431, pero varios agregadores ubican las mismas colonias en números de 3 y 4 cifras
menores. Esos cuatro registros quedaron fuera de la secuencia hasta verificarlos en calle.

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
