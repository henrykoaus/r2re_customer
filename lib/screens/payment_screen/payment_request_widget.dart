import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2re/components/card_models/payment_request_card.dart';
import 'package:r2re/constants/screen_size.dart';
import 'package:r2re/state_management/payment_request_provider.dart';

class PaymentRequestWidget extends StatelessWidget {
  const PaymentRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final paymentRequestProvider =
        Provider.of<PaymentRequestProvider>(context, listen: false);
    return FutureBuilder<void>(
      future: paymentRequestProvider.fetchPaymentRequest(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (paymentRequestProvider.paymentRequest.isEmpty) {
          return const SizedBox();
        } else {
          return Container(
            constraints: BoxConstraints(
              maxHeight: (paymentRequestProvider.paymentRequest.length >= 2)
                  ? size!.height / 3.8
                  : size!.height / 6,
            ),
            child: Flex(
              direction: Axis.vertical,
              children: [
                const Text(
                  '💬음식점 계산중',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: paymentRequestProvider.paymentRequest.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: PaymentRequestCard(
                          data: paymentRequestProvider.paymentRequest[index],
                        ),
                      );
                    },
                  ),
                ),
                (paymentRequestProvider.paymentRequest.isNotEmpty)
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(),
                (paymentRequestProvider.paymentRequest.isNotEmpty)
                    ? const Divider(
                        height: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      )
                    : const SizedBox(),
                (paymentRequestProvider.paymentRequest.isNotEmpty)
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(),
              ],
            ),
          );
        }
      },
    );
  }
}
