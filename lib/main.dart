import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:unbroken/api/http_client.dart';
import 'package:unbroken/screens/splash.dart';
import 'package:unbroken/services/auth_service.dart';
import 'package:unbroken/services/storage_service.dart';

import 'api/api_service.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _setupLocator();
  runApp(const MyApp());
}

Future<void> _setupLocator() async {
  getIt.registerSingletonAsync<StorageService>(() async {
    final storageService = StorageService();
    await storageService.init();
    return storageService;
  });
  await getIt.isReady<StorageService>();

  getIt.registerSingleton<http.Client>(HttpClient(storageService: getIt<StorageService>()));
  getIt.registerSingleton<ApiService>( ApiService(client: getIt<http.Client>()));
  getIt.registerSingleton<AuthService>( AuthService(
      apiService: getIt<ApiService>(),
      storageService: getIt<StorageService>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Unbroken',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage());
  }
}
