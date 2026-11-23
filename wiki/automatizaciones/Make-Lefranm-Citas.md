---
titulo: Make · LEFRANM CITASS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5645150
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, calendar, data-store, agente-ia]
actualizado: 2026-11-23
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

## Diagnóstico 2026-11-23 — "contesta pero no agenda"

Queja del dueño: el bot responde en WhatsApp pero no registra las citas en Google Calendar.

**Lo verificado (corte 2026-11-23):**

- Escenario activo, sin pausa, `isinvalid: false`. Última edición: 2026-11-07.
- Las cinco herramientas de Calendar del agente usan la conexión de Google de la cuenta del spa,
  con permiso completo de Calendar. Los 20 IDs de calendario del prompt existen en esa cuenta.
- Errores del 2026-10-24 al 2026-11-23: solo 3. Dos el 2026-11-11 por falla de la conexión de
  WhatsApp (`AccountValidationError`), uno el 2026-11-01 por mensaje vacío
  (`text.body is required`). **Ningún error de Google Calendar.**
- **El agente sí crea eventos.** Formato del bot: `Servicio - Nombre` con descripción
  (nombre, servicio, teléfono). En noviembre: unos 25 en FACIAL, 3 en MASAJE y 3 en
  MICRODERMOABRASIÓN. Último evento creado por el bot: 2026-11-21 11:48 hora CDMX.
- Del 2026-11-22 al 23 hubo ejecuciones, pero ningún evento nuevo del bot en los calendarios
  revisados (FACIAL, MASAJE, DEPILACIÓN, MICRODERMO, ACUPUNTURA, PRESOTERAPIA, SPA DE MANOS,
  HOLLYWOOD PEEL, LIFTING, AURICULO, RADIOFRECUENCIA, CONOTERAPIA, VENTOSAS, DERMAPEN).
- Las promos del Buen Fin (Conoterapia, Ventosas, Dermapen) tienen **cero** citas desde el
  2026-11-15.
- Las ejecuciones de 11 operaciones son las que escalan a humano (sendMessage de aviso, correo
  y AddRecord de pausa). Las de 8 son respuestas normales. El número de operaciones **no**
  muestra si el agente llamó a una herramienta.

**Límite del diagnóstico:** el plan de Make no deja leer las entradas y salidas de cada módulo
por API: `executions_get-detail` solo devuelve el estado. Sin el caso concreto (cliente y
fecha) no se puede ver qué hizo el agente en una conversación.

> [!warning] Inferencia sin verificar — causa probable
> El flag `cita_agendada` (módulo 30) se calcula **leyendo el texto** de la respuesta
> ("Tu cita para… quedó para…"), no del resultado de `createAnEvent`. Si el modelo redacta la
> confirmación sin haber llamado "Agendar cita", o la llamada no regresa un evento, nadie lo
> detecta: el cliente recibe "Listo" y el calendario queda vacío. Ya hubo un caso así el
> 2026-09-11 (motivo de escalamiento: "cita no aparece en calendario").

> [!warning] Inferencia sin verificar — calendarios del Buen Fin
> El prompt no da un ID de calendario para las promos del Buen Fin: dice "usa el calendario
> de masajes". Las tres promos no tienen ni una cita.

**Otras observaciones:**

- El `summary` sale inconsistente: a veces trae el renglón completo del catálogo
  (`Limpieza profunda | 2 h | $699 (promo) - Nombre`).
- Hubo una cita a las 15:09: el agente no redondea a horarios cerrados.
- `tokenLimit: "50"` en el agente: no está claro qué limita.

**Siguientes pasos propuestos:**

1. Pedir al dueño 2 o 3 casos concretos (cliente y fecha) y revisarlos en el historial del
   escenario en Make.
2. Validar contra la herramienta y no contra el texto: que `cita_agendada` dependa del
   `id` del evento creado, y que el prompt prohíba confirmar sin un Event ID.
3. Poner IDs explícitos de calendario a las promos del Buen Fin.

## Correlaciones

Proyecto: [[Lefranm-Agendamiento-de-Citas]]. Patrones:
[[Agente-Conversacional-de-WhatsApp]], [[Agendamiento-con-Google-Calendar]].
Su escenario compañero de recordatorios es [[Make-Lefranm-Seguimiento-Citas]].
