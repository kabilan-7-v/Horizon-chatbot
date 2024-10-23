import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horizon/Auth/horizon_login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HorizonDrawer extends StatelessWidget {
  const HorizonDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Image.asset("assets/icon/icon.png"),
          Spacer(),
          InkWell(
            onTap: () {
              logout(context);
            },
            child: Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.red),
              child: Center(
                  child: Text(
                "Log Out",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }

  void logout(context) async {
    await OneSignal.logout();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }
}
