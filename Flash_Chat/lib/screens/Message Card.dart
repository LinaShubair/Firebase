import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  MessageCard({this.message, this.sender, this.isMe});

  final String sender;
  final String message;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isMe
              ? SizedBox()
              : Text(
            sender,
            style: TextStyle(color: Colors.grey, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Material(
              color: isMe ? Color(0xFF264653) : Colors.grey,
              elevation: 10,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: isMe ? Radius.circular(30) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      textAlign:  TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
