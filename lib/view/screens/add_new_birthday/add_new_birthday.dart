import 'package:flutter/material.dart';

class AddNewBirthdayScreen extends StatefulWidget {
  const AddNewBirthdayScreen({Key? key}) : super(key: key);

  @override
  _AddNewBirthdayScreenState createState() => _AddNewBirthdayScreenState();
}

class _AddNewBirthdayScreenState extends State<AddNewBirthdayScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: "Name",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
