import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unbroken/models/login_response.dart';
import 'package:unbroken/models/user.dart';
import 'package:unbroken/models/workout_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = "jwtToken";
  static const String _userIdKey = "userId";
  static const String _userWorkoutTypeKey = "userWorkoutType";

  late SharedPreferencesWithCache prefsWithCache;
  late FlutterSecureStorage secureStorage;

  Future<void> init() async {
    prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions());
    secureStorage = const FlutterSecureStorage();
  }

  Future<void> saveToken(LoginResponse loginResponse) async {
    await secureStorage.write(key: _tokenKey, value: loginResponse.token);
  }

  Future<void> saveUserInfo(User user) async {
    await prefsWithCache.setInt(_userIdKey, user.id!);
    await prefsWithCache.setString(_userWorkoutTypeKey, user.workoutType.name);
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  Future<int?> getUserId() async {
    return prefsWithCache.getInt(_userIdKey);
  }

  Future<WorkoutType?> getUserWorkoutType() async {
    String? prefsUserWorkoutType =
        prefsWithCache.getString(_userWorkoutTypeKey);
    return WorkoutType.values.firstWhere(
      (e) => e.toString().split('.').last == prefsUserWorkoutType,
      orElse: () =>
          throw Exception("Invalid WorkoutType: $prefsUserWorkoutType"),
    );
  }

  Future<void> updateUserInfo(WorkoutType workoutType) async {
    WorkoutType existingWorkoutType = (await getUserWorkoutType())!;
    if (existingWorkoutType != workoutType) {
      await prefsWithCache.setString(_userWorkoutTypeKey, workoutType.name);
      print('User info udpated $existingWorkoutType, new $workoutType');
    }
  }

  Future<bool> isAuthenticated() async {
    return await getToken() != null;
  }

  Future<void> clear() async {
    await secureStorage.deleteAll();
    await prefsWithCache.clear();
  }
}
