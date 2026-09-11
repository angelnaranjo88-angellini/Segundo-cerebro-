---
titulo: El catálogo de WhatsApp en agentes de Make
tipo: sintesis
estado: activo
clientes: [Tersil]
tags: [whatsapp, catalogo, make, agente-ia, commerce]
actualizado: 2026-09-11
---

# El catálogo de WhatsApp en agentes de Make

> **La pregunta**: ¿puede el agente de WhatsApp darse cuenta de que alguien pidió el catálogo
> —o de que mandó un carrito desde el catálogo nativo de WhatsApp— y responder sobre él?

Corte: **2026-09-11**. Escenario analizado y **ya modificado**:
[[Make-Asistente-Tersil-V2]] (id 9597789).

## Respuesta corta

**Sí se puede. Había cuatro candados y ninguno estaba en WhatsApp: los cuatro estaban en el
escenario de Make. El 2026-09-11 se abrieron los dos que bloqueaban la recepción del pedido.**

| # | Candado | Estado |
|---|---|---|
| 1 | Un **filtro** descartaba todo lo que no fuera texto plano antes de que el agente se enterara | ✅ **abierto** |
| 2 | El **disparador de Make no mapea** `order` ni `referred_product` en su panel | ✅ **abierto** — los datos llegan completos; se leen con índices explícitos |
| 3 | El **módulo de envío de Make no sabe mandar** el catálogo nativo (solo `list` y `button`) | ⛔ sigue cerrado — y resulta que no hace falta |
| 4 | El prompt **nunca mencionaba el catálogo de WhatsApp** | ✅ **abierto** |

El candado 3 no hace falta porque **el cliente ya puede abrir el catálogo por su cuenta** desde
el botón "Catálogo" del perfil de WhatsApp del negocio. Mandarlo como mensaje interactivo es
conversión extra, no un requisito para vender.

## Evidencia

### Candado 1 — el filtro "Solo mensajes de texto" *(abierto el 2026-09-11)*

El módulo 3 de [[Make-Asistente-Tersil-V2]] llevaba este filtro:

```
{{1.messages[].text.body}}  →  exists
```

Es el primer paso después del webhook. Un mensaje sin `text.body` muere ahí: el agente no
corre, no se registra al contacto para seguimiento y **el cliente no recibe nada**. Silencio,
no un error.

Los carritos enviados desde el catálogo de WhatsApp llegan con `type: "order"` y **sin**
`text.body`. Caían en este filtro.

Ahora el filtro es `{{1.messages[].id}}` → *exists*, que solo descarta los webhooks de estado
(`sent`/`delivered`/`read`, que llegan con `statuses[]` y sin `messages[]`). El costo por
mensaje descartado sigue siendo de 1 operación, igual que antes.

Rastro en las ejecuciones: la corrida normal consume **5 operaciones**; varias corridas
recientes consumieron **1 operación en ~0.4 s** (2026-09-09 19:13, 23:32 ×2 y 2026-09-07
22:04 UTC). Una sola operación significa que solo corrió el disparador — o sea, que el filtro
bloqueó. Si hubiera pasado el filtro y lo hubiera detenido la pausa del bot, serían 2.

> [!warning] Inferencia sin verificar
> Que esas cuatro corridas de 1 operación fueran carritos del catálogo es probable pero **no
> está probado**: la API de Make no expone el detalle por módulo de este escenario
> (`executions_get-detail` solo devuelve `status: SUCCESS`). Podrían ser también imágenes
> —comprobantes de pago—, stickers o audios, que caen en el mismo filtro. La forma de
> comprobarlo es mandar un carrito desde el catálogo y abrir el historial en Make.

### Candado 2 — el disparador de Make no mapea el catálogo

La salida de `whatsapp-business-cloud:watchEvents2` (verificada contra el RPC `interfaceWebhook`
de la app, 2026-09-11) expone por mensaje: `from`, `id`, `timestamp`, `type`, `text`, `image`,
`audio`, `video`, `document`, `contacts`, `sticker`, `location`, `context{from,id}`, `button` e
`interactive{list_reply, button_reply}`.

No hay:

| Campo del Cloud API | Para qué sirve | ¿Lo mapea Make? |
|---|---|---|
| `order.product_items[]` | el carrito: SKU, cantidad, precio | **No** |
| `order.catalog_id` | de qué catálogo salió | **No** |
| `context.referred_product` | qué producto estaba viendo el cliente | **No** |
| `interactive.nfm_reply` | respuestas de Flows | **No** |

Consecuencia doble:

