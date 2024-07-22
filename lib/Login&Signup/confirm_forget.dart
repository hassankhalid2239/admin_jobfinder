import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/snackbar.dart';
import 'login_page.dart';

class ConfirmForget extends StatefulWidget {
  const ConfirmForget({super.key});

  @override
  State<ConfirmForget> createState() => _ConfirmForgetState();
}

class _ConfirmForgetState extends State<ConfirmForget> {
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
            snack.errorSnackBar('On Snap!', e.message.toString()));
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
        centerTitle: true,
        title:
            Text('Jobbook', style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/forget_mail.png'),
                const SizedBox(
                  height: 30,
                ),
                Text('Confirmation',
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    'Reset mail has been sent. Please check and then log in with your new password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  height: 150,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        logOut();
                      },
                      child: Text(
                        'Go to Login',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
