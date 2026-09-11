---
titulo: Tersil — Asistente de ventas
tipo: proyecto
estado: activo
clientes: [Tersil]
tags: [whatsapp, agente-ia, ventas, catalogo]
inicio: 2026-06-17
actualizado: 2026-09-11
---

# Tersil — Asistente de ventas

> Agente de WhatsApp que atiende, cotiza con descuentos por volumen, recaba el aviso de
> privacidad, genera la ficha de compra, entrega los datos de pago y **se apaga solo** para
> dejarle la conversación al humano.

## Qué resuelve

Vender ropa de bebé de punta a punta por WhatsApp sin que nadie del negocio esté pegado al
teléfono. A diferencia de los otros agentes del portafolio, aquí el agente no filtra prospectos
para que un humano cierre: **cierra él** y solo entrega la conversación cuando ya dio los datos
de pago.

## Estado actual

Activo. Tercera generación:

| Generación | Escenario | Qué cambió | Estado |
|---|---|---|---|
| v1 | `Asistente Tersil` (9405390) | mandaba fotos de producto vía imgbb + extracción con OpenAI | apagado, 0 ejecuciones |
| v1.5 | `Asistente Tersil V2 - Catalogo PDF` (9628524) | intentó mandar el catálogo como documento PDF | apagado, 0 ejecuciones, nunca corrió |
| v2 | [[Make-Asistente-Tersil-V2]] (9597789) | dejó de mandar imágenes; todo apunta a un catálogo web | reemplazada |
| **v2.1** | [[Make-Asistente-Tersil-V2]] (9597789) | **abre el escenario a los pedidos del catálogo de WhatsApp y a todo mensaje que no sea texto** | **activo, 838 ejecuciones al 2026-09-11** |

La decisión de fondo de la v2: **sacar las imágenes del flujo**. La v1 subía fotos a imgbb y las
mandaba una por una; la v2 las reemplazó por un link único a un catálogo web. Eso bajó el
escenario de 10 paquetes a 8 y quitó la extracción estructurada por completo.

## Piezas

- [[Make-Asistente-Tersil-V2]] — el agente (8 módulos).
- [[Make-Tersil-Seguimiento-10h]] — sondeo cada 30 min, un solo recordatorio.
- Data Store `TERSIL_Seguimiento` (182352) — la cola de seguimiento.
- Data Store `TERSIL_Pausa_Bot` (174953) — el candado que apaga al bot por número.
- Catálogo web en bolt.host — fuera de Make, fuera de este repo.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 838 | 2026-09-11 |
| Operaciones | 2 981 (3.6 por ejecución) | 2026-09-11 |
| Errores | 11 (**1.3%**) | 2026-09-11 |
| Créditos | ~3 812 | 2026-09-11 |

**Es el agente conversacional más confiable del portafolio, con diferencia.** 1.3% de error
frente a 7.1%-10.1% de los otros tres. Y el más barato por ejecución: 3.6 operaciones frente a
5.0-8.4.

## Decisiones tomadas

- **Cero extracción estructurada.** No hay un solo `transformTextToStructuredData`. El agente
  escribe la ficha de compra como texto y el escenario la corta con un marcador
  (`[FICHA_GENERADA]`) usando `split()`. Es la decisión que explica el 1.3% de error: se
  eliminó la capa que rompe a los otros tres agentes.
- **Marcador de control dentro de la respuesta del modelo.** El agente añade
  `[FICHA_GENERADA]` al final; el escenario manda al cliente lo de antes del marcador y al
  dueño lo de después. Dos destinos, una sola llamada al modelo.
- **Autopausa al cerrar.** Al detectar el marcador, escribe el número en `TERSIL_Pausa_Bot` y
  el filtro de entrada lo bloquea para siempre. Elegante y peligroso a la vez: la despausa es
  manual.
- **Aviso de privacidad obligatorio** antes de pedir cualquier dato personal (PASO 5). Único
  en el portafolio.

## Resuelto el 2026-09-11

El cliente ya puede **armar su carrito en el catálogo de WhatsApp y enviar su pedido por el
chat**, y el asistente lo recibe, lo confirma con nombres de modelo, recalcula el total con el
descuento por volumen, pide los colores (que el catálogo no manda), pasa el aviso de privacidad
y cierra sin volver a preguntar lo que ya sabe. También dejó de ser ciego a fotos de
comprobante, notas de voz, ubicaciones y botones. Detalle de la edición en
[[Make-Asistente-Tersil-V2#Cambio del 2026-09-11]]; el razonamiento completo en
[[Catalogo-de-WhatsApp-en-Agentes-de-Make]].

**Probado en producción el mismo día** con tres carritos reales de 3 artículos: el último
devolvió *"Son 3 piezas, así que te toca 10% de descuento — Total: $807 MXN con envío gratis"*.

Lo único que falta para que quede impecable: las claves del catálogo de WhatsApp son **IDs
automáticos de Meta**, no las claves `PRM-`/`INV-` del prompt, así que el agente confirma el
pedido por piezas y total pero tiene que preguntarle al cliente qué modelos eligió. Se cierra
con una tabla `ID de contenido → modelo` en el prompt, que necesita los 8 IDs de Commerce
Manager.

## Pendientes y riesgos

1. **Pausas que nunca se levantan.** 7 números pausados desde agosto de 2026, ninguno
   reactivado. Cada uno es un cliente al que el bot ya no le habla.
2. **Tres copias del catálogo**: WhatsApp, bolt.host y la lista de 8 modelos dentro del prompt.
   Ahora importa más que antes: si los precios divergen, el cliente ve un número en el catálogo
   de WhatsApp y otro en la respuesta del agente. El prompt manda usar $299 siempre.
3. **Datos bancarios en el prompt.** Ver [[Tersil#Notas operativas]].
4. **Las notas de voz no se transcriben**: el agente solo puede pedir que le escriban.
5. **El seguimiento cuesta 2.5 veces más que el agente** (~9 511 créditos contra ~3 812). Ver
   [[Make-Tersil-Seguimiento-10h]].

## Correlaciones

Cuarta implementación de [[Agente-Conversacional-de-WhatsApp]] y la que rompe su tesis
principal: demuestra que **la fragilidad no viene de la IA, viene de la extracción
estructurada**. Comparar con [[Lefranm-Agente-de-Ventas]], que hace lo mismo con cuatro
extracciones y falla ocho veces más. Ver [[Patrones-Reutilizables]].
