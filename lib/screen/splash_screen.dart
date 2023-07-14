import 'package:flutter/material.dart';

/// todo 13: create SplashScreen
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/story-logo.png"),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
