import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

autoSizeText(String? text, double fontSize, FontWeight fontWeight, Color color) {
  AutoSizeText(
    text!,
    style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    minFontSize: 10,
    maxFontSize: 20,
    overflow: TextOverflow.ellipsis,
  );
}
