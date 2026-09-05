---
titulo: Hoja "CUT - FOTOS PARA PUBLICAR"
tipo: fuente
estado: activo
origen: Google Drive · hoja de cálculo · id 1QnLRGRkiScFFGnBBVPwjZTu3TcCXtYQGMrfZUcc8jwE
fecha_ingesta: 2026-09-05
tags: [cut, contenido, sheets, cola]
actualizado: 2026-09-05
---

# Hoja "CUT - FOTOS PARA PUBLICAR"

> La cola de publicación del colegio. Es a la vez backlog, bitácora y base de datos del
> pipeline de contenido.

## Resumen

Hoja creada el 2026-08-28, modificada por última vez el 2026-09-04. Estructura:

| Columna | Contenido |
|---|---|
| `URL_IMAGEN` | Enlace de Drive a la creatividad |
| `ESTADO` | `PUBLICADO` / pendiente — el filtro del escenario |
| `FECHA_PUBLICACION` | Fecha y hora del posteo |
| `TEXTO_GENERADO` | El copy que escribió la IA |
| `ID_POST_FACEBOOK` | Id devuelto por Facebook (`109847578307070_…`) |
| `ID_POST_INSTAGRAM` | Id devuelto por Instagram |

## Ideas clave

**El copy generado tiene dos mitades.** La primera —encabezado, gancho, descripción de la
imagen— la escribe la IA y varía en cada publicación. La segunda es un bloque fijo de contacto
(dirección, teléfono, horario, sitio, hashtags `#SomosLeonesTláhuac`, `#InscripcionesAbiertas`)
idéntico en todas. Escribir la parte fija en el prompt en vez de plantilla es gasto de tokens
innecesario en cada ejecución.

**La cadencia es diaria y la campaña tenía fecha dura**: publicaciones observadas del 28 al 31
de agosto de 2026, todas girando alrededor del cierre de inscripciones del 4 de septiembre y
el inicio de clases del 7 de septiembre.

## Qué páginas actualizó esta ingesta

[[CUT-Contenido-Social]], [[Make-CUT-Creacion-de-Contenido-Sheets]],
[[Colegio-Maria-Chavarria-Vital]], [[Pipeline-de-Contenido-Social]].

## Preguntas que abre

- Las `URL_IMAGEN` tienen forma `https://drive.google.com/file/d/<id>/view?usp=sharing`, que
  **no es una URL de descarga directa**. Es la hipótesis principal del 46% de error del
  escenario. Verificar contra el detalle de ejecuciones.
- Cerrada la campaña 2026, ¿qué alimenta la cola ahora? Sin contenido nuevo, el escenario corre
  cada mañana sobre una hoja sin pendientes.
