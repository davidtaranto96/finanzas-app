import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/person.dart';
import '../../domain/models/group.dart';


final mockPeopleProvider = Provider<List<Person>>((ref) {
  return [
    const Person(
      id: 'p1',
      name: 'Sofía Taranto',
      alias: 'Sofi',
      avatarColor: Colors.pinkAccent,
      totalBalance: 27944.33,
      groupDebts: [
        DebtDetail(groupName: 'Gastos sin grupo', amount: 35420.00),
        DebtDetail(groupName: 'Lolla 2026', amount: -7475.67),
      ],
    ),
    const Person(
      id: 'p2',
      name: 'Juan Taranto',
      avatarColor: Colors.blueAccent,
      totalBalance: 141380.67,
      groupDebts: [
        DebtDetail(groupName: 'Gastos sin grupo', amount: 70750.00),
        DebtDetail(groupName: 'Lolla 2026', amount: 70630.67),
      ],
    ),
    const Person(
      id: 'p3',
      name: 'Martin',
      avatarColor: Colors.greenAccent,
      totalBalance: 120000,
      groupDebts: [
        DebtDetail(groupName: 'Préstamo personal', amount: 120000),
      ],
    ),
    const Person(
      id: 'p4',
      name: 'Laura',
      avatarColor: Colors.orangeAccent,
      totalBalance: -15000,
      groupDebts: [
        DebtDetail(groupName: 'Cena Cumple', amount: -15000),
      ],
    ),
  ];
});

final mockGroupsProvider = Provider<List<ExpenseGroup>>((ref) {
  final people = ref.read(mockPeopleProvider);
  return [
    ExpenseGroup(
      id: 'g1',
      name: 'Viaje a Bariloche',
      members: people,
      totalGroupExpense: 450000, // Lo que costó todo en grupo
    ),
    ExpenseGroup(
      id: 'g2',
      name: 'Departamento',
      members: [people[0], people[1]], // Solo Sofi y Juan
      totalGroupExpense: 90000,
    ),
  ];
});

/// Filtros para la vista
final peopleThatOweMeProvider = Provider<List<Person>>((ref) {
  return ref.watch(mockPeopleProvider).where((p) => p.owesMe).toList();
});

final peopleIOweProvider = Provider<List<Person>>((ref) {
  return ref.watch(mockPeopleProvider).where((p) => p.iOweThem).toList();
});

final globalPeopleBalanceProvider = Provider<double>((ref) {
  return ref.watch(mockPeopleProvider).fold(0.0, (sum, p) => sum + p.totalBalance);
});
