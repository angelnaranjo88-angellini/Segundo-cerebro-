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

**n8n** — segunda plataforma de automatización, usada en los proyectos de
[[Universidad-Marista]], [[Apcon-Escuela-de-Mecanica-Automotriz]] y
[[Salones-de-Belleza-Manuel]]. **Sin inventariar** (declarada el 2026-09-08): no hay conteo de
flujos, ni tasa de error, ni costo. Ver la advertencia en *Lo que el inventario NO ve*.

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

- **Bolt** — generación de aplicaciones web. Sin inventariar (declarado 2026-09-08).
- **Vercel** — despliegue. Cuenta `angelnaranjo88-3229's projects`, plan hobby.
- **HTML/CSS/JS a mano**, sin framework — [[Landing-Sonrisas-Dental]].
- **GitHub** — 2 repositorios visibles al corte: `Segundo-cerebro-` (este wiki) y
  `Nuevo-Proyecto-Marista`.

> [!warning] Contradicción sobre Vercel
> El inventario del 2026-09-05 registró la cuenta de Vercel **sin proyectos desplegados**,
> y de ahí salió la conclusión "infraestructura web sin usar". El 2026-09-08 el dueño declara
> tener **sitios y aplicaciones en Bolt y Vercel** para [[Universidad-Marista]],
> [[Apcon-Escuela-de-Mecanica-Automotriz]] y [[Salones-de-Belleza-Manuel]]. O los despliegues
> viven en otra cuenta o equipo de Vercel, o el inventario miró donde no era. Sin resolver.

## Lo que el inventario NO ve

> [!warning] Hay una segunda plataforma sin inventariar
> El 2026-09-08 el dueño confirmó tres clientes más —[[Universidad-Marista]],
> [[Apcon-Escuela-de-Mecanica-Automotriz]] y [[Salones-de-Belleza-Manuel]]— con aplicaciones
> y flujos de automatización construidos en **n8n, Bolt y Vercel**, fuera de Make. Todo este
> inventario se levantó desde la API de Make (ver [[Fuente-Inventario-Make]]), así que la
> frase de arriba —"es el centro de gravedad, todo vive aquí"— es cierta solo para lo que
> Make alcanza a ver.
>
> Consecuencias para las síntesis del wiki, hasta que se ingiera n8n:
> - El portafolio está **subestimado**: 3 clientes contados de 5, y ningún proyecto de esos
>   tres.
> - La conclusión "un solo proveedor de IA y un solo canal" pierde base: no sabemos qué corre
>   en n8n ni con qué modelo.
> - Las comparativas de costo y tasa de error de [[Correlacion-de-Proyectos]] y
>   [[Riesgos-y-Deuda-Tecnica]] solo describen la mitad del negocio.

## Lo que llama la atención del inventario

1. **No hay repositorio de las automatizaciones.** El activo más valioso del negocio —los 7
   escenarios en producción— vive solo dentro de Make, sin blueprints exportados ni control de
   versiones. Ver [[Riesgos-y-Deuda-Tecnica]].
2. **Un solo proveedor de IA** (OpenAI vía Make) y un solo canal (WhatsApp) **en lo que Make
   ve**. Con n8n sin inventariar, esta lectura está incompleta — ver la advertencia de arriba.
3. **La landing de [[Landing-Sonrisas-Dental]] sigue sin desplegar**, teniendo tú despliegues
   en Vercel para otros clientes.

## Correlaciones

[[Correlacion-de-Proyectos]], [[Patrones-Reutilizables]].
