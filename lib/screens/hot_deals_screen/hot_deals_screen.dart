import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/restaurant_card_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/screens/hot_deals_screen/components/hot_deals_app_bar.dart';
import 'package:r2re/state_management/hot_deals_provider.dart';

class HotDealsScreen extends StatefulWidget {
  const HotDealsScreen({super.key});

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotDealsProvider =
        Provider.of<HotDealsProvider>(context, listen: false);
    return FutureBuilder<void>(
      future: hotDealsProvider
          .fetchHotDealsRestaurants(_textEditingController.text),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (hotDealsProvider.hotDealsDocs.isEmpty) {
          return Scaffold(
              appBar: AppBar(),
              body: const SafeArea(
                child: Column(
                  children: [
                    HotDealsAppBar(),
                    Expanded(
                      child: Center(
                        child: Text(
                          '핫딜 제공 음식점이 아직 없습니다.',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return Consumer<HotDealsProvider>(
            builder: (context, hotDealsProvider, child) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Column(
                      children: [
                        const HotDealsAppBar(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: size!.width / 1.5,
                                child: const AutoSizeText(
                                  'Tip: 핫딜이란 50% 이상 딜을 의미해요',
                                  style: TextStyle(
                                      color: Colors.pinkAccent, fontSize: 16),
                                  maxFontSize: 16,
                                  minFontSize: 12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextField(
                            controller: _textEditingController,
                            onChanged: (value) {
                              (searchQuery) {
                                return hotDealsProvider
                                    .fetchHotDealsRestaurants(
                                        _textEditingController.text);
                              }(value);
                            },
                            decoration: InputDecoration(
                                hintText: '근처 핫딜s 제공 음식점을 검색해보세요.',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor: Colors.black54,
                                suffixIcon: _textEditingController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _textEditingController.clear();
                                          hotDealsProvider
                                              .fetchHotDealsRestaurants(
                                                  _textEditingController.text);
                                        },
                                      ),
                                suffixIconColor: Colors.black54,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black54,
                                    ),
                                    borderRadius: BorderRadius.circular(24)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.purple,
                                    ),
                                    borderRadius: BorderRadius.circular(24)),
                                filled: true,
                                fillColor: Colors.grey[100]),
                            cursorColor: Colors.black54,
                          ),
                        ),
                        Expanded(
                          child: hotDealsProvider.filteredDocs.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 30),
                                        child: GridView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          keyboardDismissBehavior:
                                              ScrollViewKeyboardDismissBehavior
                                                  .onDrag,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                MediaQuery.of(context)
                                                            .size
                                                            .shortestSide <
                                                        600
                                                    ? 2
                                                    : 4,
                                            childAspectRatio: 0.9,
                                            mainAxisSpacing: 0,
                                            crossAxisSpacing: 0,
                                          ),
                                          itemCount: hotDealsProvider
                                              .filteredDocs.length,
                                          itemBuilder: (context, index) {
                                            final restaurantData =
                                                hotDealsProvider
                                                        .filteredDocs[index]
                                                        .data()
                                                    as Map<String, dynamic>;
                                            return RestaurantCardModel(
                                                data: restaurantData);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding:
                                      EdgeInsets.only(bottom: size!.height / 4),
                                  child: const Center(
                                    child: Text(
                                      '검색결과가 없습니다',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
