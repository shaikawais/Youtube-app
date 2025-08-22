import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future setToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } on Exception catch (e) {
      log("Error setting token:$e");
    }
  }

  Future removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } on Exception catch (e) {
      log("Error removing token:$e");
    }
  }

  Future<String?> getToken() async {
    String? token;
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.containsKey('token') ? token = prefs.getString('token') : null;

      return token;
    } catch (e) {
      token = null;
      log("Error fetching token: $e");
    }
    return token;
  }

  Future setUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
    } on Exception catch (e) {
      log("Error setting token:$e");
    }
  }

  Future removeUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
    } on Exception catch (e) {
      log("Error removing token:$e");
    }
  }

  Future<String?> getId() async {
    String? id;
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.containsKey('userId') ? id = prefs.getString('userId') : null;
      return id;
    } catch (e) {
      id = null;
      log('Error Fetching User Id: $e');
    }
    return null;
  }
}
