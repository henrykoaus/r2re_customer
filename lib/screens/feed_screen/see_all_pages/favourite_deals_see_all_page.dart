import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/restaurant_card_model.dart';
import 'package:r2re/state_management/restaurant_card_display_provider.dart';

class FavouriteDealsSeeAllPage extends StatelessWidget {
  const FavouriteDealsSeeAllPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final restaurantDataProvider =
        Provider.of<RestaurantCardDisplayProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('내가 찜한 딜s'),
        ),
        body: FutureBuilder<void>(
          future: restaurantDataProvider
              .fetchFavouriteRestaurants(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()));
            } else if (restaurantDataProvider.favouriteRestaurants.isEmpty) {
              return const Center(
                child: Text(
                  '찜하신 음식점이 아직 없습니다.',
                  style: TextStyle(fontSize: 22),
                ),
              );
            } else {
              return ListView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 2, 30),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.shortestSide < 600
                                ? 2
                                : 4,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                      ),
                      itemCount:
                          restaurantDataProvider.favouriteRestaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final restaurantData =
                            restaurantDataProvider.favouriteRestaurants[index];
                        return RestaurantCardModel(data: restaurantData);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
