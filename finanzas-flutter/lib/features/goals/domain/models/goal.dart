import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Goal extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final String iconName;
  final int colorValue;

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    this.deadline,
    this.iconName = 'flag',
    required this.colorValue,
  });

  static const Map<String, IconData> iconMap = {
    'flag': Icons.flag_rounded,
    'travel': Icons.flight_takeoff_rounded,
    'home': Icons.home_rounded,
    'car': Icons.directions_car_rounded,
    'laptop': Icons.laptop_mac_rounded,
    'game': Icons.videogame_asset_rounded,
    'shop': Icons.shopping_bag_rounded,
    'food': Icons.restaurant_rounded,
    'fitness': Icons.fitness_center_rounded,
    'savings': Icons.savings_rounded,
  };

  IconData get icon => iconMap[iconName] ?? Icons.flag_rounded;
  Color get color => Color(colorValue);

  double get remaining => targetAmount > savedAmount ? targetAmount - savedAmount : 0.0;
  double get progress => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => savedAmount >= targetAmount;

  @override
  List<Object?> get props => [id, savedAmount, targetAmount];
}
