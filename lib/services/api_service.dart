import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo/utils/hmac_utils.dart';
import "package:todo/utils/client_id_manager.dart";
import '../models/product.dart';

String baseUrl = 'http://10.0.3.1:5000/api/v1';

class ApiService {
  final String baseUrl = 'http://10.0.3.1:5000/api/v1';
  final String token;

  ApiService({this.token = ''});

  Future<List<Product>> getProducts() async {
    String clientId = await ClientIdManager.getClientId();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String hmacSignature = await HmacUtils.generateHmac(clientId, timestamp);

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'x-client-id': clientId,
        'x-timestamp': timestamp,
        'x-hmac-signature': hmacSignature,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)["data"];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}
