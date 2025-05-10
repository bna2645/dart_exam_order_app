import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_provider.dart';
import 'order.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Management',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatelessWidget {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('My Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Item Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = searchController.text;
                    List<Order> results = orderProvider.searchOrders(query);
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Search Results'),
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 300,
                              ), // Constrain the height
                              child: ListView.builder(
                                shrinkWrap:
                                    true, // Ensure the ListView does not take infinite height
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final order = results[index];
                                  return ListTile(
                                    title: Text(order.itemName),
                                    subtitle: Text(
                                      'Price: ${order.price} ${order.currency}',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: currencyController,
                    decoration: InputDecoration(labelText: 'Currency'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newOrder = Order(
                  item: itemController.text,
                  itemName: itemNameController.text,
                  price: int.parse(priceController.text),
                  currency: currencyController.text,
                  quantity: int.parse(quantityController.text),
                );
                orderProvider.addOrder(newOrder);
                itemController.clear();
                itemNameController.clear();
                priceController.clear();
                currencyController.clear();
                quantityController.clear();
              },
              child: Text('Add Item to Cart'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orderProvider.orders.length,
                itemBuilder: (context, index) {
                  final order = orderProvider.orders[index];
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(order.itemName),
                    subtitle: Text('Price: ${order.price} ${order.currency}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        orderProvider.deleteOrder(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
