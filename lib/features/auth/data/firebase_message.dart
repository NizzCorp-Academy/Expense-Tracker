import 'package:firebase_messaging/firebase_messaging.dart';
class Firbase_Message {
 final _firebase_message = FirebaseMessaging.instance; 

 Future<void>initNotifications() async{
await _firebase_message.requestPermission();

final FCMToken = await _firebase_message.getToken();

print('Token: $FCMToken');
 }
}