import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyContainer extends StatefulWidget {
  const PolicyContainer({super.key});

  @override
  State<PolicyContainer> createState() => _PolicyContainerState();
}

class _PolicyContainerState extends State<PolicyContainer> {
  final divider = const VerticalDivider(
    thickness: 0.5,
    width: 5,
    color: Colors.grey,
    indent: 18,
    endIndent: 18,
  );

  bool _isExpanded = false;

  final Uri _agreementUrl = Uri.parse('https://www.r2rekorea.com/privacy');
  final Uri _privacyPolicyUrl =
      Uri.parse('https://www.r2rekorea.com/r2re-privacy-policy');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                TextButton(
                  onPressed: () => setState(
                    () {
                      launchUrl(
                        _agreementUrl,
                      );
                    },
                  ),
                  child: const Text(
                    '이용약관',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                divider,
                TextButton(
                  onPressed: () => setState(
                    () {
                      launchUrl(
                        _privacyPolicyUrl,
                      );
                    },
                  ),
                  child: const Text(
                    '개인정보처리방침',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
                divider,
                TextButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ListView(
                          children: [
                            Column(
                              children: [
                                const ListTile(
                                  title: Text(
                                    '상호',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '알투레코리아',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '사업자등록번호',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '512-12-93999',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '대표자명',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '정현우',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '전화번호',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '070-8095-4157',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '전자우편',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'info@r2rekorea.com',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '신고현황',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '통신판매업',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '판매방식',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '인터넷, 기타',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '취급품목',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '기타',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '신고일자',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '20231215',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '주소',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '강원도 춘천시 서부대성로 327',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '인터넷도메인',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'https://www.r2rekorea.com/',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '통신판매번호',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const ListTile(
                                  title: Text(
                                    '통신판매업 신고기관명',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      enableDrag: true,
                      isDismissible: true,
                      showDragHandle: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      isScrollControlled: true,
                      useSafeArea: true,
                    );
                  },
                  child: const Text(
                    '사업자정보',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  '알투레코리아',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
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
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '대표자: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '정현우',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '사업자등록번호: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '512-12-93999',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '주소: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '강원도 춘천시 서부대성로 327',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '개인정보담당자: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'info@r2rekorea.com',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '고객센터: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '070-8095-4157',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '이메일문의: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'info@r2rekorea.com / butwookorea@gmail.com',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: '통신판매업신고: ',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '알투레코리아는 통신판매중개사로서 거래 당사자가 아니므로, 판매자가 등록한 상품정보 및 거래 등과 통신판매 당사자의 고의 또는 과실로 소비자에게 발생하는 손해에 대해 책임을 지지 않습니다. 상품 및 거래에 대한 정확한 정보는 해당 판매자에게 직접 확인바랍니다.',
              style: TextStyle(color: Colors.black45),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
