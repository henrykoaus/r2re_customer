import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RepMenuCardModel extends StatelessWidget {
  final String image;
  final String menuName;

  const RepMenuCardModel({
    super.key,
    required this.image,
    required this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 130,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              child: Image(
                height: 80,
                fit: BoxFit.fill,
                image: NetworkImage(image),
              ),
            ),
            Expanded(
              child: Center(
                child: AutoSizeText(
                  menuName,
                  style: const TextStyle(fontSize: 16),
                  minFontSize: 10,
                  maxFontSize: 22,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
