import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/constants/screen_size.dart';

class EnquiryPage extends StatefulWidget {
  const EnquiryPage({super.key});

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _subjectEditingController =
      TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _textEditingController.dispose();
    _subjectEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference enquiryCollection =
        FirebaseFirestore.instance.collection('usersEnquiry');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('문의하기'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 100,
                      width: size!.width / 1.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white60),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _subjectEditingController,
                          minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: '제목',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
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
                          decoration: const InputDecoration(
                              hintText:
                                  '문의사항을 작성해주세요.\n\n알투레코리아가 등록된 고객님의 \n이메일로 답장을 드립니다.'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 30,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_subjectEditingController.text.isNotEmpty &&
                    _textEditingController.text.isNotEmpty) {
                  dialogIndicator(context);
                  Map<String, dynamic> enquiryData = {
                    'subject': _subjectEditingController.text,
                    'enquiry': _textEditingController.text,
                    'uid': currentUser!.uid,
                    'email': currentUser!.email,
                    'displayName': currentUser!.displayName ?? '',
                  };
                  await enquiryCollection.add(enquiryData);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      if (context.mounted) {
                        generalDialog(context,
                            '문의사항이 전달되었습니다.\n\n등록된 고객님의 이메일로 \n빠른 시일내에 답장 드리겠습니다.');
                      }
                    }
                  }
                } else {
                  generalDialog(context, '제목 및 문의사항을 입력해주세요.');
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
                  '문의하기',
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
