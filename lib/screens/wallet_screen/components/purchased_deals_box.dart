import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/purchased_card_models/purchased_deal_card_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/wallet_screen/see_all_purchased_deals/see_all_purchased_deals.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class PurchasedDealsBox extends StatefulWidget {
  const PurchasedDealsBox({super.key});

  @override
  State<PurchasedDealsBox> createState() => _PurchasedDealsBoxState();
}

class _PurchasedDealsBoxState extends State<PurchasedDealsBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              const Icon(
                Icons.discount,
                color: Colors.pinkAccent,
              ),
              const Expanded(
                child: AutoSizeText(
                  '  내 알투레 딜s',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  minFontSize: 18,
                  maxFontSize: 24,
                  maxLines: 1,
                ),
              ),
              ExpandIcon(
                isExpanded: _isExpanded,
                onPressed: (isExpanded) {
                  setState(
                    () {
                      _isExpanded = !isExpanded;
                    },
                  );
                },
              ),
              const Expanded(
                child: SizedBox(
                  width: 20,
                ),
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Column(
            children: [
              FutureBuilder<void>(
                future: purchasedDealsProvider
                    .fetchPurchasedDeals(currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size!.height / 3.75,
                      width: size!.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (purchasedDealsProvider.purchasedDeals.isEmpty) {
                    return Container(
                      height: size!.height / 3.75,
                      width: size!.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          '현재 소유하고 계신 \n 딜이 없습니다.',
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      constraints: BoxConstraints(
                          maxHeight: size!.height / 3.75,
                          maxWidth: size!.width / 1.1),
                      child: Stack(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (purchasedDealsProvider
                                            .purchasedDeals.length <=
                                        2)
                                    ? purchasedDealsProvider
                                        .purchasedDeals.length
                                    : 2,
                                itemBuilder: (context, index) {
                                  final dealsData = purchasedDealsProvider
                                      .purchasedDeals[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                    child: PurchasedDealCardModel(
                                      data: dealsData,
                                      imageSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SeeAllPurchasedDeals()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                elevation: 10,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(24),
                              ),
                              child: const Text(
                                '전체보기',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
      ],
    );
  }
}
