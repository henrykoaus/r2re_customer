import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/restaurant_card_model.dart';
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/state_management/restaurant_card_display_provider.dart';

class GreatDealsDisplay extends StatefulWidget {
  const GreatDealsDisplay({super.key});

  @override
  State<GreatDealsDisplay> createState() => _GreatDealsDisplayState();
}

class _GreatDealsDisplayState extends State<GreatDealsDisplay> {
  @override
  Widget build(BuildContext context) {
    final restaurantDataProvider =
        Provider.of<RestaurantCardDisplayProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
      child: FutureBuilder<void>(
        future: restaurantDataProvider.fetchGreatDealRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      settingDialog(context);
                    },
                    child: const Text(
                      '위치 권한을 설정해 주셔야 합니다',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            );
          } else if (restaurantDataProvider.greatDealRestaurants.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '등록된 음식점이 아직 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return SizedBox(
              height: 230,
              width: 190,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount:
                    (restaurantDataProvider.greatDealRestaurants.length >= 30)
                        ? 30
                        : restaurantDataProvider.greatDealRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurantData =
                      restaurantDataProvider.greatDealRestaurants[index];
                  return RestaurantCardModel(data: restaurantData);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
