import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use different base URLs for different platforms
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8000'; // iOS simulator
    } else {
      return 'http://localhost:8000'; // Web and others
    }
  }
  
  static Future<Map<String, dynamic>> sendImage(File imageFile) async {
    try {
      print('Sending image to: $baseUrl/predict');
      print('Image file path: ${imageFile.path}');
      
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      
      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg',
      );
      request.files.add(multipartFile);
      
      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      });
      
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      
      final response = await http.Response.fromStream(streamedResponse).timeout(
        const Duration(seconds: 10),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('API Response: $result');
        return result;
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      throw Exception('Network connection failed. Please check if backend is running.');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to send image: $e');
    }
  }
  
  static Future<Map<String, dynamic>> checkHealth() async {
    try {
      print('Checking health at: $baseUrl/health');
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Health check error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }
}
