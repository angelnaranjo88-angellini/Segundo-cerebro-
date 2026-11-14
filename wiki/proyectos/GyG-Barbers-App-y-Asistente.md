---
titulo: G&G Barber's — App de gestión y asistente Dante
tipo: proyecto
estado: activo
clientes: [GG-Barbers]
tags: [bolt, supabase, make, whatsapp, agente-ia, citas]
inicio: 2026-11-03
actualizado: 2026-11-14
---

# G&G Barber's — App de gestión y asistente Dante

> App de ventas, citas, inventario y reportes (Bolt + Supabase) reciclada de un cliente anterior,
> más un agente de WhatsApp ("Dante") que agenda directo en la base de la app.

## Piezas

| Pieza | Dónde | Nota |
|---|---|---|
| App web | Bolt, repo `angelnaranjo88-angellini/app-reservas` | Antes "Salón L'GREÑE"; rebrand al kit G&G |
| Base de datos | Supabase `kwygpjmziybxboselpcd` (reclamada desde Bolt) | Tablas services, products, sales, appointments, notifications |
| API del bot | Edge Function `bot-api` | Protegida con `BOT_API_KEY` (vive en Secrets de Supabase y en Make; nunca en el repo) |
| Asistente | [[Make-GyG-Asistente-Dante]] | Agente IA con 6 herramientas |
| Recordatorios | Escenario Make 7033720 | Diario 10:00 CDMX: plantilla `recordatorio_cita` (aprobada 2026-11-13) a las citas de mañana; marca `reminder_sent_at` |

## Decisiones

- **La app es la fuente de verdad, no Google Calendar.** El bot escribe en `appointments`;
  la app lo ve en tiempo real (Supabase Realtime).
- **La regla de capacidad vive en la base**: trigger `check_appointment_capacity` (máx. 2
  citas traslapadas, horario por día, domingo cerrado). Probada en Postgres local antes de
  desplegar.
- **Guardado por cita, no por lista.** La app original reescribía toda la lista de citas y
  borraba las que no tenía en pantalla; se corrigió antes de conectar el bot.
- **Notificaciones** con triggers (cita nueva/cancelada/reprogramada, stock ≤ 3) y sonido en la app.
- Base anterior vaciada con `TRUNCATE` tras reclamarla (datos del negocio previo).

## Pendientes (2026-11-14)

App publicada y mensaje prellenado de los anuncios actualizado (2026-11-14). Solo quedan los de seguridad:

- Contraseñas de la app escritas en el frontend: migrar a login real de Supabase.
- Políticas RLS abiertas a `anon` en todas las tablas: cualquiera con la llave pública puede leer.

> [!warning] Inferencia sin verificar
> El costo en créditos de Make por conversación no se ha medido; cada consulta de agenda suma
> ~3 operaciones del subescenario más el agente.

## Correlaciones

Reutiliza el patrón de [[Lefranm-Agendamiento-de-Citas]] (CRUD de citas como herramientas del
agente) sustituyendo Calendar por Supabase. Las lecciones de construcción quedaron en
[[Herramientas-de-Agente-en-Make]].
