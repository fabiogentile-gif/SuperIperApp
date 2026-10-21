import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/app_bar.dart';
import 'package:superiper_app/widgets/homepage/add_card_button.dart';
import 'package:superiper_app/widgets/homepage/card_search_bar.dart';
import 'package:superiper_app/widgets/homepage/card_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _allCards = List.generate(6, (i) => 'Carta ${i + 1}');

  String _query = '';

  List<String> get _filteredCards {
    final q = _query.trim().toLowerCase();

    if (q.isEmpty) return _allCards;

    return _allCards.where((name) => name.toLowerCase().contains(q)).toList();
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = _filteredCards;

    return Scaffold(
      appBar: const StandardAppBar(title: 'Le tue carte',subtitle: 'Tutte le tue carte fedeltà  in un posto solo',),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CardSearchBar(
              controller: _searchController,
              query: _query,
              onChanged: _updateQuery,
              onClear: _clearSearch,
            ),
          ),
          CardGrid(cards: cards),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AddCardButton(),
            ),
          ),
        ],
      ),
      
    );
  }
}
