// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ARS'));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _closingDayMeta =
      const VerificationMeta('closingDay');
  @override
  late final GeneratedColumn<int> closingDay = GeneratedColumn<int>(
      'closing_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
      'due_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pendingStatementAmountMeta =
      const VerificationMeta('pendingStatementAmount');
  @override
  late final GeneratedColumn<double> pendingStatementAmount =
      GeneratedColumn<double>('pending_statement_amount', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _lastClosedDateMeta =
      const VerificationMeta('lastClosedDate');
  @override
  late final GeneratedColumn<DateTime> lastClosedDate =
      GeneratedColumn<DateTime>('last_closed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cvuMeta = const VerificationMeta('cvu');
  @override
  late final GeneratedColumn<String> cvu = GeneratedColumn<String>(
      'cvu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        initialBalance,
        currencyCode,
        iconName,
        colorValue,
        isDefault,
        creditLimit,
        closingDay,
        dueDay,
        pendingStatementAmount,
        lastClosedDate,
        alias,
        cvu
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  VerificationContext validateIntegrity(Insertable<AccountEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('closing_day')) {
      context.handle(
          _closingDayMeta,
          closingDay.isAcceptableOrUnknown(
              data['closing_day']!, _closingDayMeta));
    }
    if (data.containsKey('due_day')) {
      context.handle(_dueDayMeta,
          dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta));
    }
    if (data.containsKey('pending_statement_amount')) {
      context.handle(
          _pendingStatementAmountMeta,
          pendingStatementAmount.isAcceptableOrUnknown(
              data['pending_statement_amount']!, _pendingStatementAmountMeta));
    }
    if (data.containsKey('last_closed_date')) {
      context.handle(
          _lastClosedDateMeta,
          lastClosedDate.isAcceptableOrUnknown(
              data['last_closed_date']!, _lastClosedDateMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('cvu')) {
      context.handle(
          _cvuMeta, cvu.isAcceptableOrUnknown(data['cvu']!, _cvuMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      initialBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_balance'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit']),
      closingDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}closing_day']),
      dueDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day']),
      pendingStatementAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}pending_statement_amount'])!,
      lastClosedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_closed_date']),
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias']),
      cvu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cvu']),
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountEntity extends DataClass implements Insertable<AccountEntity> {
  final String id;
  final String name;
  final String type;
  final double initialBalance;
  final String currencyCode;
  final String? iconName;
  final int? colorValue;
  final bool isDefault;
  final double? creditLimit;
  final int? closingDay;
  final int? dueDay;
  final double pendingStatementAmount;
  final DateTime? lastClosedDate;
  final String? alias;
  final String? cvu;
  const AccountEntity(
      {required this.id,
      required this.name,
      required this.type,
      required this.initialBalance,
      required this.currencyCode,
      this.iconName,
      this.colorValue,
      required this.isDefault,
      this.creditLimit,
      this.closingDay,
      this.dueDay,
      required this.pendingStatementAmount,
      this.lastClosedDate,
      this.alias,
      this.cvu});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['initial_balance'] = Variable<double>(initialBalance);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    if (!nullToAbsent || closingDay != null) {
      map['closing_day'] = Variable<int>(closingDay);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    map['pending_statement_amount'] = Variable<double>(pendingStatementAmount);
    if (!nullToAbsent || lastClosedDate != null) {
      map['last_closed_date'] = Variable<DateTime>(lastClosedDate);
    }
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || cvu != null) {
      map['cvu'] = Variable<String>(cvu);
    }
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialBalance: Value(initialBalance),
      currencyCode: Value(currencyCode),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      isDefault: Value(isDefault),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      closingDay: closingDay == null && nullToAbsent
          ? const Value.absent()
          : Value(closingDay),
      dueDay:
          dueDay == null && nullToAbsent ? const Value.absent() : Value(dueDay),
      pendingStatementAmount: Value(pendingStatementAmount),
      lastClosedDate: lastClosedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastClosedDate),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      cvu: cvu == null && nullToAbsent ? const Value.absent() : Value(cvu),
    );
  }

  factory AccountEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
      closingDay: serializer.fromJson<int?>(json['closingDay']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      pendingStatementAmount:
          serializer.fromJson<double>(json['pendingStatementAmount']),
      lastClosedDate: serializer.fromJson<DateTime?>(json['lastClosedDate']),
      alias: serializer.fromJson<String?>(json['alias']),
      cvu: serializer.fromJson<String?>(json['cvu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'iconName': serializer.toJson<String?>(iconName),
      'colorValue': serializer.toJson<int?>(colorValue),
      'isDefault': serializer.toJson<bool>(isDefault),
      'creditLimit': serializer.toJson<double?>(creditLimit),
      'closingDay': serializer.toJson<int?>(closingDay),
      'dueDay': serializer.toJson<int?>(dueDay),
      'pendingStatementAmount':
          serializer.toJson<double>(pendingStatementAmount),
      'lastClosedDate': serializer.toJson<DateTime?>(lastClosedDate),
      'alias': serializer.toJson<String?>(alias),
      'cvu': serializer.toJson<String?>(cvu),
    };
  }

  AccountEntity copyWith(
          {String? id,
          String? name,
          String? type,
          double? initialBalance,
          String? currencyCode,
          Value<String?> iconName = const Value.absent(),
          Value<int?> colorValue = const Value.absent(),
          bool? isDefault,
          Value<double?> creditLimit = const Value.absent(),
          Value<int?> closingDay = const Value.absent(),
          Value<int?> dueDay = const Value.absent(),
          double? pendingStatementAmount,
          Value<DateTime?> lastClosedDate = const Value.absent(),
          Value<String?> alias = const Value.absent(),
          Value<String?> cvu = const Value.absent()}) =>
      AccountEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        initialBalance: initialBalance ?? this.initialBalance,
        currencyCode: currencyCode ?? this.currencyCode,
        iconName: iconName.present ? iconName.value : this.iconName,
        colorValue: colorValue.present ? colorValue.value : this.colorValue,
        isDefault: isDefault ?? this.isDefault,
        creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
        closingDay: closingDay.present ? closingDay.value : this.closingDay,
        dueDay: dueDay.present ? dueDay.value : this.dueDay,
        pendingStatementAmount:
            pendingStatementAmount ?? this.pendingStatementAmount,
        lastClosedDate:
            lastClosedDate.present ? lastClosedDate.value : this.lastClosedDate,
        alias: alias.present ? alias.value : this.alias,
        cvu: cvu.present ? cvu.value : this.cvu,
      );
  AccountEntity copyWithCompanion(AccountsTableCompanion data) {
    return AccountEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      closingDay:
          data.closingDay.present ? data.closingDay.value : this.closingDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      pendingStatementAmount: data.pendingStatementAmount.present
          ? data.pendingStatementAmount.value
          : this.pendingStatementAmount,
      lastClosedDate: data.lastClosedDate.present
          ? data.lastClosedDate.value
          : this.lastClosedDate,
      alias: data.alias.present ? data.alias.value : this.alias,
      cvu: data.cvu.present ? data.cvu.value : this.cvu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('pendingStatementAmount: $pendingStatementAmount, ')
          ..write('lastClosedDate: $lastClosedDate, ')
          ..write('alias: $alias, ')
          ..write('cvu: $cvu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      initialBalance,
      currencyCode,
      iconName,
      colorValue,
      isDefault,
      creditLimit,
      closingDay,
      dueDay,
      pendingStatementAmount,
      lastClosedDate,
      alias,
      cvu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialBalance == this.initialBalance &&
          other.currencyCode == this.currencyCode &&
          other.iconName == this.iconName &&
          other.colorValue == this.colorValue &&
          other.isDefault == this.isDefault &&
          other.creditLimit == this.creditLimit &&
          other.closingDay == this.closingDay &&
          other.dueDay == this.dueDay &&
          other.pendingStatementAmount == this.pendingStatementAmount &&
          other.lastClosedDate == this.lastClosedDate &&
          other.alias == this.alias &&
          other.cvu == this.cvu);
}

class AccountsTableCompanion extends UpdateCompanion<AccountEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> initialBalance;
  final Value<String> currencyCode;
  final Value<String?> iconName;
  final Value<int?> colorValue;
  final Value<bool> isDefault;
  final Value<double?> creditLimit;
  final Value<int?> closingDay;
  final Value<int?> dueDay;
  final Value<double> pendingStatementAmount;
  final Value<DateTime?> lastClosedDate;
  final Value<String?> alias;
  final Value<String?> cvu;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.closingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.pendingStatementAmount = const Value.absent(),
    this.lastClosedDate = const Value.absent(),
    this.alias = const Value.absent(),
    this.cvu = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.initialBalance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.closingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.pendingStatementAmount = const Value.absent(),
    this.lastClosedDate = const Value.absent(),
    this.alias = const Value.absent(),
    this.cvu = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type);
  static Insertable<AccountEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? initialBalance,
    Expression<String>? currencyCode,
    Expression<String>? iconName,
    Expression<int>? colorValue,
    Expression<bool>? isDefault,
    Expression<double>? creditLimit,
    Expression<int>? closingDay,
    Expression<int>? dueDay,
    Expression<double>? pendingStatementAmount,
    Expression<DateTime>? lastClosedDate,
    Expression<String>? alias,
    Expression<String>? cvu,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (iconName != null) 'icon_name': iconName,
      if (colorValue != null) 'color_value': colorValue,
      if (isDefault != null) 'is_default': isDefault,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (closingDay != null) 'closing_day': closingDay,
      if (dueDay != null) 'due_day': dueDay,
      if (pendingStatementAmount != null)
        'pending_statement_amount': pendingStatementAmount,
      if (lastClosedDate != null) 'last_closed_date': lastClosedDate,
      if (alias != null) 'alias': alias,
      if (cvu != null) 'cvu': cvu,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<double>? initialBalance,
      Value<String>? currencyCode,
      Value<String?>? iconName,
      Value<int?>? colorValue,
      Value<bool>? isDefault,
      Value<double?>? creditLimit,
      Value<int?>? closingDay,
      Value<int?>? dueDay,
      Value<double>? pendingStatementAmount,
      Value<DateTime?>? lastClosedDate,
      Value<String?>? alias,
      Value<String?>? cvu,
      Value<int>? rowid}) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      currencyCode: currencyCode ?? this.currencyCode,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      creditLimit: creditLimit ?? this.creditLimit,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      pendingStatementAmount:
          pendingStatementAmount ?? this.pendingStatementAmount,
      lastClosedDate: lastClosedDate ?? this.lastClosedDate,
      alias: alias ?? this.alias,
      cvu: cvu ?? this.cvu,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (closingDay.present) {
      map['closing_day'] = Variable<int>(closingDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (pendingStatementAmount.present) {
      map['pending_statement_amount'] =
          Variable<double>(pendingStatementAmount.value);
    }
    if (lastClosedDate.present) {
      map['last_closed_date'] = Variable<DateTime>(lastClosedDate.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (cvu.present) {
      map['cvu'] = Variable<String>(cvu.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('pendingStatementAmount: $pendingStatementAmount, ')
          ..write('lastClosedDate: $lastClosedDate, ')
          ..write('alias: $alias, ')
          ..write('cvu: $cvu, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthlyBudgetMeta =
      const VerificationMeta('monthlyBudget');
  @override
  late final GeneratedColumn<double> monthlyBudget = GeneratedColumn<double>(
      'monthly_budget', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isFixedMeta =
      const VerificationMeta('isFixed');
  @override
  late final GeneratedColumn<bool> isFixed = GeneratedColumn<bool>(
      'is_fixed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_fixed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, iconName, colorValue, monthlyBudget, isFixed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('monthly_budget')) {
      context.handle(
          _monthlyBudgetMeta,
          monthlyBudget.isAcceptableOrUnknown(
              data['monthly_budget']!, _monthlyBudgetMeta));
    }
    if (data.containsKey('is_fixed')) {
      context.handle(_isFixedMeta,
          isFixed.isAcceptableOrUnknown(data['is_fixed']!, _isFixedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      monthlyBudget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_budget']),
      isFixed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_fixed'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryEntity extends DataClass implements Insertable<CategoryEntity> {
  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final double? monthlyBudget;
  final bool isFixed;
  const CategoryEntity(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.colorValue,
      this.monthlyBudget,
      required this.isFixed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || monthlyBudget != null) {
      map['monthly_budget'] = Variable<double>(monthlyBudget);
    }
    map['is_fixed'] = Variable<bool>(isFixed);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      colorValue: Value(colorValue),
      monthlyBudget: monthlyBudget == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyBudget),
      isFixed: Value(isFixed),
    );
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      monthlyBudget: serializer.fromJson<double?>(json['monthlyBudget']),
      isFixed: serializer.fromJson<bool>(json['isFixed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'colorValue': serializer.toJson<int>(colorValue),
      'monthlyBudget': serializer.toJson<double?>(monthlyBudget),
      'isFixed': serializer.toJson<bool>(isFixed),
    };
  }

  CategoryEntity copyWith(
          {String? id,
          String? name,
          String? iconName,
          int? colorValue,
          Value<double?> monthlyBudget = const Value.absent(),
          bool? isFixed}) =>
      CategoryEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        colorValue: colorValue ?? this.colorValue,
        monthlyBudget:
            monthlyBudget.present ? monthlyBudget.value : this.monthlyBudget,
        isFixed: isFixed ?? this.isFixed,
      );
  CategoryEntity copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      monthlyBudget: data.monthlyBudget.present
          ? data.monthlyBudget.value
          : this.monthlyBudget,
      isFixed: data.isFixed.present ? data.isFixed.value : this.isFixed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('isFixed: $isFixed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconName, colorValue, monthlyBudget, isFixed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.colorValue == this.colorValue &&
          other.monthlyBudget == this.monthlyBudget &&
          other.isFixed == this.isFixed);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconName;
  final Value<int> colorValue;
  final Value<double?> monthlyBudget;
  final Value<bool> isFixed;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.isFixed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required String iconName,
    required int colorValue,
    this.monthlyBudget = const Value.absent(),
    this.isFixed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        iconName = Value(iconName),
        colorValue = Value(colorValue);
  static Insertable<CategoryEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<int>? colorValue,
    Expression<double>? monthlyBudget,
    Expression<bool>? isFixed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (colorValue != null) 'color_value': colorValue,
      if (monthlyBudget != null) 'monthly_budget': monthlyBudget,
      if (isFixed != null) 'is_fixed': isFixed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? iconName,
      Value<int>? colorValue,
      Value<double?>? monthlyBudget,
      Value<bool>? isFixed,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isFixed: isFixed ?? this.isFixed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (monthlyBudget.present) {
      map['monthly_budget'] = Variable<double>(monthlyBudget.value);
    }
    if (isFixed.present) {
      map['is_fixed'] = Variable<bool>(isFixed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('isFixed: $isFixed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sharedTotalAmountMeta =
      const VerificationMeta('sharedTotalAmount');
  @override
  late final GeneratedColumn<double> sharedTotalAmount =
      GeneratedColumn<double>('shared_total_amount', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sharedOwnAmountMeta =
      const VerificationMeta('sharedOwnAmount');
  @override
  late final GeneratedColumn<double> sharedOwnAmount = GeneratedColumn<double>(
      'shared_own_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sharedOtherAmountMeta =
      const VerificationMeta('sharedOtherAmount');
  @override
  late final GeneratedColumn<double> sharedOtherAmount =
      GeneratedColumn<double>('shared_other_amount', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sharedRecoveredMeta =
      const VerificationMeta('sharedRecovered');
  @override
  late final GeneratedColumn<double> sharedRecovered = GeneratedColumn<double>(
      'shared_recovered', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isSharedMeta =
      const VerificationMeta('isShared');
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
      'is_shared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_shared" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        type,
        categoryId,
        accountId,
        date,
        note,
        personId,
        groupId,
        sharedTotalAmount,
        sharedOwnAmount,
        sharedOtherAmount,
        sharedRecovered,
        isShared
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('shared_total_amount')) {
      context.handle(
          _sharedTotalAmountMeta,
          sharedTotalAmount.isAcceptableOrUnknown(
              data['shared_total_amount']!, _sharedTotalAmountMeta));
    }
    if (data.containsKey('shared_own_amount')) {
      context.handle(
          _sharedOwnAmountMeta,
          sharedOwnAmount.isAcceptableOrUnknown(
              data['shared_own_amount']!, _sharedOwnAmountMeta));
    }
    if (data.containsKey('shared_other_amount')) {
      context.handle(
          _sharedOtherAmountMeta,
          sharedOtherAmount.isAcceptableOrUnknown(
              data['shared_other_amount']!, _sharedOtherAmountMeta));
    }
    if (data.containsKey('shared_recovered')) {
      context.handle(
          _sharedRecoveredMeta,
          sharedRecovered.isAcceptableOrUnknown(
              data['shared_recovered']!, _sharedRecoveredMeta));
    }
    if (data.containsKey('is_shared')) {
      context.handle(_isSharedMeta,
          isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      sharedTotalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}shared_total_amount']),
      sharedOwnAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}shared_own_amount']),
      sharedOtherAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}shared_other_amount']),
      sharedRecovered: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}shared_recovered']),
      isShared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_shared'])!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionEntity extends DataClass
    implements Insertable<TransactionEntity> {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String categoryId;
  final String accountId;
  final DateTime date;
  final String? note;
  final String? personId;
  final String? groupId;
  final double? sharedTotalAmount;
  final double? sharedOwnAmount;
  final double? sharedOtherAmount;
  final double? sharedRecovered;
  final bool isShared;
  const TransactionEntity(
      {required this.id,
      required this.title,
      required this.amount,
      required this.type,
      required this.categoryId,
      required this.accountId,
      required this.date,
      this.note,
      this.personId,
      this.groupId,
      this.sharedTotalAmount,
      this.sharedOwnAmount,
      this.sharedOtherAmount,
      this.sharedRecovered,
      required this.isShared});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category_id'] = Variable<String>(categoryId);
    map['account_id'] = Variable<String>(accountId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<String>(personId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || sharedTotalAmount != null) {
      map['shared_total_amount'] = Variable<double>(sharedTotalAmount);
    }
    if (!nullToAbsent || sharedOwnAmount != null) {
      map['shared_own_amount'] = Variable<double>(sharedOwnAmount);
    }
    if (!nullToAbsent || sharedOtherAmount != null) {
      map['shared_other_amount'] = Variable<double>(sharedOtherAmount);
    }
    if (!nullToAbsent || sharedRecovered != null) {
      map['shared_recovered'] = Variable<double>(sharedRecovered);
    }
    map['is_shared'] = Variable<bool>(isShared);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      type: Value(type),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      sharedTotalAmount: sharedTotalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedTotalAmount),
      sharedOwnAmount: sharedOwnAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedOwnAmount),
      sharedOtherAmount: sharedOtherAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedOtherAmount),
      sharedRecovered: sharedRecovered == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedRecovered),
      isShared: Value(isShared),
    );
  }

  factory TransactionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      personId: serializer.fromJson<String?>(json['personId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      sharedTotalAmount:
          serializer.fromJson<double?>(json['sharedTotalAmount']),
      sharedOwnAmount: serializer.fromJson<double?>(json['sharedOwnAmount']),
      sharedOtherAmount:
          serializer.fromJson<double?>(json['sharedOtherAmount']),
      sharedRecovered: serializer.fromJson<double?>(json['sharedRecovered']),
      isShared: serializer.fromJson<bool>(json['isShared']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'categoryId': serializer.toJson<String>(categoryId),
      'accountId': serializer.toJson<String>(accountId),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'personId': serializer.toJson<String?>(personId),
      'groupId': serializer.toJson<String?>(groupId),
      'sharedTotalAmount': serializer.toJson<double?>(sharedTotalAmount),
      'sharedOwnAmount': serializer.toJson<double?>(sharedOwnAmount),
      'sharedOtherAmount': serializer.toJson<double?>(sharedOtherAmount),
      'sharedRecovered': serializer.toJson<double?>(sharedRecovered),
      'isShared': serializer.toJson<bool>(isShared),
    };
  }

  TransactionEntity copyWith(
          {String? id,
          String? title,
          double? amount,
          String? type,
          String? categoryId,
          String? accountId,
          DateTime? date,
          Value<String?> note = const Value.absent(),
          Value<String?> personId = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          Value<double?> sharedTotalAmount = const Value.absent(),
          Value<double?> sharedOwnAmount = const Value.absent(),
          Value<double?> sharedOtherAmount = const Value.absent(),
          Value<double?> sharedRecovered = const Value.absent(),
          bool? isShared}) =>
      TransactionEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        accountId: accountId ?? this.accountId,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        personId: personId.present ? personId.value : this.personId,
        groupId: groupId.present ? groupId.value : this.groupId,
        sharedTotalAmount: sharedTotalAmount.present
            ? sharedTotalAmount.value
            : this.sharedTotalAmount,
        sharedOwnAmount: sharedOwnAmount.present
            ? sharedOwnAmount.value
            : this.sharedOwnAmount,
        sharedOtherAmount: sharedOtherAmount.present
            ? sharedOtherAmount.value
            : this.sharedOtherAmount,
        sharedRecovered: sharedRecovered.present
            ? sharedRecovered.value
            : this.sharedRecovered,
        isShared: isShared ?? this.isShared,
      );
  TransactionEntity copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      personId: data.personId.present ? data.personId.value : this.personId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sharedTotalAmount: data.sharedTotalAmount.present
          ? data.sharedTotalAmount.value
          : this.sharedTotalAmount,
      sharedOwnAmount: data.sharedOwnAmount.present
          ? data.sharedOwnAmount.value
          : this.sharedOwnAmount,
      sharedOtherAmount: data.sharedOtherAmount.present
          ? data.sharedOtherAmount.value
          : this.sharedOtherAmount,
      sharedRecovered: data.sharedRecovered.present
          ? data.sharedRecovered.value
          : this.sharedRecovered,
      isShared: data.isShared.present ? data.isShared.value : this.isShared,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('personId: $personId, ')
          ..write('groupId: $groupId, ')
          ..write('sharedTotalAmount: $sharedTotalAmount, ')
          ..write('sharedOwnAmount: $sharedOwnAmount, ')
          ..write('sharedOtherAmount: $sharedOtherAmount, ')
          ..write('sharedRecovered: $sharedRecovered, ')
          ..write('isShared: $isShared')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      amount,
      type,
      categoryId,
      accountId,
      date,
      note,
      personId,
      groupId,
      sharedTotalAmount,
      sharedOwnAmount,
      sharedOtherAmount,
      sharedRecovered,
      isShared);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.date == this.date &&
          other.note == this.note &&
          other.personId == this.personId &&
          other.groupId == this.groupId &&
          other.sharedTotalAmount == this.sharedTotalAmount &&
          other.sharedOwnAmount == this.sharedOwnAmount &&
          other.sharedOtherAmount == this.sharedOtherAmount &&
          other.sharedRecovered == this.sharedRecovered &&
          other.isShared == this.isShared);
}

class TransactionsTableCompanion extends UpdateCompanion<TransactionEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> categoryId;
  final Value<String> accountId;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> personId;
  final Value<String?> groupId;
  final Value<double?> sharedTotalAmount;
  final Value<double?> sharedOwnAmount;
  final Value<double?> sharedOtherAmount;
  final Value<double?> sharedRecovered;
  final Value<bool> isShared;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.personId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sharedTotalAmount = const Value.absent(),
    this.sharedOwnAmount = const Value.absent(),
    this.sharedOtherAmount = const Value.absent(),
    this.sharedRecovered = const Value.absent(),
    this.isShared = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String categoryId,
    required String accountId,
    required DateTime date,
    this.note = const Value.absent(),
    this.personId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sharedTotalAmount = const Value.absent(),
    this.sharedOwnAmount = const Value.absent(),
    this.sharedOtherAmount = const Value.absent(),
    this.sharedRecovered = const Value.absent(),
    this.isShared = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        categoryId = Value(categoryId),
        accountId = Value(accountId),
        date = Value(date);
  static Insertable<TransactionEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? categoryId,
    Expression<String>? accountId,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? personId,
    Expression<String>? groupId,
    Expression<double>? sharedTotalAmount,
    Expression<double>? sharedOwnAmount,
    Expression<double>? sharedOtherAmount,
    Expression<double>? sharedRecovered,
    Expression<bool>? isShared,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (personId != null) 'person_id': personId,
      if (groupId != null) 'group_id': groupId,
      if (sharedTotalAmount != null) 'shared_total_amount': sharedTotalAmount,
      if (sharedOwnAmount != null) 'shared_own_amount': sharedOwnAmount,
      if (sharedOtherAmount != null) 'shared_other_amount': sharedOtherAmount,
      if (sharedRecovered != null) 'shared_recovered': sharedRecovered,
      if (isShared != null) 'is_shared': isShared,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? categoryId,
      Value<String>? accountId,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<String?>? personId,
      Value<String?>? groupId,
      Value<double?>? sharedTotalAmount,
      Value<double?>? sharedOwnAmount,
      Value<double?>? sharedOtherAmount,
      Value<double?>? sharedRecovered,
      Value<bool>? isShared,
      Value<int>? rowid}) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      note: note ?? this.note,
      personId: personId ?? this.personId,
      groupId: groupId ?? this.groupId,
      sharedTotalAmount: sharedTotalAmount ?? this.sharedTotalAmount,
      sharedOwnAmount: sharedOwnAmount ?? this.sharedOwnAmount,
      sharedOtherAmount: sharedOtherAmount ?? this.sharedOtherAmount,
      sharedRecovered: sharedRecovered ?? this.sharedRecovered,
      isShared: isShared ?? this.isShared,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (sharedTotalAmount.present) {
      map['shared_total_amount'] = Variable<double>(sharedTotalAmount.value);
    }
    if (sharedOwnAmount.present) {
      map['shared_own_amount'] = Variable<double>(sharedOwnAmount.value);
    }
    if (sharedOtherAmount.present) {
      map['shared_other_amount'] = Variable<double>(sharedOtherAmount.value);
    }
    if (sharedRecovered.present) {
      map['shared_recovered'] = Variable<double>(sharedRecovered.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('personId: $personId, ')
          ..write('groupId: $groupId, ')
          ..write('sharedTotalAmount: $sharedTotalAmount, ')
          ..write('sharedOwnAmount: $sharedOwnAmount, ')
          ..write('sharedOtherAmount: $sharedOtherAmount, ')
          ..write('sharedRecovered: $sharedRecovered, ')
          ..write('isShared: $isShared, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitAmountMeta =
      const VerificationMeta('limitAmount');
  @override
  late final GeneratedColumn<double> limitAmount = GeneratedColumn<double>(
      'limit_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _spentAmountMeta =
      const VerificationMeta('spentAmount');
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
      'spent_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, limitAmount, spentAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets_table';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
          _limitAmountMeta,
          limitAmount.isAcceptableOrUnknown(
              data['limit_amount']!, _limitAmountMeta));
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
          _spentAmountMeta,
          spentAmount.isAcceptableOrUnknown(
              data['spent_amount']!, _spentAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      limitAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}limit_amount'])!,
      spentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}spent_amount'])!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }
}

class BudgetEntity extends DataClass implements Insertable<BudgetEntity> {
  final String id;
  final String categoryId;
  final double limitAmount;
  final double spentAmount;
  const BudgetEntity(
      {required this.id,
      required this.categoryId,
      required this.limitAmount,
      required this.spentAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['limit_amount'] = Variable<double>(limitAmount);
    map['spent_amount'] = Variable<double>(spentAmount);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      limitAmount: Value(limitAmount),
      spentAmount: Value(spentAmount),
    );
  }

  factory BudgetEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntity(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      limitAmount: serializer.fromJson<double>(json['limitAmount']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'limitAmount': serializer.toJson<double>(limitAmount),
      'spentAmount': serializer.toJson<double>(spentAmount),
    };
  }

  BudgetEntity copyWith(
          {String? id,
          String? categoryId,
          double? limitAmount,
          double? spentAmount}) =>
      BudgetEntity(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        limitAmount: limitAmount ?? this.limitAmount,
        spentAmount: spentAmount ?? this.spentAmount,
      );
  BudgetEntity copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetEntity(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      limitAmount:
          data.limitAmount.present ? data.limitAmount.value : this.limitAmount,
      spentAmount:
          data.spentAmount.present ? data.spentAmount.value : this.spentAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntity(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spentAmount: $spentAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, limitAmount, spentAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntity &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.limitAmount == this.limitAmount &&
          other.spentAmount == this.spentAmount);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetEntity> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<double> limitAmount;
  final Value<double> spentAmount;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required String categoryId,
    required double limitAmount,
    this.spentAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        categoryId = Value(categoryId),
        limitAmount = Value(limitAmount);
  static Insertable<BudgetEntity> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<double>? limitAmount,
    Expression<double>? spentAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? categoryId,
      Value<double>? limitAmount,
      Value<double>? spentAmount,
      Value<int>? rowid}) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<double>(limitAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, targetAmount, currentAmount, colorValue, iconName, deadline];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(Insertable<GoalEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_amount'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalEntity extends DataClass implements Insertable<GoalEntity> {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final int colorValue;
  final String? iconName;
  final DateTime? deadline;
  const GoalEntity(
      {required this.id,
      required this.name,
      required this.targetAmount,
      required this.currentAmount,
      required this.colorValue,
      this.iconName,
      this.deadline});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      colorValue: Value(colorValue),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
    );
  }

  factory GoalEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'colorValue': serializer.toJson<int>(colorValue),
      'iconName': serializer.toJson<String?>(iconName),
      'deadline': serializer.toJson<DateTime?>(deadline),
    };
  }

  GoalEntity copyWith(
          {String? id,
          String? name,
          double? targetAmount,
          double? currentAmount,
          int? colorValue,
          Value<String?> iconName = const Value.absent(),
          Value<DateTime?> deadline = const Value.absent()}) =>
      GoalEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        colorValue: colorValue ?? this.colorValue,
        iconName: iconName.present ? iconName.value : this.iconName,
        deadline: deadline.present ? deadline.value : this.deadline,
      );
  GoalEntity copyWithCompanion(GoalsTableCompanion data) {
    return GoalEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconName: $iconName, ')
          ..write('deadline: $deadline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, targetAmount, currentAmount, colorValue, iconName, deadline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.colorValue == this.colorValue &&
          other.iconName == this.iconName &&
          other.deadline == this.deadline);
}

