import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/screens/auth_screen/email_auth/email_verification_screen.dart';
import 'package:r2re/screens/auth_screen/components/fade_stack.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  int selectedForm = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const EmailVerificationScreen();
        } else {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Material(
              child: SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    forceMaterialTransparency: true,
                    title: const Text(
                      '이메일로 계속하기',
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            FadeStack(
                              selectedForm: selectedForm,
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 60,
                              child: Container(
                                color: Colors.grey[200],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: (selectedForm == 0)
                                            ? '계정이 없으신가요?'
                                            : '이미 계정이 있으신가요?',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (selectedForm == 0) {
                                            selectedForm = 1;
                                          } else {
                                            selectedForm = 0;
                                          }
                                        });
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text: (selectedForm == 0)
                                              ? '회원가입'
                                              : '로그인',
                                          style: const TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
