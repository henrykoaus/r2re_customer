import 'package:flutter/material.dart';
import 'package:r2re/components/card_models/category_card_model.dart';
import 'package:r2re/screens/feed_screen/see_all_pages/category_page_model.dart';

class CategoryDisplay extends StatefulWidget {
  const CategoryDisplay({super.key});

  @override
  State<CategoryDisplay> createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryCardModel(
            text: '카페/브런치',
            image: 'assets/images/category/cafe.jpeg',
            pushWidget: CategoryPageModel(category: '카페/브런치'),
          ),
          CategoryCardModel(
            text: '고기/구이',
            image: 'assets/images/category/bbq.jpeg',
            pushWidget: CategoryPageModel(category: '고기/구이'),
          ),
          CategoryCardModel(
            text: '피자/햄버거',
            image: 'assets/images/category/fastfood.jpeg',
            pushWidget: CategoryPageModel(category: '피자/햄버거'),
          ),
          CategoryCardModel(
            text: '회/초밥',
            image: 'assets/images/category/sushi.jpeg',
            pushWidget: CategoryPageModel(category: '회/초밥'),
          ),
          CategoryCardModel(
            text: '한식',
            image: 'assets/images/category/korean.jpeg',
            pushWidget: CategoryPageModel(category: '한식'),
          ),
          CategoryCardModel(
            text: '중식',
            image: 'assets/images/category/chinese.jpeg',
            pushWidget: CategoryPageModel(category: '중식'),
          ),
          CategoryCardModel(
            text: '일식',
            image: 'assets/images/category/japanese.jpeg',
            pushWidget: CategoryPageModel(category: '일식'),
          ),
          CategoryCardModel(
            text: '양식',
            image: 'assets/images/category/western.jpeg',
            pushWidget: CategoryPageModel(category: '양식'),
          ),
          CategoryCardModel(
            text: '분식',
            image: 'assets/images/category/ksnack.jpeg',
            pushWidget: CategoryPageModel(category: '분식'),
          ),
          CategoryCardModel(
            text: '아시안',
            image: 'assets/images/category/asian.jpeg',
            pushWidget: CategoryPageModel(category: '아시안'),
          ),
          CategoryCardModel(
            text: '다양한 음식',
            image: 'assets/images/category/brunch.jpeg',
            pushWidget: CategoryPageModel(category: '다양한 음식'),
          ),
        ],
      ),
    );
  }
}
