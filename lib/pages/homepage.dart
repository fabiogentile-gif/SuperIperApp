import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Le mie carte'),backgroundColor: Theme.of(context).scaffoldBackgroundColor,),
      body: const Center(child:MiaCard(titolo: "conad", descrizione: "supermercato", icona: Icons.access_alarm_outlined,colore: Colors.red,) ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add),
        
      ),
      
    );
  }
}