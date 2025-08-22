import 'package:frontend/services/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<String> signIn({required String username, required String password}) async {
    try {
      isLoading.value = true;
      return await _authService.signIn(username, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (error) {
      rethrow;
    }
  }
}
