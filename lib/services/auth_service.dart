import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  // Factory constructor to create a User from JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }
}

class AuthService {
  final String baseUrl = 'https://api.ordercraft.com';

  // Login method to authenticate and return a User object
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    // Check if the login was successful
    if (response.statusCode == 200) {
      // Parse the JSON response and return a User object
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      // Throw an exception if login failed
      throw Exception('Failed to login: Invalid email or password');
    }
  }

  // Register method to create a new user
  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    // Check if the registration was successful
    if (response.statusCode != 200) {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
