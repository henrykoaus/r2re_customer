import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessInfoProvider extends ChangeNotifier {
  String? address;
  String? digitalSaleNo;
  String? name;
  String? ownerName;
  String? registration;
  String? telephone;

  Future<void> fetchBusinessInfo() async {
    final docRef =
    FirebaseFirestore.instance.collection('businessInfo').doc('r2re');
    docRef.snapshots().listen(
          (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          address = data['address'];
          digitalSaleNo = data['digitalSaleNo'];
          name = data['name'];
          ownerName = data['ownerName'];
          registration = data['registration'];
          telephone = data['telephone'];
        }
      },
    );
  }
}
