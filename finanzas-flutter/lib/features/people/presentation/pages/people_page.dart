import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/person.dart';
import '../providers/people_provider.dart';

class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPeople = ref.watch(mockPeopleProvider);
    final globalBalance = ref.watch(globalPeopleBalanceProvider);
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2, locale: 'en_US');
    final isPositive = globalBalance >= 0;

    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Focus on "Amigos" by default
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Personas y Saldos',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Colors.white70), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white70), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            // Resumen de Saldo Global (Splitwise style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPositive 
                      ? 'En general, te deben ${fmt.format(globalBalance)}'
                      : 'En general, debés ${fmt.format(globalBalance.abs())}',
                    style: GoogleFonts.inter(
                      color: isPositive ? const Color(0xFF26A69A) : const Color(0xFFFF7043),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                ],
              ),
            ),

            // TabBar
            const TabBar(
              indicatorColor: Color(0xFF26A69A),
              labelColor: Color(0xFF26A69A),
              unselectedLabelColor: Colors.white38,
              tabs: [
                Tab(child: Text('Grupos', style: TextStyle(fontSize: 13))),
                Tab(child: Text('Amigos', style: TextStyle(fontSize: 13))),
                Tab(child: Text('Actividad', style: TextStyle(fontSize: 13))),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                   // ─── Pestaña Grupos ───
                  _buildGroupsTab(context, ref),
                  
                  // ─── Pestaña Amigos (Main) ───
                  _buildFriendsTab(context, allPeople),

                  // ─── Pestaña Actividad ───
                  _buildActivityTab(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFF26A69A),
          icon: const Icon(Icons.receipt_long_rounded, color: Colors.white),
          label: const Text('Añadir gasto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildFriendsTab(BuildContext context, List<Person> people) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];
        return _FriendListTile(person: person);
      },
    );
  }

  Widget _buildGroupsTab(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(mockGroupsProvider);
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: groups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final group = groups[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.group, color: Colors.white54),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('Sin deudas pendientes', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return const Center(
      child: Text('No hay actividad reciente', style: TextStyle(color: Colors.white38)),
    );
  }
}

class _FriendListTile extends StatelessWidget {
  final Person person;
  const _FriendListTile({required this.person});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2, locale: 'en_US');
    final isPositive = person.owesMe;
    final color = isPositive ? const Color(0xFF26A69A) : const Color(0xFFFF7043);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: person.avatarColor.withValues(alpha: 0.2),
                radius: 20,
                child: Text(
                  person.displayName[0].toUpperCase(),
                  style: TextStyle(color: person.avatarColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    // Detalle por grupo (Identado como en el screenshot)
                    ...person.groupDebts.map((debt) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(width: 20, height: 1, color: Colors.white12),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 13, color: Colors.white38),
                                children: [
                                  TextSpan(text: person.displayName),
                                  TextSpan(text: debt.amount > 0 ? ' te debe ' : ' debés a '),
                                  TextSpan(
                                    text: fmt.format(debt.amount.abs()),
                                    style: TextStyle(color: debt.amount > 0 ? const Color(0xFF26A69A).withValues(alpha: 0.8) : const Color(0xFFFF7043).withValues(alpha: 0.8)),
                                  ),
                                  const TextSpan(text: ' para '),
                                  TextSpan(text: '"${debt.groupName}"', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isPositive ? 'te debe' : 'debés',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  Text(
                    fmt.format(person.totalBalance.abs()),
                    style: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10, height: 1, indent: 76),
      ],
    );
  }
}
