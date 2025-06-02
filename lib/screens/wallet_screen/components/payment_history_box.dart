import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/screens/wallet_screen/components/list_tiles/payment_history_list_tile.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/wallet_screen/see_all_purchased_deals/see_all_payment_history.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class PaymentHistoryBox extends StatefulWidget {
  const PaymentHistoryBox({super.key});

  @override
  State<PaymentHistoryBox> createState() => _PaymentHistoryBoxState();
}

class _PaymentHistoryBoxState extends State<PaymentHistoryBox> {
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
                Icons.payments,
                color: Colors.pinkAccent,
              ),
              const Expanded(
                child: AutoSizeText(
                  '  내 R페이 내역',
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
                    .fetchDealsPaymentHistory(currentUser!.uid),
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
                  } else if (purchasedDealsProvider
                      .dealsPaymentHistory.isEmpty) {
                    return Container(
                      height: size!.height / 3.75,
                      width: size!.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'R페이 거래내역이 없습니다.',
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
                                            .dealsPaymentHistory.length <=
                                        3)
                                    ? purchasedDealsProvider
                                        .dealsPaymentHistory.length
                                    : 3,
                                itemBuilder: (context, index) {
                                  final dealsData = purchasedDealsProvider
                                      .dealsPaymentHistory[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                    child: PaymentHistoryListTile(
                                      data: dealsData,
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
                                          const SeeAllPaymentHistory()),
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
