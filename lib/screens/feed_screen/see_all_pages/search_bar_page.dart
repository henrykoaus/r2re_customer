import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/components/card_models/restaurant_card_model.dart';
import 'package:r2re/state_management/see_all_page_provider.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key}) : super(key: key);

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
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
      future:
          seeAllPageProvider.fetchAllRestaurants(_textEditingController.text),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (seeAllPageProvider.allDocs.isEmpty) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(
                  child: Text(
                '등록된 음식점이 없습니다.',
                style: TextStyle(fontSize: 22),
              )));
        } else {
          return Consumer<SeeAllPageProvider>(
            builder: (context, seeAllPageProvider, child) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 48,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const BackButton(),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: TextField(
                                            controller: _textEditingController,
                                            onChanged: (value) {
                                              (searchQuery) {
                                                return seeAllPageProvider
                                                    .fetchAllRestaurants(
                                                        _textEditingController
                                                            .text);
                                              }(value);
                                            },
                                            decoration: InputDecoration(
                                                hintText: '음식점을 검색해주세요.',
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                prefixIconColor: Colors.grey,
                                                suffixIcon:
                                                    _textEditingController
                                                            .text.isEmpty
                                                        ? null
                                                        : IconButton(
                                                            icon: const Icon(
                                                                Icons.clear),
                                                            onPressed: () {
                                                              _textEditingController
                                                                  .clear();
                                                              seeAllPageProvider
                                                                  .fetchAllRestaurants(
                                                                      _textEditingController
                                                                          .text);
                                                            },
                                                          ),
                                                suffixIconColor: Colors.grey,
                                                enabledBorder: inputBorder(),
                                                focusedBorder: inputBorder(),
                                                filled: true,
                                                fillColor: Colors.grey[100]),
                                            cursorColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: seeAllPageProvider.filteredDocs.isNotEmpty
                                ? ListView(
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
                                          itemCount: seeAllPageProvider
                                              .filteredDocs.length,
                                          itemBuilder: (context, index) {
                                            final restaurantData =
                                                seeAllPageProvider
                                                        .filteredDocs[index]
                                                        .data()
                                                    as Map<String, dynamic>;
                                            return RestaurantCardModel(
                                                data: restaurantData);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size!.height / 4),
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
                ),
              );
            },
          );
        }
      },
    );
  }
}

OutlineInputBorder inputBorder() {
  return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(13));
}
