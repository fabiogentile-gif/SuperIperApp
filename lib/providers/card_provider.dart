import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';

class CardProvider extends ChangeNotifier {
  final List<LoyaltyCard> _cards = [
    const LoyaltyCard(
      name: 'Esselunga',
      code: '9820 4512 7308 64',
      holder: 'Mario Rossi',
      category: 'Spesa',
    ),
  ];

  List<LoyaltyCard> get cards => List.unmodifiable(_cards);

  List<LoyaltyCard> get favorites =>
      _cards.where((c) => c.isFavorite).toList(growable: false);

  bool isFavorite(String code) =>
      _cards.any((c) => c.code == code && c.isFavorite);

  void addCard(LoyaltyCard card) {
    _cards.add(card);
    notifyListeners();
  }

  void updateCard(
    String originalCode, {
    String? name,
    String? code,
    String? category,
    String? holder,
    String? type,
    IconData? icon,
    Color? color,
    Color? onColor,
    bool? isFavorite,
  }) {
    final i = _cards.indexWhere((c) => c.code == originalCode);
    if (i == -1) return;

    _cards[i] = _cards[i].copyWith(
      name: name,
      code: code,
      category: category,
      holder: holder,
      type: type,
      icon: icon,
      color: color,
      onColor: onColor,
      isFavorite: isFavorite,
    );
    notifyListeners();
  }

  void deleteCard(String code) {
    final i = _cards.indexWhere((c) => c.code == code);
    if (i == -1) return;

    _cards.removeAt(i);
    notifyListeners();
  }

  void toggleFavorite(String code) {
    final i = _cards.indexWhere((c) => c.code == code);
    if (i == -1) return;
    _cards[i] = _cards[i].copyWith(isFavorite: !_cards[i].isFavorite);
    notifyListeners();
  }
}