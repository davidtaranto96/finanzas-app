import 'package:flutter/widgets.dart';

/// Registry of GlobalKeys attached to widgets targeted by the interactive tour.
/// Keys are instantiated once and reused; screens attach them to the relevant
/// widget via the `key:` parameter.
class TourKeys {
  TourKeys._();

  // Dashboard
  static final balanceCard = GlobalKey(debugLabel: 'tour_balance_card');
  static final recentTransactions =
      GlobalKey(debugLabel: 'tour_recent_transactions');
  static final fab = GlobalKey(debugLabel: 'tour_fab');
  static final aiAssistantButton =
      GlobalKey(debugLabel: 'tour_ai_assistant');

  // Bottom nav
  static final navHome = GlobalKey(debugLabel: 'tour_nav_home');
  static final navTransactions = GlobalKey(debugLabel: 'tour_nav_transactions');
  static final navBudget = GlobalKey(debugLabel: 'tour_nav_budget');
  static final navGoals = GlobalKey(debugLabel: 'tour_nav_goals');
  static final navMore = GlobalKey(debugLabel: 'tour_nav_more');

  // Transactions page
  static final transactionsList =
      GlobalKey(debugLabel: 'tour_transactions_list');
  static final transactionFilters =
      GlobalKey(debugLabel: 'tour_transaction_filters');

  // Budget
  static final budgetCategories =
      GlobalKey(debugLabel: 'tour_budget_categories');

  // Goals
  static final goalsList = GlobalKey(debugLabel: 'tour_goals_list');

  // More menu
  static final moreAccounts = GlobalKey(debugLabel: 'tour_more_accounts');
  static final morePeople = GlobalKey(debugLabel: 'tour_more_people');
  static final moreWishlist = GlobalKey(debugLabel: 'tour_more_wishlist');
  static final moreSettings = GlobalKey(debugLabel: 'tour_more_settings');
}
