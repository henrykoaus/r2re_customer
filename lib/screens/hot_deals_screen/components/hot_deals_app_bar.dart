import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/carousel_slider/customised_container.dart';
import 'package:r2re/components/send_email.dart';
import 'package:r2re/constants/screen_size.dart';

class HotDealsAppBar extends StatelessWidget {
  const HotDealsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size!.height / 8,
      width: size!.width,
      child: CarouselSlider(
        items: [
          const CustomisedContainer(
            image: 'assets/images/category/cafe.jpeg',
            title: '핫딜s에서 50% 이상 딜을 제공하는',
            subtitle: '음식점을 찾아 최애음식을 즐기세요',
            titleSize: 24,
            subtitleSize: 20,
          ),
          CustomisedContainer(
            image: 'assets/images/basic_photo.png',
            title: '알투레는 함께할 가맹점을 찾고있습니다',
            subtitle: '알투레에 알려주세요',
            widget: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sendEmail(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 12),
                    child: const AutoSizeText(
                      '입점문의',
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
            titleSize: 24,
            subtitleSize: 20,
          ),
        ],
        options: CarouselOptions(
          enlargeCenterPage: false,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
          viewportFraction: 1,
        ),
      ),
    );
  }
}
