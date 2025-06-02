import 'package:flutter/material.dart';
import 'package:r2re/screens/feed_screen/card_displays/favourite_deals_display.dart';
import 'package:r2re/screens/feed_screen/card_displays/nearby_deals_display.dart';
import 'package:r2re/screens/feed_screen/card_displays/new_deals_display.dart';
import 'package:r2re/screens/feed_screen/card_displays/popular_deals_display.dart';
import 'package:r2re/screens/feed_screen/components/feed_bottom_app_bar.dart';
import 'package:r2re/screens/feed_screen/components/card_title.dart';
import 'package:r2re/screens/feed_screen/card_displays/region_display.dart';
import 'package:r2re/screens/feed_screen/card_displays/category_display.dart';
import 'package:r2re/screens/feed_screen/components/feed_app_bar.dart';
import 'package:r2re/screens/feed_screen/components/policy_container.dart';
import 'package:r2re/screens/feed_screen/components/search_bar_button.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/favourite_deals_see_all_page.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/nearby_deals_see_all_page.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/new_deals_see_all_page.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/popular_deals_see_all_page.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          FeedAppBar(),
          SearchBarButton(),
          RegionDisplay(),
          CategoryDisplay(),
          CardTitle(
            title: '알투레 인기딜s',
            trailing: '더보기  :',
            pushWidget: PopularDealsSeeAllPage(),
          ),
          PopularDealsDisplay(),
          CardTitle(
            title: '알투레 내주변 딜s',
            trailing: '더보기  :',
            pushWidget: NearbyDealsSeeAllPage(),
          ),
          NearbyDealsDisplay(),
          CardTitle(
            title: '알투레 신규 음식점s',
            trailing: '더보기  :',
            pushWidget: NewDealsSeeAllPage(),
          ),
          NewDealsDisplay(),
          CardTitle(
            title: '내가 찜한 딜s',
            trailing: '펼쳐보기  :',
            pushWidget: FavouriteDealsSeeAllPage(),
          ),
          FavouriteDealsDisplay(),
          FeedBottomAppBar(),
          PolicyContainer(),
        ],
      ),
    );
  }
}
