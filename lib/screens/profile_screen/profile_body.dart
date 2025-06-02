import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/favourite_deals_see_all_page.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/feedback_page.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/my_purchased_deals_page.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/restaurant_suggestion/restaurant_suggestion_page.dart';
import 'package:r2re/screens/profile_screen/profile_screen.dart';
import 'package:r2re/screens/wallet_screen/see_all_purchased_deals/see_all_payment_history.dart';
import 'package:r2re/screens/wallet_screen/see_all_purchased_deals/see_all_purchase_history.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key, required this.onMenuChanged}) : super(key: key);

  final Function() onMenuChanged;

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  AnimationController? _iconAnimationController;
  Animation<double>? _animation;

  final _endIndent = size!.width / 3;

  String? _userName;
  String? _userEmail;

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.displayName == null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('userData')
            .doc(user!.uid)
            .get();
        _userName = userData.data()!['displayName'] as String?;
      } catch (error) {
        rethrow;
      }
    } else {
      _userName = user?.displayName;
    }
    setState(() {});
  }

  Future<void> fetchEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('userData')
            .doc(user!.uid)
            .get();
        _userEmail = userData.data()!['email'] as String?;
      } catch (error) {
        rethrow;
      }
    } else {
      _userEmail = user?.email;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    _animation = Tween<double>(
      begin: 20,
      end: _endIndent,
    ).animate(_iconAnimationController!);
    fetchUserName();
    fetchEmail();
  }

  @override
  void dispose() {
    _iconAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Flex(
        direction: Axis.vertical,
        children: [
          settingMenu(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                userProfile(context),
                const SizedBox(height: 30),
                AnimatedBuilder(
                    animation: _animation!,
                    builder: (context, child) {
                      return Divider(
                        color: Colors.grey,
                        indent: 20,
                        endIndent: _animation!.value,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      possessedDeals(context),
                      paymentHistory(context),
                      dealPurchaseHistory(context),
                      myFavourites(context),
                      recommendedService(),
                      giveFeedback(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row settingMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SafeArea(
          child: SizedBox(
            width: 50,
          ),
        ),
        IconButton(
          icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              size: 35,
              progress: _iconAnimationController!),
          onPressed: () {
            widget.onMenuChanged();
            _iconAnimationController!.status == AnimationStatus.completed
                ? _iconAnimationController!.reverse()
                : _iconAnimationController!.forward();
          },
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Column userProfile(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userPhoto = user?.photoURL;
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: (userPhoto != null)
              ? ClipOval(
                  child: Image.network(userPhoto,
                      width: 100, height: 100, fit: BoxFit.cover),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: (_userName != null && _userName != 'nullnull')
              ? Text(
                  _userName!,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              : const Text(''),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: AutoSizeText(
            _userEmail ?? '',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            maxFontSize: 16,
            minFontSize: 10,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  ListTile possessedDeals(BuildContext context) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.cart_fill,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '구매한 딜s',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyPurchasedDealsPage()),
        );
      },
    );
  }

  ListTile paymentHistory(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.payments,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        'R페이 내역',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SeeAllPaymentHistory()),
        );
      },
    );
  }

  ListTile dealPurchaseHistory(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.feed,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '딜구매 내역',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SeeAllPurchaseHistory()),
        );
      },
    );
  }

  ListTile myFavourites(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.favorite,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '찜한 딜s',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FavouriteDealsSeeAllPage()),
        );
      },
    );
  }

  ListTile recommendedService() {
    return ListTile(
      leading: const Icon(
        Icons.recommend,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '음식점 추천',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => const RestaurantSuggestionPage()));
      },
    );
  }

  ListTile giveFeedback() {
    return ListTile(
      leading: const Icon(
        Icons.feedback_rounded,
        color: Colors.pinkAccent,
        size: 28,
      ),
      title: const Text(
        '피드백 주기',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => const FeedbackPage()));
      },
    );
  }
}
