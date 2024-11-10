
import 'package:flutter/material.dart';
import 'package:robs_game/authentication/register_page.dart';

import 'main_page.dart';
import 'main_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //creates the initial route for naviagation
      initialRoute: '/',
      routes: {
        //displays different screens
        '/': (context) => RegistrationPage(), // your main page
        '/second': (context) => const myGame(), // your MyFlutterApp page);
      },
    ),
  );



}