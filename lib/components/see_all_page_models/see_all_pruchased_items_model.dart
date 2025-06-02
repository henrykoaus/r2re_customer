import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/purchased_card_models/purchased_deal_card_each_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class SeeAllPurchasedItemsModel extends StatelessWidget {
  final String unique;
  final String title;

  const SeeAllPurchasedItemsModel({
    super.key,
    required this.unique,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder<void>(
        future: purchasedDealsProvider.fetchEachPurchasedDeal(
            currentUser!.uid, unique),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CircularProgressIndicator()));
          } else if (purchasedDealsProvider.eachPurchasedDeal.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: const Center(
                child: Text(
                  '구매하신 딜이 없습니다.',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            );
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("내 $title 딜s"),
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: size!.width / 1.8,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            AutoSizeText(
                              "$title  👉 ",
                              style: const TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              maxFontSize: 18,
                              minFontSize: 12,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final restaurantData = await FirebaseFirestore
                                .instance
                                .collection('restaurantData')
                                .doc(unique)
                                .get()
                                .then((doc) =>
                                    doc.data() as Map<String, dynamic>);
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => RestaurantPage(
                                            data: restaurantData,
                                          )));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            '상세정보',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: purchasedDealsProvider.eachPurchasedDeal.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data =
                          purchasedDealsProvider.eachPurchasedDeal[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: PurchasedDealCardEachModel(
                          data: data,
                          imageSize: 10,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
