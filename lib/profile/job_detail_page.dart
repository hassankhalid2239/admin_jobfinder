import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import '../OtherProfiles/other_view_profile.dart';
import '../Widgets/snackbar.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({
    super.key,
    required this.userImage,
    required this.id,
    required this.userName,
    required this.jobTitle,
    required this.jobLocation,
    required this.postDate,
    required this.jobSalary,
    required this.jobExperience,
    required this.jobType,
    required this.jobDescription,
    required this.jobRecruitment,
    required this.ownerEmail,
    required this.uid,
  });

  final String? userImage;
  final String? userName;
  final String? jobTitle;
  final String? jobLocation;
  final String? postDate;
  final String? jobSalary;
  final String? jobType;
  final String? jobExperience;
  final String? jobDescription;
  final String? jobRecruitment;
  final String? ownerEmail;
  final String id;
  final String uid;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Snack snack = Snack();
  bool isFav = false;
  String? utoken = '';
  String? cuser = '';
  String? ruid = '';
  String? userImage = '';
  applyForJob() {
    final Uri params = Uri(
        scheme: 'mailto',
        path: widget.ownerEmail,
        query:
            'subject=Applying for ${widget.jobTitle}&body=Hello, Please attach your Resume.');
    final url = params.toString();
    launchUrlString(url);
  }

  getUserToken() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc(widget.uid)
        .get();
    DocumentSnapshot uDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      utoken = snap['token'];
      ruid = snap['id'];
      cuser = uDoc['Name'];
      userImage = uDoc['User Image'];
    });
  }

  checkIsFav(String jobid) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteJobs")
        .doc(jobid)
        .get();
    setState(() {
      isFav = document.exists;
    });
  }

  favJobs(String jobid) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteJobs")
        .doc(jobid)
        .get();
    if (document.exists) {
      setState(() {
        isFav = false;
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteJobs")
          .doc(jobid)
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
          .collection("FavoriteJobs")
          .doc(jobid)
          .set({
        'job id': jobid
      });
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

  void sendPushNotification(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAoweGA3E:APA91bH7dhtvuJ79BqQyC0fjCshsF8O673ZuVQleiRXRztXyEZ4UD0_v7Tp8KHg7-XCJOgYRsnCUgS_TUJWZ_FbAMqnjJekeTy1xzHURXXeUL1WQty5hnmgR4YyNOlfuLUMZKhzk6CgY',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": 'fyp'
          },
          "to": token
        }),
      );
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .collection('Notification')
          .doc(id)
          .set({
        'title': title.toString(),
        'id': id,
        'uid': uid,
        'body': body.toString(),
        'UserImage': userImage,
        "Arrived": dt,
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snack.errorSnackBar('On Error!', e.message.toString()));
    }
  }

  initInfo() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherViewProfileScreen(id: ruid!)));
            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            //   return OtherViewProfileScreen(id: widget.uid,);
            // }));
          } else {}
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              snack.errorSnackBar('On Error!', e.message.toString()));
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
    });
  }

  @override
  void initState() {
    super.initState();
    getUserToken();
    initInfo();
    checkIsFav(widget.id);
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
            Text('Detail Jobs', style: Theme.of(context).textTheme.labelMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                favJobs(widget.id);
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.jobTitle}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 24,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold)),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 25,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: widget.userImage == ""
                                  ? const Icon(
                                      Icons.error,
                                      size: 25,
                                      color: Colors.red,
                                    )
                                  : Image.network(widget.userImage!))),
                      title: Text('${widget.userName}',
                          style: Theme.of(context).textTheme.headlineMedium),
                      subtitle: Text('${widget.jobLocation}',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        const Icon(
                          Icons.work_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text('  ${widget.jobExperience} Years Experience',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text('  ${widget.jobType}',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        const Icon(
                          Icons.currency_exchange_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text('  ${widget.jobSalary}',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              splashFactory: InkRipple.splashFactory,
                              backgroundColor: const Color(0xff5800FF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            applyForJob();
                            sendPushNotification(utoken!, '$cuser',
                                'applied your ${widget.jobTitle} job.');
                          },
                          child: Text('Easy Apply Now',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ))),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Responsibilities: ',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('${widget.jobDescription}',
                        style: GoogleFonts.dmSans(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recruitment: ',
                        style: GoogleFonts.dmSans(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                        '${widget.jobRecruitment}',
                        style: GoogleFonts.dmSans(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
