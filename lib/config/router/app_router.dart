import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imenmoj_userhub/config/router/routes.dart';
import 'package:imenmoj_userhub/features/auth/presentation/screens/auth_screen.dart';
import 'package:imenmoj_userhub/features/user/presentation/screens/user_list_screen.dart';

import '../../features/user/data/models/user_model.dart';
import '../../features/user/presentation/screens/user_form_screen.dart';

class AppRouter {
  late GoRouter router = GoRouter(
    debugLogDiagnostics: false,
    initialLocation: Routes.authScreen,
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      child: Container(),
    ),
    routes: [
      _route(
        name: Routes.authScreen,
        path: Routes.authScreen,
        pageBuilder: (state) => const AuthScreen(),
      ),
      _route(
        name: Routes.userFormScreen,
        path: Routes.userFormScreen,
        pageBuilder: (state) {
          final user = state.extra as UserModel?;
          return UserFormScreen(user: user);
        },
      ),
      _route(
        name: Routes.userListScreen,
        path: Routes.userListScreen,
        pageBuilder: (state) => const UserListScreen(),
      ),
    ],
  );

  GoRoute _route({
    required String name,
    required String path,
    required Widget Function(GoRouterState state) pageBuilder,
    List<GoRoute> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: name,
        routes: routes,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: pageBuilder(state),
          key: state.pageKey,
          restorationId: state.pageKey.value,
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );

}

