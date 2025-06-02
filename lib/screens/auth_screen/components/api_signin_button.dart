import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiSignInButton extends StatefulWidget {
  final Widget widget;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const ApiSignInButton({
    super.key,
    required this.widget,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<ApiSignInButton> createState() => _ApiSignInButtonState();
}

class _ApiSignInButtonState extends State<ApiSignInButton> {
  final Uri _url = Uri.parse('https://www.r2rekorea.com/privacy');

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: FilledButton(
        onPressed: () {
          showDialog(
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
                        '서비스이용을 위해 아래 약관을 확인 후 동의해주세요.',
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
                    onPressed: widget.onPressed,
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
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          surfaceTintColor: widget.backgroundColor,
          fixedSize: const Size(300, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            widget.widget,
            Expanded(
              child: Center(
                child: Text(
                  widget.text,
                  style: GoogleFonts.roboto(
                    color: widget.textColor,
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
