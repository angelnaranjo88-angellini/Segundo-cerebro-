---
titulo: Make · Asistente G&G Barbers (Dante)
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 6914875
clientes: [GyG-Barbers]
tags: [whatsapp, agente-ia, supabase, citas]
actualizado: 2026-11-07
---

# Make · Asistente G&G Barbers (Dante)

> Mensaje de WhatsApp → agente IA "Dante" → herramientas contra `bot-api` → respuesta.

## Disparador

`whatsapp-business-cloud:watchEvents2`, webhook 3027069, conexión 12162330 (55 4786 2032).

## Flujo

1. `watchEvents2` — entra el mensaje.
2. `util:SetVariable2` — clave del bot (el valor vive solo en Make).
3. Router: texto → agente; audio/foto/sticker → aviso "solo leo texto".
4. `ai-local-agent:RunLocalAIAgent` (gpt-5-mini vía Make AI Provider), memoria por
   `threadId = gyg5-<wa_id>`.
5. `sendMessage` con la respuesta.

## Herramientas del agente

| Herramienta | Módulo | Datos de la IA |
|---|---|---|
| Servicios y precios | `http:MakeRequest` directo | ninguno |
| Buscar mis citas | `http:MakeRequest` directo | ninguno (teléfono del trigger) |
| Revisar disponibilidad | `CallSubscenario` → 6944004 | fecha, servicios |
| Agendar cita | `CallSubscenario` → 6944004 | nombre, fecha, hora, servicios, notas |
| Cancelar cita | `CallSubscenario` → 6944004 | id |
| Reprogramar cita | `CallSubscenario` → 6944004 | id, fecha, hora |

El subescenario **6944004 "G&G herramienta citas (bot-api)"** arma el JSON, llama a la
función, guarda cada petición en el data store **195258 "GG bot log"** y devuelve `tool_output`.

## Historial

- 2026-11-07: tras ~8 intentos fallidos, quedó funcionando con el patrón de subescenario.
  Ver [[Herramientas-de-Agente-en-Make]] para la causa.

## Correlaciones

Hermano de [[Make-Lefranm-Citas]]; mismo patrón [[Agente-Conversacional-de-WhatsApp]].
