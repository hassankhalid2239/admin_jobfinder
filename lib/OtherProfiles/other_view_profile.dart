// ignore_for_file: deprecated_member_use

import 'package:admin_jobfinder/OtherProfiles/skills_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Widgets/snackbar.dart';
import '../job/chatroom_screen.dart';
import '../profile/pdf_viewer_screen.dart';
import 'education_page.dart';
import 'experience_page.dart';

class OtherViewProfileScreen extends StatefulWidget {
  final String id;
  const OtherViewProfileScreen({super.key, required this.id});

  @override
  State<OtherViewProfileScreen> createState() => _OtherViewProfileScreenState();
}

class _OtherViewProfileScreenState extends State<OtherViewProfileScreen> {
  final ScrollController scController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String resumeUrl = '';
  String resumeName = '';
  String name = '';
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  Snack snack = Snack();
  bool isFav = false;
  String? utoken = '';
  String? cuser = '';
  String? ruid = '';
  String? userImage = '';

  checkIsFav(String userId) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteTalent")
        .doc(userId)
        .get();
    setState(() {
      isFav = document.exists;
    });
  }

  favUsers(String userId) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteTalent")
        .doc(userId)
        .get();
    if (document.exists) {
      setState(() {
        isFav = false;
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoritTalent")
          .doc(userId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black87,
        elevation: 20,
        content: Text(
          "Removed from favorites",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ));
      // Fluttertoast.showToast(
      //     msg: 'Removed from favorites', toastLength: Toast.LENGTH_SHORT);
    } else {
      setState(() {
        isFav = true;
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteTalent")
          .doc(userId)
          .set({'UserId id': userId});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black87,
        elevation: 20,
        content: Text(
          "Added to favorites",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ));
      // Fluttertoast.showToast(
      //     msg: 'Added to favorites', toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  void initState() {
    super.initState();
    _getResumeData();
    // getUserToken();
    // initInfo();
    checkIsFav(widget.id);
  }

  hireForJob() {
    final Uri params = Uri(
        scheme: 'mailto',
        path: user?.email,
        query: 'subject=Job offer &body=Get a chance to job');
    final url = params.toString();
    launchUrlString(url);
  }

  Future _getResumeData() async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.id)
        .get();
    setState(() {
      resumeUrl = ref.get('Resume Url');
      resumeName = ref.get('ResumeName');
      name = ref.get('Name');
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _getResumeData();
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
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
        toolbarHeight: 50,
        centerTitle: true,
        // backgroundColor: Color(0xff282837),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(name, style: Theme.of(context).textTheme.displayMedium),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                favUsers(widget.id);
              },
              icon: Icon(
                isFav ? Icons.bookmark : Icons.bookmark_border_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              iconSize: 24,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        color: Theme.of(context).colorScheme.onSecondary,
        onRefresh: () => refreshData(),
        child: ListView(
          children: [
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.id)
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
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                    radius: 30,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: snapshot.data!
                                                    .get('User Image') ==
                                                ""
                                            ? const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 25,
                                                color: Colors.white,
                                              )
                                            : Image.network(
                                                '${snapshot.data!.get('User Image')}'))),
                                title: Text('${snapshot.data!.get('Name')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                subtitle: Text(
                                  '${snapshot.data!.get('Email')}',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 30,
                                runSpacing: 10,
                                children: [
                                  SizedBox(
                                    // width: w*0.391,
                                    width: 150,
                                    height: 45,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            splashFactory:
                                                InkRipple.splashFactory,
                                            backgroundColor:
                                                const Color(0xff5800FF),
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () {
                                          hireForJob();
                                        },
                                        child: Text('Hire Me',
                                            style: GoogleFonts.dmSans(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ))),
                                  ),
                                  SizedBox(
                                    // width: w*0.417,
                                    width: 150,
                                    height: 45,
                                    child: OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            splashFactory:
                                                InkRipple.splashFactory,
                                            backgroundColor: Colors.transparent,
                                            foregroundColor:
                                                const Color(0xff5800FF),
                                            side: const BorderSide(
                                                color: Color(0xff5800FF),
                                                width: 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () async {
                                          String user1 = widget.id;
                                          String? user2 = user?.uid;
                                          String roomId =
                                              chatRoomId(user1, user2!);
                                          DocumentSnapshot usnap =
                                              await FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(widget.id)
                                                  .get();
                                          String name = usnap.get('Name');
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ChatRoomScreen(
                                                  chatRoomId: roomId,
                                                  name: name,
                                                  receiverId: widget.id),
                                            ),
                                          );
                                        },
                                        child: Text('Message',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Resume-section
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Resume',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    resumeUrl == ''
                        ? const SizedBox()
                        : ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewerScreen(
                                            pdfUrl: resumeUrl.toString(),
                                            resumeName: resumeName.toString(),
                                          )));
                            },
                            horizontalTitleGap: 10,
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              'assets/svg/img_frame_primary.svg',
                              theme: const SvgTheme(
                                  currentColor: Color(0xff8F00FF)),
                              width: 24,
                              height: 24,
                            ),
                            title: Text(resumeName,
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                  ],
                ),
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
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('About Me',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.id)
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
                        })
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Expriencesection
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Experience',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.id)
                            .collection("Experience")
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
                          return ListView.separated(
                            controller: scController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length > 2
                                ? 2
                                : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data!.docs[index]['Start Date']}-${snapshot.data!.docs[index]['End Date']}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff5800FF)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('${snapshot.data!.docs[index]['Title']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(
                                    'At ${snapshot.data!.docs[index]['Company Name']}',
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index]['Job Description']}',
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16,
                            ),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ExperiencePage(id: widget.id),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all experience  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Education-section
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Education',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.id)
                            .collection("Education")
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
                          return ListView.separated(
                            controller: scController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length > 2
                                ? 2
                                : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data!.docs[index]['Start Date']}-${snapshot.data!.docs[index]['End Date']}',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff5800FF)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      '${snapshot.data!.docs[index]['School']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(
                                    '${snapshot.data!.docs[index]['Degree']}',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16,
                            ),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: EducationPage(
                                    id: widget.id,
                                  ),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all education  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Skill-section
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Skills',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.id)
                            .collection("Skills")
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
                          return Wrap(
                            spacing: 16,
                            runSpacing: 10,
                            children: List.generate(
                                snapshot.data!.docs.length > 3
                                    ? 3
                                    : snapshot.data!.docs.length, (index) {
                              return Chip(
                                color: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                ),
                                elevation: 0,
                                label: Text(
                                    '${snapshot.data!.docs[index]['Title']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                backgroundColor: const Color(0xff282837),
                              );
                            }),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SkillsPage(
                                    id: widget.id,
                                  ),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all skills  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
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
    );
  }
}
