import 'package:admin_jobfinder/profile/update_job_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Post/post_job_screen.dart';
import '../Widgets/shimmer_jobcard.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  refreshData() {
    setState(() {});
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
            Text('My Jobs', style: Theme.of(context).textTheme.displayMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const PostJobScreen(),
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 300)));
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.outline,
              ),
              iconSize: 28,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Jobs')
            .where('uid', isEqualTo: uid)
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
              return RefreshIndicator(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                color: Theme.of(context).colorScheme.onSecondary,
                onRefresh: () => refreshData(),
                child: ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: InkRipple.splashFactory,
                          // splashColor: Color(0xff5800FF),
                          overlayColor:
                              const WidgetStatePropertyAll(Color(0x4d5800ff)),
                          onTap: () {
                            String id = snapshot.data!.docs[index]['id'];
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: UpdateJobScreen(jobid: id),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                    leading: CircleAvatar(
                                        radius: 22,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            child: snapshot.data.docs[index]
                                                        ['UserImage'] ==
                                                    ""
                                                ? const Icon(
                                                    Icons.person,
                                                    size: 25,
                                                    color: Colors.grey,
                                                  )
                                                : Image.network(
                                                    snapshot.data.docs[index]
                                                        ['UserImage']))),
                                    title: Text(
                                        '${snapshot.data.docs[index]['JobTitle']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    subtitle: Text(
                                      '${snapshot.data.docs[index]['UserName']} - ${snapshot.data.docs[index]['PostedAt']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          size: 18,
                                        ),
                                        Text(
                                          ' ${snapshot.data.docs[index]['JobLocation']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.currency_exchange_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          size: 15,
                                        ),
                                        Text(
                                          ' ${snapshot.data.docs[index]['JobSalary']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text(
                  'There is no Job!',
                  style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
                ),
              );
            }
          }
          return Center(
            child: Text(
              'Something went wrong',
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
