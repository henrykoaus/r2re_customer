import 'package:flutter/material.dart';
import 'package:r2re/screens/auth_screen/email_auth/email_signin_form.dart';
import 'package:r2re/screens/auth_screen/email_auth/email_signup_form.dart';

class FadeStack extends StatefulWidget {
  final int selectedForm;

  const FadeStack({super.key, required this.selectedForm});

  @override
  State<FadeStack> createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  List<Widget> forms = [
    const EmailSignInForm(),
    const EmailSignUpForm(),
  ];

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeStack oldWidget) {
    if (widget.selectedForm != oldWidget.selectedForm) {
      animationController!.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController!,
      child: IndexedStack(
        index: widget.selectedForm,
        children: forms,
      ),
    );
  }
}
