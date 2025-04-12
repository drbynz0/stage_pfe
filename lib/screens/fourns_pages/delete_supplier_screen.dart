import 'package:flutter/material.dart';

class DeleteSupplierScreen extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteSupplierScreen({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmer la suppression'),
      content: const Text('Voulez-vous vraiment supprimer ce fournisseur ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}