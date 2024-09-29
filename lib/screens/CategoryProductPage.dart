import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/screens/product_page.dart'; // Import ProductPage if needed

class CategoryProductPage extends StatelessWidget {
  final String category;

  CategoryProductPage({required this.category});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! List<Product>) {
      // Handle the case where no products were passed
      return Scaffold(
        appBar: AppBar(
          title: Text('$category Products'),
        ),
        body: Center(child: Text('No products available for this category.')),
      );
    }

    final List<Product> products = arguments as List<Product>;

    // Filter products based on the selected category
    final filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(category.toLowerCase());
      // Modify this if you have a product.category field: product.category == category
    }).toList();

    if (filteredProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('$category Products'),
        ),
        body: Center(child: Text('No products available for this category.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Products'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the ProductPage when a product is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: product),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.asset(product.imageUrl, height: 100, fit: BoxFit.cover),
                  Text(product.name),
                  Text('\$${product.price}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
