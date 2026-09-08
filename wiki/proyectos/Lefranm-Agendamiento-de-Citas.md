---
titulo: Lefranm — Agendamiento de citas
tipo: proyecto
estado: activo
clientes: [Lefranm-Quiropractico]
tags: [whatsapp, agente-ia, calendar, data-store, mcp]
inicio: 2026-07-13
actualizado: 2026-09-05
---

# Lefranm — Agendamiento de citas

> El proyecto más maduro del portafolio: un agente de WhatsApp que consulta disponibilidad
> real, agenda, busca, cancela y reprograma citas en Google Calendar — y que además está
> publicado como herramientas MCP consultables desde fuera de Make.

## Qué resuelve

Los servicios de cabina (reductivo, microdermoabrasión, presoterapia, spa de manos) se agendan
por WhatsApp. El agente cubre el ciclo completo sin intervención humana.

## Estado actual

Activo. Creado el 2026-07-13, editado por última vez el **2026-09-04** — el proyecto con
desarrollo más reciente. Es la referencia arquitectónica: todo lo que aprendiste aquí es lo
que conviene portar al resto.

## Piezas

- [[Make-Lefranm-Citas]] — el escenario (20 módulos).
- [[Make-Lefranm-Seguimiento-Citas]] — recordatorios cada 30 min sobre el Data Store.
- Google Calendar — cinco módulos distintos: `getFreeBusyInformation`, `createAnEvent`,
  `searchEvents`, `updateAnEvent`, `deleteAnEvent`. El CRUD completo.
- Data Store de Make — estado de conversación y de cita.
- Herramientas MCP publicadas: `revisar_disponibilidad`, `agendar_cita`, `buscar_cita`,
  `cancelar_cita`, `reprogramar_cita`.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 1 865 | 2026-09-05 |
| Operaciones | 12 787 | 2026-09-05 |
| Errores | 141 (7.6%) | 2026-09-05 |
| Créditos | ~20 624 | 2026-09-05 |

Es el escenario **más caro del entorno**: por sí solo consume ~58% de todos los créditos.

## Decisiones tomadas

- **Consultar antes de escribir.** `getFreeBusyInformation` antes de `createAnEvent` — el paso
  que le falta a [[Asistente-Chavarria]] y que evita empalmes.
- **Data Store en vez de Airtable.** Divergencia deliberada o accidental respecto al resto del
  portafolio; documentada en [[Persistencia-Airtable-vs-Data-Store]].
- **Patrón `GetRecord` → `Resume`**: recupera el estado de la conversación antes de continuar.
  Es lo que le da memoria al agente entre mensajes. Ver
  [[Agente-Conversacional-de-WhatsApp]].
- **Exponerlo como MCP.** Convierte una automatización en un servicio reutilizable.

## Pendientes y riesgos

- 141 errores acumulados (7.6%). Con 6.9 operaciones por ejecución, cada fallo cuesta caro.
- Concentración de gasto: si hay que optimizar créditos, se optimiza aquí o no se optimiza.

## Correlaciones

Es el techo técnico del portafolio y el modelo a copiar hacia
[[Asistente-Chavarria]] y [[Landing-Sonrisas-Dental]]. Ver [[Patrones-Reutilizables]].
