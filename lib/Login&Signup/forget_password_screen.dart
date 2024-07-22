import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/snackbar.dart';
import 'confirm_forget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FocusNode _passFocusNode = FocusNode();
  final _forgetFormKey = GlobalKey<FormState>();
  final TextEditingController _forgetpassText = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Snack snack = Snack();

  Future _forgetPassSubmitForm() async {
    final isValid = _forgetFormKey.currentState!.validate();
    try {
      if (isValid) {
        setState(() {
          _isLoading = true;
        });
        await _auth.sendPasswordResetEmail(email: _forgetpassText.text.trim());
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ConfirmForget()),
            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(snack.helpSnackBar('Hi There!', 'Check mail box'));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.message ==
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
        ScaffoldMessenger.of(context).showSnackBar(
            snack.errorSnackBar('On Error!', 'No Internet Connection'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            snack.errorSnackBar('On Snap!', e.message.toString()));
      }
    }
    setState(() {
      _isLoading = false;
    });
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset Password',
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    "Always keep your account secure and\ndon't forget to update it",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _forgetFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Email Account',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _forgetpassText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email shuold not be empty!';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address!';
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
                          hintText: 'Enter Your Email',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(
                            Icons.mail_outline_sharp,
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
                const SizedBox(
                  height: 30,
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
                      onPressed: () => _forgetPassSubmitForm(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Reset Now',
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
