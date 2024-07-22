// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Widgets/snackbar.dart';
import '../main_page.dart';
import 'forget_password_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();
  final Snack snack = Snack();
  final TextEditingController _emailTextControler =
      TextEditingController(text: '');
  final TextEditingController _passTextControler =
      TextEditingController(text: '');
  bool _obsecuretext = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextControler.text.trim().toLowerCase(),
            password: _passTextControler.text.trim());
        String uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot usnap =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        bool utype = usnap.get('User Type');
        if (utype == false) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const MainPage(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 500)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              snack.errorSnackBar('On Error!', 'Please correct credentials'));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.message ==
            'The supplied auth credential is incorrect, malformed or has expired.') {
          ScaffoldMessenger.of(context).showSnackBar(snack.errorSnackBar(
              'On Error!', 'Email and password are incorrect'));
        } else if (e.message ==
            'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          ScaffoldMessenger.of(context).showSnackBar(
              snack.errorSnackBar('On Error!', 'No Internet Connection'));
        } else if (e.message ==
            'We have blocked all requests from this device due to unusual activity. Try again later.') {
          ScaffoldMessenger.of(context).showSnackBar(snack.errorSnackBar(
              'On Error!', 'Too many attempts please try later'));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              snack.errorSnackBar('On Error!', e.message.toString()));
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permissions');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permissions');
      }
    } else {
      if (kDebugMode) {
        print('User denied permissions');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    _emailTextControler.dispose();
    _passTextControler.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.onSurface,
              statusBarIconBrightness: Theme.of(context).brightness),
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.053, right: w * 0.053),
            // padding: EdgeInsets.only(left: 20.w,right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey, There 👋\nfind talent here!',
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(
                  height: h * 0.01,
                ),
                Text('Enter your email address and password\nto use the app',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 30),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email',
                          style: Theme.of(context).textTheme.labelSmall),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextControler,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email should not be empty!';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email!';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Email',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(
                            Icons.mail_outline_sharp,
                            size: 20,
                            color: Colors.grey,
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.red,
                          )),
                        ),
                      ),
                      SizedBox(height: h * 0.037),
                      Text('Password',
                          style: Theme.of(context).textTheme.labelSmall),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextControler,
                        obscureText: !_obsecuretext,
                        //Change it dynamically
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password should not be empty!';
                          } else if (value.length < 8) {
                            return 'Password Should be at least 8 Characters';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obsecuretext = !_obsecuretext;
                              });
                            },
                            child: Icon(
                              _obsecuretext
                                  ? Icons.visibility_off_sharp
                                  : Icons.visibility_sharp,
                              color: Colors.grey,
                            ),
                          ),
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Password',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(
                            Icons.lock_outline_sharp,
                            size: 20,
                            color: Colors.grey,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const ForgetPasswordScreen(),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 300)));
                      },
                      child: Text('Forget Password?',
                          style: Theme.of(context).textTheme.bodyMedium)),
                ),
                SizedBox(
                  height: h * 0.019,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () => _submitFormOnLogin(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Login',
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
