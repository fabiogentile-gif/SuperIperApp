import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/widgets/app_bar.dart';
import 'package:superiper_app/widgets/homepage/add_card_button.dart';
import 'package:superiper_app/widgets/homepage/add_card_sheet.dart';
import 'package:superiper_app/widgets/homepage/card_search_bar.dart';
import 'package:superiper_app/widgets/homepage/card_grid.dart';

class HomePage extends StatefulWidget {
  final CardProvider cardProvider;

  const HomePage({super.key, required this.cardProvider});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LoyaltyCard> _filter(List<LoyaltyCard> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((c) => (c.name).toLowerCase().contains(q)).toList();
  }

  void _updateQuery(String value) => setState(() => _query = value);

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Le tue carte',
        subtitle: 'Tutte le tue carte fedeltà in un posto solo',
      ),
      body: Column(
        children: [
          CardSearchBar(
            controller: _searchController,
            query: _query,
            onChanged: _updateQuery,
            onClear: _clearSearch,
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.cardProvider,
              builder: (context, _) => CardGrid(
                cards: _filter(widget.cardProvider.cards),
                cardProvider: widget.cardProvider,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AddCardButton(
              onSave: (NewCardData data) {
                widget.cardProvider.addCard(
                  LoyaltyCard(
                    name: data.storeName,
                    code: data.number,
                    holder: data.holder,
                    category: data.category,
                  ),
                );
                _clearSearch();
              },
            ),
          ),
        ],
      ),
    );
  }
}
