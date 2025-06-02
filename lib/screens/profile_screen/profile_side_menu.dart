import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/enqiery_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSideMenu extends StatefulWidget {
  final double menuWidth;

  const ProfileSideMenu({super.key, required this.menuWidth});

  @override
  State<ProfileSideMenu> createState() => _ProfileSideMenuState();
}

class _ProfileSideMenuState extends State<ProfileSideMenu> {
  final Uri _url = Uri.parse('https://www.r2rekorea.com/r2re-privacy-policy');

  final currentUser = FirebaseAuth.instance.currentUser;

  requestAccountDeletion() async {
    try {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(currentUser!.uid)
          .update({"accountDeletionRequested": true});
      await currentUser!.delete();
    } on FirebaseAuthException {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            title: const Text(
              '\n 사용자 확인을 위해 \n 동일 계정으로 다시 \n 재로그인 후 삭제 부탁드립니다.\n',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            actions: [
              Center(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        dialogIndicator(context);
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.pinkAccent,
                      ),
                      child: const Text(
                        '재로그인',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: widget.menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text(
                '세팅',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            customerService(context),
            ListTile(
              leading: const Icon(
                Icons.manage_accounts,
                color: Colors.pinkAccent,
                size: 28,
              ),
              title: const Text(
                '계정삭제',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    title: const Text(
                      '\n계정 삭제시 소유했던 상품들이\n 모두 소멸됩니다.\n \n 계정을 삭제하시겠습니까? \n',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    actions: [
                      Center(
                        child: Wrap(
                          children: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);
                                  dialogIndicator(context);
                                  requestAccountDeletion();
                                  Navigator.pop(context);
                                } catch (e) {
                                  return;
                                }
                              },
                              style: TextButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Colors.pinkAccent,
                              ),
                              child: const Text(
                                '삭제',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
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
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            termsOfService(),
            signOut(),
          ],
        ),
      ),
    );
  }

  ListTile customerService(BuildContext context) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.bubble_left_bubble_right_fill,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '문의하기',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => const EnquiryPage()));
      },
    );
  }

  ListTile termsOfService() {
    return ListTile(
      leading: const Icon(
        Icons.policy,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '약관 및 정책',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () => setState(
        () {
          launchUrl(
            _url,
          );
        },
      ),
    );
  }

  ListTile signOut() {
    return ListTile(
      leading: const Icon(
        Icons.exit_to_app,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '로그아웃',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        FirebaseAuth.instance.signOut();
      },
    );
  }
}
