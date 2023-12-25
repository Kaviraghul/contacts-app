import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/resources/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final VoidCallback onAddPressed;

  const MyBottomNavigationBar({Key? key, required this.onAddPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: AppStrings.add,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: AppStrings.logout,
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        if (index == 1) {
          onAddPressed();
        } else if (index == 2) {
          UserPreferences.setLoggedIn(false);
          UserPreferences.setUserId('');
          context.go('/');
          // print(UserPreferences.getUserId());
        }
      },
    );
  }
}