- **Carrito** (`type: order`): ni siquiera llega al agente (candado 1).
- **Consulta de producto**: el cliente toca un producto en el catálogo y escribe "¿lo tienes en
  azul?". Eso **sí** trae `text.body`, así que pasa el filtro — pero el agente recibe la
  pregunta pelona, sin saber de qué producto habla, porque `referred_product` no está mapeado y
  el módulo solo pasa `{{1.messages[].text.body}}`. **Esto es exactamente el síntoma de "el
  asistente no lee".**

### Candado 3 — Make no puede enviar el catálogo nativo

El módulo `whatsapp-business-cloud:sendMessage` acepta `type: interactive`, pero su subtipo
solo ofrece dos opciones: **List Messages** (`list`) y **Reply Buttons** (`button`). No existe
`catalog_message`, ni `product`, ni `product_list`.

Y la app de WhatsApp en Make **no tiene módulo "Make an API Call"** (verificado: sus 11 módulos
son watchEvents2, verifiyPhoneNumber, uploadMedia, updateBusinessProfile, sendTemplateMessage,
sendMessage, registerPhoneNumber, getMedia, getBusinessProfile, enable2SVPhoneNumber,
deregisterPhoneNumber). Para mandar el catálogo nativo hay que salir por el módulo **HTTP**
contra el Graph API.

### Candado 4 — el prompt mandaba a otro catálogo *(abierto el 2026-09-11)*

El `systemPrompt` tenía un PASO 2 explícito: cuando alguien pide catálogo, modelos o fotos,
responder **siempre** con el link de `tersil-baby-catalog-gl2r.bolt.host`. El catálogo de
WhatsApp no se mencionaba ni una vez.

Ahora el prompt presenta **dos formas de ver el catálogo** —el botón "Catálogo" del perfil de
WhatsApp y el link web— y tres pasos nuevos: **PASO 2.5** (pedido llegado del catálogo),
**PASO 2.6** (consulta sobre un producto referido) y **PASO 2.7** (mensajes que no son texto).

## Contradicciones detectadas

> [!warning] Dos catálogos, dos fuentes de verdad
> El negocio tiene el catálogo **subido en WhatsApp** y además el catálogo **web en bolt.host**
> al que apunta el agente. Los precios y los modelos viven dos veces. El prompt lista 8 modelos
> con sus claves (PRM-016, PRM-062, PRM-056, PRM-067, INV-102, INV-106, INV-075, INV-084) — una
> tercera copia. Cualquier cambio de precio hay que hacerlo en tres lugares. Es el mismo patrón
> de deuda que [[Fuente-Catalogo-Lefranm]]: el catálogo vive donde no lo lee el sistema.

> [!warning] No hay confirmación de que el catálogo esté conectado al WABA
> Que los productos estén "subidos en WhatsApp" no implica que exista un catálogo de Meta
> Commerce vinculado a la cuenta de WhatsApp Business con `catalog_id`. No pude verificarlo: el
> conector de Meta disponible en este wiki es el del [[Colegio-Maria-Chavarria-Vital]] y
> devuelve cero catálogos accesibles. Sin `catalog_id` confirmado, el Nivel 3 de abajo no
> arranca.

## Lo que se hizo el 2026-09-11

