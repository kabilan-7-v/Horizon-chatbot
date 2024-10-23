import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horizon/models/chatmodel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> notifychatReceiver(
  String senderName,
  String receiverUid,
  String message,
) async {
  final headers = {
    "Content-type": "application/json; charset=utf-8",
    "Authorization": "Basic MmIxODVmOTktZGY2Yy00MmE3LTk0MjQtNTBlZTQ4MzcyOTUz"
  };
  final data = {
    "app_id": "231477b8-0c78-4672-805f-10bd6168cdef",
    "include_aliases": {
      "external_id": [receiverUid]
    },
    "target_channel": "push",
    "content_available": true,
    "small_icon": "launcher_icon",
    "headings": {"en": senderName},
    "contents": {"en": message},
  };
  http.post(
    Uri.parse("https://onesignal.com/api/v1/notifications"),
    body: jsonEncode(data),
    headers: headers,
  );
}

class ChatService {
//get instance

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//get user stream
  Stream<List<Map<String, dynamic>>> getusersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

//sent message
  Future<void> sendmessage(String Username, String receiverID, message) async {
    // get current user info
    final String currentuserID = _auth.currentUser!.uid;
    final String currentuserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message

    Message newmessage = Message(
        senderID: currentuserID,
        senderEmail: currentuserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat room id for the two user
    List<String> ids = [currentuserID, receiverID];
    ids.sort();
    String chatroomID = ids.join('_');

    //add new message to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newmessage.toMap());
    notifychatReceiver(Username, receiverID, message);
  }

//get messages
  Stream<QuerySnapshot> getmessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
