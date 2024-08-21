import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _solashscreenState();
}

class _solashscreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "welcome to flutter app ",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
