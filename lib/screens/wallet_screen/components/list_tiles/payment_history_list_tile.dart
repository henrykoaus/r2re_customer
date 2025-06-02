import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';

class PaymentHistoryListTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const PaymentHistoryListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    Future<void> deleteDocument() async {
      try {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(currentUser!.uid)
            .collection("paymentHistory")
            .doc("purchasedDeals")
            .collection('subCollection')
            .doc('${data["orderId"]}+${data["inputAmount"]}+${data["balance"]}')
            .delete();
      } catch (e) {
        return;
      }
    }

    return ListTile(
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '거래음식점: ',
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: data['name'],
                  style: const TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '거래품명: ',
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: data['itemName'],
                  style: const TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '거래요청일시: ',
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: data['paymentRequestTime'],
                  style: const TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '거래금액: ',
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: '${data['inputAmount']}원',
                  style: const TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 50,
        child: IconButton(
          onPressed: () async {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                scrollable: true,
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
