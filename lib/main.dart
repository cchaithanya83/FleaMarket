import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fleamarket/firebase_options.dart';
import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
   @override
 void initState() {
 super.initState();
 _firebaseMessaging.requestPermission();
 FirebaseMessaging.instance.getInitialMessage();
 FirebaseMessaging.onMessage.listen((RemoteMessage message) {
 });
 FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
 });
 }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FleaMarket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
