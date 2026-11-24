---
titulo: Make · LEFRANM COSMETICOS CORECTA (copy)
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5587862
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, airtable, agente-ia, ventas]
actualizado: 2026-11-24
---

# Make · LEFRANM COSMETICOS CORECTA (copy)

> El escenario más largo del portafolio: 22 módulos para atender, calificar y registrar una
> venta de catálogo por WhatsApp.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato, hasta 100 ejecuciones por minuto.

## Flujo (revisado el 2026-11-24)

> [!warning] Corrección
> La versión anterior de esta página describía Airtable. El blueprint actual ya no lo usa:
> la persistencia es 100% Data Store de Make. Última edición previa a esta revisión:
> 2026-11-17.

1. `watchEvents2`: entra el mensaje.
2. `datastore · GetRecord` (clientes: tier, monto acumulado, dirección) y `AddRecord`
   (actualiza el último mensaje).
3. `datastore · GetRecord` (pausas): el agente no responde mientras haya un aviso humano
   vigente (2 h).
4. `whatsapp · getMedia`, `openai · analyzeImages` y `CreateTranscription`: fotos y audios
   se convierten en texto para el agente.
5. `ai-local-agent · RunLocalAIAgent` (módulo 12), sin herramientas:
   - Todo lo que hace lo comunica con marcas en su texto: `[ENVIAR_ARCHIVO: url | nombre]`,
     `[ENVIAR_IMAGEN: url]`, `[AVISAR_HUMANO: motivo]` y el encabezado
     `🛒 FICHA DE COMPRA`.
   - Si el número que escribe es el del dueño, el agente entra en modo cotizador.
6. **Módulo 60, `util · SetVariables` (desde el 2026-11-24):** separa el texto de las marcas
   con fórmulas, sin IA. Ver [[#Cambios aplicados 2026-11-24]].
7. Módulo 42, `openai · transformTextToStructuredData`: respaldo. Si el agente dice
   "le comparto la lista" sin poner la marca, esta IA decide qué PDF mandar.
8. Módulo 38, `sendMessage`: manda el texto al cliente.
9. Router:
   - El PDF con marca va por el módulo 61; el PDF de respaldo, por el 43.
   - Si hay ficha de compra: módulo 41 (IA que extrae los datos de la ficha) → correo de
     pedido (105) → actualiza el cliente (106) → actualiza su tier (51).
   - Aviso a humano: correo (71) y pausa de 2 h (201).
   - Imagen de promo: módulo 62.

## Persistencia

Data Store de Make: clientes (tier y datos de envío) y pausas. Ver
[[Persistencia-Airtable-vs-Data-Store]].

> [!warning] Seguridad
> Los módulos 43 y 61 tienen una API key de Google escrita en texto plano dentro del
> blueprint (para descargar los PDF de Drive). No se copia aquí. Conviene restringirla en
> Google Cloud a la Drive API y a esos archivos, o moverla a una conexión de Make.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 769 | 2026-09-05 |
| Operaciones | 6 494 (8.4 por ejecución) | 2026-09-05 |
| Errores | 78 (10.1%) | 2026-09-05 |
| Créditos | ~8 315 | 2026-09-05 |
| Transferencia | 43.7 MB | 2026-09-05 |

## Problemas conocidos

- **Tasa de error más alta entre los agentes** (10.1% al corte 2026-09-05). Del 2026-11-14
  al 2026-11-24 solo hubo 3 errores, todos el 10 y 11 de noviembre por falla de la conexión
  de WhatsApp. Sospecha principal: cuatro extracciones
  estructuradas encadenadas, cada una un punto de fallo si el cliente contesta fuera de formato.
- Sufijo `(copy)` en producción: no hay rastro del original.

## Cambios aplicados 2026-11-24

Mismo problema que en [[Make-Lefranm-Citas#Incidente 2026-11-23 — confirmación de cita inventada]]:
el texto que recibía el cliente lo reescribía una IA (módulo 60, gpt-5.2), y otra IA
(módulo 70) decidía los avisos a humano.

- El **módulo 60** ahora es `util:SetVariables` con fórmulas: `mensaje_limpio`, `pdf_url`,
  `pdf_filename`, `promo_img_url`, `necesita_aviso`, `motivo_aviso` y `hay_ficha`.
- Si el agente falla y su respuesta llega vacía, el cliente recibe "Disculpe, tuve un
  detalle técnico…".
- Se **eliminó el módulo 70**. Los avisos leen de `60.*`.
- **Filtros nuevos o corregidos:**
  - Módulo 38: no manda texto vacío.
  - Módulos 61 y 43: comparan `pdf_url` contra cadena vacía, en vez de usar exist.
  - **Módulo 41** (extracción de la ficha): ahora solo corre si hay ficha. Antes corría
    con cada mensaje, lo que gastaba créditos sin necesidad.
- **Prueba:** 9 casos en un escenario temporal (lista, promo, aviso, respuesta vacía, solo
  marca, ficha, tres marcas juntas, mensaje normal, PDF sin nombre). Pasaron todos.
- **Verificación:** se descargó producción y se comparó con lo probado: 0 diferencias.

## Simulación del agente 2026-11-24

Se copió el agente con el mismo prompt a un escenario aislado y se le mandaron 4
conversaciones (10 mensajes).

**Funciona bien:**
- Compra con recolección en sucursal, de principio a fin: ficha correcta, confirmación y
  datos bancarios.
- Promo del Buen Fin con imagen y lista de precios con PDF: las marcas salen bien.
- Envío a Puebla: zona regional, peso, tarifa de $155 y total correctos.
- Queja: activa el aviso a humano.

**Problemas que cuestan dinero (pendientes de decisión del dueño):**
1. **El descuento del Buen Fin se aplica de forma inconsistente.** En una compra no lo
   ofreció ($1,178 sin descuento); en otra sí (10% con tarjeta). ¿Sigue vigente el Buen Fin?
2. **No hay flujo para pagar con tarjeta.** El cliente dijo "tarjeta" y la ficha dijo
   "Transferencia bancaria", porque la plantilla lo fija así y solo existen datos de
   transferencia.
3. **La ficha no muestra el descuento:** sale el precio de lista con un total distinto.
4. La respuesta a la queja fue demasiado larga y ofrece "llamada", que el bot no puede hacer.

## Correlaciones

Proyecto: [[Lefranm-Agente-de-Ventas]]. Patrón: [[Agente-Conversacional-de-WhatsApp]].
Gemelo estructural: [[Make-Asistente-Chavarria]].
