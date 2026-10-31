---
titulo: Make · LEFRANM COSMETICOS CORECTA (copy)
tipo: automatizacion
estado: activo
plataforma: make
id_escenario: 5587862
clientes: [Lefranm-Cosmeticos]
tags: [whatsapp, airtable, datastore, agente-ia, ventas, pdf, google-drive]
actualizado: 2026-10-31
---

# Make · LEFRANM COSMETICOS CORECTA (copy)

> El escenario más largo del portafolio: 22 módulos para atender, calificar y registrar una
> venta de catálogo por WhatsApp.

## Disparador

`whatsapp-business-cloud / watchEvents2`, inmediato.

## Flujo

1. `watchEvents2` — entra el mensaje.
2. `airtable · ActionSearchRecords` + `airtable · upsertRecord` — identifica o da de alta al
   contacto sin duplicarlo.
3. `datastore · GetRecord` + `builtin · Resume` — estado de conversación.
4. `ai-local-agent · RunLocalAIAgent` — el agente.
5. `openai-gpt-3 · transformTextToStructuredData` ×3 — extracción de intención, producto y datos.
6. `whatsapp-business-cloud · sendMessage` + `builtin · Resume` + `builtin · BasicRouter`.
7. `sendMessage` ×2 por rama.
8. `openai-gpt-3 · transformTextToStructuredData` — una cuarta extracción.
9. `google-email · sendAnEmail` — aviso.
10. `airtable · ActionUpdateRecords` → `BasicRouter` → `ActionCreateRecord` →
    `ActionUpdateRecords` — el pedido.
11. `google-email · sendAnEmail` ×2 y `datastore · AddRecord` — cierre.

## Envío de PDFs por WhatsApp

> Corte: 2026-10-31, leído del blueprint (última edición en Make: 2026-10-20). Luis Angel
> reporta que tras su último ajuste los PDF ya llegan bien; las ejecuciones del 30–31 oct
> salieron todas en `SUCCESS`.

### Cómo viaja un PDF

1. **El agente (módulo 12)** decide mandar un archivo y escribe al final de su respuesta, en
   su propia línea, la marca `[ENVIAR_ARCHIVO: URL | nombre.pdf]`. Las URL están escritas a
   mano en el `systemPrompt`, con el formato
   `https://drive.google.com/uc?export=download&id=<ID>`.
2. **Extractor (módulo 60, `gpt-5.2`)** separa la respuesta en `mensaje_limpio` (texto sin la
   marca), `pdf_url` y `pdf_filename`.
3. **Módulo 38** manda el texto limpio.
4. **Router 90**, ruta «Hay PDF para enviar» → **módulo 61** (`sendMessage` tipo `document`).
   No manda el link de Drive tal cual: con `replace()` lo convierte en
   `https://www.googleapis.com/drive/v3/files/<ID>?alt=media&key=<API key de Google>`. Esa es
   la descarga directa que WhatsApp sí acepta (el link `uc?export=download` de Drive regresa
   una página HTML de aviso y no el PDF). Por eso el `replace` necesita que la URL del prompt
   empiece **exactamente** con `https://drive.google.com/uc?export=download&id=`.
5. **Respaldo, ruta «Lista de precios sin marca»** → **módulo 43**. Si el clasificador
   (módulo 42) detecta que el agente *dijo* que mandaba la lista de precios pero se le olvidó la
   marca (`quiere_lista = true` y no hay `pdf_url`), manda la lista según `lista_color`, con la
   **URL escrita directamente en el módulo** y la misma conversión a `googleapis.com`.

### Los PDF que hay hoy

