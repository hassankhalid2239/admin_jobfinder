// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/shimmer_job_card_h.dart';
import '../Widgets/snackbar.dart';
import '../job/avail_talent_screen.dart';
import 'notification_list.dart';
import '../OtherProfiles/other_view_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userImage = '';
  String userName = '';
  initInfo() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherViewProfileScreen(id: uid)));
          } else {}
        } on FirebaseAuthException catch (e) {
          Snack().errorSnackBar('On Snap!', e.message.toString());
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('*************** onMessage **************');
      }
      if (kDebugMode) {
        print(
            'onMessage: ${message.notification!.title}/${message.notification!.body}');
      }

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'fyp', 'fyp', importance: Importance.max,
        styleInformation: bigTextStyleInformation, priority: Priority.max,
        playSound: false,
        // sound: RowResourceAndroidNotificationSound('notification'),
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  @override
  initState() {
    super.initState();
    initInfo();
    getUserData();
  }

  getUserData() async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      userImage = userDoc.get('User Image');
      userName = userDoc.get('Name');
    });
  }

  Future<void> refreshData() async {
    setState(() {
      getUserData();
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
              toolbarHeight: 50,
              leadingWidth: 80,
              titleSpacing: 0,
              leading: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: CircleAvatar(
                    radius: 22,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: userImage == ''
                            ? const Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.grey,
                              )
                            : Image.network(userImage)),
                  )),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(userName,
                      style: Theme.of(context).textTheme.headlineLarge),
                  AutoSizeText(
                    'Find your desired Talent',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationListScreen()));
                      },
                      icon: Icon(
                        Icons.notifications_none_sharp,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //New Hiring Buttons
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AutoSizeText('Available Now',
                          style: Theme.of(context).textTheme.labelMedium),
                      trailing: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AvailTalentScreen()));
                          },
                          child: AutoSizeText('View All',
                              style:
                                  Theme.of(context).textTheme.headlineSmall))),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Method 1
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('Availability', isEqualTo: true)
                      .where('User Type', isEqualTo: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const ShimmerJobCardH();
                            },
                            scrollDirection: Axis.horizontal,
                            // itemCount: snapshot.data.docs.length,
                            itemCount: 2),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      if (snapshot.data?.docs.isNotEmpty == true) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.builder(
                              itemCount: snapshot.data.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      mainAxisExtent: 230,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () {
                                    String id =
                                        snapshot.data!.docs[index]['Id'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherViewProfileScreen(
                                                    id: id)));
                                  },
                                  style: ButtonStyle(
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xff1a288a)),
                                    splashFactory: InkRipple.splashFactory,
                                    elevation:
                                        const MaterialStatePropertyAll(0),
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.zero),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xff5800FF)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                              radius: 30,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: snapshot.data
                                                                  .docs[index]
                                                              ['User Image'] ==
                                                          ''
                                                      ? const Icon(
                                                          Icons.person,
                                                          size: 25,
                                                          color: Colors.grey,
                                                        )
                                                      : Image.network(snapshot
                                                              .data.docs[index]
                                                          ['User Image']))),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          AutoSizeText(
                                            // 'Hassan Khalid',
                                            '${snapshot.data.docs[index]['Name']}',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.dmSans(
                                                color: const Color(0xffF6F8FE),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            // 'Mobile Application Developer',
                                            '${snapshot.data.docs[index]['About Me']}',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            // "Islamabad, Pakistan",
                                            "\$ ${snapshot.data.docs[index]['Location']}",
                                            style: GoogleFonts.dmSans(
                                                color: const Color(0xffF6F8FE),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 70,
                                            height: 28,
                                            decoration: BoxDecoration(
                                                color: const Color(0xd825d366),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Center(
                                              child: Text(
                                                'Available',
                                                // '${snapshot.data.docs[index]['JobType']}',
                                                style: GoogleFonts.dmSans(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    splashFactory:
                                                        InkRipple.splashFactory,
                                                    padding: EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        const Color(0xff292c47),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                onPressed: () {
                                                  String id = snapshot
                                                      .data!.docs[index]['Id'];
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtherViewProfileScreen(
                                                                  id: id)));
                                                },
                                                child: Text(
                                                  'Hire',
                                                  style: GoogleFonts.dmSans(
                                                      letterSpacing: 1,
                                                      color: const Color(
                                                          0xff5800FF),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: AutoSizeText(
                            'There is no available now!',
                            style: GoogleFonts.dmSans(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 16),
                          ),
                        );
                      }
                    }
                    return Center(
                      child: AutoSizeText(
                        'Something went wrong',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 16),
                      ),
                    );
                  },
                ),
                // Method 2
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('Users')
                //       .where('User Type', isEqualTo: true)
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return SizedBox(
                //         height: 240,
                //         child: ListView.builder(
                //             physics: const NeverScrollableScrollPhysics(),
                //             itemBuilder: (context, index) {
                //               return ShimmerJobCardH();
                //             },
                //             scrollDirection: Axis.horizontal,
                //             // itemCount: snapshot.data.docs.length,
                //             itemCount: 2),
                //       );
                //     } else if (snapshot.connectionState ==
                //         ConnectionState.active) {
                //       if (snapshot.data?.docs.isNotEmpty == true) {
                //         return Expanded(
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 10),
                //             child: GridView.builder(
                //               itemCount: snapshot.data.docs.length,
                //               gridDelegate:
                //               SliverGridDelegateWithMaxCrossAxisExtent(
                //                   maxCrossAxisExtent: 250,
                //                   mainAxisExtent: 230,
                //                   crossAxisSpacing: 10,
                //                   mainAxisSpacing: 10),
                //               itemBuilder: (context, index) {
                //                 return ElevatedButton(
                //                   onPressed: () {},
                //                   style: ButtonStyle(
                //                     overlayColor:
                //                     const MaterialStatePropertyAll(
                //                         Color(0xff1a288a)),
                //                     splashFactory: InkRipple.splashFactory,
                //                     elevation:
                //                     const MaterialStatePropertyAll(0),
                //                     padding: const MaterialStatePropertyAll(
                //                         EdgeInsets.zero),
                //                     backgroundColor:
                //                     const MaterialStatePropertyAll(
                //                         Color(0xff5800FF)),
                //                     shape: MaterialStatePropertyAll(
                //                         RoundedRectangleBorder(
                //                             borderRadius:
                //                             BorderRadius.circular(8))),
                //                   ),
                //                   child: Card(
                //                     color: Colors.transparent,
                //                     elevation: 0,
                //                     child: Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                         horizontal: 5,),
                //                       child: Column(
                //                         crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                         children: [
                //                           ListTile(
                //                             leading: CircleAvatar(
                //                                 radius: 25,
                //                                 child: ClipRRect(
                //                                     borderRadius:
                //                                     BorderRadius.circular(
                //                                         25),
                //                                     child: snapshot.data
                //                                         .docs[index]
                //                                     [
                //                                     'User Image'] ==
                //                                         ''
                //                                         ? Icon(
                //                                       Icons.person,
                //                                       size: 25,
                //                                       color: Colors.grey,
                //                                     )
                //                                         : Image.network(snapshot
                //                                         .data
                //                                         .docs[index]
                //                                     ['User Image']))),
                //                             trailing: Icon(Icons.bookmark_border_rounded,color: Colors.white,size: 25,),
                //                             contentPadding: EdgeInsets.zero,
                //                           ),
                //                           SizedBox(height: 5,),
                //                           AutoSizeText(
                //                             // 'Hassan Khalid',
                //                             '${snapshot.data.docs[index]['Name']}',
                //                             overflow: TextOverflow.ellipsis,
                //                             style: GoogleFonts.dmSans(
                //                               color: const Color(0xffF6F8FE),
                //                               fontSize: 13,
                //                               // fontWeight: FontWeight.w500
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: 5,
                //                           ),
                //                           Text(
                //                             // 'Mobile Application Developer',
                //                             '${snapshot.data.docs[index]['About Me']}',
                //                             overflow: TextOverflow.ellipsis,
                //                             style: GoogleFonts.dmSans(
                //                                 color: Colors.white,
                //                                 fontSize: 15,
                //                                 fontWeight: FontWeight.w600),
                //                           ),
                //                           SizedBox(
                //                             height: 5,
                //                           ),
                //                           Text(
                //                             "Islamabad, Pakistan",
                //                             // "\$ ${snapshot.data.docs[index]['JobSalary']}",
                //                             style: GoogleFonts.dmSans(
                //                                 color: const Color(0xffF6F8FE),
                //                                 fontSize: 12,
                //                                 fontWeight: FontWeight.w500),
                //                           ),
                //                           SizedBox(
                //                             height: 10,
                //                           ),
                //                           Container(
                //                             width: 70,
                //                             height: 28,
                //                             decoration: BoxDecoration(
                //                                 color: const Color(0xff9333FF),
                //                                 borderRadius:
                //                                 BorderRadius.circular(8)),
                //                             child: Center(
                //                               child: Text(
                //                                 'Available',
                //                                 // '${snapshot.data.docs[index]['JobType']}',
                //                                 style: GoogleFonts.dmSans(
                //                                     color: Colors.white,
                //                                     fontSize: 12),
                //                               ),
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: 13,
                //                           ),
                //                           SizedBox(
                //                             width: double.infinity,
                //                             height: 35,
                //                             child: ElevatedButton(
                //                                 style: ElevatedButton.styleFrom(
                //                                     splashFactory:
                //                                     InkRipple.splashFactory,
                //                                     padding: EdgeInsets.zero,
                //                                     backgroundColor:
                //                                     Colors.white,
                //                                     foregroundColor:
                //                                     const Color(0xff292c47),
                //                                     shape:
                //                                     RoundedRectangleBorder(
                //                                         borderRadius:
                //                                         BorderRadius
                //                                             .circular(
                //                                             8))),
                //                                 onPressed: () {
                //                                   // String id=snapshot.data!.docs[index]['id'];
                //                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetailScreen(
                //                                   //   id: id,
                //                                   //   uid: snapshot.data.docs[index]
                //                                   //   ['uid'],
                //                                   //   ownerEmail:
                //                                   //   snapshot.data.docs[index]
                //                                   //   ['OwnerEmail'],
                //                                   //   jobDescription:
                //                                   //   snapshot.data.docs[index]
                //                                   //   ['JobDescription'],
                //                                   //   jobExperience:
                //                                   //   snapshot.data.docs[index]
                //                                   //   ['JobExperience'],
                //                                   //   jobType: snapshot.data
                //                                   //       .docs[index]['JobType'],
                //                                   //   jobRecruitment:snapshot.data.docs[index]['JobRecruitment'],
                //                                   //   jobLocation:
                //                                   //   snapshot.data.docs[index]
                //                                   //   ['JobLocation'],
                //                                   //   userImage: snapshot.data
                //                                   //       .docs[index]['UserImage'],
                //                                   //   userName: snapshot.data
                //                                   //       .docs[index]['UserName'],
                //                                   //   jobTitle: snapshot.data
                //                                   //       .docs[index]['JobTitle'],
                //                                   //   postDate: snapshot.data
                //                                   //       .docs[index]['PostedAt'],
                //                                   //   jobSalary: snapshot.data
                //                                   //       .docs[index]['JobSalary'],
                //                                   // )));
                //                                 },
                //                                 child: Text(
                //                                   'Hire',
                //                                   style: GoogleFonts.dmSans(
                //                                       letterSpacing: 1,
                //                                       color: const Color(
                //                                           0xff5800FF),
                //                                       fontSize: 15,
                //                                       fontWeight:
                //                                       FontWeight.w700),
                //                                 )),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                 );
                //               },
                //             ),
                //           ),
                //         );
                //       } else {
                //         return Center(
                //           child: AutoSizeText(
                //             'There is no available now!',
                //             style: GoogleFonts.dmSans(
                //                 color: Theme.of(context).colorScheme.outline,
                //                 fontSize: 16),
                //           ),
                //         );
                //       }
                //     }
                //     return Center(
                //       child: AutoSizeText(
                //         'Something went wrong',
                //         style: GoogleFonts.dmSans(
                //             color: Theme.of(context).colorScheme.outline,
                //             fontSize: 16),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
