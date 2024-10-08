import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/models/authenticate_request.dart';
import 'package:unbroken/models/login_response.dart';
import 'package:unbroken/models/user.dart';
import 'package:unbroken/services/storage_service.dart';

class AuthService {
  // TODO check how to make private properties
  final ApiService apiService;
  final StorageService storageService;

  AuthService({required this.apiService, required this.storageService});

  Future<void> login(String email, String password) async {
    final response = await apiService.post(ApiEndpoints.login,
        body: AuthenticateRequest(email, password).toJson());

    LoginResponse loginResponse = LoginResponse.fromJson(response);
    await storageService.saveToken(loginResponse);
    await getAccountAndSaveToStorage();
  }

  Future<void> getAccountAndSaveToStorage() async {
    User user = await getAccount();
    await storageService.saveUserInfo(user);
  }

  Future<User> getAccount() async {
    final response = await apiService.get(ApiEndpoints.account);
    return User.fromJson(response);
  }

  Future<void> logout() async {
    await storageService.clear();
  }

  Future<bool> isAuthenticated() async {
    return await storageService.getToken() != null;
  }
}
