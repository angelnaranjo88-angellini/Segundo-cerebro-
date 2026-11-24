---
titulo: Make · LEFRANM CITASS
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5645150
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, calendar, data-store, agente-ia]
actualizado: 2026-11-24
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
5. ~~`openai-gpt-3 · transformTextToStructuredData` ×2~~ — **reemplazados el 2026-11-24** por
   `util · SetVariables` (módulo 30), que limpia las marcas con fórmulas, sin IA. Ver
   [[#Incidente 2026-11-23 — confirmación de cita inventada]].
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

Aclaración: `tokenLimit: "50"` es "Maximum output length (%)", es decir 50% de la salida
máxima. No es un problema.

## Cambios aplicados 2026-11-23

Aplicados por API sobre el blueprint vigente. Después se volvió a descargar el blueprint y se
comparó campo por campo con la versión preparada: idénticos. El escenario sigue activo.

1. **Confirmar solo con Event ID** (prompt del agente, módulo 3). Nueva sección
   "CONFIRMACIÓN DE CITA SOLO CON EVENTO CREADO":
   - El agente no puede decir "Listo / quedó para" si en ese turno no llamó "Agendar cita"
     y recibió su `id`.
   - Al confirmar agrega `[EVENTO_CREADO: id]`, una marca por evento.
   - Si la herramienta falla, no confirma y escala con `[AVISAR_HUMANO: ...]`.
   - Lo mismo aplica al reprogramar.
2. **Módulo 30** (limpieza de marcas):
   - Ahora también quita `[EVENTO_CREADO: ...]` y devuelve un campo nuevo, `evento_id`.
   - **Red de seguridad:** si el mensaje confirma una cita y no trae `EVENTO_CREADO`, activa
     `necesita_aviso` con el motivo "El bot confirmó una cita sin evento en el calendario:
     verificar y agendar manualmente". Eso dispara la ruta de aviso: WhatsApp a respaldo,
     correo y pausa de 2 h.
3. **Módulo 34:** `cita_agendada` ahora sale de `evento_id` (no vacío), no del texto. La
   lógica que conserva el valor previo (`32.cita_agendada`) sigue igual. Este flag lo lee
   [[Make-Lefranm-Seguimiento-Citas]], que manda reenganche a quien **no** agendó. Una
   confirmación falsa ahora queda como "no agendó", y el cliente recibe ese reenganche
   además del aviso a la persona de respaldo.
4. **Promos del Buen Fin con calendario explícito:**

   | Promo | Calendario | Duración |
   |---|---|---|
   | Conoterapia | CONOTERAPIA | 40 min por sesión; el 2x1 puede ser dos citas |
   | Masaje de espalda con ventosas | MASAJE | 30 min |
   | Masaje de piernas cansadas | MASAJE | 30 min |
   | Dermapen | Dermapen | 1 h 30 min |

> [!warning] Decisiones tomadas sin confirmar con el dueño
> - Ventosas va al calendario MASAJE, como ya decía el prompt, y no al calendario
>   "Ventosas".
> - El 2x1 de Conoterapia puede quedar en dos citas separadas.
> - Duración de Dermapen: la del catálogo, porque la promo no la trae.

Respaldo del blueprint anterior: solo en la sesión de trabajo, no en el repo.

**Pendiente:**
- Vigilar los avisos con motivo "confirmó una cita sin evento" durante los próximos días.
  Si aparecen, el agente sigue alucinando confirmaciones.
- Comprobar que el bot crea eventos en las ejecuciones nuevas (ver el calendario).
- Pedir al dueño casos concretos de citas perdidas antes del cambio.

## Incidente 2026-11-23 — confirmación de cita inventada

**Qué pasó.** El 2026-11-23 a las 00:53 (hora CDMX) un cliente preguntó "la microdermoabrasión
qué incluye". El bot le respondió: "Te confirmo que tu cita para el masaje relajante quedó
agendada para el sábado a las 3 PM". Esa cita no existía. 90 minutos después le llegó el
reenganche de [[Make-Lefranm-Seguimiento-Citas]].

**Evidencia** (ejecución de las 06:53:11 UTC, 11 operaciones, o sea que se disparó la ruta
de aviso):
- El texto no lo escribió el agente: usa "tú" (el prompt exige "usted").
- Menciona "masaje relajante", que no existe en el catálogo.
- Propone el sábado a las 15:00, que es la hora de cierre y el prompt lo prohíbe.
- El agente no llamó a ninguna herramienta.

> [!warning] Inferencia sin verificar
> Causa más probable: el módulo 30 era un LLM (gpt-4o-mini) encargado solo de "quitar
> marcas". En vez de copiar el texto del agente, generó uno nuevo. Su prompt traía
> ejemplos de frases de confirmación ("Tu cita para… quedó para…"). Los cambios del
> 2026-11-23 reforzaron esas frases y probablemente hicieron más probable que inventara.
> No se pudo leer la entrada y salida de cada módulo: la API de Make solo devuelve el
> estado de la ejecución.

**Lección.** No usar un LLM para transformaciones que deben ser deterministas, como quitar
marcas o extraer campos. Un LLM "limpiador" puede reescribir el mensaje que recibe el
cliente.

## Cambios aplicados 2026-11-24 — limpieza sin IA

Se quitaron los dos módulos de OpenAI de limpieza (30 y 17). El nuevo módulo 30 es
`util:SetVariables`, con fórmulas de Make sobre `3.response`:

| Variable | Cómo se calcula |
|---|---|
| `texto_final` | El texto del agente cortado en la primera marca o link de imagen. Si confirma una cita sin `[EVENTO_CREADO]`, se sustituye por "Permítame un momento, una persona del equipo le confirma su horario en breve 🙂". |
| `link_imagen` | El link `lh3.googleusercontent.com`, si viene. |
| `evento_id`, `cita_agendada` | Salen de la marca `[EVENTO_CREADO: id]`. |
| `necesita_aviso`, `motivo_aviso` | Salen de la marca `[AVISAR_HUMANO: …]`, o del caso "confirmó sin evento". |

Los módulos 4, 19 y 34 ahora leen de `30.*`.

**Prueba previa.** Se hizo en un escenario y un Data Store temporales, ya borrados. Pasaron
los 11 casos: cita con evento, la confirmación falsa del incidente, aviso a humano, solo
link, marca de imagen, respuesta vacía, dos eventos, saludo normal, link con texto, solo
marca y evento al inicio.

**Fallos encontrados en la prueba antes de subir a producción:**
- `replace()` con regex **no** quitaba las marcas.
- `split()` descarta el fragmento vacío cuando el texto empieza con el separador.

Se resolvió cortando con `indexOf` y `substring`.

**Verificación.** Se volvió a descargar el blueprint de producción y se comparó: idéntico,
salvo la posición visual de un manejador de error (cosmético). El escenario sigue activo.

**Comportamiento a vigilar:**
- Las marcas deben ir al final del mensaje: todo lo que esté después de la primera marca o
  link se corta.
- Si el agente responde solo con una marca, el cliente no recibe texto; el aviso a humano
  sí sale.
- Si el agente crea la cita pero olvida la marca, el cliente recibe "permítame un momento"
  y se avisa a la persona de respaldo, aunque el evento exista.

Respaldos de los blueprints: solo en la sesión de trabajo, no en el repo.

## Correlaciones

Proyecto: [[Lefranm-Agendamiento-de-Citas]]. Patrones:
[[Agente-Conversacional-de-WhatsApp]], [[Agendamiento-con-Google-Calendar]].
Su escenario compañero de reenganche (a quien no agendó) es [[Make-Lefranm-Seguimiento-Citas]].
