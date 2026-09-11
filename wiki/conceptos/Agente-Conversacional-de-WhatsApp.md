---
titulo: Agente conversacional de WhatsApp
tipo: concepto
estado: activo
tags: [patron, whatsapp, agente-ia, make]
actualizado: 2026-09-11
---

# Agente conversacional de WhatsApp

> El patrón central del portafolio. Lo has implementado **cuatro veces en producción** y otras
> seis en prototipos abandonados.

## El patrón

```
watchEvents2 (WhatsApp)
   → [recuperar estado: GetRecord + Resume]
   → RunLocalAIAgent  (decide la intención)
   → transformTextToStructuredData  (normaliza los datos)
   → [acción de negocio: Calendar / Airtable / Data Store]
   → BasicRouter  (bifurca por resultado)
   → sendMessage (WhatsApp)  +  sendAnEmail (aviso interno)
   → persistir
```

La pieza que lo hace funcionar es `RunLocalAIAgent`: en las tres implementaciones vivas
sustituyó a las cadenas de `messageAssistantAdvanced` y `CreateCompletion` de los prototipos
de 2025-2026. Menos módulos, menos puntos de fallo, decisión centralizada.

## Dónde lo uso

| Implementación | Módulos | Ops/ejec. | Error | Estado |
|---|---|---|---|---|
| [[Make-Lefranm-Citas]] | 20 | 6.9 | 7.6% | El más completo |
| [[Make-Lefranm-Cosmeticos-Ventas]] | 22 | 8.4 | 10.1% | El más largo y frágil |
| [[Make-Asistente-Chavarria]] | 15 | 5.0 | 7.1% | El más eficiente |
| [[Make-Asistente-Tersil-V2]] | 8 | 3.6 | **1.3%** | El más simple y el más confiable |

Los tres primeros están en el equipo 1436402; Tersil vive en otra cuenta, ver
[[Fuente-Cuenta-Make-EU2]]. Cortes: 2026-09-05 los tres primeros, 2026-09-11 Tersil.

Prototipos apagados que lo intentaron: `Agendamiento` (3678657), `air table` (3620443),
`Integration WhatsApp Business Cloud` (4535198), `Asistente Tersil` v1 (9405390),
`Asistente Tersil V2 - Catalogo PDF` (9628524). Ver [[Escenarios-Inactivos]].

## Variantes y cuándo elegir cada una

- **Con memoria de conversación** (`GetRecord` + `Resume`): Lefranm ×2. Necesaria cuando el
  flujo pide varios datos en turnos distintos (fecha, hora, servicio).
- **Sin memoria**: [[Make-Asistente-Chavarria]]. Válido si cada mensaje se resuelve solo, pero
  hoy es una limitación, no una decisión.
- **Una extracción vs. cuatro vs. ninguna**: Chavarría usa una; Lefranm-Ventas usa cuatro y
  tiene 40% más error relativo; [[Make-Asistente-Tersil-V2]] no usa ninguna y falla 1.3%. Con
  tres puntos la correlación ya no es sugerente: es la variable que manda.
- **Marcador en la respuesta en vez de extracción**: Tersil consigue dos destinos (cliente y
  dueño) de una sola llamada al modelo pidiéndole que escriba `[FICHA_GENERADA]` y cortando con
  `split()`. Es la alternativa barata a `transformTextToStructuredData` cuando lo único que
  necesitas es partir la respuesta, no estructurarla.

## Fallos típicos

Tres de los cuatro agentes fallan entre 7% y 10% de las veces, mientras que los sondeos sin IA
del mismo entorno fallan entre 0% y 0.65%.

> [!warning] Hallazgo corregido el 2026-09-11
> Esta página afirmaba que **"la fragilidad está en la capa de IA"**. La ingesta de
> [[Fuente-Cuenta-Make-EU2]] la desmiente: [[Make-Asistente-Tersil-V2]] usa un modelo en cada
> ejecución y falla **1.3%**. Lo que separa al 1.3% del 10% no es la presencia de IA, es
> `transformTextToStructuredData`: los tres agentes frágiles encadenan entre una y cuatro
> extracciones estructuradas; el confiable no usa ninguna.
> Enunciado nuevo: **la fragilidad está en la extracción estructurada, no en la IA.**
> [[Riesgos-y-Deuda-Tecnica]] calcula sus porcentajes con el enunciado viejo y hay que
> recalcularlos.

