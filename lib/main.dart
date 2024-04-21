import 'package:flutter/material.dart';
import 'main_page.dart';
import 'main_game.dart';



Future<void> main() async {

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //creates the initial route for naviagation
      initialRoute: '/',
      routes: {
        //displays different screens
        '/': (context) => const homePage(), // your main page
        '/second': (context) => const myGame(), // your MyFlutterApp page);
      },
    ),
  );



}