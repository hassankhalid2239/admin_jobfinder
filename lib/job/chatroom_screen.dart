import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;
  final String? name;
  final String receiverId;

  const ChatRoomScreen(
      {super.key,
      required this.chatRoomId,
      required this.name,
      required this.receiverId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool del = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      try {
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser?.uid)
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .doc(id)
            .set({
          'id': id,
          "receiveBy": widget.receiverId,
          "sendBy": _auth.currentUser?.uid,
          "message": _message.text,
          "time": FieldValue.serverTimestamp(),
        });
        FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.receiverId)
            .collection('Messages')
            .doc(id)
            .set({
          'id': id,
          "receiveBy": widget.receiverId,
          "sendBy": _auth.currentUser?.uid,
          "message": _message.text,
          "time": FieldValue.serverTimestamp(),
        });
        _message.clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter Some Text')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: Text("${widget.name}",
            style: Theme.of(context).textTheme.labelMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Users')
                    .doc(_auth.currentUser?.uid)
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: Key(snapshot.data?.docs[index]['id']),
                            onDismissed: (direction) {
                              CollectionReference ref = FirebaseFirestore
                                  .instance
                                  .collection("Users")
                                  .doc(_auth.currentUser?.uid)
                                  .collection("chatroom")
                                  .doc(widget.chatRoomId)
                                  .collection('chats');
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                  'Message deleted',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ));
                            },
                            child: messages(size, map, context));
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _message,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onSurface,
                        hintText: 'Message',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        prefixIcon: const Icon(
                          Icons.message_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff5800FF),
                        )),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.redAccent,
                        )),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(0xff5800FF))),
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onSendMessage();
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return Container(
      width: size.width,
      alignment: map['sendBy'] == _auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: map['sendBy'] == _auth.currentUser!.uid
            ? const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 100)
            : const EdgeInsets.only(top: 5, bottom: 5, right: 100, left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: map['sendBy'] == _auth.currentUser!.uid
                ? Colors.blueGrey
                : const Color(0xff5800FF)),
        child: SelectableText(
          map['message'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
