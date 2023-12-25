import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/screens/add_new_birthday/add_new_birthday.dart';
import 'package:contacts_app/view/screens/authentication/login/login_view.dart';
import 'package:contacts_app/view/screens/authentication/register/register_view.dart';
import 'package:contacts_app/view/screens/contacts/contacts_view.dart';
import 'package:contacts_app/view/screens/home/home.dart';
import 'package:contacts_app/view/screens/on_boarding_screen/onboarding_screen.dart';
import 'package:contacts_app/view/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNamesAndPath {
  // routes nam
  static String onboadingScreenName = 'onboarding';
  static String loginScreenName = 'login';
  static String userRegisterName = 'register';
  static String homeScreenName = 'home';
  static String contactsScreenName = 'contacts';
  static String profileScreenName = 'profile';
  static String addNewBirthdayScreenName = 'addNewBirthday';

  // routes path
  static String onboadingScreenPath = '/onboarding';
  static String loginScreenPath = '/login';
  static String userRegisterPath = '/userRegister';
  static String homeScreenPath = '/';
  static String contactsScreenPath = '/contacts';
  static String profileScreenPath = '/profile';
  static String addNewBirthdayScreenPath = '/addNewBirthday';
}

class RoutesManager {
  GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        name: RouteNamesAndPath.onboadingScreenName,
        path: RouteNamesAndPath.onboadingScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: OnboardingScreen());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.loginScreenName,
        path: RouteNamesAndPath.loginScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: LoginView());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.userRegisterName,
        path: RouteNamesAndPath.userRegisterPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: RegisterView());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.contactsScreenName,
        path: RouteNamesAndPath.contactsScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: ContactsView());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.homeScreenName,
        path: RouteNamesAndPath.homeScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.addNewBirthdayScreenName,
        path: RouteNamesAndPath.addNewBirthdayScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: AddNewBirthdayScreen());
        },
      ),
      GoRoute(
        name: RouteNamesAndPath.profileScreenName,
        path: RouteNamesAndPath.profileScreenPath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: ProfileScreen());
        },
      )
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(state.error.toString()),
        ),
      ),
    ),
    redirect: (context, state) {
      if (UserPreferences.isLoggedIn()) {
        return null;
      } else if (UserPreferences.getIsUserOnboarded()) {
        return context.namedLocation(RouteNamesAndPath.loginScreenName);
      } else {
        return context.namedLocation(RouteNamesAndPath.onboadingScreenName);
      }
    },
  );
}

String _getInitialRoute() {
  if (UserPreferences.isLoggedIn()) {
    return RouteNamesAndPath.homeScreenPath;
  } else if (UserPreferences.getIsUserOnboarded()) {
    return RouteNamesAndPath.loginScreenPath;
  } else {
    return RouteNamesAndPath.onboadingScreenPath;
  }
}

GoRouter appRouter = RoutesManager().router;
