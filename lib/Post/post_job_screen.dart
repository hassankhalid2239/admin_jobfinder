// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Widgets/snackbar.dart';
import '../presistent/presestent.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final Snack snack = Snack();

  final TextEditingController _jobCategoryText =
      TextEditingController(text: '');
  final TextEditingController _jobTitleText = TextEditingController(text: '');
  final TextEditingController _jobTypeText = TextEditingController(text: '');
  final TextEditingController _jobLocationText =
      TextEditingController(text: '');
  final TextEditingController _jobDescription = TextEditingController(text: '');
  final TextEditingController _jobRecruitment = TextEditingController(text: '');
  final TextEditingController _jobSalaryText = TextEditingController(text: '');
  final TextEditingController _jobExperienceText =
      TextEditingController(text: '');
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  final _jobFDataFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  String? userName;
  String? ownerEmail;

  Future _submitJobData() async {
    final isValid = _jobFDataFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance.collection('Jobs').doc(id).set({
          'uid': uid,
          'id': id,
          'JobCategory': _jobCategoryText.text,
          'JobTitle': _jobTitleText.text,
          'JobType': _jobTypeText.text,
          'JobSalary': _jobSalaryText.text,
          'JobExperience': _jobExperienceText.text,
          'JobLocation': _jobLocationText.text,
          'JobDescription': _jobDescription.text,
          'JobRecruitment': _jobRecruitment.text,
          'UserName': userDoc.get('Name'),
          'UserImage': userDoc.get('User Image'),
          "PostedAt": dt,
          "OwnerEmail": userDoc.get('Email')
        });
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              setState(() {
                _isLoading = false;
                // Fluttertoast.showToast(
                //     msg: 'Job Posted', toastLength: Toast.LENGTH_SHORT);
              })
            });
        ScaffoldMessenger.of(context).showSnackBar(
            snack.successSnackBar('Congrats!', 'Job posted successfully'));
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

  _showJobCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Job Category',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobCategoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobCategoryText.text =
                                Presistent.jobCategoryList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobCategoryList[index],
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

  _showJobTypeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Job Types',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobTypeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobTypeText.text = Presistent.jobTypeList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobTypeList[index],
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
          title: Text('Create Job Post',
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
                  Text("Tell us who you're hiring",
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
                    key: _jobFDataFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Job Category
                        Text('Job Category',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobCategoryText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select job category!';
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
                            hintText: 'Select job Category',
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
                            _showJobCategoryDialog();
                          },
                        ),
                        //Job Title
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Title',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobTitleText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job title should not be empty!';
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
                            hintText: 'Enter job title',
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
                        //Job Type
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Type',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobTypeText,
                          onTap: () {
                            _showJobTypeDialog();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Type should not be empty!';
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
                            hintText: 'Enter job type',
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
                        //Job Experience
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Required Experience',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.number,
                          controller: _jobExperienceText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Experience should not be empty!';
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
                            hintText: 'Experience Required',
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
                        //Job Salary
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Salary',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobSalaryText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Salary should not be empty!';
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
                            hintText: 'Enter job Salary',
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
                        //Job Location
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Location',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobLocationText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job location should not be empty!';
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
                            hintText: 'Enter job location',
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
                        //Job Description
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Description',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobDescription,
                          style: Theme.of(context).textTheme.titleSmall,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job description should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Enter Job Description',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            prefixIcon: const Icon(
                              Icons.description_outlined,
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
                          onTap: () {
                            showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                useSafeArea: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                context: context,
                                builder: (BuildContext context) {
                                  return ListView(
                                    children: [
                                      TextFormField(
                                        minLines: 10,
                                        maxLines: 14,
                                        textInputAction: TextInputAction.done,
                                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                                        keyboardType: TextInputType.text,
                                        controller: _jobDescription,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Job description should not be empty!';
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer,
                                          hintText: 'Enter job title',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide.none),
                                          focusedErrorBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          )),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 53,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                splashFactory:
                                                    InkRipple.splashFactory,
                                                backgroundColor:
                                                    const Color(0xff5800FF),
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () {
                                              Navigator.pop(context);
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                        //Job recruitment
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Recruitment',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobRecruitment,
                          style: Theme.of(context).textTheme.titleSmall,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job recruitment should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Enter Job recruitment',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            prefixIcon: const Icon(
                              Icons.description_outlined,
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
                          onTap: () {
                            showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                useSafeArea: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                context: context,
                                builder: (BuildContext context) {
                                  return ListView(
                                    children: [
                                      TextFormField(
                                        minLines: 10,
                                        maxLines: 14,
                                        textInputAction: TextInputAction.done,
                                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                                        keyboardType: TextInputType.text,
                                        controller: _jobRecruitment,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Job recruitment should not be empty!';
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer,
                                          hintText: 'Enter job recruitment',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide.none),
                                          focusedErrorBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          )),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 53,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                splashFactory:
                                                    InkRipple.splashFactory,
                                                backgroundColor:
                                                    const Color(0xff5800FF),
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () {
                                              Navigator.pop(context);
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                      ),
                                    ],
                                  );
                                });
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
                                'Post',
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
