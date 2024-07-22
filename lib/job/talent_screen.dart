// ignore_for_file: deprecated_member_use

import 'package:admin_jobfinder/job/search_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../OtherProfiles/other_view_profile.dart';
import '../Widgets/shimmer_jobcard.dart';
import '../presistent/presestent.dart';

class TalentScreen extends StatefulWidget {
  const TalentScreen({super.key});

  @override
  State<TalentScreen> createState() => _TalentScreenState();
}

class _TalentScreenState extends State<TalentScreen> {
  int getPageIndex = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _locationController =
      TextEditingController(text: '');
  String? selectedCategory = 'Categories';
  String? selectedType = 'Job Type';
  String searchQuery = 'Location';
  void _clearSearchQuery() {
    setState(() {
      _locationController.clear();
      _updateSearchQuery('');
      searchQuery = 'Location';
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  _showJobCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Center(
                child: Text(
                  'Job Categories',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
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
                            selectedCategory =
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

  _showJobLocationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Center(
                child: Text(
                  'Job Location',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autocorrect: true,
                        controller: _locationController,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _clearSearchQuery();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'Search for jobs',
                          border: InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                        onChanged: (query) => _updateSearchQuery(query),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 53,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                splashFactory: InkRipple.splashFactory,
                                backgroundColor: const Color(0xff5800FF),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Show Result',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )));
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
              centerTitle: true,
              title: Text('Talent',
                  style: Theme.of(context).textTheme.displayMedium),
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
              bottom: PreferredSize(
                preferredSize: const Size.square(40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: getPageIndex == 0
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2)
                                  : Border.all(color: Colors.grey, width: 2)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getPageIndex = 0;
                              });
                            },
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                'All',
                                style: getPageIndex == 0
                                    ? Theme.of(context).textTheme.headlineMedium
                                    : GoogleFonts.dmSans(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: getPageIndex == 1
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2)
                                  : Border.all(color: Colors.grey, width: 2)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getPageIndex = 1;
                              });
                              _showJobCategoryDialog();
                            },
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "$selectedCategory  ",
                                      style: getPageIndex == 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                          : GoogleFonts.dmSans(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.arrow_drop_down_sharp,
                                          size: 20,
                                          color: getPageIndex == 1
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Available
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: getPageIndex == 2
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2)
                                  : Border.all(color: Colors.grey, width: 2)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getPageIndex = 2;
                              });
                            },
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                "Available",
                                style: getPageIndex == 2
                                    ? Theme.of(context).textTheme.headlineMedium
                                    : GoogleFonts.dmSans(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Not Available
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: getPageIndex == 3
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2)
                                  : Border.all(color: Colors.grey, width: 2)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getPageIndex = 3;
                              });
                            },
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                "Not Available",
                                style: getPageIndex == 3
                                    ? Theme.of(context).textTheme.headlineMedium
                                    : GoogleFonts.dmSans(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: getPageIndex == 4
                                  ? Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2)
                                  : Border.all(color: Colors.grey, width: 2)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getPageIndex = 4;
                              });
                              _showJobLocationDialog();
                            },
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "$searchQuery  ",
                                      style: getPageIndex == 4
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                          : GoogleFonts.dmSans(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.arrow_drop_down_sharp,
                                          size: 20,
                                          color: getPageIndex == 4
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: StreamBuilder(
            stream: getPageIndex == 4
                ? FirebaseFirestore.instance
                    .collection('Users')
                    .where('User Type', isEqualTo: true)
                    .where('Location', isGreaterThanOrEqualTo: searchQuery)
                    .snapshots()
                : getPageIndex == 3
                    ? FirebaseFirestore.instance
                        .collection('Users')
                        .where('User Type', isEqualTo: true)
                        .where('Availability', isEqualTo: false)
                        .snapshots()
                    : getPageIndex == 2
                        ? FirebaseFirestore.instance
                            .collection('Users')
                            .where('User Type', isEqualTo: true)
                            .where('Availability', isEqualTo: true)
                            .snapshots()
                        : getPageIndex == 1
                            ? FirebaseFirestore.instance
                                .collection('Users')
                                .where('User Type', isEqualTo: true)
                                .where('Categories',
                                    isEqualTo: selectedCategory)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Users')
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
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              splashFactory: InkRipple.splashFactory,
                              overlayColor: const MaterialStatePropertyAll(
                                  Color(0x4d5800ff)),
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
                                                    color: Colors.grey,
                                                  )
                                                : Image.network(
                                                    snapshot.data.docs[index]
                                                        ['User Image']))),
                                    title: AutoSizeText(
                                        '${snapshot.data.docs[index]['About Me']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    subtitle: AutoSizeText(
                                      '${snapshot.data.docs[index]['Name']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
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
      ),
    );
  }
}
