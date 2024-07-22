// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Widgets/snackbar.dart';
import '../presistent/presestent.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final Snack snack = Snack();

  final TextEditingController _industryText = TextEditingController(text: '');
  final TextEditingController _websiteText = TextEditingController(text: '');
  final TextEditingController _companySizeText =
      TextEditingController(text: '');
  final TextEditingController _foundedDateText =
      TextEditingController(text: '');
  final TextEditingController _companyTypeText =
      TextEditingController(text: '');
  final TextEditingController _locationtext = TextEditingController(text: '');
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  final _profileDataFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  String? userName;
  String? ownerEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileDetailData();
  }

  Future _submitJobData() async {
    final isValid = _profileDataFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Details')
            .doc(uid)
            .set({
          'uid': uid,
          'Website': _websiteText.text,
          'Industry': _industryText.text,
          'CompanySize': _companySizeText.text,
          'CompanyType': _companyTypeText.text,
          'Location': _locationtext.text,
          'FoundedAT': _foundedDateText.text,
        });
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              setState(() {
                _isLoading = false;
                // Fluttertoast.showToast(
                //     msg: 'Job Posted', toastLength: Toast.LENGTH_SHORT);
              })
            });
        ScaffoldMessenger.of(context).showSnackBar(
            snack.successSnackBar('Congrats!', 'Changes saved successfully'));
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
              snack.errorSnackBar('Oh Snap!', e.message.toString()));
        }
      }
    }
  }

  Future _getProfileDetailData() async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Details')
        .doc(uid)
        .get();
    setState(() {
      _websiteText.text = ref.get('Website');
      _industryText.text = ref.get('Industry');
      _companySizeText.text = ref.get('CompanySize');
      _companyTypeText.text = ref.get('CompanyType');
      _locationtext.text = ref.get('Location');
      _foundedDateText.text = ref.get('FoundedAT');
    });
  }

  _showIndustriesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                'Industries',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.industries.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _industryText.text = Presistent.industries[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.industries[index],
                            style: Theme.of(context).textTheme.titleSmall));
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }

  _showCompanySizeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Company Size',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.companySizeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _companySizeText.text =
                                Presistent.companySizeList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.companySizeList[index],
                            style: Theme.of(context).textTheme.titleSmall));
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }

  _showCompanyTypeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Company Type',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.companyTypeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _companyTypeText.text =
                                Presistent.companyTypeList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.companyTypeList[index],
                            style: Theme.of(context).textTheme.titleSmall));
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
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
          title: Text('Detail Screen',
              style: Theme.of(context).textTheme.labelMedium),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tell us more details",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Please enter few details below.',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _profileDataFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Website
                        Text('Website',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.url,
                          controller: _websiteText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'website should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Begin with http://, https:// or www.',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
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
                        const SizedBox(
                          height: 20,
                        ),
                        //Industry
                        Text('Industry',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _industryText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select Industry!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Select Industry',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Theme.of(context).colorScheme.outline,
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
                          onTap: () {
                            _showIndustriesDialog();
                          },
                        ),
                        //Company Size
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Company Size',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _companySizeText,
                          onTap: () {
                            _showCompanySizeDialog();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Company size should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Select Company size',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            prefixIcon: const Icon(
                              Icons.title_outlined,
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
                        //Location
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Location',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _locationtext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Location should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'ex: Islamabad, Pakistan',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
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
                        const SizedBox(
                          height: 20,
                        ),
                        //Company Type
                        Text('Company Type',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _companyTypeText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select Company size!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Select Company size',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Theme.of(context).colorScheme.outline,
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
                          onTap: () {
                            _showCompanyTypeDialog();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Founded
                        Text('Founded At',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.none,
                          style: Theme.of(context).textTheme.titleSmall,
                          controller: _foundedDateText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date is not empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Select date',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            suffixIcon: const Icon(
                              Icons.date_range_outlined,
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
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                builder: (context, child) => Theme(
                                      data: ThemeData().copyWith(
                                          colorScheme: ColorScheme.light(
                                              background: Theme.of(context)
                                                  .colorScheme
                                                  .background)),
                                      child: child!,
                                    ),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              setState(() {
                                _foundedDateText.text =
                                    DateFormat('y').format(pickedDate);
                              });
                            }
                          },
                        )
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
                          _submitJobData();
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
        ));
  }
}
