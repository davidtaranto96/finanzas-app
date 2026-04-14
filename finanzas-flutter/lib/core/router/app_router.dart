
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/monthly_overview/presentation/pages/monthly_overview_page.dart';
import '../../features/people/presentation/pages/people_page.dart';
import '../../features/people/presentation/pages/link_friend_page.dart';
import '../../features/people/presentation/pages/friend_requests_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/accounts/presentation/pages/account_detail_page.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../../features/goals/presentation/pages/savings_page.dart';
import '../../features/more/presentation/pages/novedades_page.dart';
import '../../features/onboarding/presentation/pages/setup_wizard_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/mercado_pago_page.dart';
import '../../features/recurring/presentation/pages/recurring_page.dart';
import '../shell/app_shell.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

/// Key del Navigator interno del ShellRoute — usado por AppShell para cerrar modales
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Maps a raw `sencillo://` URI from a widget click to an internal GoRouter path.
/// Anything unknown falls back to `/home` to keep the app from crashing into
/// "Page Not Found". Concrete in-app side effects (opening the Add sheet,
/// opening the AI voice sheet, etc.) are triggered by AppShell's
/// `HomeWidget.widgetClicked` listener — this function just picks a safe
/// landing screen for the cold-start case.
String _mapWidgetUri(String raw) {
  // Normalize: in cold start GoRouter sometimes prefixes with '/', so both
  // "sencillo://..." and "/sencillo://..." can arrive here.
  final cleaned = raw.startsWith('/') ? raw.substring(1) : raw;
  final uri = Uri.tryParse(cleaned);
  if (uri == null) return '/home';
  final host = uri.host.isEmpty ? uri.path.replaceAll('/', '') : uri.host;
  switch (host) {
    case 'quick-expense':
    case 'quick-voice':
    case 'add':
    case 'home':
      return '/home';
    case 'gastos':
    case 'transactions':
      return '/transactions';
    case 'cotizaciones':
    case 'dollar':
    case 'rates':
      return '/home';
    case 'crypto':
    case 'stocks':
    case 'acciones':
      return '/home';
    case 'accounts':
      return '/accounts';
    case 'budget':
      return '/budget';
    case 'goals':
      return '/goals';
    default:
      return '/home';
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Escucha el estado de auth para redirigir
  final authState = ref.watch(authStateProvider);
  final skipAuth = ref.watch(skipAuthProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoading = authState.isLoading;
      final authSkipped = skipAuth.skipped;
      final goingToLogin = state.matchedLocation == '/login';
      final location = state.matchedLocation;

      // ─── Widget deep-link safety net ─────────────────────────────
      // If the app is cold-started from a home-screen widget, Android passes
      // the raw URI (e.g. "sencillo://quick-expense/") to Flutter. GoRouter
      // would otherwise throw "no routes for location". We map known widget
      // hosts to real internal routes, and fall back to /home for anything
      // unknown so the app never crashes into a "Page Not Found".
      if (location.startsWith('sencillo:') ||
          location.startsWith('/sencillo:')) {
        final mapped = _mapWidgetUri(location);
        return mapped;
      }
      // Empty/malformed path → land safely on home
      if (location.isEmpty || location == '/') {
        return '/home';
      }

      if (isLoading && !authSkipped) return null; // esperá a que cargue
      // If user skipped auth OR is logged in, allow navigation
      if ((isLoggedIn || authSkipped) && goingToLogin) return '/home';
      // Not logged in and didn't skip → go to login
      if (!isLoggedIn && !authSkipped && !goingToLogin) return '/login';
      return null;
    },
    errorBuilder: (context, state) {
      // Last-line-of-defense: any unmatched route drops the user on /home.
      // We still log for debugging.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/home');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/setup-wizard',
        builder: (context, state) => const SetupWizardPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/budget',
                builder: (context, state) => const BudgetPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                builder: (context, state) => const GoalsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MorePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/monthly_overview',
        builder: (context, state) => const MonthlyOverviewPage(standalone: true),
      ),
      GoRoute(
        path: '/people',
        builder: (context, state) => const PeoplePage(standalone: true),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistPage(),
      ),
      GoRoute(
        path: '/accounts',
        builder: (context, state) => const AccountsPage(standalone: true),
      ),
      GoRoute(
        path: '/mercado-pago',
        builder: (context, state) => const MercadoPagoPage(),
      ),
      GoRoute(
        path: '/accounts/:accountId',
        builder: (context, state) => AccountDetailPage(
          accountId: state.pathParameters['accountId']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/savings',
        builder: (context, state) => const SavingsPage(),
      ),
      GoRoute(
        path: '/transactions/:txId',
        builder: (context, state) => TransactionDetailPage(
          txId: state.pathParameters['txId']!,
        ),
      ),
      GoRoute(
        path: '/link-friend',
        builder: (context, state) => const LinkFriendPage(),
      ),
      GoRoute(
        path: '/friend-requests',
        builder: (context, state) => const FriendRequestsPage(),
      ),
      GoRoute(
        path: '/novedades',
        builder: (context, state) => const NovedadesPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/recurring',
        builder: (context, state) => const RecurringPage(),
      ),
    ],
  );
});
