import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/screens/wallet_screen/components/list_tiles/purchase_history_list_tile.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class SeeAllPurchaseHistory extends StatelessWidget {
  const SeeAllPurchaseHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider = Provider.of<PurchasedDealsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 딜구매 내역',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: purchasedDealsProvider
                .fetchDealsPurchaseHistory(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (purchasedDealsProvider.dealsPurchaseHistory.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      '구매내역이 없습니다.',
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
                      itemCount:
                          purchasedDealsProvider.dealsPurchaseHistory.length,
                      itemBuilder: (context, index) {
                        final transactionHistoryData =
                            purchasedDealsProvider.dealsPurchaseHistory[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: PurchaseHistoryListTile(
                            data: transactionHistoryData,
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
