import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [
    Order(
      item: "A1000",
      itemName: "Iphone 15",
      price: 1200,
      currency: "USD",
      quantity: 1,
    ),
    Order(
      item: "A1001",
      itemName: "Iphone 16",
      price: 1500,
      currency: "USD",
      quantity: 1,
    ),
  ];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  List<Order> searchOrders(String query) {
    return _orders
        .where(
          (order) => order.itemName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void deleteOrder(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }
}
