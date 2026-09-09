---
titulo: Diagnóstico — por qué el seguimiento de Tersil no envía nada
tipo: sintesis
estado: activo
clientes: [Tersil]
tags: [make, whatsapp, datastore, debug, seguimiento]
actualizado: 2026-09-09
---

# Diagnóstico — por qué el seguimiento de Tersil no envía nada

> Revisión de [[Make-Tersil-Seguimiento-10h]] el 2026-09-09, a petición del dueño, que no
> encontraba ninguna operación exitosa de envío. **No las había.** El escenario llevaba ocho
> días corriendo en verde sin mandar un solo mensaje.
>
> **Resuelto el mismo día.** Ver «Qué se hizo» al final.

## La evidencia

| Señal | Lectura |
|---|---|
| 381 ejecuciones, todas `SUCCESS`, 0 errores | El escenario corre y no falla |
| 9 321 operaciones consumidas | Sí procesa registros |
| 42 → 51 operaciones por corrida, siempre subiendo | La cola solo crece, nunca se drena |
| 59 registros, **todos** con `seguimientos: 0` | Ningún `UpdateRecord` se ejecutó jamás |
| En todos, `ultimo_seguimiento == ultimo_mensaje`, congelado el 1–2 sep | Ningún envío se registró |

El consumo encaja exactamente con `1 (búsqueda) + N (ExistRecord)` y nada más: el flujo muere
justo en el router, antes de tocar WhatsApp.

## Causa raíz

El módulo `datastore:SearchRecord` **no devuelve los campos del registro en la raíz del
bundle**. Su interfaz real es:

```json
{ "key": "5215582907288",
  "data": { "nombre": "...", "telefono": "...", "ultimo_mensaje": "...",
            "ultimo_seguimiento": "...", "seguimientos": 0 } }
```

El escenario referencia los campos **sin el prefijo `data`**:

| Referencia usada | Valor real | Debería ser |
|---|---|---|
| `{{1.seguimientos}}` | vacío | `{{1.data.seguimientos}}` |
| `{{1.telefono}}` | vacío | `{{1.data.telefono}}` |
| `{{1.nombre}}` | vacío | `{{1.data.nombre}}` |
| `{{1.key}}` | **correcto** | — |

Las tres rutas del router comparan numéricamente `{{1.seguimientos}}` contra `0`, `1` y `>= 2`.
Con el operando vacío **ninguna de las tres condiciones se cumple jamás**, así que el router
descarta todos los registros en silencio.

Y como `{{1.key}}` sí es un campo de primer nivel, el módulo `ExistRecord` recibe una clave
válida y no falla: por eso Make reporta éxito y cero errores. **El escenario está roto de la
manera más cara posible: en verde.**

> [!warning] Contradicción con el concepto
> [[Seguimiento-por-Sondeo]] afirma «fallos típicos: ninguno observado», con 3 079 ejecuciones
> y 99.9% de fiabilidad. Ese dato sigue siendo cierto para las tres implementaciones de
> Lefranm y CUT, pero ya no describe el patrón completo: esta cuarta implementación falla al
> 100% sin levantar una sola alarma. El concepto necesita una sección de fallos.

## Los otros tres defectos

Arreglar el prefijo `data` es necesario pero **no suficiente**.

### 1. La ventana de 24 horas de WhatsApp

Meta solo permite mensajes de texto libre dentro de las 24 h posteriores al último mensaje
**del cliente**. Fuera de esa ventana solo pasan plantillas aprobadas.

| Envío | Momento | ¿Dentro de la ventana? |
|---|---|---|
| Seguimiento 1 | ~23 h | Sí, por una hora escasa |
| Seguimiento 2 | ~46 h | **No** — será rechazado |
| Seguimiento 3 | ~69 h | **No** — será rechazado |

El seguimiento 2 se dispara 23 h después del *seguimiento anterior*, no del mensaje del
cliente, así que siempre caerá fuera. Los seguimientos 2 y 3 requieren **plantillas de
marketing aprobadas** por Meta, o no existen.

### 2. Los `Ignore` ocultan los rechazos

