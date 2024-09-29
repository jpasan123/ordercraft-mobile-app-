import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.ordercraft.com';

  Future<http.Response> getProducts() async {
    return await http.get(Uri.parse('$baseUrl/products'));
  }

  Future<http.Response> getProductDetails(String id) async {
    return await http.get(Uri.parse('$baseUrl/products/$id'));
  }

  Future<http.Response> placeOrder(Map<String, dynamic> orderData) async {
    return await http.post(
      Uri.parse('$baseUrl/orders'),
      body: orderData,
    );
  }
}
