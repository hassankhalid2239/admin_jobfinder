// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../presistent/prefrence.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  var pref = SharedPref();
  String? theme;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getValue();
  }

  void restartApp() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp(
                  theme: theme!,
                )),
        (route) => false);
  }

  getValue() async {
    var re = await SharedPreferences.getInstance();
    setState(() {
      theme = re.getString('theme');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        // if(gender!=null){
        //   _submitExpData();
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.onSurface,
              statusBarIconBrightness: Theme.of(context).brightness),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          centerTitle: true,
          title:
              Text('$theme', style: Theme.of(context).textTheme.displayMedium),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _addExpFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gender
                        RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Light',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            activeColor: const Color(0xff5800FF),
                            fillColor: const MaterialStatePropertyAll(
                                Color(0xff5800FF)),
                            value: 'Light',
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                pref.setData(value);
                                theme = value.toString();
                              });
                              restartApp();
                            }),
                        RadioListTile(
                            activeColor: const Color(0xff5800FF),
                            fillColor: const MaterialStatePropertyAll(
                                Color(0xff5800FF)),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Dark',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            value: 'Dark',
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                pref.setData(value);
                                theme = value.toString();
                              });
                              restartApp();
                            }),
                        RadioListTile(
                            activeColor: const Color(0xff5800FF),
                            fillColor: const MaterialStatePropertyAll(
                                Color(0xff5800FF)),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'System Default',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            value: 'System Default',
                            groupValue: theme,
                            onChanged: (value) {
                              setState(() {
                                pref.setData(value);
                                theme = value.toString();
                              });
                              restartApp();
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
