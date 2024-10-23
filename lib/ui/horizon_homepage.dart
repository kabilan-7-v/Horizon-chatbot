import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizon/ui/horizon_chatbotpage.dart';
import 'package:horizon/ui/horizon_drawer.dart';
import 'package:horizon/ui/horizon_groupcall.dart';
import 'package:horizon/ui/horizon_individualchatpage.dart';
import 'package:horizon/ui/horizon_notes.dart';
import 'package:horizon/service/gradienttext.dart';
import 'package:horizon/service/horizon_button.dart';

class HorizonHomepage extends StatefulWidget {
  const HorizonHomepage({super.key});

  @override
  State<HorizonHomepage> createState() => _HorizonHomepageState();
}

class _HorizonHomepageState extends State<HorizonHomepage> {
  final calling = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void dispose() {
    calling.dispose();
    _noteController.dispose();
    super.dispose();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? useremail = FirebaseAuth.instance.currentUser?.email;
  final String? curid = FirebaseAuth.instance.currentUser?.uid;
  String? username;
  List<Widget> highlightPostImages = [];
  List<Widget> userCards = [];
  bool isLoading = false;

  final GlobalKey<ScaffoldState> key = GlobalKey();

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    if (useremail != null) {
      var userDoc =
          await firestore.collection("Userdetails").doc(useremail).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc.data()?["username"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const GradientText(
          "Horizon",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          gradient: LinearGradient(
              colors: [Color.fromRGBO(228, 212, 156, 1), Color(0xffad9c00)]),
        ),
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/Horizon-Thumbnail-1024x576 copy.png"),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HorizonNotes()));
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/notes.png"),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      drawer: HorizonDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            child: Container(
                                height: 200,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 233, 223, 190),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Call id:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: calling,
                                      decoration: const InputDecoration(
                                          hintText: "Please Enter call id",
                                          helperStyle: TextStyle(
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  LeviButton(
                                    child: const Text(
                                      "Join Meeting",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CallPage(
                                                    callId: calling.text,
                                                  )));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ])));
                      });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(Icons.video_camera_front_outlined),
                    ),
                    Text(
                      "Create a Meet with a Id...",
                      style: TextStyle(color: Colors.blue[100]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestore.collection("Userdetails").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userCards.clear();
                  for (var doc in snapshot.data!.docs) {
                    if (doc.data()["uid"] != curid) {
                      userCards.add(userList(
                          doc.data()["username"] ?? "Unknown",
                          doc.data()["profileimageurl"] ?? "",
                          doc.data()["uid"] ?? "",
                          doc.data()["email"]));
                    }
                  }
                  return ListView.builder(
                    itemCount: userCards.length,
                    itemBuilder: (context, index) {
                      return userCards[index];
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Image.asset(
            "assets/Horizon-Thumbnail-1024x576 copy.png",
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatScreen()));
          }),
    );
  }

  Widget userList(String username, String profilePic, useruid, email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Individualchat(
                username: username,
                profilepic: profilePic,
                receiverID: useruid,
                receiveremail: email,
                // Add receiverID if available
                // Add receiverEmail if available
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                alignment: Alignment.center,
                width: 70,
                height: 70,
                imageUrl: profilePic,
                filterQuality: FilterQuality.low,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
