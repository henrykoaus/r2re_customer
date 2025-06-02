import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:r2re/constants/screen_size.dart';

class BalanceCardModel extends StatelessWidget {
  final num amount;

  const BalanceCardModel({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      elevation: 0.5,
      shadowColor: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: SizedBox(
              height: size!.height / 22,
              width: size!.height / 22,
              child: Wrap(
                children: [
                  ClipOval(
                    child: Image.asset(
                        height: size!.height / 22,
                        width: size!.height / 22,
                        'assets/images/payment_logo.png'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AutoSizeText(
              '$amount원',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 10,
              maxFontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
