import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RestaurantInfo extends StatefulWidget {
  final Map<String, dynamic> data;

  const RestaurantInfo({super.key, required this.data});

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 90,
                child: AutoSizeText(
                  '가게정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  minFontSize: 10,
                  maxFontSize: 22,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ExpandIcon(
              isExpanded: _isExpanded,
              onPressed: (isExpanded) {
                setState(
                  () {
                    _isExpanded = !isExpanded;
                  },
                );
              },
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
        ),
        const SizedBox(
          height: 15,
        ),
        if (_isExpanded)
          Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: SizedBox(
                      width: 95,
                      child: AutoSizeText(
                        '영업시간',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        minFontSize: 10,
                        maxFontSize: 22,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['mon'] != null)
                                ? '월요일: ${widget.data["openingHours"]['mon']}'
                                : '월요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['tue'] != null)
                                ? '화요일: ${widget.data["openingHours"]['tue']}'
                                : '화요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['wed'] != null)
                                ? '수요일: ${widget.data["openingHours"]['wed']}'
                                : '수요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['thu'] != null)
                                ? '목요일: ${widget.data["openingHours"]['thu']}'
                                : '목요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['fri'] != null)
                                ? '금요일: ${widget.data["openingHours"]['fri']}'
                                : '금요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['sat'] != null)
                                ? '토요일: ${widget.data["openingHours"]['sat']}'
                                : '토요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['sun'] != null)
                                ? '일요일: ${widget.data["openingHours"]['sun']}'
                                : '일요일: ',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: SizedBox(
                      width: 95,
                      child: AutoSizeText(
                        '휴무일',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        minFontSize: 10,
                        maxFontSize: 22,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            (widget.data["openingHours"] != null &&
                                    widget.data["openingHours"]['holidays'] !=
                                        null)
                                ? '${widget.data["openingHours"]['holidays']}'
                                : '',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            minFontSize: 10,
                            maxFontSize: 22,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: SizedBox(
                      width: 95,
                      child: AutoSizeText(
                        '전화번호',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        minFontSize: 10,
                        maxFontSize: 22,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SelectableText(
                            (widget.data["telephone"] != null)
                                ? '${widget.data["telephone"]}'
                                : '등록된 전화번호가 아직 없습니다.',
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
