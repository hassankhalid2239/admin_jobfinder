import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/snackbar.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});
  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _aboutDataFormKey = GlobalKey<FormState>();
  final TextEditingController _aboutmeController =
      TextEditingController(text: '');
  String? gender;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Snack snack = Snack();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _getAboutData();
  }

  Future _getAboutData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      _aboutmeController.text = ref.get('About Me');
    });
  }

  Future uploadAboutData() async {
    final isValid = _aboutDataFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final User? user = _auth.currentUser;
        final uid = user!.uid;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'About Me': _aboutmeController.text});
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              setState(() {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                    snack.successSnackBar(
                        'Congrats!', 'Changes saved successfully'));
              })
            });
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
              snack.errorSnackBar('On Error!', e.message.toString()));
        }
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
            Text('About Me', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text('Summary',
                style: Theme.of(context).textTheme.headlineMedium),
            trailing: Text(
              'Maximum 1000 words',
              style: GoogleFonts.dmSans(color: Colors.grey, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: _aboutDataFormKey,
            child: TextFormField(
              maxLines: 20,
              maxLength: 1000,
              textInputAction: TextInputAction.next,
              // focusNode: _passFocusNode,
              keyboardType: TextInputType.text,
              controller: _aboutmeController,
              style: Theme.of(context).textTheme.titleSmall,
              validator: (value) {
                if (value!.isEmpty) {
                  return;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                counterStyle: GoogleFonts.dmSans(
                    color: Theme.of(context).colorScheme.outline),
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
                hintText: 'Write your bio...',
                hintStyle: Theme.of(context).textTheme.bodySmall,
                enabledBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
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
          ),
          const SizedBox(
            height: 35,
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
                  uploadAboutData();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Submit',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
          ),
        ],
      ),
    );
  }
}
