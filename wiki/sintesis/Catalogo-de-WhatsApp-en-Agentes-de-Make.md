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

Corte: **2026-09-11**. Escenario analizado: [[Make-Asistente-Tersil-V2]] (id 9597789).

## Respuesta corta

**Sí se puede, pero hoy es imposible por tres candados independientes, y ninguno está en
WhatsApp: los tres están en el escenario de Make.**

1. Un **filtro** descarta todo lo que no sea texto plano antes de que el agente se entere.
2. El **disparador de Make no mapea** los campos del catálogo: no existe `order` ni
   `referred_product` en su salida.
3. El **módulo de envío de Make no sabe mandar** el catálogo nativo: solo soporta `list` y
   `button` como mensajes interactivos.

Y un cuarto, de diseño: el prompt del agente **nunca menciona el catálogo de WhatsApp**. Manda
siempre el catálogo web de bolt.host.

## Evidencia

### Candado 1 — el filtro "Solo mensajes de texto"

El módulo 3 de [[Make-Asistente-Tersil-V2]] lleva este filtro:

```
{{1.messages[].text.body}}  →  exists
```

Es el primer paso después del webhook. Un mensaje sin `text.body` muere ahí: el agente no
corre, no se registra al contacto para seguimiento y **el cliente no recibe nada**. Silencio,
no un error.

Los carritos enviados desde el catálogo de WhatsApp llegan con `type: "order"` y **sin**
`text.body`. Caen en este filtro.

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

### Candado 4 — el prompt manda a otro catálogo

El `systemPrompt` del agente tiene un PASO 2 explícito: cuando alguien pide catálogo, modelos o
fotos, responder **siempre** con el link de `tersil-baby-catalog-gl2r.bolt.host`, y "NUNCA
envíes imágenes, fotos ni links de imágenes individuales". El catálogo de WhatsApp no se
menciona ni una vez.

O sea: aun arreglando los candados 1-3, el agente seguiría ignorando el catálogo de WhatsApp
mientras el prompt no lo mencione.

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

## Qué hacer con esto

Tres niveles, de menos a más ambición. El 1 rinde casi todo el valor.

### Nivel 1 — dejar de callar y avisarle al agente qué tipo de mensaje llegó

Sin token de Meta, sin tocar el catálogo. Media hora de trabajo.

1. **Cambiar el filtro por un router.** En vez de "solo texto", bifurcar por
   `{{1.messages[].type}}`:
   - `text` → el flujo actual.
   - `order` → responder algo tipo *"¡Ya vi tu pedido del catálogo! Dame un momento y te
     confirmo el total 🍼"* y mandar el correo de aviso al dueño.
   - `image` → es casi siempre un comprobante de pago: acusar recibo y pasar a humano.
   - cualquier otro → acusar recibo genérico.

   Aunque no leas el contenido del carrito, **se acaba el silencio**, que es la pérdida real.

2. **Pasarle el tipo de mensaje al agente.** Hoy el Input del agente es solo
   `{{1.messages[].text.body}}`. Cambiarlo por algo como:

   ```
   [tipo: {{1.messages[].type}}] {{1.messages[].text.body}}
   ```

   y añadir al prompt una regla: *"si el tipo no es `text`, el cliente interactuó con el
   catálogo de WhatsApp; reconócelo y pide que te confirme modelos y cantidades por escrito"*.

3. **Limpiar `TERSIL_Pausa_Bot`.** Hay 7 números pausados desde agosto que nunca se
   despausaron. Un número en esa lista no recibe respuesta nunca, mandes lo que mandes — y es
   la primera cosa que confunde una prueba. Ver [[Make-Asistente-Tersil-V2#Problemas conocidos]].

### Nivel 2 — leer de verdad el carrito

Dos caminos, en este orden:

- **(a) Probar la ruta cruda.** Escribir a mano en un campo de Make
  `{{1.messages[].order.product_items[].product_retailer_id}}`. Make suele arrastrar en el
  bundle campos que no están en el panel de mapeo.
  > [!warning] Inferencia sin verificar
  > No pude comprobarlo desde la API: hace falta mandar un carrito real y mirar el bundle del
  > disparador en el historial. Si funciona, el Nivel 2 sale gratis.

- **(b) Si (a) falla, cambiar el disparador por un Custom Webhook.** El webhook genérico de Make
  entrega el JSON completo del Cloud API: `order.product_items[]` con `product_retailer_id`,
  `quantity`, `item_price` y `currency`, más `context.referred_product`. Costo: hay que
  re-apuntar la URL de callback en la app de Meta, y el `watchEvents2` actual deja de recibir.
  **Hacerlo sobre una copia del escenario**, nunca sobre el que está en producción con 838
  ejecuciones.

Este nivel es el que de verdad paga: un carrito trae SKU y cantidad **estructurados**. Hoy el
agente tiene que sacar eso de texto libre y calcular el descuento a mano — que es justo donde
falla la familia entera de agentes de este portafolio
(ver [[Agente-Conversacional-de-WhatsApp#Fallos típicos]]).

### Nivel 3 — mandar el catálogo nativo desde Make

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

Nivel 1 esta semana; Nivel 2(a) en la misma sesión, que es una prueba de cinco minutos. El
Nivel 3 solo tiene sentido si antes se decide **cuál catálogo es el canónico** — y si la
respuesta es "el de WhatsApp", entonces bolt.host pasa a ser un espejo, no una segunda verdad.

## Correlaciones

Escenario: [[Make-Asistente-Tersil-V2]]. Proyecto: [[Tersil-Asistente-de-Ventas]]. Cliente:
[[Tersil]]. Patrón: [[Agente-Conversacional-de-WhatsApp]]. Fuente de los datos:
[[Fuente-Cuenta-Make-EU2]].

El mismo problema de fondo que [[Riesgos-y-Deuda-Tecnica]] señala para Lefranm: **el catálogo
vive en un formato que el sistema no puede leer**, y el prompt paga la diferencia.
