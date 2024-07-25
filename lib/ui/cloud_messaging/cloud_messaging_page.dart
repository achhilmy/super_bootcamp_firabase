import 'package:firebase_superbootcamp/helpers/fcm_helper.dart';
import 'package:firebase_superbootcamp/helpers/notification_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CloudMessagingPage extends StatelessWidget {
  const CloudMessagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Messaging Page"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
            valueListenable: NotificationHelper.payload,
            builder: (context, value, child) {
              final valueJson = FcmHelper.tryDecode(value);
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Notif title: ${valueJson['title']}'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Payload Notif:  ${valueJson['body']}'),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
