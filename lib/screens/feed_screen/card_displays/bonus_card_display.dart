import 'package:flutter/material.dart';
import 'package:r2re/components/card_models/bonus_card_model.dart';

class BonusCardDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const BonusCardDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? deals = data['deals'];
    List<BonusCardModel> bonusCards = [];
    if (deals != null) {
      for (var dealEntry in deals.entries) {
        if (dealEntry.value is Map) {
          Map<String, dynamic> dealData = dealEntry.value;
          if (dealData.containsKey('rate') && dealData.containsKey('qty')) {
            num rate = dealData['rate'];
            num qty = dealData['qty'];
            if (rate > 0) {
              if (qty > 0) {
                bonusCards.add(
                  BonusCardModel(
                    data: dealData,
                    rate: rate,
                  ),
                );
              }
            }
          }
        }
      }
      bonusCards.sort((a, b) => b.rate.compareTo(a.rate));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: bonusCards.isEmpty
                    ? const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            '제공하는 딜이 아직 없습니다.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bonusCards.length,
                          itemBuilder: (context, index) => bonusCards[index],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
