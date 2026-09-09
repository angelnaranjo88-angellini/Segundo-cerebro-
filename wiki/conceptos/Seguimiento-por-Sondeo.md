---
titulo: Seguimiento por sondeo
tipo: concepto
estado: activo
tags: [patron, make, whatsapp, seguimiento]
actualizado: 2026-09-09
---

# Seguimiento por sondeo

> Tres módulos, cada 30 minutos, cero IA. El patrón más aburrido del portafolio y, durante
> mucho tiempo, el que parecía **el más confiable** — hasta que la cuarta implementación
> demostró que también es el que falla más callado.

## El patrón

```
[cada 1800 s]
  buscar registros pendientes  (Airtable ActionSearchRecords | Data Store SearchRecord)
     → sendMessage (WhatsApp)
     → marcar como enviado     (ActionUpdateRecords | UpdateRecord)
```

Sin webhook, sin agente, sin extracción. La base de datos es la cola y el campo de estado es
el candado que evita el doble envío.

## Dónde lo uso

| Implementación | Almacén | Ejecuciones | Errores |
|---|---|---|---|
| [[Make-Lefranm-Seguimiento-Citas]] | Data Store | 1 311 | **0** |
| [[Make-Lefranm-Seguimiento-Cosmeticos]] | Airtable | 1 308 | **0** |
| [[Make-CUT-Seguimiento-Prospectos]] | Airtable | 460 | 3 (0.65%) |
| [[Make-Tersil-Seguimiento-23h]] | Data Store | 381 | 0 reportados, **100% sin efecto** |

Las tres primeras: **3 079 ejecuciones, 3 errores**, fiabilidad del 99.9%. La cuarta reporta
cero errores y no ha enviado nada, así que el porcentaje de excepciones **no mide si el patrón
funciona**. Ver [[Diagnostico-Seguimiento-Tersil]].

## Variantes y cuándo elegir cada una

Las cuatro son el mismo escenario con distinta tabla. La única variante real es el almacén, y
esa elección la arrastra el agente que siembra los registros, no el sondeo mismo. Ver
[[Persistencia-Airtable-vs-Data-Store]].

La segunda variante, y la que trae problemas, es **cuántos recordatorios** se mandan: las tres
implementaciones sanas mandan uno; la de Tersil intenta tres y choca con la ventana de 24 h de
WhatsApp.

## Fallos típicos

> [!warning] Corrección del 2026-09-09
> Hasta hoy esta sección decía «ninguno observado». Sigue siendo cierto para las tres
> implementaciones de Lefranm y CUT (3 079 ejecuciones, 3 errores), pero
> [[Make-Tersil-Seguimiento-23h]] falla al 100% desde su creación **sin reportar un solo
> error**. La fiabilidad del patrón nunca se midió: se midió su tasa de excepciones, que es
> otra cosa.

**El fallo silencioso.** `datastore:SearchRecord` devuelve los campos del registro anidados
bajo `data`, no en la raíz del bundle: `{{1.data.seguimientos}}`, no `{{1.seguimientos}}`. Si
el filtro de la ruta compara numéricamente contra el operando equivocado, la condición nunca
se cumple, ningún registro pasa y **el escenario reporta éxito**. Ver
[[Diagnostico-Seguimiento-Tersil]].

La señal que delata este fallo no es el contador de errores sino **el consumo por corrida
creciendo de forma monótona**: si la cola se drenara, bajaría.

**La ventana de 24 h.** El patrón sirve para *un* recordatorio dentro de la ventana de servicio
de WhatsApp. Cualquier seguimiento posterior necesita plantilla aprobada por Meta. Los tres
escenarios que funcionan mandan un solo mensaje; el de Tersil intentaba tres y por eso choca.

**Marcar antes de enviar.** Si el `UpdateRecord` corre antes del `sendMessage`, un envío
fallido queda marcado como hecho. El orden correcto es enviar y luego marcar; el candado
protege contra el doble envío, no contra el cero envíos.

**El riesgo económico.** El sondeo cobra aunque no haya nada que hacer. Los cuatro escenarios
corren 48 veces al día, para siempre, hayan o no registros pendientes. Con la campaña del
colegio ya cerrada, [[Make-CUT-Seguimiento-Prospectos]] es gasto puro; el de Tersil gastó
9 321 operaciones sin enviar un mensaje.

## Correlaciones

Es la contraparte de [[Agente-Conversacional-de-WhatsApp]]. Juntos forman el ciclo completo:
el agente captura y siembra, el sondeo persigue. Ver [[Patrones-Reutilizables]].
