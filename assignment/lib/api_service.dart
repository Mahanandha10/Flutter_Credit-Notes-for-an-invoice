import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<String> addCustomer(Map<String, dynamic> customerData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/submit-form"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(customerData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception("Failed to add customer: ${response.body}");
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
