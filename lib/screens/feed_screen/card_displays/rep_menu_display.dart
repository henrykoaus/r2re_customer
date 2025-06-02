import 'package:flutter/material.dart';
import 'package:r2re/components/card_models/rep_menu_card_model.dart';

class RepMenuDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const RepMenuDisplay({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? repMenu = data['repMenu'];
    List<RepMenuCardModel> menuCards = [];
    if (repMenu != null) {
      for (var dealEntry in repMenu.entries) {
        if (dealEntry.value is Map) {
          Map<String, dynamic> dealData = dealEntry.value;
          if (dealData.containsKey('menuName') &&
              dealData.containsKey('menuImage')) {
            String menuName = dealData['menuName'];
            String menuImage = dealData['menuImage'];
            menuCards.add(
              RepMenuCardModel(
                menuName: menuName,
                image: menuImage,
              ),
            );
          }
        }
      }
    }

    return SizedBox(
      height: 130,
      child: menuCards.isEmpty
          ? const Center(
              child: Text(
                '등록된 대표메뉴가 아직 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: menuCards.length,
              itemBuilder: (context, index) => menuCards[index],
            ),
    );
  }
}
