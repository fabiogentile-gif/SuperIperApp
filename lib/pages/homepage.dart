import 'package:flutter/material.dart';
import 'package:superiper_app/models/loyalty_card.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/features/cards/data/card_repository.dart';
import 'package:superiper_app/features/cards/domain/card.dart' as model;
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
  final CardRepository _repository = CardRepository();
  final _searchController = TextEditingController();

  String _query = '';
  List<model.Card> _cards = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

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

  Future<void> _loadCards() async {
    try {
      final cards = await _repository.getAll();

      if (!mounted) return;

      setState(() {
        _cards = cards;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Impossibile caricare le carte salvate.';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCard(model.Card card) async {
    if (card.id == null) return;

    try {
      await _repository.delete(card.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Carta eliminata')));

      await _loadCards();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore durante l’eliminazione della carta'),
        ),
      );
    }
  }

  Future<void> _addCard() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => const AddCardSheet(),
    );

    if (saved == true && mounted) {
      await _loadCards();
    }
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