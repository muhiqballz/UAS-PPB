import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const NotificationPopup({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Notifikasi Terbaru',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: notifications.map((notification) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  notification['icon'],
                  color: notification['color'],
                ),
                title: Text(
                  notification['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                subtitle: Text(
                  notification['message'],
                  style: TextStyle(
                    color: const Color(0xFF2C3E50).withOpacity(0.7),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Tutup',
            style: TextStyle(
              color: Color(0xFF3498DB),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
