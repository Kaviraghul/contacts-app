import 'package:contacts_app/view/resources/size_config.dart';
import 'package:flutter/material.dart';

class AppButtons {
  get context => null;

  double width = SizeConfig.screenW!;
  double height = SizeConfig.screenH!;

  Widget startButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () {
          onPressed.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: (width <= 550)
              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
              : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
          textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
        ),
        child: Text(text),
      ),
    );
  }

  Widget textButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: () {
        onPressed.call();
      },
      style: TextButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: (width <= 550) ? 13 : 17,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
