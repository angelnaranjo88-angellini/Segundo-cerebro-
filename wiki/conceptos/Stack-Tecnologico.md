---
titulo: Stack tecnológico
tipo: concepto
estado: activo
tags: [stack, herramientas, inventario]
actualizado: 2026-09-08
---

# Stack tecnológico

> Todo lo que sostiene el portafolio, al corte 2026-09-05.

## Orquestación

**Make** (`us2.make.com`) — organización `My Organization` (5357289), equipo `My Team`
(1436402). 22 escenarios: 7 activos, 15 apagados. Es el centro de gravedad: no hay servidores,
no hay código de backend, todo vive aquí.

## Capa de IA

| Módulo | Uso | Dónde |
|---|---|---|
| `ai-local-agent · RunLocalAIAgent` | Decisión de intención | Los 3 agentes vivos |
| `openai-gpt-3 · transformTextToStructuredData` | Extracción de datos | Los 3 agentes vivos |
| `openai-gpt-3 · analyzeImages` | Visión → copy publicitario | Pipeline de contenido |
| `openai-gpt-3 · GenerateImage` / `editImage` | Generación de imagen | Solo prototipos apagados |
| `knowledge · KnowledgeStandAlone` | RAG nativo de Make | Probado una vez, abandonado |

## Canales

- **WhatsApp Business Cloud** — el canal principal. Disparador de 11 de los 22 escenarios.
- **Facebook Pages** e **Instagram Business** — publicación.
- **Gmail** — avisos internos.
- **Meta Ads** — una cuenta: `1258701508163147` "Bachillerato Maria Chavarria" (MXN, activa,
  con método de pago, presupuesto diario mínimo $17.01 MXN).

## Datos

- **Airtable** — contactos, prospectos, pedidos.
- **Data Store de Make** — estado de conversación y citas de Lefranm.
- **Google Sheets** — cola de publicación de contenido.
- **Google Calendar** — citas.
- **Google Drive** — creatividades, catálogos, PDFs.

Ver la tensión entre los dos primeros en [[Persistencia-Airtable-vs-Data-Store]].

## Web

- **HTML/CSS/JS a mano**, sin framework — [[Landing-Sonrisas-Dental]].
- **Vercel** — cuenta `angelnaranjo88-3229's projects`, plan hobby, **sin proyectos
  desplegados** al corte.
- **GitHub** — 2 repositorios: `Segundo-cerebro-` (este wiki) y `Nuevo-Proyecto-Marista`.

## Lo que el inventario NO ve

> [!warning] Hay una segunda plataforma sin inventariar
> El 2026-09-08 el dueño confirmó tres clientes más —**Universidad Marista**, **Apcon
> (Escuela de Mecánica Automotriz)** y **Salones de Belleza Manuel**— cuyos proyectos están
> construidos **fuera de Make**, en otra plataforma todavía sin nombrar. Todo este inventario
> se levantó desde la API de Make (ver [[Fuente-Inventario-Make]]), así que la frase de arriba
> —"es el centro de gravedad, todo vive aquí"— es cierta solo para lo que Make alcanza a ver.
> Falta ingerir esa plataforma: sin ella, el wiki subestima el portafolio y no puede decir
> cuánto del negocio depende de un único proveedor.

## Lo que llama la atención del inventario

1. **No hay repositorio de las automatizaciones.** El activo más valioso del negocio —los 7
   escenarios en producción— vive solo dentro de Make, sin blueprints exportados ni control de
   versiones. Ver [[Riesgos-y-Deuda-Tecnica]].
2. **Un solo proveedor de IA** (OpenAI vía Make) y un solo canal (WhatsApp). Concentración
   alta, y en el canal es deliberado y correcto para el mercado.
3. **Infraestructura web sin usar**: Vercel vacío mientras hay una landing sin desplegar.

## Correlaciones

[[Correlacion-de-Proyectos]], [[Patrones-Reutilizables]].
