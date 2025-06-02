import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/home_page.dart';
import 'package:r2re/screens/auth_screen/api_signin_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void getPermission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isGranted && status.isLimited) {
      await Geolocator.getCurrentPosition();
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        await Geolocator.getCurrentPosition();
      } else {
        return;
      }
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      if (mounted) {
        settingDialog(context);
      }
    } else if (status.isRestricted) {
      if (mounted) {
        settingDialog(context);
      }
    } else if (status.isDenied) {
      if (mounted) {
        settingDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
    getPermission();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("userData")
                .doc(uid)
                .snapshots(),
            builder: (context, docSnapshot) {
              if (docSnapshot.hasError) {
                return Text('Error: ${docSnapshot.error}');
              } else if (docSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const HomePage();
              } else if (snapshot.hasData && docSnapshot.data!.exists) {
                return const HomePage();
              } else {
                return const ApiSignInScreen();
              }
            },
          );
        } else {
          return const ApiSignInScreen();
        }
      },
    );
  }
}
