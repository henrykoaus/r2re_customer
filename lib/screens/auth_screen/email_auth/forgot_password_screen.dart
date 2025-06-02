import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              title: const Text(
                '비밀번호 초기화하기',
              ),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Text(
                    '비밀번호 초기화를 위해 \n 이메일을 입력해주세요.',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        emailTextFormField(),
                        const SizedBox(
                          height: 40,
                        ),
                        resetButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.black38,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: '이메일',
        prefixIcon: const Icon(Icons.email),
        prefixIconColor: Colors.pinkAccent,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _emailController.clear();
          },
        ),
        suffixIconColor: Colors.grey,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
    );
  }

  ElevatedButton resetButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () async {
        dialogIndicator(context);
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: _emailController.text);
          if (context.mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
          if (context.mounted) {
            generalDialog(context,
                "입력하신 이메일주소로 \n 초기화 링크가 전송되었습니다. \n  \n 새로운 비밀번호로 \n 다시 로그인해주세요.");
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          String message = '';
          if (e.code == 'user-not-found') {
            message = '사용자가 존재하지 않습니다.';
          } else if (e.code == 'invalid-email') {
            message = '이메일을 확인해주세요.';
          } else {
            message = '이메일주소를 입력해주세요.';
          }
          if (context.mounted) {
            generalDialog(context, message);
          }
        }
      },
      icon: const Icon(
        Icons.lock_reset,
        size: 24,
        color: Colors.white,
      ),
      label: const Text(
        '비밀번호 초기화',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
