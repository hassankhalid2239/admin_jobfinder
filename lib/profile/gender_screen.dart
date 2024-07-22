// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgets/snackbar.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  String? gender;
  final User? _user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final Snack snack = Snack();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGenderData();
  }

  Future _getGenderData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      gender = ref.get('Gender');
    });
  }

  Future _submitGenData() async {
    final isValid = _addExpFormKey.currentState!.validate();
    if (isValid) {
      try {
        final uid = _user!.uid;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'Gender': gender});
        ScaffoldMessenger.of(context).showSnackBar(
            snack.successSnackBar('Congrats!', 'Changes saved successfully'));
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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (gender != null) {
          _submitGenData();
        }
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
              Text('Gender', style: Theme.of(context).textTheme.displayMedium),
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
                              'Male',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            activeColor: const Color(0xff5800FF),
                            fillColor:
                                const WidgetStatePropertyAll(Color(0xff5800FF)),
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            activeColor: const Color(0xff5800FF),
                            fillColor: const MaterialStatePropertyAll(
                                Color(0xff5800FF)),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Female',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            activeColor: const Color(0xff5800FF),
                            fillColor: const MaterialStatePropertyAll(
                                Color(0xff5800FF)),
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Others',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            value: 'Others',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
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
