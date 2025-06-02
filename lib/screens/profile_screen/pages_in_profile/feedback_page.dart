import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/screen_size.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference feedbackCollection =
        FirebaseFirestore.instance.collection('usersFeedback');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('알투레에 피드백 주기'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: size!.height / 2.5,
                  width: size!.width / 1.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white60),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: _textEditingController,
                      minLines: 40,
                      maxLines: null,
                      decoration: const InputDecoration(hintText: '피드백을 써주세요'),
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 30,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_textEditingController.text.isNotEmpty) {
                  dialogIndicator(context);
                  Map<String, dynamic> feedbackData = {
                    'feedback': _textEditingController.text,
                    'uid': currentUser!.uid,
                    'email': currentUser!.email,
                    'displayName': currentUser!.displayName ?? '',
                  };
                  await feedbackCollection.add(feedbackData);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      if (context.mounted) {
                        generalDialog(
                            context, '피드백이 전송되었습니다.\n\n 더 나은 서비스로 개선하겠습니다.');
                      }
                    }
                  }
                } else {
                  generalDialog(context, '피드백을 작성해주세요.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: Text(
                  '피드백 보내기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
