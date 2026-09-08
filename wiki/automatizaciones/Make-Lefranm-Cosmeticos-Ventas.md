---
titulo: Make · LEFRANM COSMETICOS CORECTA (copy)
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5587862
clientes: [Lefranm-Quiropractico]
tags: [whatsapp, airtable, agente-ia, ventas]
actualizado: 2026-09-05
---

# Make · LEFRANM COSMETICOS CORECTA (copy)

> El escenario más largo del portafolio: 22 módulos para atender, calificar y registrar una
> venta de catálogo por WhatsApp.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato.

## Flujo

1. `watchEvents2` — entra el mensaje.
2. `airtable · ActionSearchRecords` + `airtable · upsertRecord` — identifica o da de alta al
   contacto sin duplicarlo.
3. `datastore · GetRecord` + `builtin · Resume` — estado de conversación.
4. `ai-local-agent · RunLocalAIAgent` — el agente.
5. `openai-gpt-3 · transformTextToStructuredData` ×3 — extracción de intención, producto y datos.
6. `whatsapp-business-cloud · sendMessage` + `builtin · Resume` + `builtin · BasicRouter`.
7. `sendMessage` ×2 por rama.
8. `openai-gpt-3 · transformTextToStructuredData` — una cuarta extracción.
9. `google-email · sendAnEmail` — aviso.
10. `airtable · ActionUpdateRecords` → `BasicRouter` → `ActionCreateRecord` →
    `ActionUpdateRecords` — el pedido.
11. `google-email · sendAnEmail` ×2 y `datastore · AddRecord` — cierre.

## Persistencia

Airtable para contactos y pedidos; Data Store solo para el hilo de conversación.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 769 | 2026-09-05 |
| Operaciones | 6 494 (8.4 por ejecución) | 2026-09-05 |
| Errores | 78 (10.1%) | 2026-09-05 |
| Créditos | ~8 315 | 2026-09-05 |
| Transferencia | 43.7 MB | 2026-09-05 |

## Problemas conocidos

- **Tasa de error más alta entre los agentes** (10.1%). Sospecha principal: cuatro extracciones
  estructuradas encadenadas, cada una un punto de fallo si el cliente contesta fuera de formato.
- Sufijo `(copy)` en producción: no hay rastro del original.

## Correlaciones

Proyecto: [[Lefranm-Agente-de-Ventas]]. Patrón: [[Agente-Conversacional-de-WhatsApp]].
Gemelo estructural: [[Make-Asistente-Chavarria]].
