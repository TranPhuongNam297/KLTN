import 'package:flutter/material.dart';


class ConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirmed;

  ConfirmDialog({required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận thoát', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: Text('Bạn có muốn thoát ra ngoài khi chưa làm xong không?', style: TextStyle(fontSize: 20)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(false),
          child: Text('Không', style: TextStyle(fontSize: 20)),
        ),
        TextButton(
          onPressed: onConfirmed,
          child: Text('Có', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
