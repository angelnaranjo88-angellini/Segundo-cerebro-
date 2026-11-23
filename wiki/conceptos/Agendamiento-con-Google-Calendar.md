---
titulo: Agendamiento con Google Calendar
tipo: concepto
estado: activo
tags: [patron, calendar, citas, make]
actualizado: 2026-11-23
---

# Agendamiento con Google Calendar

> Google Calendar como base de datos de citas. La versión completa del patrón hace CRUD
> entero; la incompleta solo crea, y por eso empalma.

## El patrón

Cinco módulos de Make cubren el ciclo de vida de una cita:

| Operación | Módulo | ¿Para qué? |
|---|---|---|
| Consultar | `getFreeBusyInformation` | **Antes** de ofrecer horario. El paso que se olvida. |
| Crear | `createAnEvent` | Agendar. |
| Buscar | `searchEvents` | "¿Cuándo tengo mi cita?" |
| Modificar | `updateAnEvent` | Reprogramar. |
| Borrar | `deleteAnEvent` | Cancelar. |

Calendar es además la interfaz humana: el negocio ve y edita las citas sin entrar a Make.

## Dónde lo uso

| Implementación | Módulos de Calendar | Completitud |
|---|---|---|
| [[Make-Lefranm-Citas]] | los 5 | **Completa** |
| [[Make-Asistente-Chavarria]] | solo `createAnEvent` | Incompleta |
| `Agendamiento` (3678657, apagado) | `createAnEvent`, `searchEvents` ×3 | Prototipo |
| `Recordatorios de citas` (5037096, apagado) | `searchEvents` | Sin activar |
| `Reporte semanal de citas` (5037104, apagado) | `searchEvents` | Sin activar |
| `Seguimiento post-cita` (5037100, apagado) | `searchEvents` | Sin activar |

Lefranm expone además el patrón como **cinco herramientas MCP**
(`revisar_disponibilidad`, `agendar_cita`, `buscar_cita`, `cancelar_cita`,
`reprogramar_cita`), una por operación. Ese mapeo uno a uno entre módulo de Calendar y
herramienta MCP es la abstracción correcta y ya está hecha.

## Fallos típicos

- **Crear sin consultar.** [[Make-Asistente-Chavarria]] llama a `createAnEvent` sin
  `getFreeBusyInformation` previo: nada impide dos visitas al mismo tiempo.
- **Recordatorios sobre Calendar vs. sobre la base propia.** Los prototipos leían Calendar
  para recordar. [[Make-Lefranm-Seguimiento-Citas]] lee el Data Store, pero no es un
  recordatorio de cita: reengancha a quien **no** agendó.

  > [!warning] Contradicción corregida 2026-11-23
  > Antes esta página decía que el seguimiento sobre Data Store había reemplazado a los
  > recordatorios. Revisado el blueprint, hoy no existe ningún recordatorio de cita activo.
  > El escenario 5037096 sigue apagado.

## Correlaciones

[[Lefranm-Agendamiento-de-Citas]] es la referencia. [[Landing-Sonrisas-Dental]] es el candidato
evidente para reutilizarlo. Ver [[Patrones-Reutilizables]].
