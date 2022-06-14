import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Message Card.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String messageText;
  var loggedUser;
  final messageTextController = TextEditingController();

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: SizedBox(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  _auth.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("userEmail");
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.id, (route) => false);
                }),
          ],
          title: Text(
            '⚡Flash Chat',
            style: TextStyle(fontSize: 25),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _firestore
                    .collection("messages")
                    .orderBy("sort", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  var items = snapshot.data.docs.reversed;
                  List<MessageCard> myList = [];
                  for (var item in items) {
                    var myData = item.data() as Map<String, dynamic>;
                    String message = myData['text'];
                    String sender = myData['sender'];
                    if (loggedUser.email == sender) {
                      myList.add(MessageCard(
                        message: message,
                        sender: sender,
                        isMe: true,
                      ));
                    } else {
                      myList.add(MessageCard(
                        message: message,
                        sender: sender,
                        isMe: false,
                      ));
                    }
                  }

                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      reverse: true,
                      children: myList,
                    ),
                  );
                },
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          messageTextController.clear();
                          var id = DateTime.now().microsecondsSinceEpoch;
                          _firestore
                              .collection("messages")
                              .doc(id.toString())
                              .set({
                            "text": messageText,
                            "sender": loggedUser.email,
                            "sort": id.toString()
                          });
                        },
                        child: Icon(
                          Icons.send,
                          size: 32,
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
