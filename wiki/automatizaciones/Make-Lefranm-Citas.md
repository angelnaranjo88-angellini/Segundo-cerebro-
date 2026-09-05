---
titulo: Make · LEFRANM CITASS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5645150
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, calendar, data-store, agente-ia]
actualizado: 2026-09-05
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

## Correlaciones

Proyecto: [[Lefranm-Agendamiento-de-Citas]]. Patrones:
[[Agente-Conversacional-de-WhatsApp]], [[Agendamiento-con-Google-Calendar]].
Su escenario compañero de recordatorios es [[Make-Lefranm-Seguimiento-Citas]].
