import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/carousel_slider/carousel_slider_model.dart';
import 'package:r2re/components/carousel_slider/customised_button.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/profile_screen/pages_in_profile/restaurant_suggestion/restaurant_suggestion_page.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedBottomAppBar extends StatefulWidget {
  const FeedBottomAppBar({
    super.key,
  });

  @override
  State<FeedBottomAppBar> createState() => _FeedBottomAppBarState();
}

class _FeedBottomAppBarState extends State<FeedBottomAppBar> {
  final Uri _url = Uri.parse('https://www.r2rekorea.com/');

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: SizedBox(
            height: size!.height / 6,
            width: size!.width,
            child: CarouselSliderModel(
              image1: 'assets/images/food.jpeg',
              title1: '단골 가게가 알투레에 없나요?',
              subtitle1: '가게를 추천해 주세요. 알투레가 초대 할게요',
              widget1: const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomisedButton(
                      title: '음식점 추천',
                      pushWidget: RestaurantSuggestionPage(),
                      rootNavigator: true,
                    ),
                  ],
                ),
              ),
              image2: 'assets/images/category/bbq.jpeg',
              title2: '알투레는 알투레코리아가 운영합니다',
              subtitle2: '알투레코리아가 궁금하시다면?',
              widget2: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(
                        () {
                          launchUrl(
                            _url,
                          );
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 12),
                      child: const AutoSizeText(
                        '알투레코리아',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        minFontSize: 10,
                        maxFontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
              image3: 'assets/images/category/brunch.jpeg',
              title3: '딜을 구매하고 R페이로 계산하세요',
              subtitle3: '내지갑에서 구매하신 딜과 거래내역도 볼 수 있습니다',
              widget3: const Expanded(child: SizedBox(height: 20)),
              titleSize: 24,
              subtitleSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
