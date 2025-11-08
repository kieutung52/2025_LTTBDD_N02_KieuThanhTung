import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_flutter/core/services/seeding_service.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/services/api_client.dart';
import 'core/services/auth_service.dart';
import 'core/services/dictionary_service.dart';
import 'core/services/exercise_service.dart';
import 'core/services/learning_service.dart';
import 'core/services/user_service.dart';
import 'core/state/auth_provider.dart';
import 'core/state/learning_provider.dart';
import 'core/state/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  const storage = FlutterSecureStorage();
  final dio = Dio();
  final apiClient = ApiClient(dio, storage);

  final authService = AuthService(apiClient, storage);
  final userService = UserService(apiClient);
  final learningService = LearningService(apiClient);
  final dictionaryService = DictionaryService(apiClient);
  final exerciseService = ExerciseService(apiClient);
  final seedingService = SeedingService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        // --- Services ---
        Provider<AuthService>(create: (_) => authService),
        Provider<UserService>(create: (_) => userService),
        Provider<LearningService>(create: (_) => learningService),
        Provider<DictionaryService>(create: (_) => dictionaryService),
        Provider<ExerciseService>(create: (_) => exerciseService),
        Provider<SeedingService>(create: (_) => seedingService),

        // --- State Providers ---
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider<LearningProvider>(
          create: (_) => LearningProvider(), 
        ),
        ChangeNotifierProxyProvider<LearningProvider, AuthProvider>(
          create: (context) => AuthProvider(
            authService,
            userService,
            storage,
            Provider.of<LearningProvider>(context, listen: false),
          ),
          update: (_, learningProvider, authProvider) {
            authProvider!.learningProvider = learningProvider;
            return authProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}