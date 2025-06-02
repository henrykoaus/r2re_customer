import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomisedButton extends StatelessWidget {
  final String title;
  final Widget pushWidget;
  final bool? rootNavigator;

  const CustomisedButton(
      {super.key,
      required this.title,
      required this.pushWidget,
      this.rootNavigator});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context,
                rootNavigator: (rootNavigator == true) ? true : false)
            .push(MaterialPageRoute(builder: (context) => pushWidget));
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 12),
      child: AutoSizeText(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        minFontSize: 10,
        maxFontSize: 26,
      ),
    );
  }
}
