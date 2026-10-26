import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/widgets/app_bar.dart';
import 'package:superiper_app/widgets/homepage/card_grid.dart';
import 'package:superiper_app/widgets/homepage/card_search_bar.dart';

class Favorites extends StatefulWidget {
  final CardProvider cardProvider;

  const Favorites({super.key, required this.cardProvider});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
    return all.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  void _updateQuery(String value) => setState(() => _query = value);

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  String _subtitle(int n) => switch (n) {
    0 => 'Nessuna carta preferita',
    1 => '1 carta preferita',
    _ => '$n carte preferite',
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: widget.cardProvider,
      builder: (context, _) {
        final favorites = widget.cardProvider.favorites;

        return Scaffold(
          appBar: StandardAppBar(
            title: 'Preferiti',
            subtitle: _subtitle(favorites.length),
          ),
          body: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Nessun preferito',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  children: [
                    CardSearchBar(
                      controller: _searchController,
                      query: _query,
                      onChanged: _updateQuery,
                      onClear: _clearSearch,
                    ),
                    Expanded(
                      child: CardGrid(
                        cards: _filter(favorites),
                        cardProvider: widget.cardProvider,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
