# 🧠 Brain Dump: Finanzas App (Flutter + Drift)

Este documento es una guía de transferencia para que Claude (o cualquier otro asistente) pueda continuar con el desarrollo sin perder contexto.

## 🚀 Estado Actual
La aplicación ha completado la migración de **Mock Data** a una base de datos real impulsada por **Drift (SQLite)**. Todos los flujos críticos (Dashboard, Cuentas, Movimientos) ahora consumen streams de la base de datos.

### Infraestructura Clave
- **Base de Datos**: `lib/core/database/` (Usa Drift).
- **Servicios de Lógica**: `lib/core/logic/`.
    - `AccountService`: Maneja depósitos, retiros y pagos de tarjetas.
    - `TransactionService`: Registro de movimientos.
    - `MonthClosureService`: Lógica de cierre de mes y ciclo de deuda.
- **Providers**: `lib/core/database/database_providers.dart` (Streams reactivos).

## 🛠️ Problemas Técnicos Resueltos
1. **Error de SQLite en Android**: Se corrigió el error de `libsqlite3.so not found` añadiendo `sqlite3_flutter_libs` y un failsafe en `main.dart`. **Nota**: Si el error persiste, ejecutar `flutter clean && flutter run`.
2. **Escapado de Símbolos**: Se corrigieron errores de sintaxis en `AccountsPage` y `PeoplePage` relacionados con el carácter `$`.
3. **Migración de UI**: `HomePage` y `TransactionsPage` ahora muestran datos reales.

## 📋 Pendientes Críticos (Backlog para Claude)

### 1. Motor de Ingesta Inteligente (PDFs)
El usuario quiere que la app "desglose" los resúmenes de tarjeta de forma automática.
- **Archivos de referencia**: `CUENTAS/Resumen8abr2026.pdf` y `CUENTAS/Resumen19mar2026-1.pdf`.
- **Tarea**: Crear un servicio que use Regex o un parser de texto para identificar:
    - Fecha de transacción.
    - Descripción.
    - Monto.
- **Input**: El usuario pegará el texto del PDF o se implementará una carga de archivo.
- **Integración**: Los gastos extraídos deben impactar el balance de la tarjeta correspondiente (`visa_credit` o `mc_credit`).

### 2. Ciclo del Dinero (Logic Check)
- Validar que al "Pagar Resumen" en `AccountsPage`, el movimiento se registre correctamente en el historial.
- Asegurar que el "Presupuesto Seguro" (`safeBudget`) en el Dashboard refleje correctamente el efectivo disponible menos las deudas de TC y gastos fijos ($317.000).

### 3. Pantalla de Carga Estética
Implementar una pantalla de "Procesando Datos" cuando se haga la ingesta masiva de movimientos del PDF, con micro-animaciones premium.

## 📊 Datos del Usuario (Para el Seeder)
- **Deuda Visa**: $511.659
- **Deuda Mastercard**: $1.522.588
- **Saldo Cash ARS**: Debe derivarse de las cuentas bancarias (Nación, etc.).

## 🔧 Comandos Útiles
- Generar código: `dart run build_runner build --delete-conflicting-outputs`
- Limpieza total: `flutter clean; flutter pub get`
