import 'package:equatable/equatable.dart';

enum AccountType {
  cash,      // efectivo
  bank,      // cuenta bancaria
  credit,    // tarjeta de crédito
  savings,   // caja de ahorro
  investment, // inversión
}

class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currencyCode;
  final String? color;       // hex color
  final String? icon;
  final bool isDefault;

  // Para tarjetas de crédito
  final double? creditLimit;
  final int? closingDay;     // día de cierre
  final int? dueDay;         // día de vencimiento
  
  // Tracking para Cierre de Mes
  final double pendingStatementAmount; // Deuda del resumen anterior
  final DateTime? lastClosedDate;

  // Banking
  final String? alias;
  final String? cvu;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currencyCode = 'ARS',
    this.color,
    this.icon,
    this.isDefault = false,
    this.creditLimit,
    this.closingDay,
    this.dueDay,
    this.pendingStatementAmount = 0.0,
    this.lastClosedDate,
    this.alias,
    this.cvu,
  });

  bool get isCreditCard => type == AccountType.credit;

  double get availableCredit =>
      isCreditCard ? (creditLimit ?? 0) - balance : balance;
  
  /// Total que se debe (Gasto actual + Resumen pendiente de pago)
  double get totalDebt => isCreditCard ? balance + pendingStatementAmount : 0.0;

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currencyCode,
    String? color,
    String? icon,
    bool? isDefault,
    double? creditLimit,
    int? closingDay,
    int? dueDay,
    double? pendingStatementAmount,
    DateTime? lastClosedDate,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currencyCode: currencyCode ?? this.currencyCode,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      creditLimit: creditLimit ?? this.creditLimit,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      pendingStatementAmount: pendingStatementAmount ?? this.pendingStatementAmount,
      lastClosedDate: lastClosedDate ?? this.lastClosedDate,
      alias: alias ?? this.alias,
      cvu: cvu ?? this.cvu,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        balance,
        currencyCode,
        pendingStatementAmount,
        lastClosedDate,
        alias,
        cvu,
      ];
}
