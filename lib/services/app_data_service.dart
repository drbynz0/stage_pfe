import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/external_order.dart';
import '../models/internal_order.dart';
import '../models/supplier.dart';
import '../models/product.dart';

class AppData extends ChangeNotifier {
  List<Client> _clients = [];
  List<ExternalOrder> _externalOrders = [];
  List<InternalOrder> _internalOrders = [];
  List<Supplier> _suppliers = [];
  List<Product> _products = [];

  AppData() {
    // Initialisation des données
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _clients = Client.getClients();
    _products = Product.getProducts();
    _externalOrders = ExternalOrder.getExternalOrderList();
    _internalOrders = InternalOrder.getInternalOrderList();
    _suppliers = Supplier.listSuppliers;
    notifyListeners();
  }

  // Getters
  List<Client> get clients => _clients;
  List<Product> get products => _products;
  List<ExternalOrder> get externalOrders => _externalOrders;
  List<InternalOrder> get internalOrders => _internalOrders;
  List<Supplier> get suppliers => _suppliers;

}