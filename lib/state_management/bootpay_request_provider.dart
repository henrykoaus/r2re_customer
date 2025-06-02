import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/env/env.dart';

class BootPayRequestProvider extends ChangeNotifier {
  Payload payload = Payload();
  final web = Env.bootpay_web;
  final android = Env.bootpay_android;
  final ios = Env.bootpay_ios;

  String get applicationId {
    return Bootpay().applicationId(web, android, ios);
  }

  Future<void> bootPayRequest({
    required BuildContext context,
    required String name,
    required num rate,
    required String itemName,
    required num price,
    GeoPoint? restaurantGeoPoint,
    required num paymentAmount,
    required String unique,
    required num qty,
    String? userEmail,
  }) async {
    payload.androidApplicationId = android;
    payload.iosApplicationId = ios;

    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    final CollectionReference userDataCollection =
        FirebaseFirestore.instance.collection('userData');
    final CollectionReference restaurantDataCollection =
        FirebaseFirestore.instance.collection('restaurantData');
    String dateTimeNow = DateFormat('yy/MM/dd - HH:mm').format(DateTime.now());
    final percentageKey = '$rate%';
    const quantityChange = -1;

    payload.pg = 'nicepay';
    payload.methods = [
      'bank',
      'vbank',
      'payco',
      'kakao',
      'npay',
      'card',
      'phone'
    ];
    payload.orderName = itemName;
    payload.price = price.toDouble();
    payload.orderId =
        '$unique${DateTime.now().microsecondsSinceEpoch.toString()}';

    User user = User();
    user.username = firebaseUser!.displayName;
    user.email = firebaseUser.email ?? userEmail;

    Extra extra = Extra();
    extra.appScheme = 'com.r2rekorea.r2reapp';
    extra.cardQuota = '3';
    extra.sellerName = name;
    extra.openType = "popup";
    // extra.displaySuccessResult = true;
    // extra.displayErrorResult = true;

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    payload.extra?.openType = "popup";

    Item item = Item();
    item.name = itemName;
    item.qty = 1;
    item.id = itemName;
    item.price = price.toDouble();

    payload.user = user;
    payload.extra = extra;

    String? orderId = payload.orderId;

    Future<void> purchasedDeals() async {
      final setData = {
        "name": name,
        "unique": unique,
        "geo": restaurantGeoPoint,
      };

      final transactionData = {
        "name": name,
        "rate": rate,
        "itemName": itemName,
        "price": price,
        "unique": unique,
        "orderId": orderId,
        "paidTime": dateTimeNow,
        "balance": price + price * rate ~/ 100,
        "displayName": firebaseUser.displayName ?? '',
        "email": firebaseUser.email ?? userEmail ?? '',
        "uid": firebaseUser.uid,
      };

      final salesHistoryData = {
        "name": name,
        "rate": rate,
        "itemName": itemName,
        "price": price,
        "unique": unique,
        "orderId": orderId,
        "paidTime": dateTimeNow,
        "displayName": firebaseUser.displayName ?? '',
        "email": firebaseUser.email ?? userEmail ?? '',
        "uid": firebaseUser.uid,
      };

      await userDataCollection
          .doc(firebaseUser.uid)
          .collection('purchasedDeals')
          .doc(unique)
          .set(setData);

      await userDataCollection
          .doc(firebaseUser.uid)
          .collection('purchasedDeals')
          .doc(unique)
          .collection('subCollection')
          .doc(orderId)
          .set(transactionData);

      await userDataCollection
          .doc(firebaseUser.uid)
          .collection('transactionHistory')
          .doc('purchasedDeals')
          .collection('subCollection')
          .doc(orderId)
          .set(transactionData);

      await restaurantDataCollection.doc(unique).update({
        'deals.$percentageKey.qty': FieldValue.increment(quantityChange),
      });

      await restaurantDataCollection
          .doc(unique)
          .collection('salesHistory')
          .doc(orderId)
          .set(salesHistoryData);

      notifyListeners();
    }

    bool? isTransactionSuccessful;

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onConfirm: (String data) {
        return true;
      },
      onDone: (String data) {
        purchasedDeals();
        isTransactionSuccessful = true;
      },
      onCancel: (String data) {
        isTransactionSuccessful = false;
      },
      onClose: () {
        Bootpay().dismiss(context);
        if (isTransactionSuccessful == true) {
          Navigator.pushNamed(context, '/home');
          generalDialog(
              context, '결제가 완료되었습니다. \n \n R페이로 해당 음식점에서 \n \n 거래해주세요.');
        } else {
          Navigator.of(context).pop();
          generalDialog(context, '결제가 취소되었습니다.');
        }
      },
      onError: (String data) {
        isTransactionSuccessful = false;
      },
    );
  }
}
