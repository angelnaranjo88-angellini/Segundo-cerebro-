---
titulo: CUT — Contenido social automatizado
tipo: proyecto
estado: activo
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [contenido, facebook, instagram, sheets, vision]
inicio: 2026-08-28
actualizado: 2026-09-05
---

# CUT — Contenido social automatizado

> Cada mañana a las 06:00 el sistema toma la siguiente foto pendiente de una hoja de Google,
> le escribe el copy con visión por IA y la publica en Facebook e Instagram.

## Qué resuelve

Sostener presencia diaria en redes durante la campaña de inscripciones sin que nadie tenga que
redactar y publicar a mano todos los días.

## Estado actual

Activo. Creado el 2026-08-28, editado el 2026-09-03. Es la **cuarta generación** del pipeline
de contenido: ver [[Pipeline-de-Contenido-Social]] para la genealogía completa desde los
prototipos disparados por WhatsApp de mayo de 2026.

## Piezas

- [[Make-CUT-Creacion-de-Contenido-Sheets]] — el escenario.
- Hoja **"CUT - FOTOS PARA PUBLICAR"** en Drive — la cola de publicación. Columnas:
  `URL_IMAGEN, ESTADO, FECHA_PUBLICACION, TEXTO_GENERADO, ID_POST_FACEBOOK, ID_POST_INSTAGRAM`.
  Ver [[Fuente-Hoja-CUT-Fotos]].
- Carpeta de creatividades en Drive (`publi 17`… `publi 33`, agosto 2026).

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 13 | 2026-09-05 |
| Operaciones | 63 | 2026-09-05 |
| Errores | 6 (46%) | 2026-09-05 |
| Créditos | ~63 | 2026-09-05 |

## Decisiones tomadas

- **La hoja de cálculo como cola, y como registro.** El escenario filtra por `ESTADO`, publica
  y escribe de vuelta los ids de post. Es a la vez backlog y bitácora — barato y auditable.
- **Disparo por calendario, no por mensaje.** El cambio de fondo respecto a los prototipos:
  el contenido se planea antes y se publica solo, en vez de depender de que alguien mande la
  foto por WhatsApp en el momento.

## Pendientes y riesgos

- **46% de ejecuciones con error** (6 de 13). Es la tasa más alta del portafolio con
  diferencia. Candidato número uno a diagnóstico. Ver [[Riesgos-y-Deuda-Tecnica]].
- El copy generado repite un bloque de pie de página largo e idéntico en todas las
  publicaciones; la parte generada por IA es solo el encabezado.

## Correlaciones

Su ADN está en [[Pipeline-de-Contenido-Social]], compartido con cinco escenarios apagados.
Es también el único proyecto que conecta con inversión pagada: las creatividades que publica
son las mismas que alimentan la cuenta de Meta Ads del cliente.
