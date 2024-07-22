import 'package:admin_jobfinder/job/search_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../OtherProfiles/other_view_profile.dart';
import '../Widgets/shimmer_jobcard.dart';

class AvailTalentScreen extends StatefulWidget {
  const AvailTalentScreen({super.key});

  @override
  State<AvailTalentScreen> createState() => _AvailTalentScreenState();
}

class _AvailTalentScreenState extends State<AvailTalentScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Future<void> refreshData() async {
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
            Text('Available', style: Theme.of(context).textTheme.displayMedium),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.outline,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('Availability', isEqualTo: true)
              .where('User Type', isEqualTo: true)
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
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashFactory: InkRipple.splashFactory,
                            // splashColor: Color(0xff5800FF),
                            overlayColor:
                                const WidgetStatePropertyAll(Color(0x4d5800ff)),
                            onTap: () {
                              String id = snapshot.data!.docs[index]['Id'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherViewProfileScreen(id: id)));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      ['User Image'] ==
                                                  ""
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 25,
                                                  color: Colors.white,
                                                )
                                              : Image.network(snapshot.data
                                                  .docs[index]['User Image']))),
                                  title: AutoSizeText(
                                      '${snapshot.data.docs[index]['About Me']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  subtitle: AutoSizeText(
                                    '${snapshot.data.docs[index]['Name']}',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Wrap(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        size: 18,
                                      ),
                                      AutoSizeText(
                                        '${snapshot.data.docs[index]['Location']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AutoSizeText(
                                        snapshot.data.docs[index]
                                                    ['Availability'] ==
                                                true
                                            ? ' Available'
                                            : ' Not Available',
                                        style: GoogleFonts.dmSans(
                                          color: snapshot.data.docs[index]
                                                      ['Availability'] ==
                                                  true
                                              ? const Color(0xff25D366)
                                              : Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ));
              } else {
                return Center(
                  child: Text('There is no Job!',
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
      ),
    );
  }
}
