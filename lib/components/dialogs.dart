import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void dialogIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void generalDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      title: Text(
        ' \n $message',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      actions: [
        Center(
          child: Wrap(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.pinkAccent,
                ),
                child: const Text(
                  '닫기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void settingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          "권한 설정을 확인해주세요.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              '설정하기',
              style: TextStyle(color: Colors.black87, fontSize: 17),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.black87, fontSize: 17),
            ),
          ),
        ],
      );
    },
  );
}
