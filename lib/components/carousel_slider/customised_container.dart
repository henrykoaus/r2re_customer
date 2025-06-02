import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:r2re/constants/screen_size.dart';

class CustomisedContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Widget? widget;
  final double titleSize;
  final double subtitleSize;

  const CustomisedContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.titleSize,
    required this.subtitleSize,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> columnItems = [
      Expanded(
        child: AutoSizeText(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          minFontSize: 16,
          maxFontSize: 28,
          maxLines: 3,
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Expanded(
        child: AutoSizeText(
          subtitle,
          style: TextStyle(fontSize: subtitleSize, color: Colors.white),
          minFontSize: 14,
          maxFontSize: 28,
          maxLines: 3,
        ),
      ),
    ];

    if (widget != null) {
      columnItems.add(widget!);
    }

    return Container(
      width: size!.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnItems,
        ),
      ),
    );
  }
}
