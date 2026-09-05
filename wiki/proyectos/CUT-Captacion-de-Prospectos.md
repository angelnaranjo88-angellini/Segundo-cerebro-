---
titulo: CUT — Captación y seguimiento de prospectos
tipo: proyecto
estado: activo
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [prospectos, whatsapp, airtable, meta-ads]
inicio: 2026-08-26
actualizado: 2026-09-05
---

# CUT — Captación y seguimiento de prospectos

> El embudo completo del colegio: anuncio en Meta → conversación en WhatsApp → registro en
> Airtable → recordatorio automático cada media hora hasta que el prospecto responde o cierra.

## Qué resuelve

Que ningún interesado se enfríe entre que pregunta y que se inscribe — con una fecha límite
dura de por medio (4 de septiembre de 2026).

## Estado actual

Activo. El escenario de seguimiento corre cada 30 minutos, indefinidamente.

## Piezas

- Meta Ads — cuenta `1258701508163147` "Bachillerato Maria Chavarria" (MXN, activa).
- [[Asistente-Chavarria]] — la puerta de entrada conversacional.
- [[Make-CUT-Seguimiento-Prospectos]] — el sondeo cada 30 min sobre Airtable.
- [[CUT-Contenido-Social]] — la parte orgánica del mismo embudo.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones (seguimiento) | 460 | 2026-09-05 |
| Operaciones | 595 | 2026-09-05 |
| Errores | 3 (0.65%) | 2026-09-05 |
| Créditos | ~595 | 2026-09-05 |

## Decisiones tomadas

- **Sondeo, no webhook.** Airtable no dispara; el escenario pregunta. Ver
  [[Seguimiento-por-Sondeo]].
- **Airtable como base del embudo**, con un campo de estado que el propio escenario actualiza
  para no volver a contactar al mismo prospecto.

## Pendientes y riesgos

- Cerrado el ciclo 2026, el escenario sigue corriendo cada 30 minutos: 48 ejecuciones diarias
  que ya no captan a nadie. Candidato a pausar hasta la próxima campaña.
- No hay página que cruce **gasto publicitario contra prospectos registrados**. Es el dato que
  falta para saber si el embudo es rentable. Ver [[Riesgos-y-Deuda-Tecnica]].

## Correlaciones

Idéntico en estructura a [[Make-Lefranm-Seguimiento-Cosmeticos]] y
[[Make-Lefranm-Seguimiento-Citas]]: tres implementaciones del mismo patrón de tres módulos.
Ver [[Seguimiento-por-Sondeo]] y [[Patrones-Reutilizables]].