Los tres `sendMessage` tienen `Ignore` como manejador de error. Cualquier rechazo de Meta
—incluido el `131047` de fuera de ventana— se descarta sin dejar rastro. El «0 errores» del
escenario es, literalmente, información falsa. Debería ser un `Break` o un manejador que
registre el fallo.

### 3. Se marca el contador antes de enviar

En las rutas 1 y 2 el `UpdateRecord` corre **antes** del `sendMessage`; en la ruta 3 el
`DeleteRecord` corre antes del último mensaje. Si el envío falla, el contador ya subió (o el
registro ya se borró) y ese seguimiento se pierde para siempre. El orden correcto es enviar
primero y marcar después.

## El costo

~50 operaciones cada 30 minutos, 48 veces al día: **~2 400 operaciones diarias** que no
producen nada. En ocho días van 9 321 operaciones y el número sube solo, porque cada
conversación nueva añade un registro que nunca se drena.

> [!warning] Inferencia sin verificar
> Al arreglarlo, la primera corrida encontrará de golpe los ~59 registros acumulados, todos con
> el último mensaje del cliente del 1–2 de septiembre. **Todos estarán fuera de la ventana de
> 24 h** y Meta los rechazará en bloque. Conviene vaciar o depurar `TERSIL_Seguimiento` antes
> de reactivar, para no quemar reputación del número con decenas de envíos fallidos seguidos.

## Qué se hizo (2026-09-09, 17:28 UTC)

El dueño decidió simplificar: **un solo seguimiento, a las 10 horas**. Eso disuelve el problema
de la ventana de 24 h en vez de gestionarlo, porque a las 10 h siempre se está dentro.

El escenario se reescribió entero —de 12 módulos a 4, sin router— y se renombró a
`Tersil - Seguimiento 10 h`:

| Defecto | Arreglo |
|---|---|
| `{{1.seguimientos}}` vacío | Todas las referencias pasan a `{{1.data.*}}` |
| Tres seguimientos, dos fuera de ventana | Uno solo a las 10 h; rutas 2 y 3 eliminadas |
| `Ignore` ocultaba los rechazos | `Break` con 3 reintentos y `dlq: true` |
| Se marcaba antes de enviar | `sendMessage` primero, `UpdateRecord` después |

Y se añadió un guardarraíl que no existía: el filtro exige `ultimo_mensaje > now-24h`, así que
un registro que se pase de la ventana **nunca se intenta**. Eso resolvió de paso el riesgo del
envío masivo: los 54 registros represados desde el 1 de septiembre quedaron excluidos solos, sin
tener que purgar el data store. Los 5 que sí caían dentro de la ventana entraron a la primera
corrida posterior al cambio.

### Verificado

La corrida de las **17:44 UTC** del mismo día consumió **16 operaciones en 4 774 ms** —contra
las 52 en 746 ms de la última corrida rota— y los cinco registros de la ventana pasaron a
`seguimientos: 1` con marca de tiempo escalonada de segundo en segundo. Como el `UpdateRecord`
corre después del `sendMessage`, esa marca es la prueba de que los mensajes salieron.
`dlqCount: 0`.

**Cinco mensajes enviados en la primera corrida.** Los primeros del escenario en sus nueve días
de vida.

### Lo que queda abierto

- El prompt de [[Make-Tersil-Asistente-V2]] todavía le dice al modelo que «el sistema envía
  automáticamente los mensajes de seguimiento **cada 23 horas**». Es interno —el cliente no lo
  ve— y no afecta al comportamiento, pero quedó desactualizado.
- Los 54 registros viejos siguen en el data store sin recibir nada, correctamente excluidos por
  el guardarraíl. No cuestan operaciones, pero son basura acumulada.
- La autopausa de [[Make-Tersil-Asistente-V2]] es permanente y hay registros de hace cinco
  semanas.

## Correlaciones

Ver [[Make-Tersil-Seguimiento-10h]], [[Make-Tersil-Asistente-V2]], [[Tersil]],
[[Seguimiento-por-Sondeo]] y [[Riesgos-y-Deuda-Tecnica]].
