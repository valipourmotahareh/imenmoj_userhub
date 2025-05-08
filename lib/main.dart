import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imenmoj_userhub/config/router/app_router.dart';
import 'package:imenmoj_userhub/core/appwrite/appwrite_client.dart';
import 'package:imenmoj_userhub/core/di/injection.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:imenmoj_userhub/features/user/data/models/user_model.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_bloc.dart';

import 'config/app_config.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  /// Initialize essential services
  await FlutterDownloader.initialize(debug: true);
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');

  /// Initialize Appwrite client
  await AppwriteInitializer.init();

  /// Set up dependency injection (GetIt)
  setupLocator();

  /// Set up notification plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'user_notifications_channel',
    'User Related Notifications',
    description: 'Notifications for user actions and updates',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Run the app
  runApp(EasyLocalization(
      startLocale: AppConfig.startLocale,
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.langPath,
      useOnlyLangCode: true,
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => getIt<UserBloc>(),
        ),
      ],
      child: MaterialApp.router(
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Imen Moj Task',
        theme: ThemeData(primarySwatch: Colors.blue),
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
