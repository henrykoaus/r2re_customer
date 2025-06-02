import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r2re/screens/auth_screen/components/api_signin_button.dart';
import 'package:r2re/screens/auth_screen/email_auth/email_auth_screen.dart';
import 'package:r2re/screens/auth_screen/social_auth/auth_model.dart';
import 'package:r2re/screens/auth_screen/social_auth/social_auth_model.dart';

class ApiSignInScreen extends StatelessWidget {
  const ApiSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kakaoAuth = SocialAuthModel(KakaoAuth());
    final naverAuth = SocialAuthModel(NaverAuth());
    final googleAuth = SocialAuthModel(GoogleAuth());
    final appleAuth = SocialAuthModel(AppleAuth());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: Wrap(
                  children: [
                    ClipOval(child: Image.asset('assets/icon/logo_icon.png')),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ApiSignInButton(
                widget: Image.asset(
                  'assets/images/social_media_logos/kakao_logo.png',
                  height: 45,
                  width: 45,
                ),
                text: '카카오로 계속하기',
                onPressed: () async {
                  Navigator.pop(context);
                  await kakaoAuth.kakaoLogIn();
                },
                backgroundColor: const Color.fromRGBO(254, 229, 0, 1),
                textColor: Colors.black,
              ),
              const SizedBox(
                height: 15,
              ),
              ApiSignInButton(
                widget: Image.asset(
                  'assets/images/social_media_logos/naver_logo.png',
                  height: 45,
                  width: 45,
                ),
                text: '네이버로 계속하기',
                onPressed: () async {
                  Navigator.pop(context);
                  await naverAuth.naverLogIn();
                },
                backgroundColor: const Color.fromRGBO(3, 199, 90, 1),
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              ApiSignInButton(
                widget: Image.asset(
                  'assets/images/social_media_logos/google_logo.png',
                  height: 45,
                  width: 45,
                ),
                text: 'Sign In With Google',
                onPressed: () async {
                  Navigator.pop(context);
                  await googleAuth.googleLogIn();
                },
                backgroundColor: Colors.white,
                textColor: Colors.black,
              ),
              const SizedBox(
                height: 15,
              ),
              ApiSignInButton(
                widget: Image.asset(
                  'assets/images/social_media_logos/apple_logo.png',
                  height: 45,
                  width: 45,
                ),
                text: 'Sign In With Apple',
                onPressed: () async {
                  Navigator.pop(context);
                  await appleAuth.appleLogIn();
                },
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 40,
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              emailLogIn(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card emailLogIn(BuildContext context) {
    return Card(
      elevation: 3,
      child: FilledButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EmailAuthScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          fixedSize: const Size(300, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset(
                'assets/images/social_media_logos/email_logo.png',
                height: 30,
                width: 30,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '이메일로 시작하기',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
