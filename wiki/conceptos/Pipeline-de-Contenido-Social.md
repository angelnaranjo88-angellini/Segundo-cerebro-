---
titulo: Pipeline de contenido social
tipo: concepto
estado: activo
tags: [patron, contenido, vision, facebook, instagram]
actualizado: 2026-09-05
---

# Pipeline de contenido social

> Seis escenarios en diez meses persiguiendo la misma idea: que una imagen se convierta sola
> en una publicación. Cinco murieron; el sexto corre todos los días.

## El patrón

```
[origen de la imagen]
   → analyzeImages (visión IA: describe y redacta el copy)
   → BasicRouter
   → CreatePostWithPhotos (Facebook)  +  CreatePostPhoto (Instagram)
   → registrar el id del post
```

## Genealogía

| Gen. | Escenario | Fecha | Origen de la imagen | Destino | Vivió |
|---|---|---|---|---|---|
| 1 | Automatización de redes sociales (instagram) | 2026-01 | Generada por IA (`GenerateImage`) | Instagram | No |
| 2 | Creacion de contenido automatica | 2026-02 | Foto por WhatsApp | Facebook | No |
| 2b | Creacion de contenido automatica Calpitas | 2026-05 | Foto por WhatsApp | Facebook | No, inválido |
| 3 | Publicacion multi-canal / Reutilizacion | 2026-05 | Foto por WhatsApp | FB + IG | No |
| 3b | CREACION DE CONTENIDO POR FOTO / POR MENSAJE | 2026-05→08 | WhatsApp + `editImage` | Facebook | 2 ejecuciones |
| **4** | **[[Make-CUT-Creacion-de-Contenido-Sheets]]** | **2026-08** | **Hoja de Google, programado** | **FB + IG** | **Sí** |

## El salto que lo hizo funcionar

Las generaciones 1 a 3 se disparaban **por mensaje de WhatsApp**: dependían de que un humano
mandara la foto en el momento oportuno. Ninguna acumuló ejecuciones.

La generación 4 invierte el control: **el contenido se planea antes en una hoja y el escenario
lo publica solo a las 06:00**. El humano dejó de ser el disparador y pasó a ser el editor de
la cola. Eso es lo que la mantuvo viva.

Es el mismo principio que hace que [[Seguimiento-por-Sondeo]] sea el patrón más confiable del
portafolio: **quitar al humano del camino crítico y poner una cola en su lugar.**

## Fallos típicos

La generación 4 falla el 46% de las veces. Ver [[Make-CUT-Creacion-de-Contenido-Sheets]] para
las hipótesis. El patrón funciona; la implementación aún no está estable.

## Correlaciones

[[CUT-Contenido-Social]], [[Escenarios-Inactivos]], [[Patrones-Reutilizables]].
