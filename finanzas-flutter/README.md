# Fint

App de finanzas personales para Android e iOS. Control total de tus ingresos, gastos, tarjetas de credito y objetivos de ahorro.

## Funcionalidades principales

### Dashboard
- Balance hero card con vista rotativa: Disponible / Efectivo / Deuda tarjetas
- Tasa de ahorro mensual con barra de progreso
- Stats detallados: ingresos, gastos, ahorro, pendiente a recuperar
- Countdown al dia de cobro (configurable desde perfil)
- Alertas de vencimiento y cierre de tarjetas de credito
- Pago rapido de resumen con opcion de deshacer
- Listado de ultimos movimientos

### Cuentas
- Cuenta "Efectivo" creada por defecto
- Soporte para cuentas debito y tarjetas de credito
- Iconos y colores personalizables por cuenta
- Alias y CVU/CBU opcionales
- Deuda pendiente en tarjetas de credito
- Ordenamiento inteligente: efectivo primero, por saldo, tarjetas al final
- Editar y eliminar cuentas (con proteccion de cuenta default)

### Movimientos
- Registro de ingresos, gastos y transferencias
- Busqueda global desde el shell de navegacion
- Detalle de transaccion con toda la info
- Categorias con iconos y colores
- Gastos compartidos con seguimiento por persona

### Presupuestos
- Presupuestos fijos y variables por categoria
- Barra de progreso con alertas de exceso
- Empty state con CTA para crear el primero

### Objetivos de ahorro
- CRUD completo conectado a base de datos (Drift/SQLite)
- Progreso visual con barra y porcentaje
- Iconos y colores personalizables
- Fecha limite opcional
- Empty state con CTA para crear el primero

### Gastos compartidos (Personas)
- Registro de gastos compartidos
- Tracking de deudas por persona
- Calculo de "a recuperar" en el dashboard

### Wishlist
- Items con links de producto
- Cuotas y promos
- Apertura web directa

### Perfil y Settings
- Perfil de usuario: nombre, sueldo mensual, dia de cobro
- Borrado completo de base de datos con confirmacion
- Empty states mejorados en toda la app

## Stack

- **Framework:** Flutter 3.x / Dart
- **Estado:** Riverpod 2.x con generacion de codigo
- **Base de datos:** Drift (SQLite) con migraciones versionadas (v4)
- **Navegacion:** go_router con shell route y bottom navigation
- **UI:** Material 3, Google Fonts, fl_chart
- **Extras:** speech_to_text, file_picker, syncfusion_flutter_pdf

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
