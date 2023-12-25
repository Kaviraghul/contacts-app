import 'package:flutter/material.dart';

abstract class AbstractAppBottomSheets {
  void addNewBirthday(BuildContext context) {}
}

class AppBottomSheets extends AbstractAppBottomSheets {
  @override
  void addNewBirthday(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(color: Colors.yellow),
        );
      },
    );
  }
}
