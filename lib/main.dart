// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/resources/language_model.dart';
import 'package:thefirstone/ui/splash.dart';
import 'l10n/l10n.dart';
import 'ui/api/firebase_api.dart';
import 'ui/sample_pages/notification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageModel()),
      ChangeNotifierProvider(create: (context) => FirebaseAuthProvider()),
    ],
    child: MyApp(),
  ));
}

// final _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var ins;

  @override
  void initState() {
    super.initState();
    // Screen.keepOn(true);
    // Keep the screen on.
    // KeepScreenOn.turnOn();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      Permission.notification
    ].request();

    final info = statuses[Permission.storage].toString();
    // print(info);
  }

  // _getScreen() {
  //   // print(_auth.currentUser!.uid);
  //   if (_auth != null) {
  //     if (_auth.currentUser != null) {
  //       // if (!_auth.currentUser!.uid.isEmpty)
  //       // return DoctorsPage();
  //       return Profiles();
  //     }
  //   }
  //   // return Profiles();
  //   return LoginPage();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADKit',
      theme: ThemeData(
        primaryColor: Colors.white,
        // accentColor: Color(0xFFFCF0E7),
        colorScheme: ThemeData.light().colorScheme.copyWith(
              secondary:
                  const Color(0xFFFCF0E7), // Set your custom accent color here
            ),
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const splash_screen(),
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen()
      },
      locale: Locale(Provider.of<LanguageModel>(context).currentLocale),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
