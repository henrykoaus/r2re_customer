import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/global_navigator_key.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthModel {
  Future<bool> logIn();
}

class KakaoAuth implements AuthModel {
  final context = GlobalNavigatorKey.navigatorKey.currentContext;

  @override
  Future<bool> logIn() async {
    try {
      dialogIndicator(context!);
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (error) {
          Navigator.pop(context!);
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (error) {
          Navigator.pop(context!);
          return false;
        }
      }
    } catch (error) {
      Navigator.pop(context!);
      return false;
    }
  }
}

class NaverAuth implements AuthModel {
  final context = GlobalNavigatorKey.navigatorKey.currentContext;

  @override
  Future<bool> logIn() async {
    try {
      dialogIndicator(context!);
      NaverLoginResult naverLogIn = await FlutterNaverLogin.logIn();
      naverLogIn;
      return true;
    } catch (error) {
      Navigator.pop(context!);
      return false;
    }
  }
}

class GoogleAuth implements AuthModel {
  final context = GlobalNavigatorKey.navigatorKey.currentContext;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  @override
  Future<bool> logIn() async {
    try {
      dialogIndicator(context!);
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final googleUser = userCredential.user;
      googleUser;
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final userData = {
        'uid': firebaseUser!.uid,
        'displayName': firebaseUser.displayName,
        'email': firebaseUser.email,
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
      return true;
    } catch (error) {
      Navigator.pop(context!);
      return false;
    }
  }
}

class AppleAuth implements AuthModel {
  final context = GlobalNavigatorKey.navigatorKey.currentContext;
  final userDataCollection = FirebaseFirestore.instance.collection('userData');

  @override
  Future<bool> logIn() async {
    try {
      dialogIndicator(context!);
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'r2reapp.r2rekorea.com',
            redirectUri: Uri.parse(
                'https://r2re-75417.firebaseapp.com/__/auth/handler')),
      );
      AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      String displayName = '${result.familyName}${result.givenName}';
      String email = '${result.email}';
      final appleUser = userCredential.user;
      final userData = {
        'uid': appleUser!.uid,
        'displayName': appleUser.displayName ?? displayName,
        'email': appleUser.email ?? email,
        "accountDeletionRequested": false,
      };
      final docRef = userDataCollection.doc(appleUser.uid);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        userDataCollection.doc(appleUser.uid).set(userData);
      } else {
        userDataCollection
            .doc(appleUser.uid)
            .update({"accountDeletionRequested": false});
      }
      Navigator.pop(context!);
      return true;
    } catch (error) {
      Navigator.pop(context!);
      return false;
    }
  }
}
