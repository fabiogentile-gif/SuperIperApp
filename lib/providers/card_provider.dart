import 'package:flutter/material.dart';
import 'package:superiper_app/features/cards/data/card_repository.dart';
import 'package:superiper_app/models/loyalty_card.dart';

class CardProvider extends ChangeNotifier {
  CardProvider({CardRepository? repository})
    : _repository = repository ?? CardRepository();

  final CardRepository _repository;

  final List<LoyaltyCard> _cards = [];

  Future<void> load() async {
    _cards
      ..clear()
      ..addAll(await _repository.getAll());
    notifyListeners();
  }

  Future<bool> addCard(LoyaltyCard card) async {
    try {
      await _repository.insert(card);
    } catch (e) {
      debugPrint('Errore salvataggio carta: $e');
      return false; // per esempio carta già presente
    }
    _cards.add(card);
    notifyListeners();
    return true;
  }

  List<LoyaltyCard> get cards => List.unmodifiable(_cards);

  List<LoyaltyCard> get favorites =>
      _cards.where((c) => c.isFavorite).toList(growable: false);

  bool isFavorite(String code) =>
      _cards.any((c) => c.code == code && c.isFavorite);

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
    String? barcodeFormat,
  }) async {
    final i = _cards.indexWhere((c) => c.code == originalCode);
    if (i == -1) return;

    final updated = _cards[i].copyWith(/* ...come prima */);
    await _repository.update(originalCode, updated);
    _cards[i] = updated;
    notifyListeners();
  }

  Future<void> deleteCard(String code) async {
    final i = _cards.indexWhere((c) => c.code == code);
    if (i == -1) return;

    await _repository.delete(code);
    _cards.removeAt(i);
    notifyListeners();
  }

  Future<void> toggleFavorite(String code) async {
    final i = _cards.indexWhere((c) => c.code == code);
    if (i == -1) return;

    final updated = _cards[i].copyWith(isFavorite: !_cards[i].isFavorite);
    await _repository.update(code, updated);
    _cards[i] = updated;
    notifyListeners();
  }
}
