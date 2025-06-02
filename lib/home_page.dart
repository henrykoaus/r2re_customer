import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/hot_deals_screen/hot_deals_screen.dart';
import 'package:r2re/screens/payment_screen/payment_screen.dart';
import 'package:r2re/screens/profile_screen/profile_screen.dart';
import 'package:r2re/screens/feed_screen/feed_screen.dart';
import 'package:r2re/screens/wallet_screen/wallet_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    PersistentTabController persistentTabController;
    persistentTabController = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: persistentTabController,
      screens: mainScreens(),
      items: navBarsItems(),
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 1),
      backgroundColor: CupertinoColors.systemGrey5,
      resizeToAvoidBottomInset: false,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(13.0),
        colorBehindNavBar: CupertinoColors.systemGrey5,
      ),
      navBarStyle: NavBarStyle.style15,
    );
  }

  List<Widget> mainScreens() {
    return [
      const FeedScreen(),
      const HotDealsScreen(),
      const PaymentScreen(),
      const WalletScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.restaurant_menu),
        title: ("알투레딜"),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.pinkAccent,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.tickets_fill),
        title: ("핫딜s"),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.pinkAccent,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
      ),
      paymentBottomNavBar(context),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_balance_wallet),
        title: ("내지갑"),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.pinkAccent,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle_rounded),
        title: ("내알투레"),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.pinkAccent,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
      ),
    ];
  }

  PersistentBottomNavBarItem paymentBottomNavBar(BuildContext context) {
    return PersistentBottomNavBarItem(
      icon: ClipOval(
        child: Image.asset(
          'assets/images/payment_logo.png',
        ),
      ),
      title: ("R페이"),
      textStyle: const TextStyle(fontSize: 13),
      activeColorPrimary: Colors.pinkAccent.withOpacity(0.8),
      inactiveColorPrimary: Colors.pink,
      onPressed: (index) {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return const Wrap(
              children: [
                PaymentScreen(),
              ],
            );
          },
          constraints: BoxConstraints(
            maxWidth: size!.width / 1.1,
          ),
          enableDrag: true,
          isDismissible: true,
          showDragHandle: true,
          barrierColor: Colors.grey.withOpacity(0.4),
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          isScrollControlled: true,
          useSafeArea: true,
        );
      },
    );
  }
}
