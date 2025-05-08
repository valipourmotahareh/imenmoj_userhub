import 'package:appwrite/appwrite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:imenmoj_userhub/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:imenmoj_userhub/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:imenmoj_userhub/features/auth/domain/repositories/auth_repository.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:imenmoj_userhub/features/user/data/data_sources/user_local_datasource.dart';
import 'package:imenmoj_userhub/features/user/data/data_sources/user_remote_datasource.dart';
import 'package:imenmoj_userhub/features/user/data/repositories/user_repository_impl.dart';
import 'package:imenmoj_userhub/features/user/domain/repositories/user_repository.dart';
import 'package:imenmoj_userhub/features/user/domain/usecases/get_users_usecase.dart';
import 'package:imenmoj_userhub/features/user/presentation/bloc/user_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
    /// Core
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());

    getIt.registerLazySingleton<Client>(() => Client()
        ..setEndpoint('https://fra.cloud.appwrite.io/v1')
        ..setProject('68190d20000af55a9c7f'));

    /// DataSources
    getIt.registerLazySingleton<AuthRemoteDataSourceImpl>(
            () => AuthRemoteDataSourceImpl(getIt<Client>()),
    );

    getIt.registerLazySingleton<UserRemoteDataSource>(
            () => UserRemoteDataSource(
            client: getIt<Client>(),
            databaseId: '681a435200337485b362',
            collectionId: '681a4367001c06b230aa',
        ),
    );

    getIt.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSource());

    /// Repositories
    getIt.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImpl(getIt<AuthRemoteDataSourceImpl>()),
    );

    getIt.registerLazySingleton<UserRepository>(
            () => UserRepositoryImpl(
            remoteDataSource: getIt<UserRemoteDataSource>(),
            localDataSource: getIt<UserLocalDataSource>(),
        ),
    );

    /// UseCases
    getIt.registerLazySingleton<GetUsersUseCase>(
            () => GetUsersUseCase(getIt<UserRepository>()),
    );

    /// Blocs
    getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
    getIt.registerFactory<UserBloc>(() => UserBloc(
        getIt<UserRepository>(),
        getIt<FlutterLocalNotificationsPlugin>(),
    ));

    /// Notifications
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
            () => flutterLocalNotificationsPlugin,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
