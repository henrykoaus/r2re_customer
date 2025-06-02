import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/components/card_models/purchased_card_models/balance_card_model.dart';

class PurchasedDealCardEachModel extends StatelessWidget {
  final Map<String, dynamic> data;
  final double imageSize;

  const PurchasedDealCardEachModel({
    super.key,
    required this.data,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final widgetSize = size!.height;

    String dateTimeNow =
        DateFormat('yy/MM/dd - HH:mm:ss').format(DateTime.now());

    Future<void> paymentRequestToOwner() async {
      final transferData = {
        "balance": data["balance"],
        "displayName": data["displayName"],
        "email": data["email"],
        "itemName": data["itemName"],
        "name": data["name"],
        "orderId": data["orderId"],
        "paidTime": data["paidTime"],
        "price": data["price"],
        "rate": data["rate"],
        "uid": data["uid"],
        "unique": data["unique"],
        "paymentRequestTime": dateTimeNow,
      };
      await FirebaseFirestore.instance
          .collection('restaurantData')
          .doc(data["unique"])
          .collection('paymentRequest')
          .doc(data["orderId"])
          .set(transferData);
    }

    Future<void> paymentRequestInWallet() async {
      final storedData = {
        "itemName": data["itemName"],
        "name": data["name"],
        "orderId": data["orderId"],
        "price": data["price"],
        "rate": data["rate"],
        "uid": data["uid"],
        "unique": data["unique"],
      };
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(data["uid"])
          .collection('paymentRequest')
          .doc(data["orderId"])
          .set(storedData);
    }

    final restaurantDataCollection =
        FirebaseFirestore.instance.collection('restaurantData');

    String? image;

    Future<void> fetchImage() async {
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

    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            title: const Text(
              '\n해당 딜을 사용해\n가게와 계산하시겠습니까?\n ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            actions: [
              Center(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await paymentRequestToOwner();
                        await paymentRequestInWallet();
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (context.mounted) {
                            Navigator.pushNamed(context, '/home');
                            generalDialog(context,
                                '가게 결제가 완료되면\n계산된 금액이 차감됩니다\n\n거래요청 취소를 원할시\nR페이에서 취소가능합니다');
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.pinkAccent,
                      ),
                      child: const Text(
                        '계산요청',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      child: Stack(
        children: [
          SizedBox(
            height: widgetSize / 8,
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fetchImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: widgetSize / imageSize,
                            width: widgetSize / imageSize,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/basic_photo.png"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          );
                        } else {
                          return Container(
                            height: widgetSize / imageSize,
                            width: widgetSize / imageSize,
                            decoration: BoxDecoration(
                              image: (image != null)
                                  ? DecorationImage(
                                      image: NetworkImage(image!),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/basic_photo.png"),
                                      fit: BoxFit.fill,
                                    ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: AutoSizeText(
                                data["name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: 18,
                                maxFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              '${data["rate"]}% 딜',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold),
                              minFontSize: 12,
                              maxFontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: widgetSize / 9,
                      width: widgetSize / 9,
                      child: BalanceCardModel(
                        amount: data["balance"],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.discount,
                color: Colors.purple,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
