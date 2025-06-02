import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:r2re/constants/global_navigator_key.dart';
import 'package:r2re/env/env.dart';
import 'package:r2re/home_page.dart';
import 'package:r2re/auth_page.dart';
import 'package:r2re/state_management/favourite_provider.dart';
import 'package:r2re/state_management/bootpay_request_provider.dart';
import 'package:r2re/state_management/hot_deals_provider.dart';
import 'package:r2re/state_management/payment_request_provider.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';
import 'package:r2re/state_management/restaurant_card_display_provider.dart';
import 'package:r2re/state_management/see_all_page_provider.dart';
import 'firebase_options.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  widgetsBinding;
  KakaoSdk.init(nativeAppKey: Env.kakao);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RestaurantCardDisplayProvider()),
        ChangeNotifierProvider(create: (context) => SeeAllPageProvider()),
        ChangeNotifierProvider(create: (context) => FavouritesProvider()),
        ChangeNotifierProvider(create: (context) => HotDealsProvider()),
        ChangeNotifierProvider(create: (context) => PurchasedDealsProvider()),
        ChangeNotifierProvider(create: (context) => PaymentRequestProvider()),
        ChangeNotifierProvider(create: (context) => BootPayRequestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
      },
      initialRoute: '/auth',
      navigatorKey: GlobalNavigatorKey.navigatorKey,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.pink),
      ),
    );
  }
}
