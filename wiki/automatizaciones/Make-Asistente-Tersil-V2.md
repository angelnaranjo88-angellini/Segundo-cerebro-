---
titulo: Make · Asistente Tersil V2
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 9597789
clientes: [Tersil]
tags: [whatsapp, agente-ia, datastore, ventas]
actualizado: 2026-09-11
---

# Make · Asistente Tersil V2

> Ocho módulos: recibe el mensaje, contesta con un agente, registra al contacto para
> seguimiento y —si cerró la venta— avisa al dueño y se apaga para ese número.

Equipo 2904200 (`eu2.make.com`). Creado 2026-07-30, última edición **2026-09-11** (ver
[[#Cambio del 2026-09-11]]).

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato, hook 4318709. Conexión
`TERSIL (Tersil)`, número emisor `+52 1 55 3135 7396`.

## Flujo

1. `whatsapp-business-cloud · watchEvents2` — entra el mensaje.
2. `datastore · ExistRecord` sobre `TERSIL_Pausa_Bot` (174953) — ¿el bot está pausado para este
   número? Filtro `Solo mensajes entrantes (ignora acuses de entrega)`:
   `{{1.messages[].id}}` debe existir. Solo descarta los webhooks de estado
   (`sent`/`delivered`/`read`), que llegan con `statuses[]` y sin `messages[]`.
3. `ai-local-agent · RunLocalAIAgent` — el agente. Filtro `Bot activo (no pausado)`
   (`{{3.exist}} ≠ true`). Modelo `large` (gpt-5-mini, reasoning low), memoria por
   `threadId = wa_id`, 30 turnos de historial, conexión de IA `tersil`.
   El Input del agente **no es el texto pelón**: es una ficha técnica con todos los campos
   útiles del mensaje, incluidos los del catálogo:

   ```
   Tipo de mensaje: {{1.messages[].type}}
   Texto del cliente: {{1.messages[].text.body}}
   Claves de modelo del pedido: {{1.messages[].order.product_items[].product_retailer_id}}
   Cantidades (en el mismo orden): {{1.messages[].order.product_items[].quantity}}
   Precio unitario que muestra el catalogo: {{1.messages[].order.product_items[].item_price}}
   Nota que escribio el cliente al enviar el pedido: {{1.messages[].order.text}}
   Producto que el cliente estaba viendo: {{1.messages[].context.referred_product.product_retailer_id}}
   Boton o lista que toco: ...button_reply.title / list_reply.title / button.text
   Pie de foto o archivo: ...image.caption / video.caption / document.caption
   ```

   Los campos que no aplican llegan vacíos y el prompt ordena ignorarlos en silencio. Son rutas
   de array sin funciones IML: si el campo no viene en el bundle, se resuelve a vacío en vez de
   romper la ejecución.
4. `whatsapp-business-cloud · sendMessage` — manda al cliente
   `first(split(2.response; "[FICHA_GENERADA]"))`, o sea todo lo anterior al marcador.
5. `datastore · AddRecord` sobre `TERSIL_Seguimiento` (182352), `overwrite: true` — reinicia el
   reloj de seguimiento en cada mensaje.
6. `datastore · AddRecord` sobre `TERSIL_Pausa_Bot` — **pausa el bot**. Filtro
   `Fin del PASO 8`: `{{2.response}}` contiene `[FICHA_GENERADA]`.
7. `google-email · sendAnEmail` — correo al dueño con la ficha de compra
   (`last(split(...))`), el último mensaje enviado y las instrucciones para despausar.
8. `datastore · DeleteRecord` sobre `TERSIL_Seguimiento` — lo saca de la cola de seguimiento.

Sin routers. Una sola rama, con tres filtros que la cortan en distintos puntos.

## Persistencia

Solo Data Store, dos tablas: `TERSIL_Seguimiento` (cola, con `nombre`, `telefono`,
`ultimo_mensaje`, `ultimo_seguimiento`, `seguimientos`) y `TERSIL_Pausa_Bot` (candado por
número). **Sin Airtable.** Es el único agente del portafolio que no lo usa — ver
[[Persistencia-Airtable-vs-Data-Store]].

Nota: no hay base de datos de pedidos. El pedido existe únicamente como texto dentro de un
correo. Si se borra el correo, se borró el pedido.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 838 | 2026-09-11 |
| Operaciones | 2 981 (3.6 por ejecución) | 2026-09-11 |
| Errores | 11 (1.3%) | 2026-09-11 |
| Créditos | ~3 812 | 2026-09-11 |
| Transferencia | ~14.0 MB | 2026-09-11 |

La ruta feliz consume **5 operaciones**. Las corridas de **1 operación** son mensajes
bloqueados por el filtro de texto; las de más de 5, ventas cerradas.

## Cambio del 2026-09-11

Se abrió el escenario a los pedidos del catálogo de WhatsApp. **Tres ediciones quirúrgicas, cero
módulos nuevos, cero operaciones extra por ejecución:**

| Qué | Antes | Ahora |
|---|---|---|
| Filtro del módulo 2 | `Solo mensajes de texto` → `text.body` existe | `Solo mensajes entrantes` → `messages[].id` existe |
| Input del agente | `{{1.messages[].text.body}}` | ficha técnica con tipo, carrito, producto referido, botón y pie de foto |
| `systemPrompt` | sin nada del catálogo de WhatsApp | + PASO 2.5 (pedido del catálogo), 2.6 (consulta de producto), 2.7 (mensajes no-texto) |

Segunda edición el mismo día, tras la prueba real: la ficha pasó a mandar las claves y
cantidades por **dos rutas en paralelo** (lista A con `messages[1]`, lista B con `messages[]`)
y el PASO 2.5 se partió en dos casos según reconozca o no las claves. Ver
[[#Prueba real del 2026-09-11 y segundo ajuste]].

Además: el correo al dueño ahora imprime el carrito crudo tal como llegó (claves, cantidades,
precio del catálogo) y el tipo del último mensaje, para poder auditar sin abrir Make. Y se
corrigió la mentira del prompt sobre el seguimiento (decía 23 h, el escenario hace 10 h una
sola vez).

Se eligió **no** meter un router: el agente decide qué hacer según la ficha, así que el
escenario sigue teniendo 8 módulos y 5 operaciones por ejecución. El costo no sube.

Respaldo del estado anterior: Make guarda historial de versiones del escenario
(menú `...` → versiones anteriores).

## Problemas conocidos

- **Resuelto el 2026-09-11**: el filtro ya no descarta los carritos del catálogo, las fotos de
  comprobante, los audios ni los botones; y como el módulo 5 sí corre, el reloj de seguimiento
  se reinicia con cualquier mensaje, así que ya no puede pasar que un cliente mande su pedido y
  reciba de vuelta el recordatorio de [[Make-Tersil-Seguimiento-10h]].

## Prueba real del 2026-09-11 y segundo ajuste

Se mandó un carrito de **3 artículos ($897 estimado)** desde el catálogo de WhatsApp. Dos
hallazgos, uno bueno y uno malo.

**✅ Confirmado: Make SÍ entrega los datos del carrito.** El agente recibió un
`product_retailer_id` real. La ruta cruda funciona aunque el disparador no la mapee en su panel
— queda cerrada la incógnita que abría [[Fuente-Cuenta-Make-EU2]].

**❌ Bug: Make aplana mal la ruta de array anidada.**
`{{1.messages[].order.product_items[].product_retailer_id}}` tiene **dos niveles de `[]`**
(`messages[]` → `product_items[]`) y Make se queda con el primer elemento. De los 3 artículos
llegó 1, con cantidad 1, así que el agente cobró **$299 en vez de $807** y no aplicó el 10%.

Arreglo aplicado: se indexa explícitamente el mensaje —`1.messages[1]`— para dejar **un solo
nivel de `[]`**, que es el caso documentado de Make para arrays de colecciones. Como no se puede
confirmar sin otra prueba, la ficha manda las dos rutas en paralelo, rotuladas **lista A**
(`messages[1]`) y **lista B** (`messages[]`), y el prompt ordena usar **la que traiga más
elementos**. Así una sola prueba resuelve cuál sirve; después se borra la perdedora.

**Segunda prueba (3 artículos otra vez): la lista A también trajo uno solo.** Así que el
problema no es el número de niveles de `[]`: **Make no aplana `order.product_items` en
ninguna forma**, ni con `messages[]` ni indexando el mensaje. Es coherente con que el campo no
esté declarado en la interfaz del disparador: el `[]` se resuelve contra el esquema conocido, y
`product_items` no lo es, así que Make lo trata como un valor suelto y devuelve el primero.

**Tercer intento, el que está en producción: índices explícitos.** La ficha enumera diez líneas
fijas, `Art 1` a `Art 10`:

```
Art 1: clave={{1.messages[1].order.product_items[1].product_retailer_id}} cant={{...[1].quantity}}
Art 2: clave={{1.messages[1].order.product_items[2].product_retailer_id}} cant={{...[2].quantity}}
...
Art 10: ...
```

No depende de que Make aplane nada: pide cada posición por su número. Sin funciones IML, así
que las posiciones vacías se resuelven a vacío y el prompt las ignora. Diez posiciones sobran
para un catálogo de 8 modelos.

> [!warning] Inferencia sin verificar
> Que `product_items[2]` devuelva el segundo artículo está sin probar. Si también viene vacío,
> significa que Make **trunca los datos** en el bundle, no que falle el mapeo — y entonces el
> único camino que queda es sustituir el disparador por un **Custom Webhook**, que entrega el
> JSON crudo del Cloud API. Eso obliga a re-apuntar la URL de callback en la app de Meta.

**❌ Tercer hallazgo: las claves del catálogo son códigos automáticos de Meta.** El pedido trajo
`36hao5euls`, no `PRM-016`. El agente lo mostró tal cual al cliente, que es feo e inútil. El
prompt ahora distingue dos casos: si reconoce todas las claves confirma con el nombre del
modelo; si no reconoce alguna, **nunca enseña la clave** y confirma por piezas y total pidiendo
los nombres. La solución de fondo es una tabla de equivalencias `código de Meta → modelo` en el
prompt, que necesita los 8 IDs de contenido de Commerce Manager.

- **Pausas permanentes.** `TERSIL_Pausa_Bot` tiene 7 números pausados entre el 2026-08-01 y el
  2026-08-21, ninguno reactivado. No hay proceso ni escenario de despausa: hay que borrar el
  registro a mano. Cualquier prueba hecha con uno de esos números parece un bot roto.
- **Un solo `maxErrors: 3`** y sin DLQ (`dlq: false`), a diferencia del seguimiento.
- **Las notas de voz no se transcriben.** El flujo no tiene `getMedia` ni Whisper, así que el
  agente solo puede pedir al cliente que escriba. Es la mejora pendiente más obvia; el
  escenario apagado `Integration WhatsApp… json2video` (9668182) ya tenía el `getMedia`.
- **Datos bancarios en el `systemPrompt`** — ver [[Tersil#Notas operativas]].
- El nombre del emisor está cableado por id (`604043842799894`) en dos módulos.

## Correlaciones

Proyecto: [[Tersil-Asistente-de-Ventas]]. Cliente: [[Tersil]]. Patrón:
[[Agente-Conversacional-de-WhatsApp]]. Complemento:
[[Make-Tersil-Seguimiento-10h]]. Fuente: [[Fuente-Cuenta-Make-EU2]].

Es el primo simplificado de [[Make-Lefranm-Cosmeticos-Ventas]]: mismo negocio (vender catálogo
por WhatsApp), 8 módulos contra 22, y una octava parte de la tasa de error.