Tres ediciones quirúrgicas sobre el escenario en producción. **Cero módulos nuevos, cero
operaciones extra por ejecución.** Detalle en
[[Make-Asistente-Tersil-V2#Cambio del 2026-09-11]].

1. **El filtro de entrada dejó de exigir texto.** Pasó de `text.body` existe a
   `messages[].id` existe. Ahora entra el carrito, la foto del comprobante, la nota de voz, el
   botón y la ubicación. Solo se descartan los acuses de entrega.
2. **El Input del agente dejó de ser el texto pelón.** Es una ficha técnica con tipo de mensaje,
   claves y cantidades del carrito, producto referido, botón tocado y pie de foto. Se resolvió
   con **rutas de array sin funciones IML**, que es la decisión clave: un campo ausente se
   resuelve a vacío en vez de reventar la ejecución. Ver
   [[Agente-Conversacional-de-WhatsApp#Patrón nuevo: ficha técnica como Input del agente]].
3. **El prompt aprendió a vender por el catálogo de WhatsApp.** PASO 2.5 le dice que un pedido
   es la señal de compra más fuerte que existe: empareja claves con cantidades, **recalcula el
   total él mismo con los $299 y el descuento por volumen** (nunca confía en el precio del
   catálogo, que puede estar viejo), pregunta los colores —que el carrito no manda—, pasa el
   aviso de privacidad y en el PASO 6 ya no vuelve a preguntar modelos ni cantidades.

Se descartó meter un router a propósito: **el ruteo lo hace el modelo, no el escenario.** Así
el escenario sigue en 8 módulos y 5 operaciones, y el costo no sube.

De regalo: el correo al dueño ahora imprime el carrito crudo como llegó, lo que lo convierte en
el auditor del candado 2 sin abrir Make.

## La prueba del 2026-09-11

Carrito real de **3 artículos, $897 estimado**. Tres cosas quedaron demostradas:

1. **Make sí entrega el carrito.** Llegó un `product_retailer_id` de verdad. El candado 2 está
   abierto: la ruta cruda funciona aunque el panel de mapeo no la muestre.
2. **Pero Make no aplana el array con `[]`.** De 3 artículos llegaba 1, y el agente cobró $299
   en vez de $807. Ni `messages[]` ni `messages[1]` lo arreglan: la causa es que `order` no
   existe en la interfaz del disparador, así que el `[]` se resuelve contra el esquema conocido.
   **Los datos sí vienen completos en el bundle**; se leen con índices explícitos
   (`product_items[1]`, `[2]`, `[3]`…). Confirmado al tercer intento: el mismo carrito de 3
   artículos devolvió *"Son 3 piezas — Total: $807 MXN"*.
3. **Los precios del catálogo están bien** ($897 = 3 × $299), pero **las claves no son las del
   prompt**: el pedido trajo `36hao5euls`, un ID automático de Meta. El agente se lo enseñó al
   cliente, que es feo e inútil.

**La lección transferible**: en Make, `[]` solo aplana los arrays que el módulo declara en su
interfaz. Para todo lo demás —y el catálogo de WhatsApp entra ahí— hay que pedir cada posición
por su número. Es el mismo tropiezo que espera a cualquier otro agente que lea
`order.product_items`. Ver
[[Agente-Conversacional-de-WhatsApp#Patrón nuevo: ficha técnica como Input del agente]].

## Lo que falta, y no está en Make

1. **Resolver los nombres de modelo.** Las claves del catálogo son IDs automáticos de Meta, no
   `PRM-016`. Dos salidas: (a) capturar los 8 *ID de contenido* de Commerce Manager y meter una
   tabla de equivalencias `código → modelo` en el prompt —rápido y sin tocar el catálogo—, o
   (b) reescribir los ID de contenido en Commerce Manager, que es más limpio a largo plazo pero
   cambia los artículos. Mientras tanto el agente ya no enseña claves que no reconoce: confirma
   por piezas y total, y pide los nombres. **Es lo único que separa el flujo actual de estar
   completo.**
2. **Decidir qué hacer con las 7 pausas de agosto.** Un número en `TERSIL_Pausa_Bot` no recibe
   respuesta nunca, y hoy nadie levanta las pausas. Es una decisión de negocio —¿cuándo devuelve
   el humano la conversación al bot?— no un arreglo de escenario, así que se dejó como estaba.

### Nivel 3 (opcional) — mandar el catálogo nativo desde Make

Módulo **HTTP** → `POST https://graph.facebook.com/v21.0/{phone_number_id}/messages`, con
`Authorization: Bearer <token de usuario del sistema>` y cuerpo `type: interactive`. Tres
variantes:

| Variante | `interactive.type` | Lo que necesita |
|---|---|---|
| Botón "Ver catálogo" | `catalog_message` | `action.parameters.thumbnail_product_retailer_id` |
| Un producto | `product` | `catalog_id` + `product_retailer_id` |
| Varios productos | `product_list` | `catalog_id` + secciones con `product_retailer_id` |

Requisitos previos: catálogo de Meta Commerce conectado al WABA, comercio habilitado en el
número, y que los SKU del catálogo coincidan con las claves del prompt. `catalog_message` no
está disponible en India (irrelevante para México).

> [!warning] Inferencia sin verificar
> La forma exacta del JSON está tomada de documentación de terceros y de memoria: el proxy de
> red de esta sesión bloquea `developers.facebook.com` y `docs.360dialog.com`. Verificar contra
> la referencia de Meta antes de construirlo.

El token es lo delicado: **no va escrito en el escenario ni en este repo.** Guardarlo como
variable de entorno del equipo de Make o en una conexión dedicada.

## Recomendación

El Nivel 3 solo tiene sentido si antes se decide **cuál catálogo es el canónico** — y si la
respuesta es "el de WhatsApp", entonces bolt.host pasa a ser un espejo, no una segunda verdad.
Mientras haya tres copias de los precios (WhatsApp, bolt.host y el prompt), cada cambio de
precio es tres ediciones y una contradicción en potencia.

## Correlaciones

Escenario: [[Make-Asistente-Tersil-V2]]. Proyecto: [[Tersil-Asistente-de-Ventas]]. Cliente:
[[Tersil]]. Patrón: [[Agente-Conversacional-de-WhatsApp]]. Fuente de los datos:
[[Fuente-Cuenta-Make-EU2]].

El mismo problema de fondo que [[Riesgos-y-Deuda-Tecnica]] señala para Lefranm: **el catálogo
vive en un formato que el sistema no puede leer**, y el prompt paga la diferencia.
