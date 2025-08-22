import 'dart:convert';
import 'dart:developer';

import 'package:frontend/services/storage_service.dart';
import 'package:frontend/utils/controller_bindings.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final client = http.Client();
  final StorageService storageService = StorageService();

  Future<String> signIn(String username, String password) async {
    try {
      final uri = Uri.parse("http://10.0.2.2:9000/auth/login").replace(queryParameters: {
        "username": username,
        "password": password,
      });

      final response = await client.post(uri);

      log(response.body.toString());

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data["access_token"];
        await storageService.setToken(token);
        await getUserData(username, token);
        return token;
      } else if (data["detail"] == "User not found") {
        return "User not found";
      } else if (data["detail"] == "Invalid Password") {
        return "Invalid Password";
      } else {
        return "Unknown error";
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getUserData(String username, String token) async {
    try {
      final uri = Uri.parse("http://10.0.2.2:9000/auth/get_user").replace(queryParameters: {
        "username": username,
      });

      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log(response.body.toString());

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userId = data["id"];
        await storageService.setUserId(userId);
        return userId;
      } else {
        return "Unknown error";
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await storageService.removeToken();
      await storageService.removeUserId();
      InitialBindings().dependencies();
    } catch (error) {
      rethrow;
    }
  }
}
