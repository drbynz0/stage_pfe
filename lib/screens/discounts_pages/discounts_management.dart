import 'package:flutter/material.dart';
import '/models/discounts.dart';
import 'add_discounts.dart';
import 'edit_discounts.dart';
import 'delete_discounts.dart';

class DiscountsManagementScreen extends StatefulWidget {
  const DiscountsManagementScreen({super.key});

  @override
  State<DiscountsManagementScreen> createState() => _DiscountsManagementScreenState();
}

class _DiscountsManagementScreenState extends State<DiscountsManagementScreen> {
  final List<Discount> _discounts = [
    Discount(
      id: '1',
      title: 'Remise de 10%',
      validity: 'Valide jusqu\'au 30 avril 2025',
      productName: 'Produit A',
      normalPrice: 200.0,
      promotionPrice: 180.0,
    ),
    Discount(
      id: '2',
      title: 'Remise de 20%',
      validity: 'Valide jusqu\'au 15 mai 2025',
      productName: 'Produit B',
      normalPrice: 300.0,
      promotionPrice: 240.0,
    ),
  ];

  void _addDiscount(Discount discount) {
    setState(() {
      _discounts.add(discount);
    });
  }

  void _editDiscount(Discount updatedDiscount) {
    setState(() {
      final index = _discounts.indexWhere((d) => d.id == updatedDiscount.id);
      if (index != -1) {
        _discounts[index] = updatedDiscount;
      }
    });
  }

  void _deleteDiscount(String discountId) {
    setState(() {
      _discounts.removeWhere((d) => d.id == discountId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Discounts'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _discounts.isEmpty
            ? const Center(
                child: Text(
                  'Aucun discount disponible.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _discounts.length,
                itemBuilder: (context, index) {
                  final discount = _discounts[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(discount.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Produit : ${discount.productName}'),
                          Text('Prix normal : ${discount.normalPrice} MAD'),
                          Text('Prix promo : ${discount.promotionPrice} MAD'),
                          Text(discount.validity),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDiscountScreen(
                                    discount: discount,
                                    onEditDiscount: _editDiscount,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeleteDiscountScreen(
                                    discount: discount,
                                    onDeleteDiscount: _deleteDiscount,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiscountScreen(onAddDiscount: _addDiscount),
            ),
          );
        },
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}