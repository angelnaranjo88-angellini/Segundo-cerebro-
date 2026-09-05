---
titulo: Make · Asistente Chavarria
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5982362
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [whatsapp, airtable, calendar, agente-ia]
actualizado: 2026-09-05
---

# Make · Asistente Chavarria

> La versión más limpia del patrón conversacional: 15 módulos, sin extracciones redundantes.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato, hasta 100 ejecuciones por minuto.

## Flujo

1. `watchEvents2` — entra el mensaje.
2. `builtin · BasicRouter` — rutea temprano, antes de gastar en IA.
3. `ai-local-agent · RunLocalAIAgent` — el agente.
4. `openai-gpt-3 · transformTextToStructuredData` — **una sola** extracción.
5. `airtable · ActionSearchRecords` — busca al prospecto.
6. `builtin · BasicRouter` — segunda bifurcación.
7. `whatsapp-business-cloud · sendMessage` — respuesta.
8. `google-calendar · createAnEvent` — agenda la visita.
9. `builtin · Ignore` / `google-email · sendAnEmail` / `builtin · Ignore` — aviso interno.
10. `airtable · ActionCreateRecord` + `ActionUpdateRecords` ×2 — registro del prospecto.
11. `whatsapp-business-cloud · sendMessage` — confirmación.

## Persistencia

Airtable. Sin Data Store: **este agente no conserva estado de conversación entre mensajes**,
a diferencia de los dos de Lefranm.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 353 | 2026-09-05 |
| Operaciones | 1 777 (5.0 por ejecución) | 2026-09-05 |
| Errores | 25 (7.1%) | 2026-09-05 |
| Créditos | ~2 662 | 2026-09-05 |

Es el agente **más eficiente por ejecución** del portafolio: 5.0 operaciones frente a 6.9 y 8.4.

## Problemas conocidos

- `createAnEvent` **sin** `getFreeBusyInformation` previo: puede empalmar citas.
  [[Make-Lefranm-Citas]] sí lo consulta.
- Sin Data Store, una conversación cortada a la mitad no se retoma.

## Correlaciones

Proyecto: [[Asistente-Chavarria]]. Patrón: [[Agente-Conversacional-de-WhatsApp]].
Alimenta a [[Make-CUT-Seguimiento-Prospectos]].
