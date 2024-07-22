import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'add_skill_screen.dart';

class MySkillsScreen extends StatefulWidget {
  const MySkillsScreen({super.key});
  @override
  State<MySkillsScreen> createState() => _MySkillsScreenState();
}

class _MySkillsScreenState extends State<MySkillsScreen> {
  final ScrollController scController = ScrollController();
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
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        toolbarHeight: 50,
        centerTitle: true,
        title: Text('Skills', style: Theme.of(context).textTheme.displayMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: const AddSkillScreen(),
                      type: PageTransitionType.bottomToTop,
                    ));
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .collection("Skills")
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
              return Wrap(
                spacing: 10,
                runSpacing: 5,
                children: List.generate(snapshot.data!.docs.length, (index) {
                  return Chip(
                    color: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20,
                    ),
                    onDeleted: () {
                      CollectionReference ref = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .collection("Skills");
                      ref
                          .doc(snapshot.data!.docs[index]['id'].toString())
                          .delete();
                    },
                    label: Text('${snapshot.data!.docs[index]['Title']}',
                        style: Theme.of(context).textTheme.headlineSmall),
                    backgroundColor: const Color(0xff282837),
                  );
                }),
              );
            }),
      ),
    );
  }
}
