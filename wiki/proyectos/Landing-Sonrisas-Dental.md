---
titulo: Landing — Sonrisas para todos nosotros
tipo: proyecto
estado: prototipo
clientes: [Sonrisas-Para-Todos-Nosotros]
tags: [web, landing, html, dental]
inicio: 2026-09-04
actualizado: 2026-09-05
---

# Landing — Sonrisas para todos nosotros

> Landing page estática de una clínica dental. Un solo commit, sin desplegar, sin
> automatización detrás.

## Qué resuelve

Presencia web y captación de citas para la clínica. Por ahora solo la mitad presentación: la
captación no está conectada a nada.

## Estado actual

Prototipo. Repositorio
[Nuevo-Proyecto-Marista](https://github.com/angelnaranjo88-angellini/Nuevo-Proyecto-Marista),
commit único `92789f4` del 2026-09-04.

Stack: HTML + CSS + JS a mano, sin framework ni dependencias.

| Archivo | Líneas |
|---|---|
| `index.html` | 420 |
| `css/styles.css` | 551 |
| `js/script.js` | 83 |

Secciones: héroe ("Una sonrisa sana empieza con una cita"), servicios, propuesta de valor,
testimonios, preguntas frecuentes y cierre.

## Piezas

- Repositorio Git (rama única).
- Sin despliegue: la cuenta de Vercel (`angelnaranjo88-3229's projects`, plan hobby) **no tiene
  ningún proyecto** al corte 2026-09-05.

## Decisiones tomadas

- **Sin framework.** Para una landing de una página es la decisión correcta: se despliega en
  cualquier hosting estático sin build.

## Pendientes y riesgos

> [!warning] Nombre del repositorio inconsistente
> `Nuevo-Proyecto-Marista` contiene una clínica dental. Sin resolver — ver
> [[Sonrisas-Para-Todos-Nosotros]].

- Sin desplegar. Existe cuenta de Vercel vacía y lista.
- El botón de "agenda tu cita" no lleva a ningún sistema de citas, cuando ya tienes uno en
  producción para otro cliente.

## Correlaciones

El eslabón que falta ya está construido: [[Lefranm-Agendamiento-de-Citas]] hace exactamente
lo que esta landing promete. Conectar la landing a ese patrón es el paso obvio y es la
recomendación principal de [[Patrones-Reutilizables]].
