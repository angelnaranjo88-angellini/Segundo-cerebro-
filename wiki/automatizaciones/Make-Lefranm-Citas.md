---
titulo: Make · LEFRANM CITASS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5645150
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, calendar, data-store, agente-ia, promociones]
actualizado: 2026-10-31
---

# Make · LEFRANM CITASS

> Mensaje de WhatsApp → agente IA → CRUD completo de Google Calendar → respuesta y registro.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato, hasta 100 ejecuciones por minuto.

## Flujo

1. `whatsapp-business-cloud · watchEvents2` — entra el mensaje.
2. `datastore · GetRecord` + `builtin · Resume` — recupera el estado de la conversación.
3. `ai-local-agent · RunLocalAIAgent` — el agente decide qué operación toca.
4. Google Calendar, cinco módulos: `getFreeBusyInformation`, `createAnEvent`, `searchEvents`,
   `deleteAnEvent`, `updateAnEvent`.
5. `openai-gpt-3 · transformTextToStructuredData` ×2 — normaliza fecha, hora y servicio.
6. `datastore · GetRecord` + `builtin · Resume` + `builtin · BasicRouter` — retoma y rutea.
7. `whatsapp-business-cloud · sendMessage` ×3 — respuestas por rama.
8. `google-email · sendAnEmail` — aviso interno.
9. `datastore · AddRecord` ×2 — persiste conversación y cita.

## Persistencia

**Data Store de Make.** Único escenario del portafolio que no usa Airtable para el estado
principal. Ver [[Persistencia-Airtable-vs-Data-Store]].

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 1 865 | 2026-09-05 |
| Operaciones | 12 787 (6.9 por ejecución) | 2026-09-05 |
| Errores | 141 (7.6%) | 2026-09-05 |
| Créditos | ~20 624 | 2026-09-05 |
| Transferencia | 55.5 MB | 2026-09-05 |

## Problemas conocidos

- 141 errores acumulados sin diagnóstico documentado.
- Es el 58% del gasto en créditos del entorno completo.

## Promociones del mes (bloque temporal del prompt)

El `systemPrompt` del agente (módulo 3) tiene un bloque «PROMOCIONES VIGENTES» que se borra
completo al terminar el mes. Cada promo lleva nombre | duración | precio, una descripción y un
link de imagen `lh3.googleusercontent.com`. La primera vez que el cliente pregunta por una promo
se le responde **solo con la imagen**: el módulo 17 detecta el link y el 19 la manda. Abajo va el
mapa de calendarios por promo.

### Arreglo del Facial antiacné (2026-10-31)

Luis Angel agregó la promo «Facial Anti acne $840» como una línea suelta, fuera de la lista y sin
imagen. El agente contestaba preguntando si lo quería «normal o con promo». Causas:

1. El CATÁLOGO MAESTRO seguía diciendo `Facial antiacné | 2 h 30 min | $1,680`. La «regla de
   cita literal» (prioridad máxima) obliga a dar el precio del renglón del catálogo, así que el
   agente veía dos precios para el mismo servicio.
2. El nombre era distinto («Facial Anti acne» contra «Facial antiacné»), parecía otro servicio.
3. No tenía imagen y la regla de las promos dice «contesta solo con la imagen».
4. No estaba en el mapa de calendarios ni en la lista de ejemplo de promos.

Qué se cambió:
- Catálogo: el renglón queda `Facial antiacné | 2 h 30 min | $840 (promo)`, igual que ya
  estaba la Limpieza profunda `$699 (promo)`.
- En el bloque de promos quedó como viñeta normal. Se dice explícitamente que es el mismo
  servicio, que no hay versión normal y versión promo, y que **no tiene imagen**, así que se
  responde en texto desde el primer mensaje.
- Se agregó al mapa de calendarios (`erjr7…`, el de faciales) y a la lista de ejemplo.

> [!warning] Pendiente al cerrar la promo
> El bloque dice «borrar este bloque completo al terminar el mes». Al quitarlo hay que regresar
> **a mano** el renglón del catálogo a `$1,680`, porque el catálogo ya no conserva el precio
> normal. Lo mismo pasa con la Limpieza profunda `$699 (promo)`: no se sabe cuál era su precio
> normal.

> [!warning] Encabezado de mes
> Al 2026-10-31 el encabezado del bloque todavía dice «INICIO OCTUBRE 2026». Si las promos
> siguen en noviembre, conviene actualizar el texto.

## Correlaciones

Proyecto: [[Lefranm-Agendamiento-de-Citas]]. Patrones:
[[Agente-Conversacional-de-WhatsApp]], [[Agendamiento-con-Google-Calendar]].
Su escenario compañero de recordatorios es [[Make-Lefranm-Seguimiento-Citas]].
