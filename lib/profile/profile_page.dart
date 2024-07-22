import 'package:admin_jobfinder/profile/profile_detail_screen.dart';
import 'package:admin_jobfinder/profile/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'aboutme_screen.dart';
import 'edit_profile.dart';
import 'myjob_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController scController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String _companyName = '';
  String _companyTagline = '';
  String _profilePic = '';
  String _coverPic = '';

  String _website = '';
  String _industry = '';
  String _companySize = '';
  String _companyType = '';
  String _location = '';
  String _foundedAt = '';
  @override
  void initState() {
    super.initState();
    _getProfileData();
    _getProfileDetailData();
  }

  Future _getProfileData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      _companyName = ref.get('CompanyName');
      _companyTagline = ref.get('Tagline');
      _profilePic = ref.get('User Image');
      _coverPic = ref.get('CoverImage');
    });
  }

  Future _getProfileDetailData() async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Details')
        .doc(uid)
        .get();
    setState(() {
      _website = ref.get('Website');
      _industry = ref.get('Industry');
      _companySize = ref.get('CompanySize');
      _companyType = ref.get('CompanyType');
      _location = ref.get('Location');
      _foundedAt = ref.get('FoundedAT');
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.onSurface,
                statusBarIconBrightness: Theme.of(context).brightness),
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            elevation: 0,
            floating: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Profile',
                  style: Theme.of(context).textTheme.displayMedium),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const SettingPage(),
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 300)));
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).colorScheme.outline,
                      size: 22,
                    )),
              )
            ],
          ),
        ],
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          color: Theme.of(context).colorScheme.onSecondary,
          onRefresh: () => refreshData(),
          child: ListView(
            children: [
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            color: Colors.green,
                            child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(_coverPic == ''
                                  ? 'https://images.unsplash.com/photo-1707175834407-70806cecaa3a?q=80&w=2320&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                                  : _coverPic.toString()),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 10,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: 5)),
                              child: Image(
                                fit: BoxFit.fill,
                                image: NetworkImage(_profilePic == ''
                                    ? 'https://cdn.pixabay.com/photo/2021/08/10/15/36/microsoft-6536268_1280.png'
                                    : _profilePic.toString()),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _companyName,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        subtitle: Text(
                          _companyTagline,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 35,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          // width: w*0.391,
                          width: 160,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: const Color(0xff5800FF),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const EditProfilePage(),
                                        type: PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 300)));
                              },
                              child: Text('Edit Profile',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ))),
                        ),
                        SizedBox(
                          // width: w*0.417,
                          width: 160,
                          height: 45,
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xff5800FF),
                                  side: const BorderSide(
                                      color: Color(0xff5800FF), width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const MyJobsScreen(),
                                        type: PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 300)));
                              },
                              child: Text('Create Job',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //Aboutmesection
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('About Us',
                            style: Theme.of(context).textTheme.labelMedium),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const AboutMeScreen(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 22,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(snapshot.hasError.toString()));
                            }
                            return Text(
                              '${snapshot.data!.get('About Me')}',
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.outline),
                            );
                          }),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //Detail section
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Details',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const ProfileDetailScreen(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 22,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      //Website
                      Text(
                        'Website',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _website.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Industry
                      Text(
                        'Industry',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _industry.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Company Size
                      Text(
                        'Company Size',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _companySize.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Location
                      Text(
                        'Location',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _location.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Type
                      Text(
                        'Type',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _companyType.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Founded
                      Text(
                        'Founded',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _foundedAt.toString(),
                        style: GoogleFonts.dmSans(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
