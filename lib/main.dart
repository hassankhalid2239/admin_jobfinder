import 'package:admin_jobfinder/presistent/prefrence.dart';
import 'package:admin_jobfinder/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/theme.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var ref = await SharedPreferences.getInstance();
  String theme;
  if (ref.getString('theme') != null) {
    theme = ref.getString('theme')!;
  } else {
    theme = 'System Default';
  }
  runApp(MyApp(theme: theme,));
}

class MyApp extends StatelessWidget {
  final String theme;
  MyApp({super.key, required this.theme});
  final pref = SharedPref();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JobFinderApp',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: theme == 'Light'
            ? ThemeMode.light
            : theme == 'Dark'
            ? ThemeMode.dark
            : ThemeMode.system,
        home: const SplashScreen());
  }
}
