import 'package:flutter/foundation.dart';

class CardProvider extends ChangeNotifier {
  final List<Map<String, String>> _cards = [
    {
      'name':'Esselunga',
      'code': '9820 4512 7308 64',
      'holder' : 'Mario Rossi',
      'category': 'Spesa'
    }
  ];

  List<Map<String, String>> get cards => List.unmodifiable(_cards);

  void addCard(String name, String code,String holder,String category) {
    _cards.add({'name': name, 'code': code,'holder':holder,'category': category});
    notifyListeners();
  }
}