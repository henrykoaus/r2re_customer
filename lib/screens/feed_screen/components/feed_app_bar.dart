import 'package:flutter/material.dart';
import 'package:r2re/components/carousel_slider/carousel_slider_model.dart';
import 'package:r2re/constants/screen_size.dart';

class FeedAppBar extends StatelessWidget {
  const FeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size!.height / 6,
      width: size!.width,
      child: const CarouselSliderModel(
        image1: 'assets/images/food.jpeg',
        title1: 'R2:re 떠오르는 딜s',
        subtitle1: '딜 사고, 내 최애 음식을 더 많이!',
        widget1: Expanded(child: SizedBox(height: 20)),
        image2: 'assets/images/category/bbq.jpeg',
        title2: 'R2:re 딜을 구매하세요',
        subtitle2: '만 원으로 만 오천원 음식을!?',
        widget2: Expanded(child: SizedBox(height: 20)),
        image3: 'assets/images/category/brunch.jpeg',
        title3: 'R2:re와 함께',
        subtitle3: '최애 음식들을 더 자주 즐기세요',
        widget3: Expanded(child: SizedBox(height: 20)),
        titleSize: 24,
        subtitleSize: 20,
      ),
    );
  }
}
