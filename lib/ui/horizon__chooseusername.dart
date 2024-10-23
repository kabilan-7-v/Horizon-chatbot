import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizon/ui/horizon_addprofilepic.dart';

class Choseeusername extends StatefulWidget {
  Choseeusername({super.key});

  @override
  State<Choseeusername> createState() => _ChoseeusernameState();
}

class _ChoseeusernameState extends State<Choseeusername> {
  final firestore = FirebaseFirestore.instance;

  final useremail = FirebaseAuth.instance.currentUser!.email;
  bool isLoading = false;

  TextEditingController _textcontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textcontroller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              "Choose username",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "you can always change it later",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 75,
              height: 60,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _textcontroller,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "UserName",
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              isLoading = true;
              setState(() {});
              uploadusername();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Addprofilepic()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 75,
                height: 60,
                child: Card(
                  color: Colors.blue[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Center(
                            child: (isLoading)
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  uploadusername() async {
    await firestore
        .collection("Userdetails")
        .doc(useremail)
        .set({"username": _textcontroller.text}, SetOptions(merge: true));

    _textcontroller.clear();
  }
}
