import 'package:flutter/material.dart';
import 'package:r2re/screens/feed_screen/components/region_button.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/region_page_model.dart';

class RegionDisplay extends StatelessWidget {
  const RegionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          RegionButton(
            text: '서울',
            pushWidget: RegionPageModel(region: '서울'),
          ),
          RegionButton(
            text: '경기/인천',
            pushWidget: RegionPageModel(region: '경기/인천'),
          ),
          RegionButton(
            text: '강원',
            pushWidget: RegionPageModel(region: '강원'),
          ),
          RegionButton(
            text: '충북',
            pushWidget: RegionPageModel(region: '충북'),
          ),
          RegionButton(
            text: '충남/대전',
            pushWidget: RegionPageModel(region: '충남/대전'),
          ),
          RegionButton(
            text: '경북/대구',
            pushWidget: RegionPageModel(region: '경북/대구'),
          ),
          RegionButton(
            text: '전북',
            pushWidget: RegionPageModel(region: '전북'),
          ),
          RegionButton(
            text: '경남/부산',
            pushWidget: RegionPageModel(region: '경남/부산'),
          ),
          RegionButton(
            text: '전남/광주',
            pushWidget: RegionPageModel(region: '전남/광주'),
          ),
          RegionButton(
            text: '제주',
            pushWidget: RegionPageModel(region: '제주'),
          ),
        ],
      ),
    );
  }
}
