import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/my_purchased_deals_page.dart';
import 'package:r2re/screens/wallet_screen/components/payment_history_box.dart';
import 'package:r2re/screens/wallet_screen/components/purchased_deals_box.dart';
import 'package:r2re/screens/wallet_screen/components/purchase_history_box.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  final SizedBox sizedBox = const SizedBox(
    height: 20,
  );

  final Divider divider = const Divider(
    height: 1,
    indent: 5,
    endIndent: 5,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          appBar(),
          sizedBox,
          sizedBox,
          totalBalance(context, purchasedDealsProvider, currentUser),
          const SizedBox(
            height: 50,
          ),
          divider,
          const PurchasedDealsBox(),
          sizedBox,
          divider,
          const PaymentHistoryBox(),
          sizedBox,
          divider,
          const PurchaseHistoryBox(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Container appBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Colors.purpleAccent, Colors.pink],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(height: 100, width: 100, 'assets/splash.png'),
          const Text(
            '내지갑',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Column totalBalance(BuildContext context,
      PurchasedDealsProvider purchasedDealsProvider, User? currentUser) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPurchasedDealsPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(size!.width / 1.8, 120),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.purple[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 1,
          ),
          child: FutureBuilder<void>(
            future:
                purchasedDealsProvider.calculateTotalBalance(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '₩${purchasedDealsProvider.totalBalance.toString()}원',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '내 R머니 총액',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
