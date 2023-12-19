import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/screens/authentication/login/login_view.dart';
import 'package:contacts_app/view/screens/authentication/register/register_view.dart';
import 'package:contacts_app/view/screens/contacts/contacts_view.dart';
import 'package:contacts_app/view/screens/on_boarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutesManager {
  GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),
    routes: <GoRoute>[
      GoRoute(
          path: '/onboardingScreen',
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingScreen()),
      GoRoute(
          path: '/loginScreen',
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
    ],
  );
}

String _getInitialRoute() {
  if (UserPreferences.isLoggedIn()) {
    return '/contactsScreen';
  } else if (UserPreferences.getIsUserOnboarded()) {
    return '/onboardingScreen';
  } else {
    return '/onboardingScreen';
  }
}
