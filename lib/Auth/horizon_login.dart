import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horizon/service/gradienttext.dart';
import 'package:horizon/ui/horizon__chooseusername.dart';
import 'package:horizon/ui/horizon_homepage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      await OneSignal.User.addAlias(result.user!.uid, result.user!.uid);
      await OneSignal.login(result.user!.uid);

      final snap = await FirebaseFirestore.instance
          .collection('Userdetails')
          .doc(result.user!.email)
          .get();
      await FirebaseFirestore.instance
          .collection('Userdetails')
          .doc(result.user!.email)
          .set({"uid": result.user!.uid, "email": result.user!.email},
              SetOptions(merge: true));

      if (snap.data() == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Choseeusername()));
        return;
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HorizonHomepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: Card(
          margin: EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const GradientText(
                "Horizon Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(228, 212, 156, 1),
                  Color(0xffad9c00)
                ]),
              ),
              SizedBox(
                height: 50,
                child: Image.asset("assets/icon/icon.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: MaterialButton(
                    color: Colors.grey,
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/googlelogo.png'),
                                fit: BoxFit.contain),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Sign In with Google")
                      ],
                    ),

                    // by onpressed we call the function signup function
                    onPressed: () {
                      signup(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
