import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperiencePage extends StatefulWidget {
  final String id;
  const ExperiencePage({super.key, required this.id});
  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final ScrollController scController = ScrollController();
  String? gender;

  final user = FirebaseAuth.instance.currentUser;
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
          title: Text('Experiences',
              style: Theme.of(context).textTheme.displayMedium),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.id)
                .collection('Experience')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
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
                            Text('${snapshot.data!.docs[index]['Title']}',
                                style: Theme.of(context).textTheme.labelMedium),
                            Text(
                                'At ${snapshot.data!.docs[index]['Company Name']}',
                                style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                                '${snapshot.data!.docs[index]['Job Description']}',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
