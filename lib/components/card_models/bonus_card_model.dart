import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BonusCardModel extends StatelessWidget {
  final Map<String, dynamic> data;
  final num rate;

  const BonusCardModel({
    super.key,
    required this.data,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 60,
          width: 90,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 1,
                child: SizedBox(
                  height: 40,
                  width: 70,
                  child: Center(
                    child: AutoSizeText(
                      '$rate%딜',
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      minFontSize: 10,
                      maxFontSize: 22,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Icon(
            Icons.discount,
            color: Colors.purple,
            size: 20,
          ),
        ),
      ],
    );
  }
}
