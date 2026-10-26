import 'package:flutter/material.dart';

class LoyaltyCard {
  final String name;
  final String code;
  final String category;
  final String holder;
  final String type;
  final IconData icon;
  final Color color;
  final Color onColor;
  final bool isFavorite;

  const LoyaltyCard({
    required this.name,
    required this.code,
    this.category = '',
    this.holder = '',
    this.type = 'Carta fedeltà',
    this.icon = Icons.eco_outlined,
    this.color = const Color(0xFFDBEFE3),
    this.onColor = const Color(0xFF285943),
    this.isFavorite = false,
  });

  LoyaltyCard copyWith({bool? isFavorite}) => LoyaltyCard(
    name: name,
    code: code,
    category: category,
    holder: holder,
    type: type,
    icon: icon,
    color: color,
    onColor: onColor,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}