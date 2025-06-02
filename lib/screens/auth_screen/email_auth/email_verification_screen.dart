import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/home_page.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail(context);
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    } else {
      checkAndStoreData();
    }
  }

  Future sendVerificationEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      if (context.mounted) {
        generalDialog(context, '링크가 방금 전송되었습니다 \n \n 이메일을 다시 확인해주세요.');
      }
    }
  }

  Future<void> checkEmailVerified() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await currentUser.reload();
        setState(() {
          isEmailVerified = currentUser.emailVerified;
        });
        if (isEmailVerified) {
          timer?.cancel();
          checkAndStoreData();
        }
      } catch (e) {
        rethrow;
      }
    } else {
      return;
    }
  }

  Future<void> checkAndStoreData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection("userData")
          .doc(currentUser.uid);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        await storeData();
      } else {
        await docRef.update({"accountDeletionRequested": false});
      }
    } else {
      return;
    }
  }

  Future storeData() async {
    final CollectionReference userDataCollection =
        FirebaseFirestore.instance.collection('userData');
    final userData = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'displayName': FirebaseAuth.instance.currentUser?.displayName,
      'email': FirebaseAuth.instance.currentUser!.email,
      "accountDeletionRequested": false,
    };
    await userDataCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(userData);
  }

  @override
  void dispose() {
    timer?.cancel();
    sendVerificationEmail(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이메일을 확인해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    '입력하신 이메일주소: ${FirebaseAuth.instance.currentUser!.email} 로 \n \n 인증링크가 전송되었습니다.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              resendButton(context),
              const SizedBox(height: 16),
              cancelButton(),
            ],
          ),
        );

  Padding resendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: canResendEmail ? () => sendVerificationEmail(context) : null,
        icon: const Icon(
          Icons.email,
          size: 24,
          color: Colors.white,
        ),
        label: const Text(
          '재전송하기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  TextButton cancelButton() {
    return TextButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      child: const Text(
        '취소',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
