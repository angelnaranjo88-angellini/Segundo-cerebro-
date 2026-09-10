---
titulo: Sacapuntos — lealtad para papelería
tipo: proyecto
estado: prototipo
clientes: []
tags: [web, app, lealtad, papeleria, html, prototipo]
inicio: 2026-09-10
actualizado: 2026-09-10
---

# Sacapuntos — lealtad para papelería

> Sistema de puntos para una papelería: se captura el ticket, el total se convierte en puntos
> y los puntos se canjean por premios. Al 2026-09-10 existe solo la pantalla principal.

## Qué resuelve

Una papelería vende barato y repetido: cuadernos, plumas, copias, papel bond. El cliente
vuelve cada semana pero no hay ninguna razón para que vuelva **a esta** papelería y no a la
de enfrente. El programa de puntos convierte esa recurrencia en un saldo que el cliente no
quiere perder.

La regla es deliberadamente simple para que la entienda quien está en la caja y quien está
del otro lado del mostrador: **$10 de compra = 1 punto**, con multiplicador opcional por
temporada. Los puntos vencen a 12 meses.

## Estado actual

Prototipo. Una sola pantalla, sin backend, sin persistencia: el estado vive en memoria y se
pierde al recargar. Sirve para decidir el alcance, no para operar.

- Fuente: `apps/sacapuntos/dashboard.html` (HTML + CSS + JS a mano, sin framework ni build).
- Publicado como artefacto para revisión:
  <https://claude.ai/code/artifact/97bff3b8-9e09-4224-afd6-22531060acc0>

> [!warning] Todas las cifras de la pantalla son inventadas
> Los 184,260 puntos en circulación, los 58 tickets del día, las 8 semanas de la gráfica y los
> seis clientes del padrón son datos de ejemplo escritos para poblar la interfaz. No salen de
> ningún negocio real. La pantalla lo dice en un aviso propio para que nadie los cite.

## Piezas

Módulos incluidos en la v1:

| Módulo | Qué hace |
|---|---|
| Captura de ticket | Folio, total y promoción; aplica la regla y abona puntos |
| Clientes | Padrón con saldo, nivel y antigüedad; identificación por teléfono |
| Premios | Catálogo con costo en puntos y existencias por sucursal |
| Canje | Descuenta del saldo y deja rastro del movimiento |
| Movimientos | Bitácora de cada abono y cada canje |
| Reglas de puntos | Pesos por punto, multiplicadores y vigencia |

Dejados fuera a propósito: app del cliente, multisucursal real, referidos y cumpleaños,
lectura automática del ticket (OCR).

Niveles del cliente, por saldo acumulado: **Lápiz** (<500), **Pluma** (500–1499),
**Plumón** (≥1500).

## Decisiones tomadas

- **Sin framework.** Igual que en [[Landing-Sonrisas-Dental]]: una pantalla que se abre en
  cualquier navegador y no necesita build. Si el proyecto avanza a backend, la decisión se
  revisa; hoy no la necesita.
- **El indicador principal es el pasivo, no las ventas.** La cifra que encabeza el panel es
  *puntos en circulación* y su equivalente en pesos, porque un programa de lealtad es deuda:
  cada punto emitido es un premio que se deberá entregar.
- **Teléfonos enmascarados en la interfaz** (`••••3471`). El padrón vive en la base; la
  pantalla solo muestra los últimos cuatro dígitos. Consistente con la regla 5 de [[CLAUDE]].
- **Azul y naranja**, por indicación del dueño. El azul carga la marca y la estructura; el
  naranja se reserva para una sola cosa: los puntos.

## Pendientes y riesgos

> [!warning] Inferencia sin verificar
> No hay una papelería cliente detrás de este proyecto. Nació como ejercicio de diseño el
> 2026-09-10 y el negocio destino está sin definir. Todo lo que sigue son preguntas abiertas,
> no requisitos levantados con un cliente.

Tres decisiones de negocio que faltan antes de escribir backend:

1. **¿$10 = 1 punto es el tipo de cambio correcto?** Con el catálogo de premios propuesto,
   cada punto cuesta alrededor de $0.10 en premio. Eso significa regalar ~1% de la venta.
2. **¿Se acumula en mayoreo?** Escuelas y revendedores compran en miles de pesos. Si acumulan
   igual que el cliente de mostrador, dos cuentas se llevan el programa entero.
3. **¿Vigencia a 12 meses o a fin de ciclo escolar?** La segunda es más natural para una
   papelería y concentra los canjes fuera de temporada alta, que es justo cuando conviene.

Riesgos técnicos: sin persistencia, sin autenticación de cajero y sin cierre de caja. Los
tres son obligatorios antes de cualquier piloto.

> [!warning] Decisión de esquema pendiente de confirmar
> El código vive en `apps/sacapuntos/`, una cuarta carpeta fuera de las tres capas que define
> [[CLAUDE]] (`fuentes-crudas/`, `wiki/`, esquema). Se eligió eso antes que perder la fuente,
> pero el esquema es propiedad compartida: confirmar o mover. Alternativa: repositorio aparte,
> como [[Landing-Sonrisas-Dental]].

## Correlaciones

- **Es el segundo proyecto puramente web del portafolio**, junto a
  [[Landing-Sonrisas-Dental]]. Los dos son HTML plano sin desplegar; los dos comparten el
  mismo riesgo, que es quedarse en prototipo.
- **Es el primero que no es un agente de WhatsApp.** Todo lo demás vivo —
  [[Lefranm-Agente-de-Ventas]], [[Asistente-Chavarria]],
  [[CUT-Captacion-de-Prospectos]] — cabe en el patrón de
  [[Agente-Conversacional-de-WhatsApp]]. Este no: es una interfaz de mostrador, operada por un
  humano, sin modelo de lenguaje de por medio. Eso lo vuelve barato de operar (cero créditos de
  Make, cero llamadas a IA) y lo pone fuera del 88.6% del gasto que documenta
  [[Riesgos-y-Deuda-Tecnica]].
- **Pero el canal de consulta obvio ya está construido.** "¿Cuántos puntos tengo?" es
  exactamente la pregunta que resuelve un agente de WhatsApp con
  [[Persistencia-Airtable-vs-Data-Store]] detrás. Si el saldo se guarda en Airtable, consultar
  puntos por WhatsApp es un escenario de tres módulos — el mismo patrón de
  [[Seguimiento-por-Sondeo]] — y no una funcionalidad nueva.
- **Encaja como quinta pieza del paquete de cliente nuevo** de [[Patrones-Reutilizables]], en
  la variante de comercio con mostrador en vez de negocio con citas.
