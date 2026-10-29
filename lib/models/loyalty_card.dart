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

  LoyaltyCard copyWith({
    String? name,
    String? code,
    String? category,
    String? holder,
    String? type,
    IconData? icon,
    Color? color,
    Color? onColor,
    bool? isFavorite,
  }) =>
      LoyaltyCard(
        name: name ?? this.name,
        code: code ?? this.code,
        category: category ?? this.category,
        holder: holder ?? this.holder,
        type: type ?? this.type,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        onColor: onColor ?? this.onColor,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}