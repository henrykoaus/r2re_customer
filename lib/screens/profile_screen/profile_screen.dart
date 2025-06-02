import 'package:flutter/material.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/profile_screen/profile_body.dart';
import 'package:r2re/screens/profile_screen/profile_side_menu.dart';

enum MenuStatus { opened, closed }

const duration = Duration(milliseconds: 500);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final menuWidth = size!.width / 2.4 * 2;
  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXpos = 0;
  double menuXpos = size!.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: duration,
            transform: Matrix4.translationValues(bodyXpos, 0, 0),
            child: ProfileBody(onMenuChanged: () {
              setState(() {
                _menuStatus = (_menuStatus == MenuStatus.closed)
                    ? MenuStatus.opened
                    : MenuStatus.closed;
                switch (_menuStatus) {
                  case MenuStatus.opened:
                    bodyXpos = -menuWidth;
                    menuXpos = size!.width - menuWidth;
                    break;
                  case MenuStatus.closed:
                    bodyXpos = 0;
                    menuXpos = size!.width;
                    break;
                }
              });
            }),
          ),
          AnimatedContainer(
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(menuXpos, 0, 0),
            duration: duration,
            child: ProfileSideMenu(menuWidth: menuWidth),
          ),
        ],
      ),
    );
  }
}
