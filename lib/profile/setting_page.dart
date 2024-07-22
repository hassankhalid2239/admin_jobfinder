// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:admin_jobfinder/profile/theme_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Home/notification_list.dart';
import '../Login&Signup/forget_password_screen.dart';
import '../Login&Signup/login_page.dart';
import '../Widgets/snackbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool theme = false;
  final Snack snack = Snack();
  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
        ScaffoldMessenger.of(context).showSnackBar(
            snack.errorSnackBar('On Error!', 'No Internet Connection'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            snack.errorSnackBar('On Error!', e.message.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        centerTitle: true,
        title:
            Text('Setting', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: ListView(
        children: [
          //Dark mode
          Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ThemeScreen()));
                },
                style: const ButtonStyle(
                    splashFactory: InkRipple.splashFactory,
                    overlayColor: MaterialStatePropertyAll(Color(0x4d5800ff)),
                    elevation: MaterialStatePropertyAll(0),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    shape:
                        MaterialStatePropertyAll(ContinuousRectangleBorder())),
                child: ListTile(
                    leading: Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Theme.of(context).colorScheme.outline,
                    )),
              )),
          ListTile(
            leading: Text(
              'General',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          //General Section
          Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text('Application History',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            child: const ForgetPasswordScreen(),
                            type: PageTransitionType.rightToLeft,
                          ));
                    },
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text('Change Password',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            child: const NotificationListScreen(),
                            type: PageTransitionType.rightToLeft,
                          ));
                    },
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text('Notifications',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              )),
          ListTile(
            leading: Text(
              'Help',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text('Give Feedback',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text(
                        'Privacy & Policy',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())),
                    child: ListTile(
                      leading: Text('Help Center',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Text('Version',
                        style: Theme.of(context).textTheme.titleSmall),
                    trailing: Text('v1.0',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      splashFactory: InkRipple.splashFactory,
                      backgroundColor: const Color(0xff5800FF),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () => logOut(),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
