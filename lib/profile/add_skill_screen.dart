import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/snackbar.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  final TextEditingController _skilltext = TextEditingController(text: '');
  bool _isLoading = false;
  final Snack snack = Snack();
  final User? _user = FirebaseAuth.instance.currentUser;

  Future _submitExpData() async {
    final isValid = _addExpFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance
            .collection('Users')
            .doc(_user?.uid)
            .collection('Skills')
            .doc(id)
            .set({
          'id': id,
          'Title': _skilltext.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            snack.successSnackBar('Congrats!', 'Skill added successfully'));
        // SnackBar(
        //   content: Text('Skill Added'),
        // );
        Navigator.pop(context);
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
        centerTitle: true,
        title:
            Text('Add Skills', style: Theme.of(context).textTheme.labelMedium),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _addExpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text('Skill',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _skilltext,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Skill is a required field!';
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
                          hintText: 'Ex: UI/UX Designer',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
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
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        _submitExpData();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Save',
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
