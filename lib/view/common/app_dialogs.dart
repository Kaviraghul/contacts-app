import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialogs extends StatefulWidget {
  String title;
  AppDialogs({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AppDialogs> createState() => _AppDialogsState();
}

class _AppDialogsState extends State<AppDialogs> {
  @override
  Widget build(BuildContext context) {
    return _getLogoutDialog(context);
  }

  _getLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                UserPreferences.setLoggedIn(false);
                context.go('/');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
