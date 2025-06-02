import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentRequestProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _paymentRequest = [];
  List<Map<String, dynamic>> get paymentRequest => _paymentRequest;
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  Future<void> fetchPaymentRequest(String userUid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> paymentRequestSnapshot =
          await userDataCollection
              .doc(userUid)
              .collection("paymentRequest")
              .get();
      final docs = paymentRequestSnapshot.docs;
      final paymentRequestDocsData = docs.map((doc) => doc.data()).toList();
      _paymentRequest = paymentRequestDocsData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
