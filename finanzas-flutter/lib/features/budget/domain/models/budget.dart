import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Budget extends Equatable {
  final String id;
  final String categoryId;
  final String categoryName;
  final String iconKey;
  final int colorValue;
  final double limitAmount;
  final double spentAmount;
  final String monthYear; // "2026-03"
  final bool isFixed;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.iconKey = 'pie_chart',
    required this.colorValue,
    required this.limitAmount,
    required this.spentAmount,
    required this.monthYear,
    this.isFixed = false,
  });

  static const Map<String, IconData> iconMap = {
    'pie_chart': Icons.pie_chart_rounded,
    'shopping_cart': Icons.shopping_cart_rounded,
    'restaurant': Icons.restaurant_rounded,
    'car': Icons.directions_car_rounded,
    'home': Icons.home_rounded,
    'tv': Icons.tv_rounded,
    'fitness': Icons.fitness_center_rounded,
    'health': Icons.health_and_safety_rounded,
    'education': Icons.school_rounded,
    'phone': Icons.phone_iphone_rounded,
  };

  IconData get icon => iconMap[iconKey] ?? Icons.pie_chart_rounded;
  Color get color => Color(colorValue);

  double get remaining => limitAmount - spentAmount;
  double get progress =>
      limitAmount > 0 ? (spentAmount / limitAmount).clamp(0.0, 2.0) : 0.0;
  bool get isOverBudget => spentAmount > limitAmount;
  double get usedPercent => (progress * 100).clamp(0, 100);

  @override
  List<Object?> get props => [id, monthYear];
}
