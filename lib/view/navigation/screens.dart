import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/screens/authentication/login/login_view.dart';
import 'package:contacts_app/view/screens/authentication/register/register_view.dart';
import 'package:contacts_app/view/screens/contacts/contacts_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Screens extends StatelessWidget {
  Screens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'yellow school',
    );
  }

  final GoRouter _router =
      GoRouter(initialLocation: _getInitialRoute(), routes: <GoRoute>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginView()),
    GoRoute(
        path: '/userRegister',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterView()),
    GoRoute(
        path: '/contactsScreen',
        builder: (BuildContext context, GoRouterState state) =>
            const ContactsView())
  ]);
}

String _getInitialRoute() {
  print('csk will win');
  if (UserPreferences.isLoggedIn()) {
    return '/contactsScreen';
  } else {
    return '/';
  }
}
