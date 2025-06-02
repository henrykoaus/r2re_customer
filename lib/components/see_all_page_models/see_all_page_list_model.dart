import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/state_management/purchased_deals_provider.dart';

class SeeAllPageListModel extends StatelessWidget {
  final TextEditingController textEditingController;
  final String title;
  final Widget Function(Map<String, dynamic> data) childWidget;

  const SeeAllPageListModel({
    super.key,
    required this.textEditingController,
    required this.title,
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final purchasedDealsProvider =
        Provider.of<PurchasedDealsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder<void>(
        future: purchasedDealsProvider.fetchAllPurchasedDeals(
            currentUser!.uid, textEditingController.text),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CircularProgressIndicator()));
          } else if (purchasedDealsProvider.allPurchasedDeals.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: const Center(
                child: Text(
                  '구매하신 딜이 없습니다.',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            );
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: AnimatedSearchBar(
                  label: '$title    ',
                  labelAlignment: Alignment.center,
                  labelStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  height: 50,
                  searchIcon: const Icon(
                    Icons.search,
                    key: ValueKey('search'),
                    size: 28,
                  ),
                  closeIcon: const Icon(
                    Icons.close,
                    key: ValueKey('close'),
                    size: 28,
                  ),
                  controller: textEditingController,
                  onChanged: (value) {
                    Provider.of<PurchasedDealsProvider>(context, listen: false)
                        .fetchAllPurchasedDeals(
                            currentUser.uid, textEditingController.text);
                  },
                  searchDecoration: InputDecoration(
                    hintText: '음식점을 검색해주세요.',
                    isDense: true,
                    prefixIconColor: Colors.grey,
                    suffixIconColor: Colors.grey,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              body: (purchasedDealsProvider.filteredPurchasedDeals.isNotEmpty)
                  ? ListView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: purchasedDealsProvider
                              .filteredPurchasedDeals.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> data =
                                purchasedDealsProvider
                                    .filteredPurchasedDeals[index]
                                    .data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: childWidget(data),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: size!.height / 4),
                      child: const Center(
                        child: Text(
                          '검색결과가 없습니다',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