class GoalsTableCompanion extends UpdateCompanion<GoalEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<int> colorValue;
  final Value<String?> iconName;
  final Value<DateTime?> deadline;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconName = const Value.absent(),
    this.deadline = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String name,
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    required int colorValue,
    this.iconName = const Value.absent(),
    this.deadline = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        targetAmount = Value(targetAmount),
        colorValue = Value(colorValue);
  static Insertable<GoalEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<int>? colorValue,
    Expression<String>? iconName,
    Expression<DateTime>? deadline,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (colorValue != null) 'color_value': colorValue,
      if (iconName != null) 'icon_name': iconName,
      if (deadline != null) 'deadline': deadline,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? targetAmount,
      Value<double>? currentAmount,
      Value<int>? colorValue,
      Value<String?>? iconName,
      Value<DateTime?>? deadline,
      Value<int>? rowid}) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      deadline: deadline ?? this.deadline,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconName: $iconName, ')
          ..write('deadline: $deadline, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonsTableTable extends PersonsTable
    with TableInfo<$PersonsTableTable, PersonEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalBalanceMeta =
      const VerificationMeta('totalBalance');
  @override
  late final GeneratedColumn<double> totalBalance = GeneratedColumn<double>(
      'total_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cbuMeta = const VerificationMeta('cbu');
  @override
  late final GeneratedColumn<String> cbu = GeneratedColumn<String>(
      'cbu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedUserIdMeta =
      const VerificationMeta('linkedUserId');
  @override
  late final GeneratedColumn<String> linkedUserId = GeneratedColumn<String>(
      'linked_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, alias, colorValue, totalBalance, cbu, notes, linkedUserId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons_table';
  @override
  VerificationContext validateIntegrity(Insertable<PersonEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('total_balance')) {
      context.handle(
          _totalBalanceMeta,
          totalBalance.isAcceptableOrUnknown(
              data['total_balance']!, _totalBalanceMeta));
    }
    if (data.containsKey('cbu')) {
      context.handle(
          _cbuMeta, cbu.isAcceptableOrUnknown(data['cbu']!, _cbuMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('linked_user_id')) {
      context.handle(
          _linkedUserIdMeta,
          linkedUserId.isAcceptableOrUnknown(
              data['linked_user_id']!, _linkedUserIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias']),
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      totalBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_balance'])!,
      cbu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cbu']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      linkedUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linked_user_id']),
    );
  }

  @override
  $PersonsTableTable createAlias(String alias) {
    return $PersonsTableTable(attachedDatabase, alias);
  }
}

class PersonEntity extends DataClass implements Insertable<PersonEntity> {
  final String id;
  final String name;
  final String? alias;
  final int colorValue;
  final double totalBalance;
  final String? cbu;
  final String? notes;
  final String? linkedUserId;
  const PersonEntity(
      {required this.id,
      required this.name,
      this.alias,
      required this.colorValue,
      required this.totalBalance,
      this.cbu,
      this.notes,
      this.linkedUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    map['color_value'] = Variable<int>(colorValue);
    map['total_balance'] = Variable<double>(totalBalance);
    if (!nullToAbsent || cbu != null) {
      map['cbu'] = Variable<String>(cbu);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || linkedUserId != null) {
      map['linked_user_id'] = Variable<String>(linkedUserId);
    }
    return map;
  }

  PersonsTableCompanion toCompanion(bool nullToAbsent) {
    return PersonsTableCompanion(
      id: Value(id),
      name: Value(name),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      colorValue: Value(colorValue),
      totalBalance: Value(totalBalance),
      cbu: cbu == null && nullToAbsent ? const Value.absent() : Value(cbu),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      linkedUserId: linkedUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedUserId),
    );
  }

  factory PersonEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      alias: serializer.fromJson<String?>(json['alias']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      totalBalance: serializer.fromJson<double>(json['totalBalance']),
      cbu: serializer.fromJson<String?>(json['cbu']),
      notes: serializer.fromJson<String?>(json['notes']),
      linkedUserId: serializer.fromJson<String?>(json['linkedUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'alias': serializer.toJson<String?>(alias),
      'colorValue': serializer.toJson<int>(colorValue),
      'totalBalance': serializer.toJson<double>(totalBalance),
      'cbu': serializer.toJson<String?>(cbu),
      'notes': serializer.toJson<String?>(notes),
      'linkedUserId': serializer.toJson<String?>(linkedUserId),
    };
  }

  PersonEntity copyWith(
          {String? id,
          String? name,
          Value<String?> alias = const Value.absent(),
          int? colorValue,
          double? totalBalance,
          Value<String?> cbu = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> linkedUserId = const Value.absent()}) =>
      PersonEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        alias: alias.present ? alias.value : this.alias,
        colorValue: colorValue ?? this.colorValue,
        totalBalance: totalBalance ?? this.totalBalance,
        cbu: cbu.present ? cbu.value : this.cbu,
        notes: notes.present ? notes.value : this.notes,
        linkedUserId:
            linkedUserId.present ? linkedUserId.value : this.linkedUserId,
      );
  PersonEntity copyWithCompanion(PersonsTableCompanion data) {
    return PersonEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      alias: data.alias.present ? data.alias.value : this.alias,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      totalBalance: data.totalBalance.present
          ? data.totalBalance.value
          : this.totalBalance,
      cbu: data.cbu.present ? data.cbu.value : this.cbu,
      notes: data.notes.present ? data.notes.value : this.notes,
      linkedUserId: data.linkedUserId.present
          ? data.linkedUserId.value
          : this.linkedUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('colorValue: $colorValue, ')
          ..write('totalBalance: $totalBalance, ')
          ..write('cbu: $cbu, ')
          ..write('notes: $notes, ')
          ..write('linkedUserId: $linkedUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, alias, colorValue, totalBalance, cbu, notes, linkedUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.alias == this.alias &&
          other.colorValue == this.colorValue &&
          other.totalBalance == this.totalBalance &&
          other.cbu == this.cbu &&
          other.notes == this.notes &&
          other.linkedUserId == this.linkedUserId);
}

class PersonsTableCompanion extends UpdateCompanion<PersonEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> alias;
  final Value<int> colorValue;
  final Value<double> totalBalance;
  final Value<String?> cbu;
  final Value<String?> notes;
  final Value<String?> linkedUserId;
  final Value<int> rowid;
  const PersonsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.totalBalance = const Value.absent(),
    this.cbu = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsTableCompanion.insert({
    required String id,
    required String name,
    this.alias = const Value.absent(),
    required int colorValue,
    this.totalBalance = const Value.absent(),
    this.cbu = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        colorValue = Value(colorValue);
  static Insertable<PersonEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? alias,
    Expression<int>? colorValue,
    Expression<double>? totalBalance,
    Expression<String>? cbu,
    Expression<String>? notes,
    Expression<String>? linkedUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (alias != null) 'alias': alias,
      if (colorValue != null) 'color_value': colorValue,
      if (totalBalance != null) 'total_balance': totalBalance,
      if (cbu != null) 'cbu': cbu,
      if (notes != null) 'notes': notes,
      if (linkedUserId != null) 'linked_user_id': linkedUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? alias,
      Value<int>? colorValue,
      Value<double>? totalBalance,
      Value<String?>? cbu,
      Value<String?>? notes,
      Value<String?>? linkedUserId,
      Value<int>? rowid}) {
    return PersonsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      colorValue: colorValue ?? this.colorValue,
      totalBalance: totalBalance ?? this.totalBalance,
      cbu: cbu ?? this.cbu,
      notes: notes ?? this.notes,
      linkedUserId: linkedUserId ?? this.linkedUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (totalBalance.present) {
      map['total_balance'] = Variable<double>(totalBalance.value);
    }
    if (cbu.present) {
      map['cbu'] = Variable<String>(cbu.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (linkedUserId.present) {
      map['linked_user_id'] = Variable<String>(linkedUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('colorValue: $colorValue, ')
          ..write('totalBalance: $totalBalance, ')
          ..write('cbu: $cbu, ')
          ..write('notes: $notes, ')
          ..write('linkedUserId: $linkedUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTableTable extends GroupsTable
    with TableInfo<$GroupsTableTable, GroupEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _coverImageUrlMeta =
      const VerificationMeta('coverImageUrl');
  @override
  late final GeneratedColumn<String> coverImageUrl = GeneratedColumn<String>(
      'cover_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalGroupExpenseMeta =
      const VerificationMeta('totalGroupExpense');
  @override
  late final GeneratedColumn<double> totalGroupExpense =
      GeneratedColumn<double>('total_group_expense', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, coverImageUrl, totalGroupExpense, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups_table';
  @override
  VerificationContext validateIntegrity(Insertable<GroupEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_image_url')) {
      context.handle(
          _coverImageUrlMeta,
          coverImageUrl.isAcceptableOrUnknown(
              data['cover_image_url']!, _coverImageUrlMeta));
    }
    if (data.containsKey('total_group_expense')) {
      context.handle(
          _totalGroupExpenseMeta,
          totalGroupExpense.isAcceptableOrUnknown(
              data['total_group_expense']!, _totalGroupExpenseMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      coverImageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image_url']),
      totalGroupExpense: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_group_expense'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $GroupsTableTable createAlias(String alias) {
    return $GroupsTableTable(attachedDatabase, alias);
  }
}

class GroupEntity extends DataClass implements Insertable<GroupEntity> {
  final String id;
  final String name;
  final String? coverImageUrl;
  final double totalGroupExpense;
  final DateTime? startDate;
  final DateTime? endDate;
  const GroupEntity(
      {required this.id,
      required this.name,
      this.coverImageUrl,
      required this.totalGroupExpense,
      this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || coverImageUrl != null) {
      map['cover_image_url'] = Variable<String>(coverImageUrl);
    }
    map['total_group_expense'] = Variable<double>(totalGroupExpense);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  GroupsTableCompanion toCompanion(bool nullToAbsent) {
    return GroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      coverImageUrl: coverImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImageUrl),
      totalGroupExpense: Value(totalGroupExpense),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory GroupEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coverImageUrl: serializer.fromJson<String?>(json['coverImageUrl']),
      totalGroupExpense: serializer.fromJson<double>(json['totalGroupExpense']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'coverImageUrl': serializer.toJson<String?>(coverImageUrl),
      'totalGroupExpense': serializer.toJson<double>(totalGroupExpense),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  GroupEntity copyWith(
          {String? id,
          String? name,
          Value<String?> coverImageUrl = const Value.absent(),
          double? totalGroupExpense,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      GroupEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        coverImageUrl:
            coverImageUrl.present ? coverImageUrl.value : this.coverImageUrl,
        totalGroupExpense: totalGroupExpense ?? this.totalGroupExpense,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  GroupEntity copyWithCompanion(GroupsTableCompanion data) {
    return GroupEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coverImageUrl: data.coverImageUrl.present
          ? data.coverImageUrl.value
          : this.coverImageUrl,
      totalGroupExpense: data.totalGroupExpense.present
          ? data.totalGroupExpense.value
          : this.totalGroupExpense,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverImageUrl: $coverImageUrl, ')
          ..write('totalGroupExpense: $totalGroupExpense, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, coverImageUrl, totalGroupExpense, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.coverImageUrl == this.coverImageUrl &&
          other.totalGroupExpense == this.totalGroupExpense &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class GroupsTableCompanion extends UpdateCompanion<GroupEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> coverImageUrl;
  final Value<double> totalGroupExpense;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<int> rowid;
  const GroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coverImageUrl = const Value.absent(),
    this.totalGroupExpense = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsTableCompanion.insert({
    required String id,
    required String name,
    this.coverImageUrl = const Value.absent(),
    this.totalGroupExpense = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<GroupEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? coverImageUrl,
    Expression<double>? totalGroupExpense,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
      if (totalGroupExpense != null) 'total_group_expense': totalGroupExpense,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? coverImageUrl,
      Value<double>? totalGroupExpense,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<int>? rowid}) {
    return GroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      totalGroupExpense: totalGroupExpense ?? this.totalGroupExpense,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverImageUrl.present) {
      map['cover_image_url'] = Variable<String>(coverImageUrl.value);
    }
    if (totalGroupExpense.present) {
      map['total_group_expense'] = Variable<double>(totalGroupExpense.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverImageUrl: $coverImageUrl, ')
          ..write('totalGroupExpense: $totalGroupExpense, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTableTable extends GroupMembersTable
    with TableInfo<$GroupMembersTableTable, GroupMemberEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [groupId, personId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members_table';
  @override
  VerificationContext validateIntegrity(Insertable<GroupMemberEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, personId};
  @override
  GroupMemberEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMemberEntity(
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
    );
  }

  @override
  $GroupMembersTableTable createAlias(String alias) {
    return $GroupMembersTableTable(attachedDatabase, alias);
  }
}

class GroupMemberEntity extends DataClass
    implements Insertable<GroupMemberEntity> {
  final String groupId;
  final String personId;
  const GroupMemberEntity({required this.groupId, required this.personId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['person_id'] = Variable<String>(personId);
    return map;
  }

  GroupMembersTableCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersTableCompanion(
      groupId: Value(groupId),
      personId: Value(personId),
    );
  }

  factory GroupMemberEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMemberEntity(
      groupId: serializer.fromJson<String>(json['groupId']),
      personId: serializer.fromJson<String>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'personId': serializer.toJson<String>(personId),
    };
  }

  GroupMemberEntity copyWith({String? groupId, String? personId}) =>
      GroupMemberEntity(
        groupId: groupId ?? this.groupId,
        personId: personId ?? this.personId,
      );
  GroupMemberEntity copyWithCompanion(GroupMembersTableCompanion data) {
    return GroupMemberEntity(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      personId: data.personId.present ? data.personId.value : this.personId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMemberEntity(')
          ..write('groupId: $groupId, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, personId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMemberEntity &&
          other.groupId == this.groupId &&
          other.personId == this.personId);
}

class GroupMembersTableCompanion extends UpdateCompanion<GroupMemberEntity> {
  final Value<String> groupId;
  final Value<String> personId;
  final Value<int> rowid;
  const GroupMembersTableCompanion({
    this.groupId = const Value.absent(),
    this.personId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersTableCompanion.insert({
    required String groupId,
    required String personId,
    this.rowid = const Value.absent(),
  })  : groupId = Value(groupId),
        personId = Value(personId);
  static Insertable<GroupMemberEntity> custom({
    Expression<String>? groupId,
    Expression<String>? personId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (personId != null) 'person_id': personId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersTableCompanion copyWith(
      {Value<String>? groupId, Value<String>? personId, Value<int>? rowid}) {
    return GroupMembersTableCompanion(
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersTableCompanion(')
          ..write('groupId: $groupId, ')
          ..write('personId: $personId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTableTable extends UserProfileTable
    with TableInfo<$UserProfileTableTable, UserProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _monthlySalaryMeta =
      const VerificationMeta('monthlySalary');
  @override
  late final GeneratedColumn<double> monthlySalary = GeneratedColumn<double>(
      'monthly_salary', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _payDayMeta = const VerificationMeta('payDay');
  @override
  late final GeneratedColumn<int> payDay = GeneratedColumn<int>(
      'pay_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, monthlySalary, payDay, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfileEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
          _monthlySalaryMeta,
          monthlySalary.isAcceptableOrUnknown(
              data['monthly_salary']!, _monthlySalaryMeta));
    }
    if (data.containsKey('pay_day')) {
      context.handle(_payDayMeta,
          payDay.isAcceptableOrUnknown(data['pay_day']!, _payDayMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      monthlySalary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_salary']),
      payDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pay_day']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UserProfileTableTable createAlias(String alias) {
    return $UserProfileTableTable(attachedDatabase, alias);
  }
}

class UserProfileEntity extends DataClass
    implements Insertable<UserProfileEntity> {
  final String id;
  final String? name;
  final double? monthlySalary;
  final int? payDay;
  final DateTime createdAt;
  const UserProfileEntity(
      {required this.id,
      this.name,
      this.monthlySalary,
      this.payDay,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || monthlySalary != null) {
      map['monthly_salary'] = Variable<double>(monthlySalary);
    }
    if (!nullToAbsent || payDay != null) {
      map['pay_day'] = Variable<int>(payDay);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfileTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfileTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      monthlySalary: monthlySalary == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlySalary),
      payDay:
          payDay == null && nullToAbsent ? const Value.absent() : Value(payDay),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfileEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      monthlySalary: serializer.fromJson<double?>(json['monthlySalary']),
      payDay: serializer.fromJson<int?>(json['payDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'monthlySalary': serializer.toJson<double?>(monthlySalary),
      'payDay': serializer.toJson<int?>(payDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfileEntity copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<double?> monthlySalary = const Value.absent(),
          Value<int?> payDay = const Value.absent(),
          DateTime? createdAt}) =>
      UserProfileEntity(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        monthlySalary:
            monthlySalary.present ? monthlySalary.value : this.monthlySalary,
        payDay: payDay.present ? payDay.value : this.payDay,
        createdAt: createdAt ?? this.createdAt,
      );
  UserProfileEntity copyWithCompanion(UserProfileTableCompanion data) {
    return UserProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      payDay: data.payDay.present ? data.payDay.value : this.payDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('payDay: $payDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, monthlySalary, payDay, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.monthlySalary == this.monthlySalary &&
          other.payDay == this.payDay &&
          other.createdAt == this.createdAt);
}

class UserProfileTableCompanion extends UpdateCompanion<UserProfileEntity> {
  final Value<String> id;
  final Value<String?> name;
  final Value<double?> monthlySalary;
  final Value<int?> payDay;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserProfileTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.payDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.payDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserProfileEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? monthlySalary,
    Expression<int>? payDay,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (payDay != null) 'pay_day': payDay,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<double?>? monthlySalary,
      Value<int?>? payDay,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UserProfileTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      payDay: payDay ?? this.payDay,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<double>(monthlySalary.value);
    }
    if (payDay.present) {
      map['pay_day'] = Variable<int>(payDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('payDay: $payDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishlistTableTable extends WishlistTable
    with TableInfo<$WishlistTableTable, WishlistEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedCostMeta =
      const VerificationMeta('estimatedCost');
  @override
  late final GeneratedColumn<double> estimatedCost = GeneratedColumn<double>(
      'estimated_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _installmentsMeta =
      const VerificationMeta('installments');
  @override
  late final GeneratedColumn<int> installments = GeneratedColumn<int>(
      'installments', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _hasPromoMeta =
      const VerificationMeta('hasPromo');
  @override
  late final GeneratedColumn<bool> hasPromo = GeneratedColumn<bool>(
      'has_promo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_promo" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPurchasedMeta =
      const VerificationMeta('isPurchased');
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
      'is_purchased', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_purchased" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _purchasedAtMeta =
      const VerificationMeta('purchasedAt');
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
      'purchased_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _purchaseMethodMeta =
      const VerificationMeta('purchaseMethod');
  @override
  late final GeneratedColumn<String> purchaseMethod = GeneratedColumn<String>(
      'purchase_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseAccountIdMeta =
      const VerificationMeta('purchaseAccountId');
  @override
  late final GeneratedColumn<String> purchaseAccountId =
      GeneratedColumn<String>('purchase_account_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedBudgetIdMeta =
      const VerificationMeta('linkedBudgetId');
  @override
  late final GeneratedColumn<String> linkedBudgetId = GeneratedColumn<String>(
      'linked_budget_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderDaysMeta =
      const VerificationMeta('reminderDays');
  @override
  late final GeneratedColumn<int> reminderDays = GeneratedColumn<int>(
      'reminder_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderSnoozedUntilMeta =
      const VerificationMeta('reminderSnoozedUntil');
  @override
  late final GeneratedColumn<DateTime> reminderSnoozedUntil =
      GeneratedColumn<DateTime>('reminder_snoozed_until', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderDismissedMeta =
      const VerificationMeta('reminderDismissed');
  @override
  late final GeneratedColumn<bool> reminderDismissed = GeneratedColumn<bool>(
      'reminder_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        estimatedCost,
        note,
        url,
        installments,
        hasPromo,
        createdAt,
        isPurchased,
        purchasedAt,
        purchaseMethod,
        purchaseAccountId,
        linkedBudgetId,
        reminderDays,
        reminderSnoozedUntil,
        reminderDismissed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_table';
  @override
  VerificationContext validateIntegrity(Insertable<WishlistEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
          _estimatedCostMeta,
          estimatedCost.isAcceptableOrUnknown(
              data['estimated_cost']!, _estimatedCostMeta));
    } else if (isInserting) {
      context.missing(_estimatedCostMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('installments')) {
      context.handle(
          _installmentsMeta,
          installments.isAcceptableOrUnknown(
              data['installments']!, _installmentsMeta));
    }
    if (data.containsKey('has_promo')) {
      context.handle(_hasPromoMeta,
          hasPromo.isAcceptableOrUnknown(data['has_promo']!, _hasPromoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
          _isPurchasedMeta,
          isPurchased.isAcceptableOrUnknown(
              data['is_purchased']!, _isPurchasedMeta));
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
          _purchasedAtMeta,
          purchasedAt.isAcceptableOrUnknown(
              data['purchased_at']!, _purchasedAtMeta));
    }
    if (data.containsKey('purchase_method')) {
      context.handle(
          _purchaseMethodMeta,
          purchaseMethod.isAcceptableOrUnknown(
              data['purchase_method']!, _purchaseMethodMeta));
    }
    if (data.containsKey('purchase_account_id')) {
      context.handle(
          _purchaseAccountIdMeta,
          purchaseAccountId.isAcceptableOrUnknown(
              data['purchase_account_id']!, _purchaseAccountIdMeta));
    }
    if (data.containsKey('linked_budget_id')) {
      context.handle(
          _linkedBudgetIdMeta,
          linkedBudgetId.isAcceptableOrUnknown(
              data['linked_budget_id']!, _linkedBudgetIdMeta));
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
          _reminderDaysMeta,
          reminderDays.isAcceptableOrUnknown(
              data['reminder_days']!, _reminderDaysMeta));
    }
    if (data.containsKey('reminder_snoozed_until')) {
      context.handle(
          _reminderSnoozedUntilMeta,
          reminderSnoozedUntil.isAcceptableOrUnknown(
              data['reminder_snoozed_until']!, _reminderSnoozedUntilMeta));
    }
    if (data.containsKey('reminder_dismissed')) {
      context.handle(
          _reminderDismissedMeta,
          reminderDismissed.isAcceptableOrUnknown(
              data['reminder_dismissed']!, _reminderDismissedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishlistEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      estimatedCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}estimated_cost'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
      installments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installments'])!,
      hasPromo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_promo'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isPurchased: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_purchased'])!,
      purchasedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}purchased_at']),
      purchaseMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_method']),
      purchaseAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}purchase_account_id']),
      linkedBudgetId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_budget_id']),
      reminderDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_days']),
      reminderSnoozedUntil: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}reminder_snoozed_until']),
      reminderDismissed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}reminder_dismissed'])!,
    );
  }

  @override
  $WishlistTableTable createAlias(String alias) {
    return $WishlistTableTable(attachedDatabase, alias);
  }
}

class WishlistEntity extends DataClass implements Insertable<WishlistEntity> {
  final String id;
  final String title;
  final double estimatedCost;
  final String? note;
  final String? url;
  final int installments;
  final bool hasPromo;
  final DateTime createdAt;
  final bool isPurchased;
  final DateTime? purchasedAt;
  final String? purchaseMethod;
  final String? purchaseAccountId;
  final String? linkedBudgetId;
  final int? reminderDays;
  final DateTime? reminderSnoozedUntil;
  final bool reminderDismissed;
  const WishlistEntity(
      {required this.id,
      required this.title,
      required this.estimatedCost,
      this.note,
      this.url,
      required this.installments,
      required this.hasPromo,
      required this.createdAt,
      required this.isPurchased,
      this.purchasedAt,
      this.purchaseMethod,
      this.purchaseAccountId,
      this.linkedBudgetId,
      this.reminderDays,
      this.reminderSnoozedUntil,
      required this.reminderDismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['estimated_cost'] = Variable<double>(estimatedCost);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['installments'] = Variable<int>(installments);
    map['has_promo'] = Variable<bool>(hasPromo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_purchased'] = Variable<bool>(isPurchased);
    if (!nullToAbsent || purchasedAt != null) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt);
    }
    if (!nullToAbsent || purchaseMethod != null) {
      map['purchase_method'] = Variable<String>(purchaseMethod);
    }
    if (!nullToAbsent || purchaseAccountId != null) {
      map['purchase_account_id'] = Variable<String>(purchaseAccountId);
    }
    if (!nullToAbsent || linkedBudgetId != null) {
      map['linked_budget_id'] = Variable<String>(linkedBudgetId);
    }
    if (!nullToAbsent || reminderDays != null) {
      map['reminder_days'] = Variable<int>(reminderDays);
    }
    if (!nullToAbsent || reminderSnoozedUntil != null) {
      map['reminder_snoozed_until'] = Variable<DateTime>(reminderSnoozedUntil);
    }
    map['reminder_dismissed'] = Variable<bool>(reminderDismissed);
    return map;
  }

  WishlistTableCompanion toCompanion(bool nullToAbsent) {
    return WishlistTableCompanion(
      id: Value(id),
      title: Value(title),
      estimatedCost: Value(estimatedCost),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      installments: Value(installments),
      hasPromo: Value(hasPromo),
      createdAt: Value(createdAt),
      isPurchased: Value(isPurchased),
      purchasedAt: purchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedAt),
      purchaseMethod: purchaseMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseMethod),
      purchaseAccountId: purchaseAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseAccountId),
      linkedBudgetId: linkedBudgetId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedBudgetId),
      reminderDays: reminderDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDays),
      reminderSnoozedUntil: reminderSnoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderSnoozedUntil),
      reminderDismissed: Value(reminderDismissed),
    );
  }

  factory WishlistEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      estimatedCost: serializer.fromJson<double>(json['estimatedCost']),
      note: serializer.fromJson<String?>(json['note']),
      url: serializer.fromJson<String?>(json['url']),
      installments: serializer.fromJson<int>(json['installments']),
      hasPromo: serializer.fromJson<bool>(json['hasPromo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      purchasedAt: serializer.fromJson<DateTime?>(json['purchasedAt']),
      purchaseMethod: serializer.fromJson<String?>(json['purchaseMethod']),
      purchaseAccountId:
          serializer.fromJson<String?>(json['purchaseAccountId']),
      linkedBudgetId: serializer.fromJson<String?>(json['linkedBudgetId']),
      reminderDays: serializer.fromJson<int?>(json['reminderDays']),
      reminderSnoozedUntil:
          serializer.fromJson<DateTime?>(json['reminderSnoozedUntil']),
      reminderDismissed: serializer.fromJson<bool>(json['reminderDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'estimatedCost': serializer.toJson<double>(estimatedCost),
      'note': serializer.toJson<String?>(note),
      'url': serializer.toJson<String?>(url),
      'installments': serializer.toJson<int>(installments),
      'hasPromo': serializer.toJson<bool>(hasPromo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'purchasedAt': serializer.toJson<DateTime?>(purchasedAt),
      'purchaseMethod': serializer.toJson<String?>(purchaseMethod),
      'purchaseAccountId': serializer.toJson<String?>(purchaseAccountId),
      'linkedBudgetId': serializer.toJson<String?>(linkedBudgetId),
      'reminderDays': serializer.toJson<int?>(reminderDays),
      'reminderSnoozedUntil':
          serializer.toJson<DateTime?>(reminderSnoozedUntil),
      'reminderDismissed': serializer.toJson<bool>(reminderDismissed),
    };
  }

  WishlistEntity copyWith(
          {String? id,
          String? title,
          double? estimatedCost,
          Value<String?> note = const Value.absent(),
          Value<String?> url = const Value.absent(),
          int? installments,
          bool? hasPromo,
          DateTime? createdAt,
          bool? isPurchased,
          Value<DateTime?> purchasedAt = const Value.absent(),
          Value<String?> purchaseMethod = const Value.absent(),
          Value<String?> purchaseAccountId = const Value.absent(),
          Value<String?> linkedBudgetId = const Value.absent(),
          Value<int?> reminderDays = const Value.absent(),
          Value<DateTime?> reminderSnoozedUntil = const Value.absent(),
          bool? reminderDismissed}) =>
      WishlistEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        estimatedCost: estimatedCost ?? this.estimatedCost,
        note: note.present ? note.value : this.note,
        url: url.present ? url.value : this.url,
        installments: installments ?? this.installments,
        hasPromo: hasPromo ?? this.hasPromo,
        createdAt: createdAt ?? this.createdAt,
        isPurchased: isPurchased ?? this.isPurchased,
        purchasedAt: purchasedAt.present ? purchasedAt.value : this.purchasedAt,
        purchaseMethod:
            purchaseMethod.present ? purchaseMethod.value : this.purchaseMethod,
        purchaseAccountId: purchaseAccountId.present
            ? purchaseAccountId.value
            : this.purchaseAccountId,
        linkedBudgetId:
            linkedBudgetId.present ? linkedBudgetId.value : this.linkedBudgetId,
        reminderDays:
            reminderDays.present ? reminderDays.value : this.reminderDays,
        reminderSnoozedUntil: reminderSnoozedUntil.present
            ? reminderSnoozedUntil.value
            : this.reminderSnoozedUntil,
        reminderDismissed: reminderDismissed ?? this.reminderDismissed,
      );
  WishlistEntity copyWithCompanion(WishlistTableCompanion data) {
    return WishlistEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      estimatedCost: data.estimatedCost.present
          ? data.estimatedCost.value
          : this.estimatedCost,
      note: data.note.present ? data.note.value : this.note,
      url: data.url.present ? data.url.value : this.url,
      installments: data.installments.present
          ? data.installments.value
          : this.installments,
      hasPromo: data.hasPromo.present ? data.hasPromo.value : this.hasPromo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isPurchased:
          data.isPurchased.present ? data.isPurchased.value : this.isPurchased,
      purchasedAt:
          data.purchasedAt.present ? data.purchasedAt.value : this.purchasedAt,
      purchaseMethod: data.purchaseMethod.present
          ? data.purchaseMethod.value
          : this.purchaseMethod,
      purchaseAccountId: data.purchaseAccountId.present
          ? data.purchaseAccountId.value
          : this.purchaseAccountId,
      linkedBudgetId: data.linkedBudgetId.present
          ? data.linkedBudgetId.value
          : this.linkedBudgetId,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      reminderSnoozedUntil: data.reminderSnoozedUntil.present
          ? data.reminderSnoozedUntil.value
          : this.reminderSnoozedUntil,
      reminderDismissed: data.reminderDismissed.present
          ? data.reminderDismissed.value
          : this.reminderDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('note: $note, ')
          ..write('url: $url, ')
          ..write('installments: $installments, ')
          ..write('hasPromo: $hasPromo, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('purchaseMethod: $purchaseMethod, ')
          ..write('purchaseAccountId: $purchaseAccountId, ')
          ..write('linkedBudgetId: $linkedBudgetId, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('reminderSnoozedUntil: $reminderSnoozedUntil, ')
          ..write('reminderDismissed: $reminderDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      estimatedCost,
      note,
      url,
      installments,
      hasPromo,
      createdAt,
      isPurchased,
      purchasedAt,
      purchaseMethod,
      purchaseAccountId,
      linkedBudgetId,
      reminderDays,
      reminderSnoozedUntil,
      reminderDismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.estimatedCost == this.estimatedCost &&
          other.note == this.note &&
          other.url == this.url &&
          other.installments == this.installments &&
          other.hasPromo == this.hasPromo &&
          other.createdAt == this.createdAt &&
          other.isPurchased == this.isPurchased &&
          other.purchasedAt == this.purchasedAt &&
          other.purchaseMethod == this.purchaseMethod &&
          other.purchaseAccountId == this.purchaseAccountId &&
          other.linkedBudgetId == this.linkedBudgetId &&
          other.reminderDays == this.reminderDays &&
          other.reminderSnoozedUntil == this.reminderSnoozedUntil &&
          other.reminderDismissed == this.reminderDismissed);
}

class WishlistTableCompanion extends UpdateCompanion<WishlistEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> estimatedCost;
  final Value<String?> note;
  final Value<String?> url;
  final Value<int> installments;
  final Value<bool> hasPromo;
  final Value<DateTime> createdAt;
  final Value<bool> isPurchased;
  final Value<DateTime?> purchasedAt;
  final Value<String?> purchaseMethod;
  final Value<String?> purchaseAccountId;
  final Value<String?> linkedBudgetId;
  final Value<int?> reminderDays;
  final Value<DateTime?> reminderSnoozedUntil;
  final Value<bool> reminderDismissed;
  final Value<int> rowid;
  const WishlistTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.note = const Value.absent(),
    this.url = const Value.absent(),
    this.installments = const Value.absent(),
    this.hasPromo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.purchaseMethod = const Value.absent(),
    this.purchaseAccountId = const Value.absent(),
    this.linkedBudgetId = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.reminderSnoozedUntil = const Value.absent(),
    this.reminderDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishlistTableCompanion.insert({
    required String id,
    required String title,
    required double estimatedCost,
    this.note = const Value.absent(),
    this.url = const Value.absent(),
    this.installments = const Value.absent(),
    this.hasPromo = const Value.absent(),
    required DateTime createdAt,
    this.isPurchased = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.purchaseMethod = const Value.absent(),
    this.purchaseAccountId = const Value.absent(),
    this.linkedBudgetId = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.reminderSnoozedUntil = const Value.absent(),
    this.reminderDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        estimatedCost = Value(estimatedCost),
        createdAt = Value(createdAt);
  static Insertable<WishlistEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? estimatedCost,
    Expression<String>? note,
    Expression<String>? url,
    Expression<int>? installments,
    Expression<bool>? hasPromo,
    Expression<DateTime>? createdAt,
    Expression<bool>? isPurchased,
    Expression<DateTime>? purchasedAt,
    Expression<String>? purchaseMethod,
    Expression<String>? purchaseAccountId,
    Expression<String>? linkedBudgetId,
    Expression<int>? reminderDays,
    Expression<DateTime>? reminderSnoozedUntil,
    Expression<bool>? reminderDismissed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (note != null) 'note': note,
      if (url != null) 'url': url,
      if (installments != null) 'installments': installments,
      if (hasPromo != null) 'has_promo': hasPromo,
      if (createdAt != null) 'created_at': createdAt,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (purchaseMethod != null) 'purchase_method': purchaseMethod,
      if (purchaseAccountId != null) 'purchase_account_id': purchaseAccountId,
      if (linkedBudgetId != null) 'linked_budget_id': linkedBudgetId,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (reminderSnoozedUntil != null)
        'reminder_snoozed_until': reminderSnoozedUntil,
      if (reminderDismissed != null) 'reminder_dismissed': reminderDismissed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishlistTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? estimatedCost,
      Value<String?>? note,
      Value<String?>? url,
      Value<int>? installments,
      Value<bool>? hasPromo,
      Value<DateTime>? createdAt,
      Value<bool>? isPurchased,
      Value<DateTime?>? purchasedAt,
      Value<String?>? purchaseMethod,
      Value<String?>? purchaseAccountId,
      Value<String?>? linkedBudgetId,
      Value<int?>? reminderDays,
      Value<DateTime?>? reminderSnoozedUntil,
      Value<bool>? reminderDismissed,
      Value<int>? rowid}) {
    return WishlistTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      note: note ?? this.note,
      url: url ?? this.url,
      installments: installments ?? this.installments,
      hasPromo: hasPromo ?? this.hasPromo,
      createdAt: createdAt ?? this.createdAt,
      isPurchased: isPurchased ?? this.isPurchased,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      purchaseMethod: purchaseMethod ?? this.purchaseMethod,
      purchaseAccountId: purchaseAccountId ?? this.purchaseAccountId,
      linkedBudgetId: linkedBudgetId ?? this.linkedBudgetId,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderSnoozedUntil: reminderSnoozedUntil ?? this.reminderSnoozedUntil,
      reminderDismissed: reminderDismissed ?? this.reminderDismissed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<double>(estimatedCost.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (installments.present) {
      map['installments'] = Variable<int>(installments.value);
    }
    if (hasPromo.present) {
      map['has_promo'] = Variable<bool>(hasPromo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (purchaseMethod.present) {
      map['purchase_method'] = Variable<String>(purchaseMethod.value);
    }
    if (purchaseAccountId.present) {
      map['purchase_account_id'] = Variable<String>(purchaseAccountId.value);
    }
    if (linkedBudgetId.present) {
      map['linked_budget_id'] = Variable<String>(linkedBudgetId.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<int>(reminderDays.value);
    }
    if (reminderSnoozedUntil.present) {
      map['reminder_snoozed_until'] =
          Variable<DateTime>(reminderSnoozedUntil.value);
    }
    if (reminderDismissed.present) {
      map['reminder_dismissed'] = Variable<bool>(reminderDismissed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('note: $note, ')
          ..write('url: $url, ')
          ..write('installments: $installments, ')
          ..write('hasPromo: $hasPromo, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('purchaseMethod: $purchaseMethod, ')
          ..write('purchaseAccountId: $purchaseAccountId, ')
          ..write('linkedBudgetId: $linkedBudgetId, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('reminderSnoozedUntil: $reminderSnoozedUntil, ')
          ..write('reminderDismissed: $reminderDismissed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTableTable extends RecurringTransactionsTable
    with
        TableInfo<$RecurringTransactionsTableTable,
            RecurringTransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nextDateMeta =
      const VerificationMeta('nextDate');
  @override
  late final GeneratedColumn<DateTime> nextDate = GeneratedColumn<DateTime>(
      'next_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        type,
        categoryId,
        accountId,
        note,
        frequency,
        nextDate,
        isActive,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurringTransactionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('next_date')) {
      context.handle(_nextDateMeta,
          nextDate.isAcceptableOrUnknown(data['next_date']!, _nextDateMeta));
    } else if (isInserting) {
      context.missing(_nextDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransactionEntity map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransactionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      nextDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_date'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecurringTransactionsTableTable createAlias(String alias) {
    return $RecurringTransactionsTableTable(attachedDatabase, alias);
  }
}

class RecurringTransactionEntity extends DataClass
    implements Insertable<RecurringTransactionEntity> {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String categoryId;
  final String accountId;
  final String? note;
  final String frequency;
  final DateTime nextDate;
  final bool isActive;
  final DateTime createdAt;
  const RecurringTransactionEntity(
      {required this.id,
      required this.title,
      required this.amount,
      required this.type,
      required this.categoryId,
      required this.accountId,
      this.note,
      required this.frequency,
      required this.nextDate,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category_id'] = Variable<String>(categoryId);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['frequency'] = Variable<String>(frequency);
    map['next_date'] = Variable<DateTime>(nextDate);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurringTransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      type: Value(type),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      frequency: Value(frequency),
      nextDate: Value(nextDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory RecurringTransactionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransactionEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      note: serializer.fromJson<String?>(json['note']),
      frequency: serializer.fromJson<String>(json['frequency']),
      nextDate: serializer.fromJson<DateTime>(json['nextDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'categoryId': serializer.toJson<String>(categoryId),
      'accountId': serializer.toJson<String>(accountId),
      'note': serializer.toJson<String?>(note),
      'frequency': serializer.toJson<String>(frequency),
      'nextDate': serializer.toJson<DateTime>(nextDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurringTransactionEntity copyWith(
          {String? id,
          String? title,
          double? amount,
          String? type,
          String? categoryId,
          String? accountId,
          Value<String?> note = const Value.absent(),
          String? frequency,
          DateTime? nextDate,
          bool? isActive,
          DateTime? createdAt}) =>
      RecurringTransactionEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        accountId: accountId ?? this.accountId,
        note: note.present ? note.value : this.note,
        frequency: frequency ?? this.frequency,
        nextDate: nextDate ?? this.nextDate,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  RecurringTransactionEntity copyWithCompanion(
      RecurringTransactionsTableCompanion data) {
    return RecurringTransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      note: data.note.present ? data.note.value : this.note,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDate: data.nextDate.present ? data.nextDate.value : this.nextDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('nextDate: $nextDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, type, categoryId,
      accountId, note, frequency, nextDate, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransactionEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.note == this.note &&
          other.frequency == this.frequency &&
          other.nextDate == this.nextDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class RecurringTransactionsTableCompanion
    extends UpdateCompanion<RecurringTransactionEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> categoryId;
  final Value<String> accountId;
  final Value<String?> note;
  final Value<String> frequency;
  final Value<DateTime> nextDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecurringTransactionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.note = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringTransactionsTableCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String categoryId,
    required String accountId,
    this.note = const Value.absent(),
    required String frequency,
    required DateTime nextDate,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        categoryId = Value(categoryId),
        accountId = Value(accountId),
        frequency = Value(frequency),
        nextDate = Value(nextDate),
        createdAt = Value(createdAt);
  static Insertable<RecurringTransactionEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? categoryId,
    Expression<String>? accountId,
    Expression<String>? note,
    Expression<String>? frequency,
    Expression<DateTime>? nextDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (note != null) 'note': note,
      if (frequency != null) 'frequency': frequency,
      if (nextDate != null) 'next_date': nextDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringTransactionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? categoryId,
      Value<String>? accountId,
      Value<String?>? note,
      Value<String>? frequency,
      Value<DateTime>? nextDate,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RecurringTransactionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      nextDate: nextDate ?? this.nextDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (nextDate.present) {
      map['next_date'] = Variable<DateTime>(nextDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('nextDate: $nextDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallmentsTableTable extends InstallmentsTable
    with TableInfo<$InstallmentsTableTable, InstallmentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalInstallmentsMeta =
      const VerificationMeta('totalInstallments');
  @override
  late final GeneratedColumn<int> totalInstallments = GeneratedColumn<int>(
      'total_installments', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidInstallmentsMeta =
      const VerificationMeta('paidInstallments');
  @override
  late final GeneratedColumn<int> paidInstallments = GeneratedColumn<int>(
      'paid_installments', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _installmentAmountMeta =
      const VerificationMeta('installmentAmount');
  @override
  late final GeneratedColumn<double> installmentAmount =
      GeneratedColumn<double>('installment_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        title,
        totalAmount,
        totalInstallments,
        paidInstallments,
        installmentAmount,
        startDate,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installments_table';
  @override
  VerificationContext validateIntegrity(Insertable<InstallmentEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_installments')) {
      context.handle(
          _totalInstallmentsMeta,
          totalInstallments.isAcceptableOrUnknown(
              data['total_installments']!, _totalInstallmentsMeta));
    } else if (isInserting) {
      context.missing(_totalInstallmentsMeta);
    }
    if (data.containsKey('paid_installments')) {
      context.handle(
          _paidInstallmentsMeta,
          paidInstallments.isAcceptableOrUnknown(
              data['paid_installments']!, _paidInstallmentsMeta));
    }
    if (data.containsKey('installment_amount')) {
      context.handle(
          _installmentAmountMeta,
          installmentAmount.isAcceptableOrUnknown(
              data['installment_amount']!, _installmentAmountMeta));
    } else if (isInserting) {
      context.missing(_installmentAmountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      totalInstallments: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_installments'])!,
      paidInstallments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_installments'])!,
      installmentAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}installment_amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $InstallmentsTableTable createAlias(String alias) {
    return $InstallmentsTableTable(attachedDatabase, alias);
  }
}

class InstallmentEntry extends DataClass
    implements Insertable<InstallmentEntry> {
  final String id;
  final String accountId;
  final String title;
  final double totalAmount;
  final int totalInstallments;
  final int paidInstallments;
  final double installmentAmount;
  final DateTime startDate;
  final String? note;
  const InstallmentEntry(
      {required this.id,
      required this.accountId,
      required this.title,
      required this.totalAmount,
      required this.totalInstallments,
      required this.paidInstallments,
      required this.installmentAmount,
      required this.startDate,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['title'] = Variable<String>(title);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_installments'] = Variable<int>(totalInstallments);
    map['paid_installments'] = Variable<int>(paidInstallments);
    map['installment_amount'] = Variable<double>(installmentAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  InstallmentsTableCompanion toCompanion(bool nullToAbsent) {
    return InstallmentsTableCompanion(
      id: Value(id),
      accountId: Value(accountId),
      title: Value(title),
      totalAmount: Value(totalAmount),
      totalInstallments: Value(totalInstallments),
      paidInstallments: Value(paidInstallments),
      installmentAmount: Value(installmentAmount),
      startDate: Value(startDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory InstallmentEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentEntry(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      title: serializer.fromJson<String>(json['title']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalInstallments: serializer.fromJson<int>(json['totalInstallments']),
      paidInstallments: serializer.fromJson<int>(json['paidInstallments']),
      installmentAmount: serializer.fromJson<double>(json['installmentAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'title': serializer.toJson<String>(title),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalInstallments': serializer.toJson<int>(totalInstallments),
      'paidInstallments': serializer.toJson<int>(paidInstallments),
      'installmentAmount': serializer.toJson<double>(installmentAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  InstallmentEntry copyWith(
          {String? id,
          String? accountId,
          String? title,
          double? totalAmount,
          int? totalInstallments,
          int? paidInstallments,
          double? installmentAmount,
          DateTime? startDate,
          Value<String?> note = const Value.absent()}) =>
      InstallmentEntry(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        title: title ?? this.title,
        totalAmount: totalAmount ?? this.totalAmount,
        totalInstallments: totalInstallments ?? this.totalInstallments,
        paidInstallments: paidInstallments ?? this.paidInstallments,
        installmentAmount: installmentAmount ?? this.installmentAmount,
        startDate: startDate ?? this.startDate,
        note: note.present ? note.value : this.note,
      );
  InstallmentEntry copyWithCompanion(InstallmentsTableCompanion data) {
    return InstallmentEntry(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      title: data.title.present ? data.title.value : this.title,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      totalInstallments: data.totalInstallments.present
          ? data.totalInstallments.value
          : this.totalInstallments,
      paidInstallments: data.paidInstallments.present
          ? data.paidInstallments.value
          : this.paidInstallments,
      installmentAmount: data.installmentAmount.present
          ? data.installmentAmount.value
          : this.installmentAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentEntry(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, title, totalAmount,
      totalInstallments, paidInstallments, installmentAmount, startDate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentEntry &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.title == this.title &&
          other.totalAmount == this.totalAmount &&
          other.totalInstallments == this.totalInstallments &&
          other.paidInstallments == this.paidInstallments &&
          other.installmentAmount == this.installmentAmount &&
          other.startDate == this.startDate &&
          other.note == this.note);
}

class InstallmentsTableCompanion extends UpdateCompanion<InstallmentEntry> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> title;
  final Value<double> totalAmount;
  final Value<int> totalInstallments;
  final Value<int> paidInstallments;
  final Value<double> installmentAmount;
  final Value<DateTime> startDate;
  final Value<String?> note;
  final Value<int> rowid;
  const InstallmentsTableCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.title = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalInstallments = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallmentsTableCompanion.insert({
    required String id,
    required String accountId,
    required String title,
    required double totalAmount,
    required int totalInstallments,
    this.paidInstallments = const Value.absent(),
    required double installmentAmount,
    required DateTime startDate,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        title = Value(title),
        totalAmount = Value(totalAmount),
        totalInstallments = Value(totalInstallments),
        installmentAmount = Value(installmentAmount),
        startDate = Value(startDate);
  static Insertable<InstallmentEntry> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? title,
    Expression<double>? totalAmount,
    Expression<int>? totalInstallments,
    Expression<int>? paidInstallments,
    Expression<double>? installmentAmount,
    Expression<DateTime>? startDate,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (title != null) 'title': title,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalInstallments != null) 'total_installments': totalInstallments,
      if (paidInstallments != null) 'paid_installments': paidInstallments,
      if (installmentAmount != null) 'installment_amount': installmentAmount,
      if (startDate != null) 'start_date': startDate,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallmentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String>? title,
      Value<double>? totalAmount,
      Value<int>? totalInstallments,
      Value<int>? paidInstallments,
      Value<double>? installmentAmount,
      Value<DateTime>? startDate,
      Value<String?>? note,
      Value<int>? rowid}) {
    return InstallmentsTableCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      startDate: startDate ?? this.startDate,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalInstallments.present) {
      map['total_installments'] = Variable<int>(totalInstallments.value);
    }
    if (paidInstallments.present) {
      map['paid_installments'] = Variable<int>(paidInstallments.value);
    }
    if (installmentAmount.present) {
      map['installment_amount'] = Variable<double>(installmentAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTableTable extends TagsTable
    with TableInfo<$TagsTableTable, TagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue, iconName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags_table';
  @override
  VerificationContext validateIntegrity(Insertable<TagEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value']),
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
    );
  }

  @override
  $TagsTableTable createAlias(String alias) {
    return $TagsTableTable(attachedDatabase, alias);
  }
}

class TagEntry extends DataClass implements Insertable<TagEntry> {
  final String id;
  final String name;
  final int? colorValue;
  final String? iconName;
  const TagEntry(
      {required this.id, required this.name, this.colorValue, this.iconName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    return map;
  }

  TagsTableCompanion toCompanion(bool nullToAbsent) {
    return TagsTableCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
    );
  }

  factory TagEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      iconName: serializer.fromJson<String?>(json['iconName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int?>(colorValue),
      'iconName': serializer.toJson<String?>(iconName),
    };
  }

  TagEntry copyWith(
          {String? id,
          String? name,
          Value<int?> colorValue = const Value.absent(),
          Value<String?> iconName = const Value.absent()}) =>
      TagEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue.present ? colorValue.value : this.colorValue,
        iconName: iconName.present ? iconName.value : this.iconName,
      );
  TagEntry copyWithCompanion(TagsTableCompanion data) {
    return TagEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconName: $iconName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, iconName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.iconName == this.iconName);
}

class TagsTableCompanion extends UpdateCompanion<TagEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> colorValue;
  final Value<String?> iconName;
  final Value<int> rowid;
  const TagsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsTableCompanion.insert({
    required String id,
    required String name,
    this.colorValue = const Value.absent(),
    this.iconName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<TagEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<String>? iconName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (iconName != null) 'icon_name': iconName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? colorValue,
      Value<String?>? iconName,
      Value<int>? rowid}) {
    return TagsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconName: $iconName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionTagsTableTable extends TransactionTagsTable
    with TableInfo<$TransactionTagsTableTable, TransactionTagEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [transactionId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_tags_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionTagEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId, tagId};
  @override
  TransactionTagEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTagEntry(
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $TransactionTagsTableTable createAlias(String alias) {
    return $TransactionTagsTableTable(attachedDatabase, alias);
  }
}

class TransactionTagEntry extends DataClass
    implements Insertable<TransactionTagEntry> {
  final String transactionId;
  final String tagId;
  const TransactionTagEntry({required this.transactionId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<String>(transactionId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  TransactionTagsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTagsTableCompanion(
      transactionId: Value(transactionId),
      tagId: Value(tagId),
    );
  }

  factory TransactionTagEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTagEntry(
      transactionId: serializer.fromJson<String>(json['transactionId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<String>(transactionId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  TransactionTagEntry copyWith({String? transactionId, String? tagId}) =>
      TransactionTagEntry(
        transactionId: transactionId ?? this.transactionId,
        tagId: tagId ?? this.tagId,
      );
  TransactionTagEntry copyWithCompanion(TransactionTagsTableCompanion data) {
    return TransactionTagEntry(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagEntry(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTagEntry &&
          other.transactionId == this.transactionId &&
          other.tagId == this.tagId);
}

class TransactionTagsTableCompanion
    extends UpdateCompanion<TransactionTagEntry> {
  final Value<String> transactionId;
  final Value<String> tagId;
  final Value<int> rowid;
  const TransactionTagsTableCompanion({
    this.transactionId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTagsTableCompanion.insert({
    required String transactionId,
    required String tagId,
    this.rowid = const Value.absent(),
  })  : transactionId = Value(transactionId),
        tagId = Value(tagId);
  static Insertable<TransactionTagEntry> custom({
    Expression<String>? transactionId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTagsTableCompanion copyWith(
      {Value<String>? transactionId, Value<String>? tagId, Value<int>? rowid}) {
    return TransactionTagsTableCompanion(
      transactionId: transactionId ?? this.transactionId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagsTableCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledPaymentsTableTable extends ScheduledPaymentsTable
    with TableInfo<$ScheduledPaymentsTableTable, ScheduledPaymentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledPaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _autoPayMeta =
      const VerificationMeta('autoPay');
  @override
  late final GeneratedColumn<bool> autoPay = GeneratedColumn<bool>(
      'auto_pay', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_pay" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        accountId,
        categoryId,
        dueDate,
        frequency,
        autoPay,
        isActive,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_payments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScheduledPaymentEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('auto_pay')) {
      context.handle(_autoPayMeta,
          autoPay.isAcceptableOrUnknown(data['auto_pay']!, _autoPayMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledPaymentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledPaymentEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      autoPay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_pay'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $ScheduledPaymentsTableTable createAlias(String alias) {
    return $ScheduledPaymentsTableTable(attachedDatabase, alias);
  }
}

class ScheduledPaymentEntry extends DataClass
    implements Insertable<ScheduledPaymentEntry> {
  final String id;
  final String title;
  final double amount;
  final String? accountId;
  final String? categoryId;
  final DateTime dueDate;
  final String frequency;
  final bool autoPay;
  final bool isActive;
  final String? note;
  const ScheduledPaymentEntry(
      {required this.id,
      required this.title,
      required this.amount,
      this.accountId,
      this.categoryId,
      required this.dueDate,
      required this.frequency,
      required this.autoPay,
      required this.isActive,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['frequency'] = Variable<String>(frequency);
    map['auto_pay'] = Variable<bool>(autoPay);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ScheduledPaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return ScheduledPaymentsTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      dueDate: Value(dueDate),
      frequency: Value(frequency),
      autoPay: Value(autoPay),
      isActive: Value(isActive),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ScheduledPaymentEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledPaymentEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      frequency: serializer.fromJson<String>(json['frequency']),
      autoPay: serializer.fromJson<bool>(json['autoPay']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'accountId': serializer.toJson<String?>(accountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'frequency': serializer.toJson<String>(frequency),
      'autoPay': serializer.toJson<bool>(autoPay),
      'isActive': serializer.toJson<bool>(isActive),
      'note': serializer.toJson<String?>(note),
    };
  }

  ScheduledPaymentEntry copyWith(
          {String? id,
          String? title,
          double? amount,
          Value<String?> accountId = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          DateTime? dueDate,
          String? frequency,
          bool? autoPay,
          bool? isActive,
          Value<String?> note = const Value.absent()}) =>
      ScheduledPaymentEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        accountId: accountId.present ? accountId.value : this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        dueDate: dueDate ?? this.dueDate,
        frequency: frequency ?? this.frequency,
        autoPay: autoPay ?? this.autoPay,
        isActive: isActive ?? this.isActive,
        note: note.present ? note.value : this.note,
      );
  ScheduledPaymentEntry copyWithCompanion(
      ScheduledPaymentsTableCompanion data) {
    return ScheduledPaymentEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      autoPay: data.autoPay.present ? data.autoPay.value : this.autoPay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledPaymentEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('dueDate: $dueDate, ')
          ..write('frequency: $frequency, ')
          ..write('autoPay: $autoPay, ')
          ..write('isActive: $isActive, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, accountId, categoryId,
      dueDate, frequency, autoPay, isActive, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledPaymentEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.dueDate == this.dueDate &&
          other.frequency == this.frequency &&
          other.autoPay == this.autoPay &&
          other.isActive == this.isActive &&
          other.note == this.note);
}

class ScheduledPaymentsTableCompanion
    extends UpdateCompanion<ScheduledPaymentEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String?> accountId;
  final Value<String?> categoryId;
  final Value<DateTime> dueDate;
  final Value<String> frequency;
  final Value<bool> autoPay;
  final Value<bool> isActive;
  final Value<String?> note;
  final Value<int> rowid;
  const ScheduledPaymentsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.frequency = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledPaymentsTableCompanion.insert({
    required String id,
    required String title,
    required double amount,
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required DateTime dueDate,
    this.frequency = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        dueDate = Value(dueDate);
  static Insertable<ScheduledPaymentEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<DateTime>? dueDate,
    Expression<String>? frequency,
    Expression<bool>? autoPay,
    Expression<bool>? isActive,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (dueDate != null) 'due_date': dueDate,
      if (frequency != null) 'frequency': frequency,
      if (autoPay != null) 'auto_pay': autoPay,
      if (isActive != null) 'is_active': isActive,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledPaymentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String?>? accountId,
      Value<String?>? categoryId,
      Value<DateTime>? dueDate,
      Value<String>? frequency,
      Value<bool>? autoPay,
      Value<bool>? isActive,
      Value<String?>? note,
      Value<int>? rowid}) {
    return ScheduledPaymentsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      dueDate: dueDate ?? this.dueDate,
      frequency: frequency ?? this.frequency,
      autoPay: autoPay ?? this.autoPay,
      isActive: isActive ?? this.isActive,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (autoPay.present) {
      map['auto_pay'] = Variable<bool>(autoPay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledPaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('dueDate: $dueDate, ')
          ..write('frequency: $frequency, ')
          ..write('autoPay: $autoPay, ')
          ..write('isActive: $isActive, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FriendRequestsTableTable extends FriendRequestsTable
    with TableInfo<$FriendRequestsTableTable, FriendRequestEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendRequestsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromUserIdMeta =
      const VerificationMeta('fromUserId');
  @override
  late final GeneratedColumn<String> fromUserId = GeneratedColumn<String>(
      'from_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toUserIdMeta =
      const VerificationMeta('toUserId');
  @override
  late final GeneratedColumn<String> toUserId = GeneratedColumn<String>(
      'to_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromDisplayNameMeta =
      const VerificationMeta('fromDisplayName');
  @override
  late final GeneratedColumn<String> fromDisplayName = GeneratedColumn<String>(
      'from_display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fromPhotoUrlMeta =
      const VerificationMeta('fromPhotoUrl');
  @override
  late final GeneratedColumn<String> fromPhotoUrl = GeneratedColumn<String>(
      'from_photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _respondedAtMeta =
      const VerificationMeta('respondedAt');
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
      'responded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fromUserId,
        toUserId,
        fromDisplayName,
        fromPhotoUrl,
        status,
        createdAt,
        respondedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friend_requests_table';
  @override
  VerificationContext validateIntegrity(Insertable<FriendRequestEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_user_id')) {
      context.handle(
          _fromUserIdMeta,
          fromUserId.isAcceptableOrUnknown(
              data['from_user_id']!, _fromUserIdMeta));
    } else if (isInserting) {
      context.missing(_fromUserIdMeta);
    }
    if (data.containsKey('to_user_id')) {
      context.handle(_toUserIdMeta,
          toUserId.isAcceptableOrUnknown(data['to_user_id']!, _toUserIdMeta));
    } else if (isInserting) {
      context.missing(_toUserIdMeta);
    }
    if (data.containsKey('from_display_name')) {
      context.handle(
          _fromDisplayNameMeta,
          fromDisplayName.isAcceptableOrUnknown(
              data['from_display_name']!, _fromDisplayNameMeta));
    }
    if (data.containsKey('from_photo_url')) {
      context.handle(
          _fromPhotoUrlMeta,
          fromPhotoUrl.isAcceptableOrUnknown(
              data['from_photo_url']!, _fromPhotoUrlMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
          _respondedAtMeta,
          respondedAt.isAcceptableOrUnknown(
              data['responded_at']!, _respondedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FriendRequestEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendRequestEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_user_id'])!,
      toUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_user_id'])!,
      fromDisplayName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}from_display_name']),
      fromPhotoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_photo_url']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      respondedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}responded_at']),
    );
  }

  @override
  $FriendRequestsTableTable createAlias(String alias) {
    return $FriendRequestsTableTable(attachedDatabase, alias);
  }
}

class FriendRequestEntry extends DataClass
    implements Insertable<FriendRequestEntry> {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? fromDisplayName;
  final String? fromPhotoUrl;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  const FriendRequestEntry(
      {required this.id,
      required this.fromUserId,
      required this.toUserId,
      this.fromDisplayName,
      this.fromPhotoUrl,
      required this.status,
      required this.createdAt,
      this.respondedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_user_id'] = Variable<String>(fromUserId);
    map['to_user_id'] = Variable<String>(toUserId);
    if (!nullToAbsent || fromDisplayName != null) {
      map['from_display_name'] = Variable<String>(fromDisplayName);
    }
    if (!nullToAbsent || fromPhotoUrl != null) {
      map['from_photo_url'] = Variable<String>(fromPhotoUrl);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    return map;
  }

  FriendRequestsTableCompanion toCompanion(bool nullToAbsent) {
    return FriendRequestsTableCompanion(
      id: Value(id),
      fromUserId: Value(fromUserId),
      toUserId: Value(toUserId),
      fromDisplayName: fromDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromDisplayName),
      fromPhotoUrl: fromPhotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fromPhotoUrl),
      status: Value(status),
      createdAt: Value(createdAt),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
    );
  }

  factory FriendRequestEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendRequestEntry(
      id: serializer.fromJson<String>(json['id']),
      fromUserId: serializer.fromJson<String>(json['fromUserId']),
      toUserId: serializer.fromJson<String>(json['toUserId']),
      fromDisplayName: serializer.fromJson<String?>(json['fromDisplayName']),
      fromPhotoUrl: serializer.fromJson<String?>(json['fromPhotoUrl']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromUserId': serializer.toJson<String>(fromUserId),
      'toUserId': serializer.toJson<String>(toUserId),
      'fromDisplayName': serializer.toJson<String?>(fromDisplayName),
      'fromPhotoUrl': serializer.toJson<String?>(fromPhotoUrl),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
    };
  }

  FriendRequestEntry copyWith(
          {String? id,
          String? fromUserId,
          String? toUserId,
          Value<String?> fromDisplayName = const Value.absent(),
          Value<String?> fromPhotoUrl = const Value.absent(),
          String? status,
          DateTime? createdAt,
          Value<DateTime?> respondedAt = const Value.absent()}) =>
      FriendRequestEntry(
        id: id ?? this.id,
        fromUserId: fromUserId ?? this.fromUserId,
        toUserId: toUserId ?? this.toUserId,
        fromDisplayName: fromDisplayName.present
            ? fromDisplayName.value
            : this.fromDisplayName,
        fromPhotoUrl:
            fromPhotoUrl.present ? fromPhotoUrl.value : this.fromPhotoUrl,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
      );
  FriendRequestEntry copyWithCompanion(FriendRequestsTableCompanion data) {
    return FriendRequestEntry(
      id: data.id.present ? data.id.value : this.id,
      fromUserId:
          data.fromUserId.present ? data.fromUserId.value : this.fromUserId,
      toUserId: data.toUserId.present ? data.toUserId.value : this.toUserId,
      fromDisplayName: data.fromDisplayName.present
          ? data.fromDisplayName.value
          : this.fromDisplayName,
      fromPhotoUrl: data.fromPhotoUrl.present
          ? data.fromPhotoUrl.value
          : this.fromPhotoUrl,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      respondedAt:
          data.respondedAt.present ? data.respondedAt.value : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendRequestEntry(')
          ..write('id: $id, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('toUserId: $toUserId, ')
          ..write('fromDisplayName: $fromDisplayName, ')
          ..write('fromPhotoUrl: $fromPhotoUrl, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromUserId, toUserId, fromDisplayName,
      fromPhotoUrl, status, createdAt, respondedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendRequestEntry &&
          other.id == this.id &&
          other.fromUserId == this.fromUserId &&
          other.toUserId == this.toUserId &&
          other.fromDisplayName == this.fromDisplayName &&
          other.fromPhotoUrl == this.fromPhotoUrl &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.respondedAt == this.respondedAt);
}

class FriendRequestsTableCompanion extends UpdateCompanion<FriendRequestEntry> {
  final Value<String> id;
  final Value<String> fromUserId;
  final Value<String> toUserId;
  final Value<String?> fromDisplayName;
  final Value<String?> fromPhotoUrl;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> respondedAt;
  final Value<int> rowid;
  const FriendRequestsTableCompanion({
    this.id = const Value.absent(),
    this.fromUserId = const Value.absent(),
    this.toUserId = const Value.absent(),
    this.fromDisplayName = const Value.absent(),
    this.fromPhotoUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendRequestsTableCompanion.insert({
    required String id,
    required String fromUserId,
    required String toUserId,
    this.fromDisplayName = const Value.absent(),
    this.fromPhotoUrl = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.respondedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fromUserId = Value(fromUserId),
        toUserId = Value(toUserId),
        createdAt = Value(createdAt);
  static Insertable<FriendRequestEntry> custom({
    Expression<String>? id,
    Expression<String>? fromUserId,
    Expression<String>? toUserId,
    Expression<String>? fromDisplayName,
    Expression<String>? fromPhotoUrl,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? respondedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromUserId != null) 'from_user_id': fromUserId,
      if (toUserId != null) 'to_user_id': toUserId,
      if (fromDisplayName != null) 'from_display_name': fromDisplayName,
      if (fromPhotoUrl != null) 'from_photo_url': fromPhotoUrl,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendRequestsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromUserId,
      Value<String>? toUserId,
      Value<String?>? fromDisplayName,
      Value<String?>? fromPhotoUrl,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? respondedAt,
      Value<int>? rowid}) {
    return FriendRequestsTableCompanion(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      fromDisplayName: fromDisplayName ?? this.fromDisplayName,
      fromPhotoUrl: fromPhotoUrl ?? this.fromPhotoUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromUserId.present) {
      map['from_user_id'] = Variable<String>(fromUserId.value);
    }
    if (toUserId.present) {
      map['to_user_id'] = Variable<String>(toUserId.value);
    }
    if (fromDisplayName.present) {
      map['from_display_name'] = Variable<String>(fromDisplayName.value);
    }
    if (fromPhotoUrl.present) {
      map['from_photo_url'] = Variable<String>(fromPhotoUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendRequestsTableCompanion(')
          ..write('id: $id, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('toUserId: $toUserId, ')
          ..write('fromDisplayName: $fromDisplayName, ')
          ..write('fromPhotoUrl: $fromPhotoUrl, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SharedWishlistsTableTable extends SharedWishlistsTable
    with TableInfo<$SharedWishlistsTableTable, SharedWishlistEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedWishlistsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerUserIdMeta =
      const VerificationMeta('ownerUserId');
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
      'owner_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wishlistItemIdMeta =
      const VerificationMeta('wishlistItemId');
  @override
  late final GeneratedColumn<String> wishlistItemId = GeneratedColumn<String>(
      'wishlist_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _estimatedCostMeta =
      const VerificationMeta('estimatedCost');
  @override
  late final GeneratedColumn<double> estimatedCost = GeneratedColumn<double>(
      'estimated_cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVisibleMeta =
      const VerificationMeta('isVisible');
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
      'is_visible', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visible" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _claimedByUserIdMeta =
      const VerificationMeta('claimedByUserId');
  @override
  late final GeneratedColumn<String> claimedByUserId = GeneratedColumn<String>(
      'claimed_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sharedAtMeta =
      const VerificationMeta('sharedAt');
  @override
  late final GeneratedColumn<DateTime> sharedAt = GeneratedColumn<DateTime>(
      'shared_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerUserId,
        wishlistItemId,
        title,
        estimatedCost,
        url,
        note,
        isVisible,
        claimedByUserId,
        sharedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_wishlists_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SharedWishlistEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
          _ownerUserIdMeta,
          ownerUserId.isAcceptableOrUnknown(
              data['owner_user_id']!, _ownerUserIdMeta));
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('wishlist_item_id')) {
      context.handle(
          _wishlistItemIdMeta,
          wishlistItemId.isAcceptableOrUnknown(
              data['wishlist_item_id']!, _wishlistItemIdMeta));
    } else if (isInserting) {
      context.missing(_wishlistItemIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
          _estimatedCostMeta,
          estimatedCost.isAcceptableOrUnknown(
              data['estimated_cost']!, _estimatedCostMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_visible')) {
      context.handle(_isVisibleMeta,
          isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta));
    }
    if (data.containsKey('claimed_by_user_id')) {
      context.handle(
          _claimedByUserIdMeta,
          claimedByUserId.isAcceptableOrUnknown(
              data['claimed_by_user_id']!, _claimedByUserIdMeta));
    }
    if (data.containsKey('shared_at')) {
      context.handle(_sharedAtMeta,
          sharedAt.isAcceptableOrUnknown(data['shared_at']!, _sharedAtMeta));
    } else if (isInserting) {
      context.missing(_sharedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedWishlistEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedWishlistEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_user_id'])!,
      wishlistItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}wishlist_item_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      estimatedCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}estimated_cost'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isVisible: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visible'])!,
      claimedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}claimed_by_user_id']),
      sharedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}shared_at'])!,
    );
  }

  @override
  $SharedWishlistsTableTable createAlias(String alias) {
    return $SharedWishlistsTableTable(attachedDatabase, alias);
  }
}

class SharedWishlistEntry extends DataClass
    implements Insertable<SharedWishlistEntry> {
  final String id;
  final String ownerUserId;
  final String wishlistItemId;
  final String title;
  final double estimatedCost;
  final String? url;
  final String? note;
  final bool isVisible;
  final String? claimedByUserId;
  final DateTime sharedAt;
  const SharedWishlistEntry(
      {required this.id,
      required this.ownerUserId,
      required this.wishlistItemId,
      required this.title,
      required this.estimatedCost,
      this.url,
      this.note,
      required this.isVisible,
      this.claimedByUserId,
      required this.sharedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['wishlist_item_id'] = Variable<String>(wishlistItemId);
    map['title'] = Variable<String>(title);
    map['estimated_cost'] = Variable<double>(estimatedCost);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_visible'] = Variable<bool>(isVisible);
    if (!nullToAbsent || claimedByUserId != null) {
      map['claimed_by_user_id'] = Variable<String>(claimedByUserId);
    }
    map['shared_at'] = Variable<DateTime>(sharedAt);
    return map;
  }

  SharedWishlistsTableCompanion toCompanion(bool nullToAbsent) {
    return SharedWishlistsTableCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      wishlistItemId: Value(wishlistItemId),
      title: Value(title),
      estimatedCost: Value(estimatedCost),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isVisible: Value(isVisible),
      claimedByUserId: claimedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(claimedByUserId),
      sharedAt: Value(sharedAt),
    );
  }

  factory SharedWishlistEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedWishlistEntry(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      wishlistItemId: serializer.fromJson<String>(json['wishlistItemId']),
      title: serializer.fromJson<String>(json['title']),
      estimatedCost: serializer.fromJson<double>(json['estimatedCost']),
      url: serializer.fromJson<String?>(json['url']),
      note: serializer.fromJson<String?>(json['note']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      claimedByUserId: serializer.fromJson<String?>(json['claimedByUserId']),
      sharedAt: serializer.fromJson<DateTime>(json['sharedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'wishlistItemId': serializer.toJson<String>(wishlistItemId),
      'title': serializer.toJson<String>(title),
      'estimatedCost': serializer.toJson<double>(estimatedCost),
      'url': serializer.toJson<String?>(url),
      'note': serializer.toJson<String?>(note),
      'isVisible': serializer.toJson<bool>(isVisible),
      'claimedByUserId': serializer.toJson<String?>(claimedByUserId),
      'sharedAt': serializer.toJson<DateTime>(sharedAt),
    };
  }

  SharedWishlistEntry copyWith(
          {String? id,
          String? ownerUserId,
          String? wishlistItemId,
          String? title,
          double? estimatedCost,
          Value<String?> url = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? isVisible,
          Value<String?> claimedByUserId = const Value.absent(),
          DateTime? sharedAt}) =>
      SharedWishlistEntry(
        id: id ?? this.id,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        wishlistItemId: wishlistItemId ?? this.wishlistItemId,
        title: title ?? this.title,
        estimatedCost: estimatedCost ?? this.estimatedCost,
        url: url.present ? url.value : this.url,
        note: note.present ? note.value : this.note,
        isVisible: isVisible ?? this.isVisible,
        claimedByUserId: claimedByUserId.present
            ? claimedByUserId.value
            : this.claimedByUserId,
        sharedAt: sharedAt ?? this.sharedAt,
      );
  SharedWishlistEntry copyWithCompanion(SharedWishlistsTableCompanion data) {
    return SharedWishlistEntry(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId:
          data.ownerUserId.present ? data.ownerUserId.value : this.ownerUserId,
      wishlistItemId: data.wishlistItemId.present
          ? data.wishlistItemId.value
          : this.wishlistItemId,
      title: data.title.present ? data.title.value : this.title,
      estimatedCost: data.estimatedCost.present
          ? data.estimatedCost.value
          : this.estimatedCost,
      url: data.url.present ? data.url.value : this.url,
      note: data.note.present ? data.note.value : this.note,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      claimedByUserId: data.claimedByUserId.present
          ? data.claimedByUserId.value
          : this.claimedByUserId,
      sharedAt: data.sharedAt.present ? data.sharedAt.value : this.sharedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedWishlistEntry(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('wishlistItemId: $wishlistItemId, ')
          ..write('title: $title, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('url: $url, ')
          ..write('note: $note, ')
          ..write('isVisible: $isVisible, ')
          ..write('claimedByUserId: $claimedByUserId, ')
          ..write('sharedAt: $sharedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerUserId, wishlistItemId, title,
      estimatedCost, url, note, isVisible, claimedByUserId, sharedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedWishlistEntry &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.wishlistItemId == this.wishlistItemId &&
          other.title == this.title &&
          other.estimatedCost == this.estimatedCost &&
          other.url == this.url &&
          other.note == this.note &&
          other.isVisible == this.isVisible &&
          other.claimedByUserId == this.claimedByUserId &&
          other.sharedAt == this.sharedAt);
}

class SharedWishlistsTableCompanion
    extends UpdateCompanion<SharedWishlistEntry> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<String> wishlistItemId;
  final Value<String> title;
  final Value<double> estimatedCost;
  final Value<String?> url;
  final Value<String?> note;
  final Value<bool> isVisible;
  final Value<String?> claimedByUserId;
  final Value<DateTime> sharedAt;
  final Value<int> rowid;
  const SharedWishlistsTableCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.wishlistItemId = const Value.absent(),
    this.title = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.url = const Value.absent(),
    this.note = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.claimedByUserId = const Value.absent(),
    this.sharedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SharedWishlistsTableCompanion.insert({
    required String id,
    required String ownerUserId,
    required String wishlistItemId,
    required String title,
    this.estimatedCost = const Value.absent(),
    this.url = const Value.absent(),
    this.note = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.claimedByUserId = const Value.absent(),
    required DateTime sharedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerUserId = Value(ownerUserId),
        wishlistItemId = Value(wishlistItemId),
        title = Value(title),
        sharedAt = Value(sharedAt);
  static Insertable<SharedWishlistEntry> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<String>? wishlistItemId,
    Expression<String>? title,
    Expression<double>? estimatedCost,
    Expression<String>? url,
    Expression<String>? note,
    Expression<bool>? isVisible,
    Expression<String>? claimedByUserId,
    Expression<DateTime>? sharedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (wishlistItemId != null) 'wishlist_item_id': wishlistItemId,
      if (title != null) 'title': title,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (url != null) 'url': url,
      if (note != null) 'note': note,
      if (isVisible != null) 'is_visible': isVisible,
      if (claimedByUserId != null) 'claimed_by_user_id': claimedByUserId,
      if (sharedAt != null) 'shared_at': sharedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SharedWishlistsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerUserId,
      Value<String>? wishlistItemId,
      Value<String>? title,
      Value<double>? estimatedCost,
      Value<String?>? url,
      Value<String?>? note,
      Value<bool>? isVisible,
      Value<String?>? claimedByUserId,
      Value<DateTime>? sharedAt,
      Value<int>? rowid}) {
    return SharedWishlistsTableCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      wishlistItemId: wishlistItemId ?? this.wishlistItemId,
      title: title ?? this.title,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      url: url ?? this.url,
      note: note ?? this.note,
      isVisible: isVisible ?? this.isVisible,
      claimedByUserId: claimedByUserId ?? this.claimedByUserId,
      sharedAt: sharedAt ?? this.sharedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (wishlistItemId.present) {
      map['wishlist_item_id'] = Variable<String>(wishlistItemId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<double>(estimatedCost.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (claimedByUserId.present) {
      map['claimed_by_user_id'] = Variable<String>(claimedByUserId.value);
    }
    if (sharedAt.present) {
      map['shared_at'] = Variable<DateTime>(sharedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedWishlistsTableCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('wishlistItemId: $wishlistItemId, ')
          ..write('title: $title, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('url: $url, ')
          ..write('note: $note, ')
          ..write('isVisible: $isVisible, ')
          ..write('claimedByUserId: $claimedByUserId, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $PersonsTableTable personsTable = $PersonsTableTable(this);
  late final $GroupsTableTable groupsTable = $GroupsTableTable(this);
  late final $GroupMembersTableTable groupMembersTable =
      $GroupMembersTableTable(this);
  late final $UserProfileTableTable userProfileTable =
      $UserProfileTableTable(this);
  late final $WishlistTableTable wishlistTable = $WishlistTableTable(this);
  late final $RecurringTransactionsTableTable recurringTransactionsTable =
      $RecurringTransactionsTableTable(this);
  late final $InstallmentsTableTable installmentsTable =
      $InstallmentsTableTable(this);
  late final $TagsTableTable tagsTable = $TagsTableTable(this);
  late final $TransactionTagsTableTable transactionTagsTable =
      $TransactionTagsTableTable(this);
  late final $ScheduledPaymentsTableTable scheduledPaymentsTable =
      $ScheduledPaymentsTableTable(this);
  late final $FriendRequestsTableTable friendRequestsTable =
      $FriendRequestsTableTable(this);
  late final $SharedWishlistsTableTable sharedWishlistsTable =
      $SharedWishlistsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accountsTable,
        categoriesTable,
        transactionsTable,
        budgetsTable,
        goalsTable,
        personsTable,
        groupsTable,
        groupMembersTable,
        userProfileTable,
        wishlistTable,
        recurringTransactionsTable,
        installmentsTable,
        tagsTable,
        transactionTagsTable,
        scheduledPaymentsTable,
        friendRequestsTable,
        sharedWishlistsTable
      ];
}

typedef $$AccountsTableTableCreateCompanionBuilder = AccountsTableCompanion
    Function({
  required String id,
  required String name,
  required String type,
  Value<double> initialBalance,
  Value<String> currencyCode,
  Value<String?> iconName,
  Value<int?> colorValue,
  Value<bool> isDefault,
  Value<double?> creditLimit,
  Value<int?> closingDay,
  Value<int?> dueDay,
  Value<double> pendingStatementAmount,
  Value<DateTime?> lastClosedDate,
  Value<String?> alias,
  Value<String?> cvu,
  Value<int> rowid,
});
typedef $$AccountsTableTableUpdateCompanionBuilder = AccountsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<double> initialBalance,
  Value<String> currencyCode,
  Value<String?> iconName,
  Value<int?> colorValue,
  Value<bool> isDefault,
  Value<double?> creditLimit,
  Value<int?> closingDay,
  Value<int?> dueDay,
  Value<double> pendingStatementAmount,
  Value<DateTime?> lastClosedDate,
  Value<String?> alias,
  Value<String?> cvu,
  Value<int> rowid,
});

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pendingStatementAmount => $composableBuilder(
      column: $table.pendingStatementAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastClosedDate => $composableBuilder(
      column: $table.lastClosedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cvu => $composableBuilder(
      column: $table.cvu, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pendingStatementAmount => $composableBuilder(
      column: $table.pendingStatementAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastClosedDate => $composableBuilder(
      column: $table.lastClosedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cvu => $composableBuilder(
      column: $table.cvu, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<double> get pendingStatementAmount => $composableBuilder(
      column: $table.pendingStatementAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastClosedDate => $composableBuilder(
      column: $table.lastClosedDate, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get cvu =>
      $composableBuilder(column: $table.cvu, builder: (column) => column);
}

class $$AccountsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountEntity,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountEntity,
      BaseReferences<_$AppDatabase, $AccountsTableTable, AccountEntity>
    ),
    AccountEntity,
    PrefetchHooks Function()> {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<double?> creditLimit = const Value.absent(),
            Value<int?> closingDay = const Value.absent(),
            Value<int?> dueDay = const Value.absent(),
            Value<double> pendingStatementAmount = const Value.absent(),
            Value<DateTime?> lastClosedDate = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<String?> cvu = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion(
            id: id,
            name: name,
            type: type,
            initialBalance: initialBalance,
            currencyCode: currencyCode,
            iconName: iconName,
            colorValue: colorValue,
            isDefault: isDefault,
            creditLimit: creditLimit,
            closingDay: closingDay,
            dueDay: dueDay,
            pendingStatementAmount: pendingStatementAmount,
            lastClosedDate: lastClosedDate,
            alias: alias,
            cvu: cvu,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            Value<double> initialBalance = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<double?> creditLimit = const Value.absent(),
            Value<int?> closingDay = const Value.absent(),
            Value<int?> dueDay = const Value.absent(),
            Value<double> pendingStatementAmount = const Value.absent(),
            Value<DateTime?> lastClosedDate = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<String?> cvu = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            initialBalance: initialBalance,
            currencyCode: currencyCode,
            iconName: iconName,
            colorValue: colorValue,
            isDefault: isDefault,
            creditLimit: creditLimit,
            closingDay: closingDay,
            dueDay: dueDay,
            pendingStatementAmount: pendingStatementAmount,
            lastClosedDate: lastClosedDate,
            alias: alias,
            cvu: cvu,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountEntity,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountEntity,
      BaseReferences<_$AppDatabase, $AccountsTableTable, AccountEntity>
    ),
    AccountEntity,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String id,
  required String name,
  required String iconName,
  required int colorValue,
  Value<double?> monthlyBudget,
  Value<bool> isFixed,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> iconName,
  Value<int> colorValue,
  Value<double?> monthlyBudget,
  Value<bool> isFixed,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFixed => $composableBuilder(
      column: $table.isFixed, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFixed => $composableBuilder(
      column: $table.isFixed, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<double> get monthlyBudget => $composableBuilder(
      column: $table.monthlyBudget, builder: (column) => column);

  GeneratedColumn<bool> get isFixed =>
      $composableBuilder(column: $table.isFixed, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoryEntity,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoryEntity,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntity>
    ),
    CategoryEntity,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<double?> monthlyBudget = const Value.absent(),
            Value<bool> isFixed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            name: name,
            iconName: iconName,
            colorValue: colorValue,
            monthlyBudget: monthlyBudget,
            isFixed: isFixed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String iconName,
            required int colorValue,
            Value<double?> monthlyBudget = const Value.absent(),
            Value<bool> isFixed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            name: name,
            iconName: iconName,
            colorValue: colorValue,
            monthlyBudget: monthlyBudget,
            isFixed: isFixed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoryEntity,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoryEntity,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntity>
    ),
    CategoryEntity,
    PrefetchHooks Function()>;
typedef $$TransactionsTableTableCreateCompanionBuilder
    = TransactionsTableCompanion Function({
  required String id,
  required String title,
  required double amount,
  required String type,
  required String categoryId,
  required String accountId,
  required DateTime date,
  Value<String?> note,
  Value<String?> personId,
  Value<String?> groupId,
  Value<double?> sharedTotalAmount,
  Value<double?> sharedOwnAmount,
  Value<double?> sharedOtherAmount,
  Value<double?> sharedRecovered,
  Value<bool> isShared,
  Value<int> rowid,
});
typedef $$TransactionsTableTableUpdateCompanionBuilder
    = TransactionsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> type,
  Value<String> categoryId,
  Value<String> accountId,
  Value<DateTime> date,
  Value<String?> note,
  Value<String?> personId,
  Value<String?> groupId,
  Value<double?> sharedTotalAmount,
  Value<double?> sharedOwnAmount,
  Value<double?> sharedOtherAmount,
  Value<double?> sharedRecovered,
  Value<bool> isShared,
  Value<int> rowid,
});

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sharedTotalAmount => $composableBuilder(
      column: $table.sharedTotalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sharedOwnAmount => $composableBuilder(
      column: $table.sharedOwnAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sharedOtherAmount => $composableBuilder(
      column: $table.sharedOtherAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sharedRecovered => $composableBuilder(
      column: $table.sharedRecovered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sharedTotalAmount => $composableBuilder(
      column: $table.sharedTotalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sharedOwnAmount => $composableBuilder(
      column: $table.sharedOwnAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sharedOtherAmount => $composableBuilder(
      column: $table.sharedOtherAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sharedRecovered => $composableBuilder(
      column: $table.sharedRecovered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<double> get sharedTotalAmount => $composableBuilder(
      column: $table.sharedTotalAmount, builder: (column) => column);

  GeneratedColumn<double> get sharedOwnAmount => $composableBuilder(
      column: $table.sharedOwnAmount, builder: (column) => column);

  GeneratedColumn<double> get sharedOtherAmount => $composableBuilder(
      column: $table.sharedOtherAmount, builder: (column) => column);

  GeneratedColumn<double> get sharedRecovered => $composableBuilder(
      column: $table.sharedRecovered, builder: (column) => column);

  GeneratedColumn<bool> get isShared =>
      $composableBuilder(column: $table.isShared, builder: (column) => column);
}

class $$TransactionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionEntity,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionEntity,
      BaseReferences<_$AppDatabase, $TransactionsTableTable, TransactionEntity>
    ),
    TransactionEntity,
    PrefetchHooks Function()> {
  $$TransactionsTableTableTableManager(
      _$AppDatabase db, $TransactionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> personId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<double?> sharedTotalAmount = const Value.absent(),
            Value<double?> sharedOwnAmount = const Value.absent(),
            Value<double?> sharedOtherAmount = const Value.absent(),
            Value<double?> sharedRecovered = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion(
            id: id,
            title: title,
            amount: amount,
            type: type,
            categoryId: categoryId,
            accountId: accountId,
            date: date,
            note: note,
            personId: personId,
            groupId: groupId,
            sharedTotalAmount: sharedTotalAmount,
            sharedOwnAmount: sharedOwnAmount,
            sharedOtherAmount: sharedOtherAmount,
            sharedRecovered: sharedRecovered,
            isShared: isShared,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String type,
            required String categoryId,
            required String accountId,
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<String?> personId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<double?> sharedTotalAmount = const Value.absent(),
            Value<double?> sharedOwnAmount = const Value.absent(),
            Value<double?> sharedOtherAmount = const Value.absent(),
            Value<double?> sharedRecovered = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            type: type,
            categoryId: categoryId,
            accountId: accountId,
            date: date,
            note: note,
            personId: personId,
            groupId: groupId,
            sharedTotalAmount: sharedTotalAmount,
            sharedOwnAmount: sharedOwnAmount,
            sharedOtherAmount: sharedOtherAmount,
            sharedRecovered: sharedRecovered,
            isShared: isShared,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionEntity,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionEntity,
      BaseReferences<_$AppDatabase, $TransactionsTableTable, TransactionEntity>
    ),
    TransactionEntity,
    PrefetchHooks Function()>;
typedef $$BudgetsTableTableCreateCompanionBuilder = BudgetsTableCompanion
    Function({
  required String id,
  required String categoryId,
  required double limitAmount,
  Value<double> spentAmount,
  Value<int> rowid,
});
typedef $$BudgetsTableTableUpdateCompanionBuilder = BudgetsTableCompanion
    Function({
  Value<String> id,
  Value<String> categoryId,
  Value<double> limitAmount,
  Value<double> spentAmount,
  Value<int> rowid,
});

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => column);

  GeneratedColumn<double> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => column);
}

class $$BudgetsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTableTable,
    BudgetEntity,
    $$BudgetsTableTableFilterComposer,
    $$BudgetsTableTableOrderingComposer,
    $$BudgetsTableTableAnnotationComposer,
    $$BudgetsTableTableCreateCompanionBuilder,
    $$BudgetsTableTableUpdateCompanionBuilder,
    (
      BudgetEntity,
      BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetEntity>
    ),
    BudgetEntity,
    PrefetchHooks Function()> {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<double> limitAmount = const Value.absent(),
            Value<double> spentAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsTableCompanion(
            id: id,
            categoryId: categoryId,
            limitAmount: limitAmount,
            spentAmount: spentAmount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String categoryId,
            required double limitAmount,
            Value<double> spentAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsTableCompanion.insert(
            id: id,
            categoryId: categoryId,
            limitAmount: limitAmount,
            spentAmount: spentAmount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTableTable,
    BudgetEntity,
    $$BudgetsTableTableFilterComposer,
    $$BudgetsTableTableOrderingComposer,
    $$BudgetsTableTableAnnotationComposer,
    $$BudgetsTableTableCreateCompanionBuilder,
    $$BudgetsTableTableUpdateCompanionBuilder,
    (
      BudgetEntity,
      BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetEntity>
    ),
    BudgetEntity,
    PrefetchHooks Function()>;
typedef $$GoalsTableTableCreateCompanionBuilder = GoalsTableCompanion Function({
  required String id,
  required String name,
  required double targetAmount,
  Value<double> currentAmount,
  required int colorValue,
  Value<String?> iconName,
  Value<DateTime?> deadline,
  Value<int> rowid,
});
typedef $$GoalsTableTableUpdateCompanionBuilder = GoalsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> targetAmount,
  Value<double> currentAmount,
  Value<int> colorValue,
  Value<String?> iconName,
  Value<DateTime?> deadline,
  Value<int> rowid,
});

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);
}

class $$GoalsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalEntity,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalEntity>),
    GoalEntity,
    PrefetchHooks Function()> {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<double> currentAmount = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            colorValue: colorValue,
            iconName: iconName,
            deadline: deadline,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double targetAmount,
            Value<double> currentAmount = const Value.absent(),
            required int colorValue,
            Value<String?> iconName = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion.insert(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            colorValue: colorValue,
            iconName: iconName,
            deadline: deadline,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalEntity,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalEntity>),
    GoalEntity,
    PrefetchHooks Function()>;
typedef $$PersonsTableTableCreateCompanionBuilder = PersonsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> alias,
  required int colorValue,
  Value<double> totalBalance,
  Value<String?> cbu,
  Value<String?> notes,
  Value<String?> linkedUserId,
  Value<int> rowid,
});
typedef $$PersonsTableTableUpdateCompanionBuilder = PersonsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> alias,
  Value<int> colorValue,
  Value<double> totalBalance,
  Value<String?> cbu,
  Value<String?> notes,
  Value<String?> linkedUserId,
  Value<int> rowid,
});

class $$PersonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTableTable> {
  $$PersonsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalBalance => $composableBuilder(
      column: $table.totalBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cbu => $composableBuilder(
      column: $table.cbu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId, builder: (column) => ColumnFilters(column));
}

class $$PersonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTableTable> {
  $$PersonsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalBalance => $composableBuilder(
      column: $table.totalBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cbu => $composableBuilder(
      column: $table.cbu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId,
      builder: (column) => ColumnOrderings(column));
}

class $$PersonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTableTable> {
  $$PersonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<double> get totalBalance => $composableBuilder(
      column: $table.totalBalance, builder: (column) => column);

  GeneratedColumn<String> get cbu =>
      $composableBuilder(column: $table.cbu, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get linkedUserId => $composableBuilder(
      column: $table.linkedUserId, builder: (column) => column);
}

class $$PersonsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonsTableTable,
    PersonEntity,
    $$PersonsTableTableFilterComposer,
    $$PersonsTableTableOrderingComposer,
    $$PersonsTableTableAnnotationComposer,
    $$PersonsTableTableCreateCompanionBuilder,
    $$PersonsTableTableUpdateCompanionBuilder,
    (
      PersonEntity,
      BaseReferences<_$AppDatabase, $PersonsTableTable, PersonEntity>
    ),
    PersonEntity,
    PrefetchHooks Function()> {
  $$PersonsTableTableTableManager(_$AppDatabase db, $PersonsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<double> totalBalance = const Value.absent(),
            Value<String?> cbu = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> linkedUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsTableCompanion(
            id: id,
            name: name,
            alias: alias,
            colorValue: colorValue,
            totalBalance: totalBalance,
            cbu: cbu,
            notes: notes,
            linkedUserId: linkedUserId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> alias = const Value.absent(),
            required int colorValue,
            Value<double> totalBalance = const Value.absent(),
            Value<String?> cbu = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> linkedUserId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsTableCompanion.insert(
            id: id,
            name: name,
            alias: alias,
            colorValue: colorValue,
            totalBalance: totalBalance,
            cbu: cbu,
            notes: notes,
            linkedUserId: linkedUserId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonsTableTable,
    PersonEntity,
    $$PersonsTableTableFilterComposer,
    $$PersonsTableTableOrderingComposer,
    $$PersonsTableTableAnnotationComposer,
    $$PersonsTableTableCreateCompanionBuilder,
    $$PersonsTableTableUpdateCompanionBuilder,
    (
      PersonEntity,
      BaseReferences<_$AppDatabase, $PersonsTableTable, PersonEntity>
    ),
    PersonEntity,
    PrefetchHooks Function()>;
typedef $$GroupsTableTableCreateCompanionBuilder = GroupsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> coverImageUrl,
  Value<double> totalGroupExpense,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});
typedef $$GroupsTableTableUpdateCompanionBuilder = GroupsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> coverImageUrl,
  Value<double> totalGroupExpense,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});

class $$GroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImageUrl => $composableBuilder(
      column: $table.coverImageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalGroupExpense => $composableBuilder(
      column: $table.totalGroupExpense,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));
}

class $$GroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImageUrl => $composableBuilder(
      column: $table.coverImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalGroupExpense => $composableBuilder(
      column: $table.totalGroupExpense,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));
}

class $$GroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverImageUrl => $composableBuilder(
      column: $table.coverImageUrl, builder: (column) => column);

  GeneratedColumn<double> get totalGroupExpense => $composableBuilder(
      column: $table.totalGroupExpense, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$GroupsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTableTable,
    GroupEntity,
    $$GroupsTableTableFilterComposer,
    $$GroupsTableTableOrderingComposer,
    $$GroupsTableTableAnnotationComposer,
    $$GroupsTableTableCreateCompanionBuilder,
    $$GroupsTableTableUpdateCompanionBuilder,
    (
      GroupEntity,
      BaseReferences<_$AppDatabase, $GroupsTableTable, GroupEntity>
    ),
    GroupEntity,
    PrefetchHooks Function()> {
  $$GroupsTableTableTableManager(_$AppDatabase db, $GroupsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> coverImageUrl = const Value.absent(),
            Value<double> totalGroupExpense = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsTableCompanion(
            id: id,
            name: name,
            coverImageUrl: coverImageUrl,
            totalGroupExpense: totalGroupExpense,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> coverImageUrl = const Value.absent(),
            Value<double> totalGroupExpense = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsTableCompanion.insert(
            id: id,
            name: name,
            coverImageUrl: coverImageUrl,
            totalGroupExpense: totalGroupExpense,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTableTable,
    GroupEntity,
    $$GroupsTableTableFilterComposer,
    $$GroupsTableTableOrderingComposer,
    $$GroupsTableTableAnnotationComposer,
    $$GroupsTableTableCreateCompanionBuilder,
    $$GroupsTableTableUpdateCompanionBuilder,
    (
      GroupEntity,
      BaseReferences<_$AppDatabase, $GroupsTableTable, GroupEntity>
    ),
    GroupEntity,
    PrefetchHooks Function()>;
typedef $$GroupMembersTableTableCreateCompanionBuilder
    = GroupMembersTableCompanion Function({
  required String groupId,
  required String personId,
  Value<int> rowid,
});
typedef $$GroupMembersTableTableUpdateCompanionBuilder
    = GroupMembersTableCompanion Function({
  Value<String> groupId,
  Value<String> personId,
  Value<int> rowid,
});

class $$GroupMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));
}

class $$GroupMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));
}

class $$GroupMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);
}

class $$GroupMembersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupMembersTableTable,
    GroupMemberEntity,
    $$GroupMembersTableTableFilterComposer,
    $$GroupMembersTableTableOrderingComposer,
    $$GroupMembersTableTableAnnotationComposer,
    $$GroupMembersTableTableCreateCompanionBuilder,
    $$GroupMembersTableTableUpdateCompanionBuilder,
    (
      GroupMemberEntity,
      BaseReferences<_$AppDatabase, $GroupMembersTableTable, GroupMemberEntity>
    ),
    GroupMemberEntity,
    PrefetchHooks Function()> {
  $$GroupMembersTableTableTableManager(
      _$AppDatabase db, $GroupMembersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> groupId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupMembersTableCompanion(
            groupId: groupId,
            personId: personId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String groupId,
            required String personId,
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupMembersTableCompanion.insert(
            groupId: groupId,
            personId: personId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupMembersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupMembersTableTable,
    GroupMemberEntity,
    $$GroupMembersTableTableFilterComposer,
    $$GroupMembersTableTableOrderingComposer,
    $$GroupMembersTableTableAnnotationComposer,
    $$GroupMembersTableTableCreateCompanionBuilder,
    $$GroupMembersTableTableUpdateCompanionBuilder,
    (
      GroupMemberEntity,
      BaseReferences<_$AppDatabase, $GroupMembersTableTable, GroupMemberEntity>
    ),
    GroupMemberEntity,
    PrefetchHooks Function()>;
typedef $$UserProfileTableTableCreateCompanionBuilder
    = UserProfileTableCompanion Function({
  required String id,
  Value<String?> name,
  Value<double?> monthlySalary,
  Value<int?> payDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$UserProfileTableTableUpdateCompanionBuilder
    = UserProfileTableCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<double?> monthlySalary,
  Value<int?> payDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UserProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get payDay => $composableBuilder(
      column: $table.payDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UserProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get payDay => $composableBuilder(
      column: $table.payDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => column);

  GeneratedColumn<int> get payDay =>
      $composableBuilder(column: $table.payDay, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfileTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfileTableTable,
    UserProfileEntity,
    $$UserProfileTableTableFilterComposer,
    $$UserProfileTableTableOrderingComposer,
    $$UserProfileTableTableAnnotationComposer,
    $$UserProfileTableTableCreateCompanionBuilder,
    $$UserProfileTableTableUpdateCompanionBuilder,
    (
      UserProfileEntity,
      BaseReferences<_$AppDatabase, $UserProfileTableTable, UserProfileEntity>
    ),
    UserProfileEntity,
    PrefetchHooks Function()> {
  $$UserProfileTableTableTableManager(
      _$AppDatabase db, $UserProfileTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double?> monthlySalary = const Value.absent(),
            Value<int?> payDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfileTableCompanion(
            id: id,
            name: name,
            monthlySalary: monthlySalary,
            payDay: payDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            Value<double?> monthlySalary = const Value.absent(),
            Value<int?> payDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfileTableCompanion.insert(
            id: id,
            name: name,
            monthlySalary: monthlySalary,
            payDay: payDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfileTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfileTableTable,
    UserProfileEntity,
    $$UserProfileTableTableFilterComposer,
    $$UserProfileTableTableOrderingComposer,
    $$UserProfileTableTableAnnotationComposer,
    $$UserProfileTableTableCreateCompanionBuilder,
    $$UserProfileTableTableUpdateCompanionBuilder,
    (
      UserProfileEntity,
      BaseReferences<_$AppDatabase, $UserProfileTableTable, UserProfileEntity>
    ),
    UserProfileEntity,
    PrefetchHooks Function()>;
typedef $$WishlistTableTableCreateCompanionBuilder = WishlistTableCompanion
    Function({
  required String id,
  required String title,
  required double estimatedCost,
  Value<String?> note,
  Value<String?> url,
  Value<int> installments,
  Value<bool> hasPromo,
  required DateTime createdAt,
  Value<bool> isPurchased,
  Value<DateTime?> purchasedAt,
  Value<String?> purchaseMethod,
  Value<String?> purchaseAccountId,
  Value<String?> linkedBudgetId,
  Value<int?> reminderDays,
  Value<DateTime?> reminderSnoozedUntil,
  Value<bool> reminderDismissed,
  Value<int> rowid,
});
typedef $$WishlistTableTableUpdateCompanionBuilder = WishlistTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<double> estimatedCost,
  Value<String?> note,
  Value<String?> url,
  Value<int> installments,
  Value<bool> hasPromo,
  Value<DateTime> createdAt,
  Value<bool> isPurchased,
  Value<DateTime?> purchasedAt,
  Value<String?> purchaseMethod,
  Value<String?> purchaseAccountId,
  Value<String?> linkedBudgetId,
  Value<int?> reminderDays,
  Value<DateTime?> reminderSnoozedUntil,
  Value<bool> reminderDismissed,
  Value<int> rowid,
});

class $$WishlistTableTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistTableTable> {
  $$WishlistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasPromo => $composableBuilder(
      column: $table.hasPromo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseMethod => $composableBuilder(
      column: $table.purchaseMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseAccountId => $composableBuilder(
      column: $table.purchaseAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedBudgetId => $composableBuilder(
      column: $table.linkedBudgetId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderDays => $composableBuilder(
      column: $table.reminderDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderSnoozedUntil => $composableBuilder(
      column: $table.reminderSnoozedUntil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderDismissed => $composableBuilder(
      column: $table.reminderDismissed,
      builder: (column) => ColumnFilters(column));
}

class $$WishlistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistTableTable> {
  $$WishlistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installments => $composableBuilder(
      column: $table.installments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasPromo => $composableBuilder(
      column: $table.hasPromo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseMethod => $composableBuilder(
      column: $table.purchaseMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseAccountId => $composableBuilder(
      column: $table.purchaseAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedBudgetId => $composableBuilder(
      column: $table.linkedBudgetId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderDays => $composableBuilder(
      column: $table.reminderDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderSnoozedUntil => $composableBuilder(
      column: $table.reminderSnoozedUntil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderDismissed => $composableBuilder(
      column: $table.reminderDismissed,
      builder: (column) => ColumnOrderings(column));
}

class $$WishlistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistTableTable> {
  $$WishlistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => column);

  GeneratedColumn<bool> get hasPromo =>
      $composableBuilder(column: $table.hasPromo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => column);

  GeneratedColumn<String> get purchaseMethod => $composableBuilder(
      column: $table.purchaseMethod, builder: (column) => column);

  GeneratedColumn<String> get purchaseAccountId => $composableBuilder(
      column: $table.purchaseAccountId, builder: (column) => column);

  GeneratedColumn<String> get linkedBudgetId => $composableBuilder(
      column: $table.linkedBudgetId, builder: (column) => column);

  GeneratedColumn<int> get reminderDays => $composableBuilder(
      column: $table.reminderDays, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderSnoozedUntil => $composableBuilder(
      column: $table.reminderSnoozedUntil, builder: (column) => column);

  GeneratedColumn<bool> get reminderDismissed => $composableBuilder(
      column: $table.reminderDismissed, builder: (column) => column);
}

class $$WishlistTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WishlistTableTable,
    WishlistEntity,
    $$WishlistTableTableFilterComposer,
    $$WishlistTableTableOrderingComposer,
    $$WishlistTableTableAnnotationComposer,
    $$WishlistTableTableCreateCompanionBuilder,
    $$WishlistTableTableUpdateCompanionBuilder,
    (
      WishlistEntity,
      BaseReferences<_$AppDatabase, $WishlistTableTable, WishlistEntity>
    ),
    WishlistEntity,
    PrefetchHooks Function()> {
  $$WishlistTableTableTableManager(_$AppDatabase db, $WishlistTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> estimatedCost = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<int> installments = const Value.absent(),
            Value<bool> hasPromo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isPurchased = const Value.absent(),
            Value<DateTime?> purchasedAt = const Value.absent(),
            Value<String?> purchaseMethod = const Value.absent(),
            Value<String?> purchaseAccountId = const Value.absent(),
            Value<String?> linkedBudgetId = const Value.absent(),
            Value<int?> reminderDays = const Value.absent(),
            Value<DateTime?> reminderSnoozedUntil = const Value.absent(),
            Value<bool> reminderDismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WishlistTableCompanion(
            id: id,
            title: title,
            estimatedCost: estimatedCost,
            note: note,
            url: url,
            installments: installments,
            hasPromo: hasPromo,
            createdAt: createdAt,
            isPurchased: isPurchased,
            purchasedAt: purchasedAt,
            purchaseMethod: purchaseMethod,
            purchaseAccountId: purchaseAccountId,
            linkedBudgetId: linkedBudgetId,
            reminderDays: reminderDays,
            reminderSnoozedUntil: reminderSnoozedUntil,
            reminderDismissed: reminderDismissed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double estimatedCost,
            Value<String?> note = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<int> installments = const Value.absent(),
            Value<bool> hasPromo = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isPurchased = const Value.absent(),
            Value<DateTime?> purchasedAt = const Value.absent(),
            Value<String?> purchaseMethod = const Value.absent(),
            Value<String?> purchaseAccountId = const Value.absent(),
            Value<String?> linkedBudgetId = const Value.absent(),
            Value<int?> reminderDays = const Value.absent(),
            Value<DateTime?> reminderSnoozedUntil = const Value.absent(),
            Value<bool> reminderDismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WishlistTableCompanion.insert(
            id: id,
            title: title,
            estimatedCost: estimatedCost,
            note: note,
            url: url,
            installments: installments,
            hasPromo: hasPromo,
            createdAt: createdAt,
            isPurchased: isPurchased,
            purchasedAt: purchasedAt,
            purchaseMethod: purchaseMethod,
            purchaseAccountId: purchaseAccountId,
            linkedBudgetId: linkedBudgetId,
            reminderDays: reminderDays,
            reminderSnoozedUntil: reminderSnoozedUntil,
            reminderDismissed: reminderDismissed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WishlistTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WishlistTableTable,
    WishlistEntity,
    $$WishlistTableTableFilterComposer,
    $$WishlistTableTableOrderingComposer,
    $$WishlistTableTableAnnotationComposer,
    $$WishlistTableTableCreateCompanionBuilder,
    $$WishlistTableTableUpdateCompanionBuilder,
    (
      WishlistEntity,
      BaseReferences<_$AppDatabase, $WishlistTableTable, WishlistEntity>
    ),
    WishlistEntity,
    PrefetchHooks Function()>;
typedef $$RecurringTransactionsTableTableCreateCompanionBuilder
    = RecurringTransactionsTableCompanion Function({
  required String id,
  required String title,
  required double amount,
  required String type,
  required String categoryId,
  required String accountId,
  Value<String?> note,
  required String frequency,
  required DateTime nextDate,
  Value<bool> isActive,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RecurringTransactionsTableTableUpdateCompanionBuilder
    = RecurringTransactionsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> type,
  Value<String> categoryId,
  Value<String> accountId,
  Value<String?> note,
  Value<String> frequency,
  Value<DateTime> nextDate,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RecurringTransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDate => $composableBuilder(
      column: $table.nextDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RecurringTransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDate => $composableBuilder(
      column: $table.nextDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecurringTransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDate =>
      $composableBuilder(column: $table.nextDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecurringTransactionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringTransactionsTableTable,
    RecurringTransactionEntity,
    $$RecurringTransactionsTableTableFilterComposer,
    $$RecurringTransactionsTableTableOrderingComposer,
    $$RecurringTransactionsTableTableAnnotationComposer,
    $$RecurringTransactionsTableTableCreateCompanionBuilder,
    $$RecurringTransactionsTableTableUpdateCompanionBuilder,
    (
      RecurringTransactionEntity,
      BaseReferences<_$AppDatabase, $RecurringTransactionsTableTable,
          RecurringTransactionEntity>
    ),
    RecurringTransactionEntity,
    PrefetchHooks Function()> {
  $$RecurringTransactionsTableTableTableManager(
      _$AppDatabase db, $RecurringTransactionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<DateTime> nextDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringTransactionsTableCompanion(
            id: id,
            title: title,
            amount: amount,
            type: type,
            categoryId: categoryId,
            accountId: accountId,
            note: note,
            frequency: frequency,
            nextDate: nextDate,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String type,
            required String categoryId,
            required String accountId,
            Value<String?> note = const Value.absent(),
            required String frequency,
            required DateTime nextDate,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringTransactionsTableCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            type: type,
            categoryId: categoryId,
            accountId: accountId,
            note: note,
            frequency: frequency,
            nextDate: nextDate,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringTransactionsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RecurringTransactionsTableTable,
        RecurringTransactionEntity,
        $$RecurringTransactionsTableTableFilterComposer,
        $$RecurringTransactionsTableTableOrderingComposer,
        $$RecurringTransactionsTableTableAnnotationComposer,
        $$RecurringTransactionsTableTableCreateCompanionBuilder,
        $$RecurringTransactionsTableTableUpdateCompanionBuilder,
        (
          RecurringTransactionEntity,
          BaseReferences<_$AppDatabase, $RecurringTransactionsTableTable,
              RecurringTransactionEntity>
        ),
        RecurringTransactionEntity,
        PrefetchHooks Function()>;
typedef $$InstallmentsTableTableCreateCompanionBuilder
    = InstallmentsTableCompanion Function({
  required String id,
  required String accountId,
  required String title,
  required double totalAmount,
  required int totalInstallments,
  Value<int> paidInstallments,
  required double installmentAmount,
  required DateTime startDate,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$InstallmentsTableTableUpdateCompanionBuilder
    = InstallmentsTableCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> title,
  Value<double> totalAmount,
  Value<int> totalInstallments,
  Value<int> paidInstallments,
  Value<double> installmentAmount,
  Value<DateTime> startDate,
  Value<String?> note,
  Value<int> rowid,
});

class $$InstallmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentsTableTable> {
  $$InstallmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$InstallmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentsTableTable> {
  $$InstallmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$InstallmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentsTableTable> {
  $$InstallmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments, builder: (column) => column);

  GeneratedColumn<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments, builder: (column) => column);

  GeneratedColumn<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$InstallmentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InstallmentsTableTable,
    InstallmentEntry,
    $$InstallmentsTableTableFilterComposer,
    $$InstallmentsTableTableOrderingComposer,
    $$InstallmentsTableTableAnnotationComposer,
    $$InstallmentsTableTableCreateCompanionBuilder,
    $$InstallmentsTableTableUpdateCompanionBuilder,
    (
      InstallmentEntry,
      BaseReferences<_$AppDatabase, $InstallmentsTableTable, InstallmentEntry>
    ),
    InstallmentEntry,
    PrefetchHooks Function()> {
  $$InstallmentsTableTableTableManager(
      _$AppDatabase db, $InstallmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallmentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<int> totalInstallments = const Value.absent(),
            Value<int> paidInstallments = const Value.absent(),
            Value<double> installmentAmount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InstallmentsTableCompanion(
            id: id,
            accountId: accountId,
            title: title,
            totalAmount: totalAmount,
            totalInstallments: totalInstallments,
            paidInstallments: paidInstallments,
            installmentAmount: installmentAmount,
            startDate: startDate,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required String title,
            required double totalAmount,
            required int totalInstallments,
            Value<int> paidInstallments = const Value.absent(),
            required double installmentAmount,
            required DateTime startDate,
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InstallmentsTableCompanion.insert(
            id: id,
            accountId: accountId,
            title: title,
            totalAmount: totalAmount,
            totalInstallments: totalInstallments,
            paidInstallments: paidInstallments,
            installmentAmount: installmentAmount,
            startDate: startDate,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InstallmentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InstallmentsTableTable,
    InstallmentEntry,
    $$InstallmentsTableTableFilterComposer,
    $$InstallmentsTableTableOrderingComposer,
    $$InstallmentsTableTableAnnotationComposer,
    $$InstallmentsTableTableCreateCompanionBuilder,
    $$InstallmentsTableTableUpdateCompanionBuilder,
    (
      InstallmentEntry,
      BaseReferences<_$AppDatabase, $InstallmentsTableTable, InstallmentEntry>
    ),
    InstallmentEntry,
    PrefetchHooks Function()>;
typedef $$TagsTableTableCreateCompanionBuilder = TagsTableCompanion Function({
  required String id,
  required String name,
  Value<int?> colorValue,
  Value<String?> iconName,
  Value<int> rowid,
});
typedef $$TagsTableTableUpdateCompanionBuilder = TagsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> colorValue,
  Value<String?> iconName,
  Value<int> rowid,
});

class $$TagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TagsTableTable> {
  $$TagsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));
}

class $$TagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TagsTableTable> {
  $$TagsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTableTable> {
  $$TagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);
}

class $$TagsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTableTable,
    TagEntry,
    $$TagsTableTableFilterComposer,
    $$TagsTableTableOrderingComposer,
    $$TagsTableTableAnnotationComposer,
    $$TagsTableTableCreateCompanionBuilder,
    $$TagsTableTableUpdateCompanionBuilder,
    (TagEntry, BaseReferences<_$AppDatabase, $TagsTableTable, TagEntry>),
    TagEntry,
    PrefetchHooks Function()> {
  $$TagsTableTableTableManager(_$AppDatabase db, $TagsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsTableCompanion(
            id: id,
            name: name,
            colorValue: colorValue,
            iconName: iconName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> colorValue = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsTableCompanion.insert(
            id: id,
            name: name,
            colorValue: colorValue,
            iconName: iconName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTableTable,
    TagEntry,
    $$TagsTableTableFilterComposer,
    $$TagsTableTableOrderingComposer,
    $$TagsTableTableAnnotationComposer,
    $$TagsTableTableCreateCompanionBuilder,
    $$TagsTableTableUpdateCompanionBuilder,
    (TagEntry, BaseReferences<_$AppDatabase, $TagsTableTable, TagEntry>),
    TagEntry,
    PrefetchHooks Function()>;
typedef $$TransactionTagsTableTableCreateCompanionBuilder
    = TransactionTagsTableCompanion Function({
  required String transactionId,
  required String tagId,
  Value<int> rowid,
});
typedef $$TransactionTagsTableTableUpdateCompanionBuilder
    = TransactionTagsTableCompanion Function({
  Value<String> transactionId,
  Value<String> tagId,
  Value<int> rowid,
});

class $$TransactionTagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTagsTableTable> {
  $$TransactionTagsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnFilters(column));
}

class $$TransactionTagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTagsTableTable> {
  $$TransactionTagsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnOrderings(column));
}

class $$TransactionTagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTagsTableTable> {
  $$TransactionTagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$TransactionTagsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionTagsTableTable,
    TransactionTagEntry,
    $$TransactionTagsTableTableFilterComposer,
    $$TransactionTagsTableTableOrderingComposer,
    $$TransactionTagsTableTableAnnotationComposer,
    $$TransactionTagsTableTableCreateCompanionBuilder,
    $$TransactionTagsTableTableUpdateCompanionBuilder,
    (
      TransactionTagEntry,
      BaseReferences<_$AppDatabase, $TransactionTagsTableTable,
          TransactionTagEntry>
    ),
    TransactionTagEntry,
    PrefetchHooks Function()> {
  $$TransactionTagsTableTableTableManager(
      _$AppDatabase db, $TransactionTagsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTagsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTagsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> transactionId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionTagsTableCompanion(
            transactionId: transactionId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String transactionId,
            required String tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionTagsTableCompanion.insert(
            transactionId: transactionId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionTagsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TransactionTagsTableTable,
        TransactionTagEntry,
        $$TransactionTagsTableTableFilterComposer,
        $$TransactionTagsTableTableOrderingComposer,
        $$TransactionTagsTableTableAnnotationComposer,
        $$TransactionTagsTableTableCreateCompanionBuilder,
        $$TransactionTagsTableTableUpdateCompanionBuilder,
        (
          TransactionTagEntry,
          BaseReferences<_$AppDatabase, $TransactionTagsTableTable,
              TransactionTagEntry>
        ),
        TransactionTagEntry,
        PrefetchHooks Function()>;
typedef $$ScheduledPaymentsTableTableCreateCompanionBuilder
    = ScheduledPaymentsTableCompanion Function({
  required String id,
  required String title,
  required double amount,
  Value<String?> accountId,
  Value<String?> categoryId,
  required DateTime dueDate,
  Value<String> frequency,
  Value<bool> autoPay,
  Value<bool> isActive,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$ScheduledPaymentsTableTableUpdateCompanionBuilder
    = ScheduledPaymentsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String?> accountId,
  Value<String?> categoryId,
  Value<DateTime> dueDate,
  Value<String> frequency,
  Value<bool> autoPay,
  Value<bool> isActive,
  Value<String?> note,
  Value<int> rowid,
});

class $$ScheduledPaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledPaymentsTableTable> {
  $$ScheduledPaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoPay => $composableBuilder(
      column: $table.autoPay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$ScheduledPaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledPaymentsTableTable> {
  $$ScheduledPaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoPay => $composableBuilder(
      column: $table.autoPay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$ScheduledPaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledPaymentsTableTable> {
  $$ScheduledPaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<bool> get autoPay =>
      $composableBuilder(column: $table.autoPay, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ScheduledPaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledPaymentsTableTable,
    ScheduledPaymentEntry,
    $$ScheduledPaymentsTableTableFilterComposer,
    $$ScheduledPaymentsTableTableOrderingComposer,
    $$ScheduledPaymentsTableTableAnnotationComposer,
    $$ScheduledPaymentsTableTableCreateCompanionBuilder,
    $$ScheduledPaymentsTableTableUpdateCompanionBuilder,
    (
      ScheduledPaymentEntry,
      BaseReferences<_$AppDatabase, $ScheduledPaymentsTableTable,
          ScheduledPaymentEntry>
    ),
    ScheduledPaymentEntry,
    PrefetchHooks Function()> {
  $$ScheduledPaymentsTableTableTableManager(
      _$AppDatabase db, $ScheduledPaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledPaymentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledPaymentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledPaymentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<bool> autoPay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledPaymentsTableCompanion(
            id: id,
            title: title,
            amount: amount,
            accountId: accountId,
            categoryId: categoryId,
            dueDate: dueDate,
            frequency: frequency,
            autoPay: autoPay,
            isActive: isActive,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            Value<String?> accountId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            required DateTime dueDate,
            Value<String> frequency = const Value.absent(),
            Value<bool> autoPay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledPaymentsTableCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            accountId: accountId,
            categoryId: categoryId,
            dueDate: dueDate,
            frequency: frequency,
            autoPay: autoPay,
            isActive: isActive,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScheduledPaymentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ScheduledPaymentsTableTable,
        ScheduledPaymentEntry,
        $$ScheduledPaymentsTableTableFilterComposer,
        $$ScheduledPaymentsTableTableOrderingComposer,
        $$ScheduledPaymentsTableTableAnnotationComposer,
        $$ScheduledPaymentsTableTableCreateCompanionBuilder,
        $$ScheduledPaymentsTableTableUpdateCompanionBuilder,
        (
          ScheduledPaymentEntry,
          BaseReferences<_$AppDatabase, $ScheduledPaymentsTableTable,
              ScheduledPaymentEntry>
        ),
        ScheduledPaymentEntry,
        PrefetchHooks Function()>;
typedef $$FriendRequestsTableTableCreateCompanionBuilder
    = FriendRequestsTableCompanion Function({
  required String id,
  required String fromUserId,
  required String toUserId,
  Value<String?> fromDisplayName,
  Value<String?> fromPhotoUrl,
  Value<String> status,
  required DateTime createdAt,
  Value<DateTime?> respondedAt,
  Value<int> rowid,
});
typedef $$FriendRequestsTableTableUpdateCompanionBuilder
    = FriendRequestsTableCompanion Function({
  Value<String> id,
  Value<String> fromUserId,
  Value<String> toUserId,
  Value<String?> fromDisplayName,
  Value<String?> fromPhotoUrl,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> respondedAt,
  Value<int> rowid,
});

class $$FriendRequestsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FriendRequestsTableTable> {
  $$FriendRequestsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromUserId => $composableBuilder(
      column: $table.fromUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toUserId => $composableBuilder(
      column: $table.toUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromDisplayName => $composableBuilder(
      column: $table.fromDisplayName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromPhotoUrl => $composableBuilder(
      column: $table.fromPhotoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnFilters(column));
}

class $$FriendRequestsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendRequestsTableTable> {
  $$FriendRequestsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromUserId => $composableBuilder(
      column: $table.fromUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toUserId => $composableBuilder(
      column: $table.toUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromDisplayName => $composableBuilder(
      column: $table.fromDisplayName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromPhotoUrl => $composableBuilder(
      column: $table.fromPhotoUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnOrderings(column));
}

class $$FriendRequestsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendRequestsTableTable> {
  $$FriendRequestsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromUserId => $composableBuilder(
      column: $table.fromUserId, builder: (column) => column);

  GeneratedColumn<String> get toUserId =>
      $composableBuilder(column: $table.toUserId, builder: (column) => column);

  GeneratedColumn<String> get fromDisplayName => $composableBuilder(
      column: $table.fromDisplayName, builder: (column) => column);

  GeneratedColumn<String> get fromPhotoUrl => $composableBuilder(
      column: $table.fromPhotoUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => column);
}

class $$FriendRequestsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FriendRequestsTableTable,
    FriendRequestEntry,
    $$FriendRequestsTableTableFilterComposer,
    $$FriendRequestsTableTableOrderingComposer,
    $$FriendRequestsTableTableAnnotationComposer,
    $$FriendRequestsTableTableCreateCompanionBuilder,
    $$FriendRequestsTableTableUpdateCompanionBuilder,
    (
      FriendRequestEntry,
      BaseReferences<_$AppDatabase, $FriendRequestsTableTable,
          FriendRequestEntry>
    ),
    FriendRequestEntry,
    PrefetchHooks Function()> {
  $$FriendRequestsTableTableTableManager(
      _$AppDatabase db, $FriendRequestsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendRequestsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendRequestsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendRequestsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromUserId = const Value.absent(),
            Value<String> toUserId = const Value.absent(),
            Value<String?> fromDisplayName = const Value.absent(),
            Value<String?> fromPhotoUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> respondedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FriendRequestsTableCompanion(
            id: id,
            fromUserId: fromUserId,
            toUserId: toUserId,
            fromDisplayName: fromDisplayName,
            fromPhotoUrl: fromPhotoUrl,
            status: status,
            createdAt: createdAt,
            respondedAt: respondedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fromUserId,
            required String toUserId,
            Value<String?> fromDisplayName = const Value.absent(),
            Value<String?> fromPhotoUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> respondedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FriendRequestsTableCompanion.insert(
            id: id,
            fromUserId: fromUserId,
            toUserId: toUserId,
            fromDisplayName: fromDisplayName,
            fromPhotoUrl: fromPhotoUrl,
            status: status,
            createdAt: createdAt,
            respondedAt: respondedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FriendRequestsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FriendRequestsTableTable,
    FriendRequestEntry,
    $$FriendRequestsTableTableFilterComposer,
    $$FriendRequestsTableTableOrderingComposer,
    $$FriendRequestsTableTableAnnotationComposer,
    $$FriendRequestsTableTableCreateCompanionBuilder,
    $$FriendRequestsTableTableUpdateCompanionBuilder,
    (
      FriendRequestEntry,
      BaseReferences<_$AppDatabase, $FriendRequestsTableTable,
          FriendRequestEntry>
    ),
    FriendRequestEntry,
    PrefetchHooks Function()>;
typedef $$SharedWishlistsTableTableCreateCompanionBuilder
    = SharedWishlistsTableCompanion Function({
  required String id,
  required String ownerUserId,
  required String wishlistItemId,
  required String title,
  Value<double> estimatedCost,
  Value<String?> url,
  Value<String?> note,
  Value<bool> isVisible,
  Value<String?> claimedByUserId,
  required DateTime sharedAt,
  Value<int> rowid,
});
typedef $$SharedWishlistsTableTableUpdateCompanionBuilder
    = SharedWishlistsTableCompanion Function({
  Value<String> id,
  Value<String> ownerUserId,
  Value<String> wishlistItemId,
  Value<String> title,
  Value<double> estimatedCost,
  Value<String?> url,
  Value<String?> note,
  Value<bool> isVisible,
  Value<String?> claimedByUserId,
  Value<DateTime> sharedAt,
  Value<int> rowid,
});

class $$SharedWishlistsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SharedWishlistsTableTable> {
  $$SharedWishlistsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wishlistItemId => $composableBuilder(
      column: $table.wishlistItemId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVisible => $composableBuilder(
      column: $table.isVisible, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get claimedByUserId => $composableBuilder(
      column: $table.claimedByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sharedAt => $composableBuilder(
      column: $table.sharedAt, builder: (column) => ColumnFilters(column));
}

class $$SharedWishlistsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedWishlistsTableTable> {
  $$SharedWishlistsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wishlistItemId => $composableBuilder(
      column: $table.wishlistItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVisible => $composableBuilder(
      column: $table.isVisible, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get claimedByUserId => $composableBuilder(
      column: $table.claimedByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sharedAt => $composableBuilder(
      column: $table.sharedAt, builder: (column) => ColumnOrderings(column));
}

class $$SharedWishlistsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedWishlistsTableTable> {
  $$SharedWishlistsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => column);

  GeneratedColumn<String> get wishlistItemId => $composableBuilder(
      column: $table.wishlistItemId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get estimatedCost => $composableBuilder(
      column: $table.estimatedCost, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<String> get claimedByUserId => $composableBuilder(
      column: $table.claimedByUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => column);
}

class $$SharedWishlistsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SharedWishlistsTableTable,
    SharedWishlistEntry,
    $$SharedWishlistsTableTableFilterComposer,
    $$SharedWishlistsTableTableOrderingComposer,
    $$SharedWishlistsTableTableAnnotationComposer,
    $$SharedWishlistsTableTableCreateCompanionBuilder,
    $$SharedWishlistsTableTableUpdateCompanionBuilder,
    (
      SharedWishlistEntry,
      BaseReferences<_$AppDatabase, $SharedWishlistsTableTable,
          SharedWishlistEntry>
    ),
    SharedWishlistEntry,
    PrefetchHooks Function()> {
  $$SharedWishlistsTableTableTableManager(
      _$AppDatabase db, $SharedWishlistsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedWishlistsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedWishlistsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedWishlistsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerUserId = const Value.absent(),
            Value<String> wishlistItemId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> estimatedCost = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<String?> claimedByUserId = const Value.absent(),
            Value<DateTime> sharedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SharedWishlistsTableCompanion(
            id: id,
            ownerUserId: ownerUserId,
            wishlistItemId: wishlistItemId,
            title: title,
            estimatedCost: estimatedCost,
            url: url,
            note: note,
            isVisible: isVisible,
            claimedByUserId: claimedByUserId,
            sharedAt: sharedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerUserId,
            required String wishlistItemId,
            required String title,
            Value<double> estimatedCost = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<String?> claimedByUserId = const Value.absent(),
            required DateTime sharedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SharedWishlistsTableCompanion.insert(
            id: id,
            ownerUserId: ownerUserId,
            wishlistItemId: wishlistItemId,
            title: title,
            estimatedCost: estimatedCost,
            url: url,
            note: note,
            isVisible: isVisible,
            claimedByUserId: claimedByUserId,
            sharedAt: sharedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SharedWishlistsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SharedWishlistsTableTable,
        SharedWishlistEntry,
        $$SharedWishlistsTableTableFilterComposer,
        $$SharedWishlistsTableTableOrderingComposer,
        $$SharedWishlistsTableTableAnnotationComposer,
        $$SharedWishlistsTableTableCreateCompanionBuilder,
        $$SharedWishlistsTableTableUpdateCompanionBuilder,
        (
          SharedWishlistEntry,
          BaseReferences<_$AppDatabase, $SharedWishlistsTableTable,
              SharedWishlistEntry>
        ),
        SharedWishlistEntry,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$PersonsTableTableTableManager get personsTable =>
      $$PersonsTableTableTableManager(_db, _db.personsTable);
  $$GroupsTableTableTableManager get groupsTable =>
      $$GroupsTableTableTableManager(_db, _db.groupsTable);
  $$GroupMembersTableTableTableManager get groupMembersTable =>
      $$GroupMembersTableTableTableManager(_db, _db.groupMembersTable);
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(_db, _db.userProfileTable);
  $$WishlistTableTableTableManager get wishlistTable =>
      $$WishlistTableTableTableManager(_db, _db.wishlistTable);
  $$RecurringTransactionsTableTableTableManager
      get recurringTransactionsTable =>
          $$RecurringTransactionsTableTableTableManager(
              _db, _db.recurringTransactionsTable);
  $$InstallmentsTableTableTableManager get installmentsTable =>
      $$InstallmentsTableTableTableManager(_db, _db.installmentsTable);
  $$TagsTableTableTableManager get tagsTable =>
      $$TagsTableTableTableManager(_db, _db.tagsTable);
  $$TransactionTagsTableTableTableManager get transactionTagsTable =>
      $$TransactionTagsTableTableTableManager(_db, _db.transactionTagsTable);
  $$ScheduledPaymentsTableTableTableManager get scheduledPaymentsTable =>
      $$ScheduledPaymentsTableTableTableManager(
          _db, _db.scheduledPaymentsTable);
  $$FriendRequestsTableTableTableManager get friendRequestsTable =>
      $$FriendRequestsTableTableTableManager(_db, _db.friendRequestsTable);
  $$SharedWishlistsTableTableTableManager get sharedWishlistsTable =>
      $$SharedWishlistsTableTableTableManager(_db, _db.sharedWishlistsTable);
}
