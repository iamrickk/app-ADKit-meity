import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget{
  const NotificationScreen({Key?key}):super(key:key);
  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context){
    final message = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${message}')
          ],
        ),
      ),
    );
  }
}