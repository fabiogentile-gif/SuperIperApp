import 'package:flutter/foundation.dart';

class CardProvider extends ChangeNotifier {
  final List<Map<String, String>> _cards = [];

  List<Map<String, String>> get cards => List.unmodifiable(_cards);

  void addCard(String name, String code) {
    _cards.add({'name': name, 'code': code});
    notifyListeners();
  }
}