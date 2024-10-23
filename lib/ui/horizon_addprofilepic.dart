import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:horizon/ui/horizon_homepage.dart';
import 'package:image_picker/image_picker.dart';

class Addprofilepic extends StatefulWidget {
  const Addprofilepic({
    super.key,
  });

  @override
  State<Addprofilepic> createState() => _AddprofilepicState();
}

class _AddprofilepicState extends State<Addprofilepic> {
  File? profileimage;

  get data => null;

  final firestore = FirebaseFirestore.instance;

  final useremail = FirebaseAuth.instance.currentUser!.email;
  bool isLoading = false;

  var profileimageget;
  TabController? tabbarcontroller;

  String? profileimagegeturl;
  var curuserpost;
  List curuserpostlst = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Image(image: AssetImage("assets/screenshotaddphoto.jpeg")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  isLoading = true;
                  setState(() {});

                  await profilepicupload();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HorizonHomepage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 75,
                  height: 60,
                  child: Card(
                    color: Colors.blue[500],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Center(
                              child: isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Text(
                                      "Add a photo",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  profilepicupload() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (image != null) {
      profileimage = File(image.path);
    }

    var imageName = image!.name;
    print(imageName);
    var storageRef = await FirebaseStorage.instance
        .ref()
        .child('profileimages/$imageName.jpg');
    var uploadTask = await storageRef.putFile(profileimage!);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    await firestore
        .collection("Userdetails")
        .doc(useremail)
        .set({"profileimageurl": downloadUrl}, SetOptions(merge: true));
  }
}
