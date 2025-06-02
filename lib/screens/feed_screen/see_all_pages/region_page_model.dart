import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/restaurant_card_model.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/state_management/see_all_page_provider.dart';

class RegionPageModel extends StatefulWidget {
  final String region;

  const RegionPageModel({super.key, required this.region});

  @override
  State<RegionPageModel> createState() => _RegionPageModelState();
}

class _RegionPageModelState extends State<RegionPageModel> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seeAllPageProvider =
        Provider.of<SeeAllPageProvider>(context, listen: false);
    return FutureBuilder<void>(
      future: (searchQuery) {
        return seeAllPageProvider.fetchRestaurantsByRegion(
            widget.region, _textEditingController.text);
      }(_textEditingController.text),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (seeAllPageProvider.regionDocs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.region),
            ),
            body: const Center(
              child: Text(
                '등록된 음식점이 없습니다.',
                style: TextStyle(fontSize: 22),
              ),
            ),
          );
        } else {
          return Consumer<SeeAllPageProvider>(
            builder: (context, seeAllPageProvider, child) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    forceMaterialTransparency: true,
                    title: AnimatedSearchBar(
                      label: '${widget.region}    ',
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
                      controller: _textEditingController,
                      onChanged: (value) {
                        (searchQuery) {
                          return seeAllPageProvider.fetchRestaurantsByRegion(
                              widget.region, _textEditingController.text);
                        }(value);
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
                  body: seeAllPageProvider.filteredDocs.isNotEmpty
                      ? ListView(
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
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.shortestSide <
                                              600
                                          ? 2
                                          : 4,
                                  childAspectRatio: 0.9,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                ),
                                itemCount:
                                    seeAllPageProvider.filteredDocs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final restaurantData = seeAllPageProvider
                                      .filteredDocs[index]
                                      .data() as Map<String, dynamic>;
                                  return RestaurantCardModel(
                                      data: restaurantData);
                                },
                              ),
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
                ),
              );
            },
          );
        }
      },
    );
  }
}
