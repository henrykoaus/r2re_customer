import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/purchased_card_models/purchased_deal_card_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/search_bar_page.dart';
import 'package:r2re/screens/payment_screen/payment_request_widget.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return Column(
      children: [
        FutureBuilder<void>(
          future: purchasedDealsProvider.fetchPurchasedDeals(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (purchasedDealsProvider.purchasedDeals.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    '구매하신 딜이 없습니다',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            } else {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: (purchasedDealsProvider.purchasedDeals.length >= 3)
                      ? size!.height / 2.6
                      : (purchasedDealsProvider.purchasedDeals.length == 2)
                          ? size!.height / 4
                          : size!.height / 7,
                ),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: purchasedDealsProvider.purchasedDeals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: PurchasedDealCardModel(
                              data:
                                  purchasedDealsProvider.purchasedDeals[index],
                              imageSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          indent: 10,
          endIndent: 10,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            const PaymentRequestWidget(),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '더 나은 딜을 제공하는 음식점을 찾아보세요',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchBarScreen()),
                );
              },
              child: const Text(
                '👉딜 찾으러 가기',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
