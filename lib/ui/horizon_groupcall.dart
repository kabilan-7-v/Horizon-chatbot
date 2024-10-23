import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

class CallPage extends StatelessWidget {
  static final String userId = math.Random().nextInt(10000).toString();
  const CallPage({super.key, required this.callId});
  final String callId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: 1808006113,
            appSign:
                "d13777c5023210bbe66bdb9688bcbe08eda8f6971c5522de36a6cc046ffb952d",
            callID: callId,
            userID: userId,
            userName: "userName$userId",
            config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()));
  }
}
