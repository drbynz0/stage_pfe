import 'package:flutter/material.dart';
import '/models/client.dart';

class DeleteClientScreen extends StatelessWidget {
  final Client client;
  final Function() onDeleteClient;

  const DeleteClientScreen({super.key, required this.client, required this.onDeleteClient});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer un client'),
      content: Text('Êtes-vous sûr de vouloir supprimer ${client.name} ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            onDeleteClient();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}