| Documento | Variable en el prompt | Nombre que ve el cliente | ID de Drive | También en módulo 43 |
|---|---|---|---|---|
| Kit de Distribuidor Inicial | `KIT_PDF_URL` (y en la marca de ejemplo) | `Kit-Distribuidor-Inicial-Lefranm.pdf` | `1THmrKQt7_s67amVE9ptjC_bfGXdaLkNR` | no |
| Fichas técnicas (todas juntas) | `FICHAS_TECNICAS_PDF_URL` (y en la marca de ejemplo) | `Fichas-Tecnicas-Lefranm.pdf` | `1R8sErJz0sethdGPSlKiDjeJT-ZSTH1e0` | no |
| Catálogo completo | `CATALOGO_PDF_URL` | `Catalogo-Lefranm.pdf` | `1bNnhW8Z_paykFNKXOLYppF8xNlT8NWp5` | no |
| Lista Azul (público) | `LISTA_AZUL_PDF_URL` | `Lista-Precios-Azul-Lefranm.pdf` | `1T6SQKhXpbM_w05v8pCAY89nEQd1hCoxC` | **sí** (valor por defecto) |
| Lista Verde | `LISTA_VERDE_PDF_URL` | `Lista-Precios-Verde-Lefranm.pdf` | `1g7e4AnE-EMsfbOxcC0xeadmk-lxaV8Hg` | **sí** (`verde`) |
| Lista Roja | `LISTA_ROJA_PDF_URL` | `Lista-Precios-Roja-Lefranm.pdf` | `19XRzcbYiqsGX_szuwpQvq6guRTMv-mYu` | **sí** (`rojo`) |

### Checklist para cambiar un PDF

- **Atajo:** en Drive, *clic derecho → Administrar versiones → Subir nueva versión* sobre el
  archivo que ya existe conserva el **mismo ID**, y no hay que tocar nada en Make.
- Si es un archivo nuevo (ID nuevo):
  1. Compartirlo como «Cualquier persona con el enlace · Lector». Si no, la API de Drive
     regresa 403/404 y WhatsApp no recibe nada.
  2. Cambiar el ID en el `systemPrompt` del módulo 12. El Kit y las Fichas técnicas aparecen
     **dos veces** cada uno (en la variable y en la marca de ejemplo); hay que cambiar las dos.
  3. Si es una lista Azul/Verde/Roja, cambiar el ID también en el **módulo 43**. Aparece dos
     veces dentro de la fórmula (en las dos ramas del `if`). Si se olvida, el respaldo sigue
     mandando la lista vieja.
  4. Respetar el formato `https://drive.google.com/uc?export=download&id=<ID>`. Un link
     `.../file/d/<ID>/view` no lo convierte el `replace` y WhatsApp recibe una página HTML.

> [!warning] Secreto en el blueprint
> La API key de Google va escrita en texto plano dentro de las fórmulas de los módulos 61 y 43
> (no se copia aquí). Cualquiera que exporte el blueprint la ve. Conviene restringirla en Google
> Cloud a solo la Drive API, o moverla a una variable de escenario/organización de Make.

## Persistencia

Airtable para contactos y pedidos; Data Store solo para el hilo de conversación.

> [!warning] Contradicción con el blueprint actual (2026-10-31)
> El blueprint de hoy ya no tiene módulos de Airtable: usa `datastore` (GetRecord / AddRecord /
> UpdateRecord) para el contacto, su tier (`tier`, `monto_acumulado`, `fecha_limite`) y el
> pedido, más `builtin:Resume` como manejador de error después de cada módulo. La sección
> «Flujo» describe la versión del 2026-09-05; hay que volver a mapearla.

## Métricas

| Métrica | Valor | Corte |
|---|---|---|
| Ejecuciones | 769 | 2026-09-05 |
| Operaciones | 6 494 (8.4 por ejecución) | 2026-09-05 |
| Errores | 78 (10.1%) | 2026-09-05 |
| Créditos | ~8 315 | 2026-09-05 |
| Transferencia | 43.7 MB | 2026-09-05 |

## Problemas conocidos

- **Tasa de error más alta entre los agentes** (10.1%). Sospecha principal: cuatro extracciones
  estructuradas encadenadas, cada una un punto de fallo si el cliente contesta fuera de formato.
- Sufijo `(copy)` en producción: no hay rastro del original.

## Correlaciones

Proyecto: [[Lefranm-Agente-de-Ventas]]. Patrón: [[Agente-Conversacional-de-WhatsApp]].
Gemelo estructural: [[Make-Asistente-Chavarria]].
