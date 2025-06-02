import 'package:flutter/material.dart';
import 'package:r2re/components/card_models/purchased_card_models/purchased_deal_card_model.dart';
import 'package:r2re/components/see_all_page_models/see_all_page_list_model.dart';

class SeeAllPurchasedDeals extends StatefulWidget {
  const SeeAllPurchasedDeals({
    super.key,
  });

  @override
  State<SeeAllPurchasedDeals> createState() => _SeeAllPurchasedDealsState();
}

class _SeeAllPurchasedDealsState extends State<SeeAllPurchasedDeals> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SeeAllPageListModel(
      textEditingController: _textEditingController,
      title: '내 알투레 딜s',
      childWidget: (Map<String, dynamic> data) => PurchasedDealCardModel(
        data: data,
        imageSize: 10,
      ),
    );
  }
}
