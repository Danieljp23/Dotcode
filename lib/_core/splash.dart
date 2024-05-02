import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotcode/main.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: Color.fromRGBO(51, 177, 255, 30),
      logo: Image.asset(
        'assets/Splash.gif',
      ),
      durationInSeconds: 5,
      navigator:
          const RoteadorTela(), // Aqui colocamos o que deve ser aberto após o Splash
    );
  }
}
