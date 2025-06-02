import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:r2re/constants/global_navigator_key.dart';
import 'package:r2re/screens/auth_screen/social_auth/auth_model.dart';
import 'package:r2re/screens/auth_screen/social_auth/firebase_auth_remote_data_source.dart';

class SocialAuthModel {
  final AuthModel _socialAuth;
  bool _isLoggedIn = false;
  final firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  kakao.User? kakaoUser;
  NaverAccountResult? naverUser;
  final context = GlobalNavigatorKey.navigatorKey.currentContext;
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  SocialAuthModel(this._socialAuth);

  Future kakaoLogIn() async {
    _isLoggedIn = await _socialAuth.logIn();
    if (_isLoggedIn) {
      kakaoUser = await kakao.UserApi.instance.me();
      final customToken = await firebaseAuthDataSource.createCustomToken({
        'uid': kakaoUser!.id.toString(),
        'displayName': kakaoUser?.kakaoAccount?.profile?.nickname,
        'email': kakaoUser?.kakaoAccount?.email,
        'photoURL': kakaoUser?.kakaoAccount?.profile?.thumbnailImageUrl,
      });
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final userData = {
        'uid': firebaseUser!.uid,
        'displayName': firebaseUser.displayName ??
            kakaoUser?.kakaoAccount?.profile?.nickname,
        'email': firebaseUser.email ?? kakaoUser?.kakaoAccount?.email,
        "accountDeletionRequested": false,
      };
      final docRef = userDataCollection.doc(firebaseUser.uid);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        userDataCollection.doc(firebaseUser.uid).set(userData);
      } else {
        userDataCollection
            .doc(firebaseUser.uid)
            .update({"accountDeletionRequested": false});
      }
      Navigator.pop(context!);
    }
  }

  Future naverLogIn() async {
    _isLoggedIn = await _socialAuth.logIn();
    try {
      if (_isLoggedIn) {
        final isNaverLoggedIn = await FlutterNaverLogin.isLoggedIn;
        if (isNaverLoggedIn == true) {
          naverUser = await FlutterNaverLogin.currentAccount();
          final customToken = await firebaseAuthDataSource.createCustomToken({
            'uid': naverUser!.id.toString(),
            'displayName': naverUser?.nickname.toString(),
            'email': naverUser?.email.toString(),
            'photoURL': naverUser?.profileImage.toString(),
          });
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
          final firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser!.displayName!.isEmpty ||
              firebaseUser.displayName == null) {
            await firebaseUser.updateDisplayName(naverUser!.nickname);
          }
          if (firebaseUser.photoURL!.isEmpty || firebaseUser.photoURL == null) {
            await firebaseUser.updatePhotoURL(naverUser!.profileImage);
          }
          final userData = {
            'uid': firebaseUser.uid,
            'displayName': firebaseUser.displayName ?? naverUser!.nickname,
            'email': naverUser!.email,
            "accountDeletionRequested": false,
          };
          final docRef = userDataCollection.doc(firebaseUser.uid);
          final docSnapshot = await docRef.get();
          if (!docSnapshot.exists) {
            userDataCollection.doc(firebaseUser.uid).set(userData);
          } else {
            userDataCollection
                .doc(firebaseUser.uid)
                .update({"accountDeletionRequested": false});
          }
          Navigator.pop(context!);
        } else {
          Navigator.pop(context!);
        }
      }
    } catch (error) {
      Navigator.pop(context!);
    }
  }

  Future googleLogIn() async {
    _isLoggedIn = await _socialAuth.logIn();
  }

  Future appleLogIn() async {
    _isLoggedIn = await _socialAuth.logIn();
  }
}
