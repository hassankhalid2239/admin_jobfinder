import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../OtherProfiles/other_view_profile.dart';

class FavoritUserScreen extends StatefulWidget {
  const FavoritUserScreen({super.key});

  @override
  State<FavoritUserScreen> createState() => _FavoritUserScreenState();
}

class _FavoritUserScreenState extends State<FavoritUserScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> favUserList = [];
  List favItemList = [];
  getFavJobsKeys() async {
    var favoritJobDocument = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteTalent")
        .get();
    for (int i = 0; i < favoritJobDocument.docs.length; i++) {
      favUserList.add(favoritJobDocument.docs[i].id);
    }
    getFavKeysData(favUserList);
  }

  getFavKeysData(List<String> keysList) async {
    var allJobs = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < allJobs.docs.length; i++) {
      for (int k = 0; k < keysList.length; k++) {
        if (((allJobs.docs[i].data() as dynamic)['Id']) == keysList[k]) {
          favItemList.add(allJobs.docs[i].data());
        }
      }
    }
    setState(() {
      favItemList;
    });
  }

  favJobs(String userId) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteTalent")
        .doc(userId)
        .get();
    if (document.exists) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteTalent")
          .doc(userId)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteTalent")
          .doc(userId)
          .set({});
    }
  }

  Future<void> refreshData() async {
    setState(() {
      favItemList.clear();
      favUserList.clear();
    });
    getFavJobsKeys();
  }

  @override
  void initState() {
    super.initState();
    getFavJobsKeys();
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
              centerTitle: true,
              title: Text('Favorite Talent',
                  style: Theme.of(context).textTheme.displayMedium),
            ),
          ],
          body: favItemList.isEmpty
              ? RefreshIndicator(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  color: Theme.of(context).colorScheme.onSecondary,
                  onRefresh: () => refreshData(),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 350, horizontal: 50),
                        child: Text('There is no Favorite Talent',
                            style: Theme.of(context).textTheme.labelMedium),
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  color: Theme.of(context).colorScheme.onSecondary,
                  onRefresh: () => refreshData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favItemList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: double.infinity,
                        height: 107,
                        child: Card(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          child: InkWell(
                            splashFactory: InkRipple.splashFactory,
                            // splashColor: Color(0xff5800FF),
                            overlayColor:
                                const WidgetStatePropertyAll(Color(0x4d5800ff)),
                            onTap: () {
                              String id = favItemList[index]['Id'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherViewProfileScreen(id: id)));
                            },
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
                                          child: favItemList[index]
                                                      ['User Image'] ==
                                                  ""
                                              ? const Icon(
                                                  Icons.error,
                                                  size: 25,
                                                  color: Colors.red,
                                                )
                                              : Image.network(favItemList[index]
                                                  ['User Image']))),
                                  title: Text(
                                      '${favItemList[index]['About Me']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  subtitle: Text(
                                    '${favItemList[index]['Name']}',
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
                                        '${favItemList[index]['Location']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AutoSizeText(
                                        favItemList[index]['Availability'] ==
                                                true
                                            ? ' Available'
                                            : ' Not Available',
                                        style: GoogleFonts.dmSans(
                                          color: favItemList[index]
                                                      ['Availability'] ==
                                                  true
                                              ? const Color(0xff25D366)
                                              : Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
