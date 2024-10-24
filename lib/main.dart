import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:horizon/Auth/horizon_login.dart';
import 'package:horizon/ui/horizon_homepage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.Debug.setLogLevel(OSLogLevel.error);
  OneSignal.initialize("231477b8-0c78-4672-805f-10bd6168cdef");
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? SignInScreen()
          : HorizonHomepage(),
    );
  }
}
