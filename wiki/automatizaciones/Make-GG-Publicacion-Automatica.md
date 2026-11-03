---
titulo: G&G Barbers · Publicación automática FB + IG
tipo: automatizacion
estado: prototipo
clientes: [GG-Barbers]
tags: [make, google-sheets, facebook, instagram]
actualizado: 2026-11-03
---

# G&G Barbers · Publicación automática FB + IG

> Escenario de Make **6885366** que publica la campaña de inauguración de [[GG-Barbers]] en
> Facebook e Instagram a partir de una hoja de Google. Creado el 2026-11-03 tomando como base
> [[Make-CUT-Creacion-de-Contenido-Sheets]], pero **sin OpenAI**: el texto viene escrito en la hoja.

## Disparador

Cada 15 minutos. Revisa la hoja "G&G Barbers" (pestaña `Hoja 1`) y toma la primera fila sin `ESTADO`.

## Flujo

1. `google-sheets · filterRows` — primera fila con `ESTADO` vacío (las filas están en orden de fecha).
2. **Filtro**: solo sigue si `FECHA_PUBLICACION` (hora de CDMX) ya pasó.
3. `facebook-pages · CreatePostWithPhotos` — página G&G Barber's (`1451464018039847`), foto por URL.
4. `google-sheets · updateRow` — `ESTADO = PUBLICADO`, `ID_FACEBOOK`, `PUBLICADO_EL`.
5. `instagram-business · CreatePostPhoto` — @ggbarbers.mx (`17841473644530734`). Si falla, se ignora
   (Facebook ya quedó publicado y la fila marcada).
6. `google-sheets · updateRow` — `ID_INSTAGRAM`.

Imagen: `https://lh3.googleusercontent.com/d/<ID_ARCHIVO>=w1080-h1350-rj` (el sufijo `-rj` pide JPEG,
que es lo único que acepta Instagram; las imágenes originales son PNG de 1080 × 1350).

## Persistencia

Hoja de Google "G&G Barbers": columnas `N, FECHA_PUBLICACION, TEMA, URL_IMAGEN, ID_ARCHIVO, TEXTO,
ESTADO, ID_FACEBOOK, ID_INSTAGRAM, PUBLICADO_EL`. 53 filas (corte 2026-11-03).

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones de prueba | 1, sin publicar (nada vencido) | 2026-11-03 |
| Operaciones estimadas | ~100/día de revisión + 5 por publicación | 2026-11-03 |

## Problemas conocidos

> [!warning] Requiere carpeta pública
> Facebook e Instagram toman la imagen por URL. La carpeta de Drive con `Publi1…Publi55` debe estar
> compartida como "cualquiera con el enlace". Claude no tuvo permiso para compartirla; lo hace el
> humano. Sin eso, las publicaciones fallan y Make desactiva el escenario tras 3 errores.

> [!warning] Inferencia sin verificar
> El truco `=w1080-h1350-rj` para obtener JPEG desde Drive no se pudo probar desde la sesión (red
> bloqueada). Se valida con la primera publicación real.

- No hay conexión de Google Drive en Make (solo Google Sheets), por eso no se descarga el archivo
  de forma autenticada.

## Correlaciones

Deriva de [[Pipeline-de-Contenido-Social]] y de [[Make-CUT-Creacion-de-Contenido-Sheets]]; quita la
capa de IA, que concentraba casi todos los errores del entorno (ver [[Riesgos-y-Deuda-Tecnica]]).
