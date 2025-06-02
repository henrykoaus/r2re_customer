import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/screens/auth_screen/email_auth/forgot_password_screen.dart';
import 'package:r2re/screens/auth_screen/components/email_textformfield.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({super.key});

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 180,
                width: 180,
                child: Wrap(
                  children: [
                    ClipOval(child: Image.asset('assets/icon/logo_icon.png')),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              EmailTextFormField(
                controller: _emailController,
                obscureText: false,
                hintText: '이메일',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              EmailTextFormField(
                controller: _pwController,
                obscureText: true,
                hintText: '비밀번호',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              forgottenPw(),
              const SizedBox(
                height: 20,
              ),
              signInButton(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row forgottenPw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(
                  fontSize: 17, decoration: TextDecoration.underline)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen()),
            );
          },
          child: const Text('비밀번호를 잊어버리셨나요?'),
        ),
      ],
    );
  }

  GestureDetector signInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dialogIndicator(context);
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _pwController.text,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          String message = '';
          if (e.code == 'user-not-found') {
            message = '사용자가 존재하지 않습니다.';
          } else if (e.code == 'invalid-email') {
            message = '이메일 혹은 비밀번호를 확인해주세요.';
          } else if (e.code == 'wrong-password') {
            message = '이메일 혹은 비밀번호를 확인해주세요.';
          } else {
            message = '이메일 혹은 비밀번호를 확인해주세요.';
          }
          if (context.mounted) {
            generalDialog(context, message);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
