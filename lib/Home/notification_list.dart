import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../OtherProfiles/other_view_profile.dart';
import '../Widgets/shimmer_jobcard.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        centerTitle: true,
        title: Text('Notifications',
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Notification')
            .orderBy('Arrived', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              itemCount: 7,
              itemBuilder: (context, index) => const ShimmerJobCard(),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    // background: Container(color: Colors.red,),
                    key: Key(snapshot.data.docs[index]['id']),
                    onDismissed: (direction) {
                      CollectionReference ref = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .collection("Notification");
                      ref
                          .doc(snapshot.data!.docs[index]['id'].toString())
                          .delete();
                    },
                    child: ListTile(
                      onTap: () async {
                        DocumentSnapshot uDoc = await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Notification')
                            .doc(snapshot.data.docs[index]['id'])
                            .get();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OtherViewProfileScreen(id: uDoc['uid'])));
                      },
                      leading: CircleAvatar(
                          radius: 22,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: snapshot.data.docs[index]['UserImage'] ==
                                      ""
                                  ? const Icon(
                                      Icons.person,
                                      size: 25,
                                      color: Colors.black12,
                                    )
                                  : Image.network(
                                      snapshot.data.docs[index]['UserImage']))),
                      title: Text('${snapshot.data?.docs[index]['title']}',
                          style: Theme.of(context).textTheme.headlineMedium),
                      subtitle: Text('${snapshot.data?.docs[index]['body']}',
                          style: GoogleFonts.dmSans(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal)),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('There is no Notification!',
                    style: Theme.of(context).textTheme.labelMedium),
              );
            }
          }
          return Center(
            child: Text('Something went wrong',
                style: Theme.of(context).textTheme.labelMedium),
          );
        },
      ),
    );
  }
}
