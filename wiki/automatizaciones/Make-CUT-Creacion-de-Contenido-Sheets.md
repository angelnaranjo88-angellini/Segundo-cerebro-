---
titulo: Make · CUT - CREACION DE CONTENIDO POR FOTO (GOOGLE SHEETS)
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 6077792
clientes: [Colegio-Maria-Chavarria-Vital]
tags: [contenido, sheets, facebook, instagram, vision]
actualizado: 2026-09-05
---

# Make · CUT - CREACION DE CONTENIDO POR FOTO (GOOGLE SHEETS)

> Todos los días a las 06:00: siguiente foto pendiente de la hoja → copy con visión IA →
> publicación en Facebook e Instagram → hoja actualizada con los ids de post.

## Disparador

Programado: **diario a las 06:00**. No hay webhook.

## Flujo

1. `google-sheets · filterRows` — busca la siguiente fila con `ESTADO` pendiente.
2. `http · ActionGetFile` — descarga la imagen desde su URL de Drive.
3. `openai-gpt-3 · analyzeImages` — visión: describe la imagen y redacta el copy.
4. `builtin · BasicRouter` — bifurca por red social.
5. `facebook-pages · CreatePostWithPhotos` — publica en la página `109847578307070`.
6. `google-sheets · updateRow` — marca `PUBLICADO` y guarda `ID_POST_FACEBOOK`.
7. `instagram-business · CreatePostPhoto` — publica en Instagram.

## Persistencia

**La hoja de Google es la base de datos**: cola de trabajo, texto generado y bitácora de ids
en el mismo lugar. Ver [[Fuente-Hoja-CUT-Fotos]].

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 13 | 2026-09-05 |
| Operaciones | 63 | 2026-09-05 |
| Errores | **6 (46.2%)** | 2026-09-05 |
| Créditos | ~63 | 2026-09-05 |
| Transferencia | 5.1 MB | 2026-09-05 |

## Problemas conocidos

- **46% de fallo.** La tasa más alta del portafolio. Hipótesis a verificar, por orden de
  sospecha: la descarga HTTP de URLs de Drive (`/view?usp=sharing` no es una URL de descarga
  directa), y los requisitos de formato de imagen de Instagram Business.
  Es el diagnóstico pendiente número uno. Ver [[Riesgos-y-Deuda-Tecnica]].

## Correlaciones

Proyecto: [[CUT-Contenido-Social]]. Patrón y genealogía completa:
[[Pipeline-de-Contenido-Social]].
