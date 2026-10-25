import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MiaCard extends StatelessWidget {
  final String titolo;
  final String descrizione;
  final IconData icona;
  final Color colore;

  const MiaCard({
    super.key,
    required this.titolo,
    required this.descrizione,
    required this.icona,
    required this.colore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icona),
        title: Text(titolo),
        subtitle: Text(descrizione),
        tileColor: colore,
      ),
    );
  }
}
