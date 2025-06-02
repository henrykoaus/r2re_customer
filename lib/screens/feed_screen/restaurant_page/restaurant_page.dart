// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/deal_purchase_screen/deal_purchase_page.dart';
import 'package:r2re/state_management/favourite_provider.dart';
import 'package:r2re/state_management/bootpay_request_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2re/screens/feed_screen/card_displays/bonus_card_display.dart';
import 'package:r2re/screens/feed_screen/restaurant_page/restaurant_page_body/restaurant_page_body.dart';

class RestaurantPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const RestaurantPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late ScrollController _scrollController;
  static const kExpandedHeight = 240.0;

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payRequestProvider = Provider.of<BootPayRequestProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          sliverAppBar(),
          restaurantName(),
          BonusCardDisplay(data: widget.data),
          RestaurantPageBody(data: widget.data),
          bottomSizedBox(),
        ],
      ),
      bottomSheet: bottomSheet(context, payRequestProvider),
    );
  }

  SliverAppBar sliverAppBar() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    return SliverAppBar(
      leading: BackButton(
        color: _isSliverAppBarExpanded ? Colors.black87 : Colors.white,
      ),
      title: _isSliverAppBarExpanded
          ? Text(
              widget.data["name"] ?? '',
            )
          : null,
      centerTitle: true,
      pinned: true,
      snap: false,
      floating: false,
      stretch: true,
      expandedHeight: kExpandedHeight,
      flexibleSpace: _isSliverAppBarExpanded
          ? null
          : FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                width: MediaQuery.of(context).size.width,
                decoration: (widget.data["image"] != null)
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.data["image"]),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/basic_photo.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
      actions: [
        FutureBuilder<bool>(
          future: favouritesProvider.isLiked(
              currentUser!.uid, widget.data["name"], widget.data["unique"]),
          builder: (context, snapshot) {
            bool isLiked = snapshot.data ?? false;
            return IconButton(
              icon: isLiked
                  ? const Icon(CupertinoIcons.heart_fill, color: Colors.pink)
                  : Icon(CupertinoIcons.heart,
                      color: _isSliverAppBarExpanded
                          ? Colors.black87
                          : Colors.white),
              onPressed: () {
                if (isLiked) {
                  favouritesProvider.removeFavoriteItem(currentUser.uid,
                      widget.data["name"], widget.data["unique"]);
                } else {
                  favouritesProvider.addFavoriteItem(currentUser.uid,
                      widget.data["name"], widget.data["unique"]);
                }
              },
            );
          },
        ),
      ],
    );
  }

  SliverList restaurantName() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
          child: Text(
            widget.data["name"] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
      ),
    );
  }

  SliverList bottomSizedBox() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) => const SizedBox(
          height: 140,
        ),
      ),
    );
  }

  Container bottomSheet(
      BuildContext context, BootPayRequestProvider payRequestProvider) {
    return Container(
      height: size!.height / 9.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(0, -5), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: size!.height / 16,
          width: size!.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.pinkAccent,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DealPurchasePage(data: widget.data)),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.discount,
                  color: Colors.white,
                ),
                AutoSizeText(
                  '  딜 구매하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  minFontSize: 10,
                  maxFontSize: 30,
                  maxLines: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
