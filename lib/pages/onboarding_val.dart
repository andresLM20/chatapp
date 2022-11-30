import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/pages/onboarding.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OnBoarVal extends StatefulWidget {
  const OnBoarVal({Key? key}) : super(key: key);

  @override
  State<OnBoarVal> createState() => _OnBoarValState();
}

class _OnBoarValState extends State<OnBoarVal> {
  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn == true) {
      nextScreenReplace(context, HomePage());
    } else {
      nextScreenReplace(context, OnBoardingScreen());
    }
    return Container();
  }
}
