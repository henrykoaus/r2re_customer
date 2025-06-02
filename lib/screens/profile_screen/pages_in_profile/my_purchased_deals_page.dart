import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/purchased_card_models/purchased_deal_card_model.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class MyPurchasedDealsPage extends StatelessWidget {
  const MyPurchasedDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내가 구매한 딜s',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<void>(
            future:
                purchasedDealsProvider.fetchPurchasedDeals(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (purchasedDealsProvider.purchasedDeals.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      '현재 소유하고 계신 \n 딜이 없습니다.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: purchasedDealsProvider.purchasedDeals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: PurchasedDealCardModel(
                            data: purchasedDealsProvider.purchasedDeals[index],
                            imageSize: 10,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
