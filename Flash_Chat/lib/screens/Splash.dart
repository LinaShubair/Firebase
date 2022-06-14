import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static const String id = "Splash";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  delay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("userEmail");
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushNamed(
          context, (email == null) ? WelcomeScreen.id : ChatScreen.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delay();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

    // _animation = ColorTween(begin: Colors.red,end: Colors.blue).animate(_controller);

    // _controller.forward();

    // _animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _controller.reverse(from: 1);
    //   } else if (status == AnimationStatus.dismissed) {
    //     _controller.forward();
    //   }
    // });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RotationTransition(
                turns: _animation, child: Image.asset("images/logo.png")),
            SizedBox(
              height: 50,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 25.0,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  WavyAnimatedText('Welcom to my Chat App'),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
