import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:r2re/components/dialogs.dart';
import 'package:r2re/env/env.dart';
import 'dart:convert';

import 'package:r2re/screens/profile_screen/pages_in_profile/restaurant_suggestion/document_class.dart';

class RestaurantSuggestionPage extends StatefulWidget {
  const RestaurantSuggestionPage({super.key});

  @override
  State<RestaurantSuggestionPage> createState() =>
      _RestaurantSuggestionPageState();
}

class _RestaurantSuggestionPageState extends State<RestaurantSuggestionPage> {
  final TextEditingController _kakaoTextEditingController =
      TextEditingController();

  List<DocumentData> dataList = [];
  List<String> selectedStores = [];

  Future<void> getJSONData() async {
    final baseUrl =
        'https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=FD6,CE7&query=${_kakaoTextEditingController.text}';
    var getResponse = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "KakaoAK ${Env.kakao_restapi}",
        "content-type": "application/json;charset=UTF-8",
      },
    );
    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(getResponse.body);
      final List<dynamic> documents = responseData['documents'];
      setState(() {
        dataList =
            documents.map((json) => DocumentData.fromJson(json)).toList();
      });
    } else {
      getResponse.statusCode;
    }
  }

  @override
  void dispose() {
    _kakaoTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('음식점 추천하기'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              children: [
                searchBar(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      selectedStoreCard(),
                      dataList.isNotEmpty
                          ? searchingDataList()
                          : const SizedBox(),
                    ],
                  ),
                ),
                submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox searchBar() {
    return SizedBox(
      height: 48,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: searchBarTextField(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextField searchBarTextField() {
    return TextField(
      controller: _kakaoTextEditingController,
      onChanged: (value) => getJSONData(),
      decoration: searchBarDecor('음식점을 검색해주세요.'),
      cursorColor: Colors.grey,
    );
  }

  InputDecoration searchBarDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search),
      prefixIconColor: Colors.grey,
      suffixIcon: _kakaoTextEditingController.text.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _kakaoTextEditingController.clear();
                setState(() {
                  dataList.clear();
                });
              },
            ),
      suffixIconColor: Colors.grey,
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(13));
  }

  Visibility selectedStoreCard() {
    return Visibility(
      visible: dataList.isNotEmpty ? false : true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: selectedStores.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(selectedStores[index]),
              onDismissed: (direction) {
                setState(() {
                  selectedStores.removeAt(index);
                });
              },
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent[200],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            selectedStores[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 16,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedStores.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ListView searchingDataList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(dataList[index].name),
          subtitle: Text(dataList[index].addressName),
          trailing: Text(dataList[index].category),
          onTap: () {
            setState(
              () {
                selectedStores.add(dataList[index].name);
                dataList.clear();
              },
            );
          },
        );
      },
    );
  }

  Visibility submitButton(BuildContext context) {
    final CollectionReference restaurantSuggestionCollection =
        FirebaseFirestore.instance.collection('suggestion');
    return Visibility(
      visible: dataList.isNotEmpty ? false : true,
      child: ElevatedButton(
        onPressed: () async {
          if (selectedStores.isNotEmpty) {
            dialogIndicator(context);
            Map<String, dynamic> suggestionData = {
              'selectedStores': selectedStores,
            };
            await restaurantSuggestionCollection.add(suggestionData);
            if (context.mounted) {
              Navigator.of(context).pop();
              if (context.mounted) {
                Navigator.of(context).pop();
                if (context.mounted) {
                  generalDialog(context, '음식점이 추천되었습니다.');
                }
              }
            }
          } else {
            generalDialog(context, '음식점을 찾아 추천해주세요.');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            ' 추천하기 ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
