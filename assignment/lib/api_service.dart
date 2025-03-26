import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<void> submitCustomerData(Map<String, dynamic> formData) async {
    final url = Uri.parse("$baseUrl/submit-customer/");
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        print("Data submitted successfully: ${response.body}");
      } else {
        print("Failed to submit data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
