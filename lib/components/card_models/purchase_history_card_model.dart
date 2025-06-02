import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/screen_size.dart';

class PurchaseHistoryCardModel extends StatelessWidget {
  final Map<String, dynamic> data;
  final double imageSize;
  final bool isJustPurchasedDeals;

  const PurchaseHistoryCardModel({
    super.key,
    required this.data,
    required this.imageSize,
    required this.isJustPurchasedDeals,
  });

  @override
  Widget build(BuildContext context) {
    final widgetSize = size!.height;
    final currentUser = FirebaseAuth.instance.currentUser;
    final restaurantDataCollection =
        FirebaseFirestore.instance.collection('restaurantData');
    final combinedDealDataCollection =
        FirebaseFirestore.instance.collection('combinedDeals');
    String? image;
    String? combinedDealImage;

    Future<void> deleteDocument() async {
      try {
        if (isJustPurchasedDeals == true) {
          await FirebaseFirestore.instance
              .collection('userData')
              .doc(currentUser!.uid)
              .collection("transactionHistory")
              .doc("purchasedDeals")
              .collection('subCollection')
              .doc(data["orderId"])
              .delete();
        } else {
          await FirebaseFirestore.instance
              .collection('userData')
              .doc(currentUser!.uid)
              .collection("transactionHistory")
              .doc("purchasedCombinedDeals")
              .collection('subCollection')
              .doc(data["orderId"])
              .delete();
        }
      } catch (e) {
        return;
      }
    }

    Future<void> fetchDealImage() async {
      final docRef = restaurantDataCollection.doc(data["unique"]);
      docRef.snapshots().listen(
        (docSnapshot) {
          if (docSnapshot.exists) {
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;
            image = data['image'];
          }
        },
      );
    }

    Future<void> fetchCombinedDealImage() async {
      final docRef = combinedDealDataCollection.doc(data["unique"]);
      docRef.snapshots().listen(
        (docSnapshot) {
          if (docSnapshot.exists) {
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;
            combinedDealImage = data['image'];
          }
        },
      );
    }

    return SizedBox(
      height: widgetSize / 8,
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (isJustPurchasedDeals == true)
                      ? FutureBuilder(
                          future: fetchDealImage(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Container(
                                height: widgetSize / imageSize,
                                width: widgetSize / imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: widgetSize / imageSize,
                                width: widgetSize / imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              return (image != null)
                                  ? Container(
                                      height: widgetSize / imageSize,
                                      width: widgetSize / imageSize,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(image!),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    )
                                  : const Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                      : FutureBuilder(
                          future: fetchCombinedDealImage(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Container(
                                height: widgetSize / imageSize,
                                width: widgetSize / imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: widgetSize / imageSize,
                                width: widgetSize / imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              return (combinedDealImage != null)
                                  ? Container(
                                      height: widgetSize / imageSize,
                                      width: widgetSize / imageSize,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(combinedDealImage!),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    )
                                  : const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${data["paidTime"]}',
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.end,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: '${data["name"]} \n',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${data["rate"]}% 딜',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  minFontSize: 10,
                                  maxFontSize: 22,
                                  maxLines: 2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: '결제금액\n',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.purple),
                                    children: [
                                      TextSpan(
                                        text: '${data["price"]}원',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  minFontSize: 10,
                                  maxFontSize: 22,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -5,
            bottom: -5,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    title: const Text(
                      ' \n 거래내역을 삭제하시겠습니? \n',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    actions: [
                      Wrap(
                        children: [
                          TextButton(
                            onPressed: () async {
                              dialogIndicator(context);
                              await deleteDocument();
                              if (context.mounted) {
                                Navigator.pop(context);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.pinkAccent,
                            ),
                            child: const Text(
                              '삭제',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.pinkAccent,
                            ),
                            child: const Text(
                              '취소',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
