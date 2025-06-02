import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';

class PaymentRequestCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const PaymentRequestCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDataCollection =
        FirebaseFirestore.instance.collection('userData');
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

    Future<void> cancelRequest() async {
      await restaurantDataCollection
          .doc(data["unique"])
          .collection('paymentRequest')
          .doc(data["orderId"])
          .delete();
      await userDataCollection
          .doc(currentUser!.uid)
          .collection('paymentRequest')
          .doc(data["orderId"])
          .delete();
    }

    return SizedBox(
      height: 100,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              FutureBuilder(
                future: fetchImage(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/images/basic_photo.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    );
                  } else {
                    return Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: (image != null)
                            ? DecorationImage(
                                image: NetworkImage(image!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image:
                                    AssetImage("assets/images/basic_photo.png"),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 14,
                          maxFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        data["itemName"],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        minFontSize: 10,
                        maxFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
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
                        '\n계산요청을 취소하시겠습니까?\n ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      actions: [
                        Center(
                          child: Wrap(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  cancelRequest();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    if (context.mounted) {
                                      Navigator.pushNamed(context, '/home');
                                      generalDialog(context, '계산요청이 취소되었습니다');
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  elevation: 3,
                                  backgroundColor: Colors.pinkAccent,
                                ),
                                child: const Text(
                                  '계산취소',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                                  '닫기',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  surfaceTintColor: Colors.pinkAccent,
                  elevation: 3,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '취소',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
