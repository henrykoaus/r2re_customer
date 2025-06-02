import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/screens/auth_screen/components/email_textformfield.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailSignUpForm extends StatefulWidget {
  const EmailSignUpForm({super.key});

  @override
  State<EmailSignUpForm> createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cpwController = TextEditingController();

  final Uri _url = Uri.parse('https://www.r2rekorea.com/privacy');

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> signUpWithEmail() async {
      dialogIndicator(context);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
        if (e.code == 'weak-password') {
          message = '안전한 비밀번호를 사용해주세요.';
        } else if (e.code == 'email-already-in-use') {
          message = '이미 사용중인 계정입니다. \n  \n 혹은 이메일 인증중인 계정입니다.';
        } else if (e.code == 'invalid-email') {
          message = '이메일을 확인해주세요.';
        } else {
          message = '이메일주소를 입력해주세요.';
        }
        if (context.mounted) {
          generalDialog(context, message);
        }
      }
    }

    Future<void> signUpAgreed() async {
      await signUpWithEmail();
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_userNameController.text);
      } else {
        return;
      }
    }

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
                controller: _userNameController,
                obscureText: false,
                hintText: '사용자 이름',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
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
              EmailTextFormField(
                controller: _cpwController,
                obscureText: true,
                hintText: '비밀번호 확인',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              signUpButton(context, signUpAgreed),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector signUpButton(
      BuildContext context, Future<void> Function() signUpAgreed) {
    return GestureDetector(
      onTap: () async {
        final isValid = _formKey.currentState!.validate();
        if (!isValid) return;
        if (_userNameController.text.isEmpty) {
          generalDialog(context, "사용자 이름을 입력해주세요.");
          return;
        } else if (_emailController.text.isEmpty) {
          generalDialog(context, "이메일주소를 입력해주세요.");
          return;
        } else if (_emailController.text.length < 5 ||
            !_emailController.text.contains("@")) {
          generalDialog(context, "이메일을 확인해주세요.");
          return;
        } else if (_pwController.text != _cpwController.text) {
          generalDialog(context, "비밀번호가 일치하지 않습니다.");
          return;
        } else if (_pwController.text.length < 8) {
          generalDialog(context, "비밀번호는 8자리 이상이어야 합니다.");
          return;
        }
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                '알투레서비스 약관 동의',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              surfaceTintColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '회원가입을 위해 아래 약관을 확인 후 동의해주세요.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => setState(
                        () {
                          launchUrl(
                            _url,
                          );
                        },
                      ),
                      child: const Text(
                        '- 알투레 이용약관 (필수)',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      '위 링크를 클릭하여 확인해주세요',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            '이메일 로그인 정보 제공 동의',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          surfaceTintColor: Colors.white,
                          content: const SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '회원가입을 위해 아래 내용에 동의해주세요.',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '알투레에서 회원님의 개인정보에 접근합니다. 제공된 개인정보(이용자 식별자 기본제공, 그 외 제공 항목이 있을 경우 아래 별도 기재)는 이용자 식별, 통계, 계정 연동 및 CS 등을 위해 서비스 이용기간 동안 활용/보관 됩니다. 본 제공 동의를 거부할 권리가 있으나, 동의를 거부하실 경우 서비스 이용이 제한될 수 있습니다.',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '필수 제공 항목 (필수)',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text('이메일 주소, 사용자 이름, 이용자 식별값'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Colors.pinkAccent,
                              ),
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await signUpAgreed();
                              },
                              style: TextButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Colors.pinkAccent,
                              ),
                              child: const Text(
                                '동의 및 가입',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: const Text(
                    '동의 및 계속',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '회원가입',
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
