import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:r2re/components/carousel_slider/customised_container.dart';

class CarouselSliderModel extends StatelessWidget {
  final String image1;
  final String title1;
  final String subtitle1;
  final String image2;
  final String title2;
  final String subtitle2;
  final String image3;
  final String title3;
  final String subtitle3;
  final Widget? widget1;
  final Widget? widget2;
  final Widget? widget3;
  final double titleSize;
  final double subtitleSize;

  const CarouselSliderModel({
    super.key,
    required this.image1,
    required this.title1,
    required this.subtitle1,
    required this.image2,
    required this.title2,
    required this.subtitle2,
    required this.image3,
    required this.title3,
    required this.subtitle3,
    this.widget1,
    this.widget2,
    this.widget3,
    required this.titleSize,
    required this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        CustomisedContainer(
          image: image1,
          title: title1,
          subtitle: subtitle1,
          widget: (widget1 != null) ? widget1 : null,
          titleSize: titleSize,
          subtitleSize: subtitleSize,
        ),
        CustomisedContainer(
          image: image2,
          title: title2,
          subtitle: subtitle2,
          widget: (widget2 != null) ? widget2 : null,
          titleSize: titleSize,
          subtitleSize: subtitleSize,
        ),
        CustomisedContainer(
          image: image3,
          title: title3,
          subtitle: subtitle3,
          widget: (widget3 != null) ? widget3 : null,
          titleSize: titleSize,
          subtitleSize: subtitleSize,
        ),
      ],
      options: CarouselOptions(
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        viewportFraction: 1,
      ),
    );
  }
}
