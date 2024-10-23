// import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:horizon/chatservice/chatservice.dart';
import 'package:horizon/chatservice/chatbubble.dart';
// import 'package:kabisinsta/Authpage/Auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Individualchat extends StatefulWidget {
  Individualchat(
      {super.key,
      required this.username,
      required this.profilepic,
      required this.receiverID,
      required this.receiveremail});

  final String receiverID;
  final String receiveremail;
  final String username;
  final String profilepic;

  @override
  State<Individualchat> createState() => _IndividualchatState();
}

class _IndividualchatState extends State<Individualchat> {
  final TextEditingController _messagecontroller = TextEditingController();

  final ChatService _chatService = ChatService();

  void sendmessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendmessage(
          widget.username, widget.receiverID, _messagecontroller.text);
      _messagecontroller.clear();
    }
  }

  List allchatbubble = [];
  String senderID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 223, 190),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.profilepic),
            ),
            const SizedBox(
              width: 15,
            ),
            Center(
                child: Text(
              widget.username,
              style: TextStyle(
                color: Colors.white,
              ),
            ))
          ],
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: StreamBuilder(
              stream: _chatService.getmessages(widget.receiverID, senderID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                // print(snapshot.data!.docs);
                // print(
                //     "warsetxrdcytgvjhbj1234567890ghcxvzxcvbn12345678901234567890-oiugfdgfzcv bnm,p09876ewaDc9t1234567890oiuytrew1234567890poiuytrewqasdfghjsdfghj");
                return ListView(
                    children: snapshot.data!.docs
                        .map((doc) => _buildmessageItem(doc))
                        .toList());
              }),
        ),
        _buildMessageInput(),
        SizedBox(
          height: 10,
        )
      ]),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messagecontroller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 24, 23, 23)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.send, color: Colors.amber[600]),
              onPressed: () => sendmessage()),
        ],
      ),
    );
  }

  Widget _buildmessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final curid = FirebaseAuth.instance.currentUser!.uid;
    bool isCurrentuser = data["senderID"] == curid;
    var alignment =
        isCurrentuser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatBubble(isCurrentuser: isCurrentuser, message: data['message'])
          ],
        ));
  }
}