Segundo fallo típico, invisible en las métricas porque no genera error: **el filtro de entrada
que descarta lo que no es texto**. El escenario termina "con éxito" en una operación y el
cliente no recibe nada. Ver [[Catalogo-de-WhatsApp-en-Agentes-de-Make]].

## Patrón nuevo: ficha técnica como Input del agente

Nacido al arreglar [[Make-Asistente-Tersil-V2]] el 2026-09-11 y **aplicable a los otros tres
agentes tal cual**.

En vez de filtrar por `text.body` y pasarle al agente el texto pelón, se filtra solo por
`{{1.messages[].id}}` —que descarta los acuses de entrega y nada más— y el Input se convierte
en una ficha con todos los campos útiles del mensaje:

```
Tipo de mensaje: {{1.messages[].type}}
Texto del cliente: {{1.messages[].text.body}}
Claves de modelo del pedido: {{1.messages[].order.product_items[].product_retailer_id}}
Cantidades (en el mismo orden): {{1.messages[].order.product_items[].quantity}}
Producto que estaba viendo: {{1.messages[].context.referred_product.product_retailer_id}}
Boton o lista que toco: {{1.messages[].interactive.button_reply.title}}...
```

Tres razones por las que funciona:

1. **El ruteo lo hace el modelo, no el escenario.** Cero módulos nuevos, cero routers, cero
   operaciones extra. Sigue costando 5 operaciones por ejecución.
2. **No puede romper.** Son rutas de array sin funciones IML: un campo ausente se resuelve a
   vacío, no a error. Nada de `map()` ni `if()`, que sí revientan sobre un `undefined`.
3. **Para los arrays no declarados, índices explícitos.** Este es el hallazgo que más caro
   costó: `{{1.messages[].order.product_items[].product_retailer_id}}` devuelve **un solo
   elemento**, no la lista. Indexar el mensaje (`messages[1]`) tampoco arregla nada. La causa
   es que `order` **no existe en la interfaz del disparador**, así que Make resuelve el `[]`
   contra el esquema que conoce y se queda con el primero. Los datos **sí están completos en el
   bundle**: se leen pidiendo cada posición por su número.

   ```
   Art 1: clave={{1.messages[1].order.product_items[1].product_retailer_id}} cant={{...[1].quantity}}
   Art 2: clave={{1.messages[1].order.product_items[2].product_retailer_id}} cant={{...[2].quantity}}
   ... hasta Art 10
   ```

   Diez posiciones fijas, las vacías se ignoran. Regla general: **`[]` solo aplana lo que el
   módulo declara; para lo demás, índices.** Evita el Iterator + Text Aggregator, que obligaría
   a un router y a duplicar toda la cola del escenario. Probado en
   [[Make-Asistente-Tersil-V2#Prueba real del 2026-09-11 y segundo ajuste]] — tres intentos y
   un pedido de 3 piezas cobrado como 1 en el camino.
4. **Degrada con gracia.** Si algún dato no llega, el agente igual sabe que llegó un pedido y
   lo pide por escrito. El cliente queda atendido en los dos casos.

El precio a pagar es una regla dura en el prompt: la ficha es interna, nunca se menciona, y los
campos vacíos se ignoran en silencio.

## Correlaciones

[[Seguimiento-por-Sondeo]] es su complemento obligatorio: el agente siembra, el sondeo cosecha.
[[Correlacion-de-Proyectos]].

Los cuatro comparten además un límite de plataforma: ninguno puede leer ni enviar el catálogo
nativo de WhatsApp, porque los módulos de Make no lo mapean. Ver
[[Catalogo-de-WhatsApp-en-Agentes-de-Make]].
