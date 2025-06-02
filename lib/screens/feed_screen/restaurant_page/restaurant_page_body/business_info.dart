import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BusinessInfo extends StatefulWidget {
  final Map<String, dynamic> data;

  const BusinessInfo({super.key, required this.data});

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
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
                  '사업자정보',
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
                      width: 110,
                      child: AutoSizeText(
                        '상호명',
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
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            '${widget.data["name"]}',
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
                      width: 110,
                      child: AutoSizeText(
                        '대표자명',
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
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            '${widget.data["ownerName"]}',
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
                      width: 110,
                      child: AutoSizeText(
                        '사업자등록번호',
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
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            '${widget.data["registration"]}',
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
            ],
          ),
      ],
    );
  }
}
