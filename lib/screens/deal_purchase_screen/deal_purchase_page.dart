import 'package:flutter/material.dart';
import 'package:r2re/screens/deal_purchase_screen/deal_purchase_card.dart';

class DealPurchasePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DealPurchasePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? deals = data['deals'];
    List<DealPurchaseCard> dealPurchaseCards = [];
    if (deals != null) {
      for (var dealEntry in deals.entries) {
        if (dealEntry.value is Map) {
          Map<String, dynamic> dealData = dealEntry.value;
          if (dealData.containsKey('rate') &&
              dealData.containsKey('price') &&
              dealData.containsKey('itemName') &&
              dealData.containsKey('qty')) {
            num rate = dealData['rate'];
            num price = dealData['price'];
            String itemName = dealData['itemName'];
            num qty = dealData['qty'];
            if (rate > 0) {
              if (qty > 0) {
                dealPurchaseCards.add(
                  DealPurchaseCard(
                    data: data,
                    rate: rate,
                    itemName: itemName,
                    price: price,
                    paymentAmount: price + price * 100 ~/ 100,
                    qty: qty,
                  ),
                );
              }
            }
          }
        }
      }
      dealPurchaseCards.sort((a, b) => b.rate.compareTo(a.rate));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${data["name"]}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: dealPurchaseCards.isEmpty
                    ? const Center(
                        child: Text(
                          '제공하는 딜이 아직 없습니다.',
                          style: TextStyle(fontSize: 22),
                        ),
                      )
                    : ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: dealPurchaseCards.length,
                        itemBuilder: (context, index) =>
                            dealPurchaseCards[index],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
