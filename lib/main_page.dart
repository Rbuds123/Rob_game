import 'dart:math';
import 'package:flutter/material.dart';
import 'main_game.dart';
//creates the base of the home screen
class homePage extends StatelessWidget {//a stateless widget is used because the widget will be updated and mutated
//used to identify the widget
  const homePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/mainmenu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('dungeons and dragons'),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/DnDLogo.png',
                  height: 150,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    //calls function to initialise the database takes parameters of id number and dice number
                    await runGame(1, 3);
                    Navigator.pushNamed(context, '/second');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Play Game",
                    style: TextStyle(
                      color: Colors.white, // Use the desired text color
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await runGame(Random().nextInt(26) + 1,3); //use random to get an id for the database
                    Navigator.pushNamed(context, '/second');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Random Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    await runGame(1, 2); //easy setting using 2 for the dice threshold
                    Navigator.pushNamed(context, '/second');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Easy Game",
                    style: TextStyle(
                      color: Colors.white, // Use the desired text color
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    await runGame(1, 4); //use hard setting of 4 for dice threshold
                    Navigator.pushNamed(context, '/second');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Hard Game",
                    style: TextStyle(
                      color: Colors.white, // Use the desired text color
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}