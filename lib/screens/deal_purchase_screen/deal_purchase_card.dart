import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/state_management/bootpay_request_provider.dart';

class DealPurchaseCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final num rate;
  final String itemName;
  final num price;
  final num paymentAmount;
  final num qty;

  const DealPurchaseCard(
      {super.key,
      required this.data,
      required this.rate,
      required this.itemName,
      required this.price,
      required this.paymentAmount,
      required this.qty});

  @override
  Widget build(BuildContext context) {
    final bootPayRequestProvider = Provider.of<BootPayRequestProvider>(context);
    Future<String?> getEmail() async {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('userData')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (userDoc.exists) {
          return userDoc.get('email') as String?;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }

    return GestureDetector(
      onTap: () async {
        String? userEmail = await getEmail();
        if (userEmail != null) {
          if (context.mounted) {
            await bootPayRequestProvider.bootPayRequest(
              context: context,
              name: data["name"],
              rate: rate,
              itemName: itemName,
              price: price,
              restaurantGeoPoint: data["geo"],
              paymentAmount: paymentAmount,
              unique: data['unique'],
              qty: qty,
              userEmail: userEmail,
            );
          }
        } else {
          if (context.mounted) {
            generalDialog(
                context, '계정에 이메일주소가\n등록되지 않았습니다\n\n이메일주소가 없을시\n결제가 불가능합니다');
          }
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Stack(
            children: [
              SizedBox(
                height: size!.height / 7,
                width: size!.width / 1,
                child: Center(
                  child: Wrap(
                    children: [
                      SizedBox(
                        height: size!.height / 7,
                        width: size!.width / 1.2,
                        child: Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: size!.height / 9,
                                  width: size!.height / 9,
                                  child: Card(
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    shape: const CircleBorder(),
                                    shadowColor: Colors.purple,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AutoSizeText(
                                              '구매',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              minFontSize: 10,
                                              maxFontSize: 22,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          '$price원',
                                          style: const TextStyle(
                                              color: Colors.purple,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          minFontSize: 10,
                                          maxFontSize: 22,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Card(
                                  margin: const EdgeInsets.all(2),
                                  shape: const CircleBorder(),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/payment_logo.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: size!.height / 9,
                                  width: size!.height / 9,
                                  child: Card(
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    shape: const CircleBorder(),
                                    shadowColor: Colors.pink,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AutoSizeText(
                                              '보너스',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              minFontSize: 10,
                                              maxFontSize: 22,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          '${price * rate ~/ 100}원',
                                          style: const TextStyle(
                                              color: Colors.pink,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          minFontSize: 10,
                                          maxFontSize: 22,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 60,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              height: 30,
                              width: 60,
                              child: Center(
                                child: AutoSizeText(
                                  '$rate%딜',
                                  style: const TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  minFontSize: 10,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.discount,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
