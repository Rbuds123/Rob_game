import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'node.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

//declare local database hive uses boxes
late Box<Node> box;
int localDiceNumber = 1;
int localidNumber = 1;
int dienumber = 3;
//initialises csv file and database files, takes id number and difficulty as parameters as they are changed depending on user input
Future<void> runGame( int idNumber, int difficulty) async {
  localidNumber = idNumber;//used to manipulate id number depending on users input on home page
  dienumber = difficulty;//used to manipulate dice number depending on users input on home page
  WidgetsFlutterBinding.ensureInitialized();
  //initialises adapter and check if it already exists
  if(!await Hive.boxExists('gameMap')) {
    await Hive.initFlutter(); //hive creation
    Hive.registerAdapter(NodeAdapter());
    //initialises box
    box = await Hive.openBox<Node>('gameMap');

    //creates initialisation of my csv file
    String csv = "my_map.csv";
    String fileData = await rootBundle.loadString(csv);//loads csv

    List <String> rows = fileData.split("\n");
    for (int i = 0; i < rows.length; i++) {
      //selects an item from row and places
      String row = rows[i];
      List <String> itemInRow = row.split(",");

      Node node = Node(
          int.parse(itemInRow[0]),
          int.parse(itemInRow[1]),
          int.parse(itemInRow[2]),
          int.parse(itemInRow[3]),
          itemInRow[4]);

      //loads csv data into database
      int key = int.parse(itemInRow[0]);
      box.put(key, node);
    }
  }

}
//creates an instance of the widget
//a stateful widget is used because the widget will be mutated
class myGame extends StatefulWidget {
  const myGame({super.key});
  @override
  State<StatefulWidget> createState() {
    return MyGameState();
  }
}
//extends the already created widget ready to be changed and added to
class MyGameState extends State<myGame> {
  //rolls dice number and stores it
  void rollDice() {
    setState(() {
      localDiceNumber = Random().nextInt(6) + 1;
    });
  }
//creates a pop up whenever 1 of the three buttons are pushed
  Future<void> showDicePopup(BuildContext context) async {
    rollDice();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Rolled dice"),
              content: Column(
                children: [
                  Image.asset(
                    'images/dice$localDiceNumber.png',
                    height: 150,
                  )
                ],
              )
          );
        });
  }
  //event handlers set to zero as they are changed later on
  late int iD = 0;
  late int yesID = 0;
  late int noID = 0;
  late int maybeID = 0;
  String question = "";

  @override
  void initState() {
    super.initState();
    //allows the widget to be called back when it has been updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //uses id of first line the number it uses fetches the first node question mark checks if its nothing
        Node? current = box.get(localidNumber);
        //if current is not null then it will update the id's
        if (current != null) {
          iD = current.iD;
          yesID = current.yesID;
          noID = current.noID;
          maybeID = current.maybeID;
          question = current.question;
        }
      });
    });
  }

  void yesHandler() async {
    //checks if id means player still alive then returns dice popup else dice popup doesnt appear
    if(!checkId(iD)) {
      await showDicePopup(context);
    } else {localDiceNumber = 6;}
    setState(()  {
      Node? nextNode;
      //checks if the dice number is larger than predetermined difficulty if not goes to death screen
      if (localDiceNumber > dienumber) {
        nextNode = box.get(yesID);
      } else {
        nextNode = box.get(5); //death screen
      }
      if (nextNode != null) {//outputs next node
        iD = nextNode.iD;
        yesID = nextNode.yesID;
        noID = nextNode.noID;
        maybeID = nextNode.maybeID;
        question = nextNode.question;
      }
    });
  }

  void noHandler() async {
    //checks if id means player still alive then returns dice popup else dice popup doesnt appear
    if(!checkId(iD)) {
      await showDicePopup(context);
    } else {
      localDiceNumber = 6;
    }
    setState(()  {
      if(!checkId(iD)) { //if user selects no and its at the end
        //then the user will not restart and go back to home
        Node? nextNode;
        if (localDiceNumber > dienumber) {//if dice number is larger then next id is shown else you die
          nextNode = box.get(noID);
        } else {
          nextNode = box.get(5);
        }
        if (nextNode != null) {
          iD = nextNode.iD;
          yesID = nextNode.yesID;
          noID = nextNode.noID;
          maybeID = nextNode.maybeID;
          question = nextNode.question;
        }
      } else {
        //go to home
        Navigator.pop(context);
      }
    });
  }
//checks whether id is equal to character being dead and returns true if dead
  bool checkId(int idtoCheck){
    bool result = true;
    if(idtoCheck != 5 && idtoCheck != 7 && idtoCheck <= 19) {
      result = false;
    }
    return result;
  }

  void maybeHandler() async {
    if(!checkId(iD)) {// will not show dice pop up if it is at the end of the game
      await showDicePopup(context);
    }
    setState(()  {
      Node? nextNode = box.get(maybeID);
      if (localDiceNumber > dienumber) {
        nextNode = box.get(noID);
      } else {
        nextNode = box.get(5);
      }
      if (nextNode != null) {
        if(!checkId(iD)) {
          iD = nextNode.iD;
          yesID = nextNode.yesID;
          noID = nextNode.noID;
          maybeID = nextNode.maybeID;
          question = nextNode.question;
        } else {//tells user that only yes or no can be used and that maybe cannot be pressed
          //outputs message onto the screen telling the user that only yes or no can be used
          Fluttertoast.showToast(
              msg: "You can only select YES or NO",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              webPosition: "center",
              webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
              fontSize: 16.0
          );
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    //sets background to nothing and is updated depending on the id
    String backgroundImagePath = '';
    if (iD == 0 || iD == 1 || iD == 2 || iD == 4 || iD == 6 || iD == 11 || iD == 12 || iD == 15) {
      backgroundImagePath = 'images/cavebackground.png';
    } else if (iD == 3 || iD == 9 || iD == 10 || iD == 16 || iD == 17 ) {
      backgroundImagePath = 'images/basecampbackground.png';
    } else
    if (iD == 8 || iD == 13 || iD == 14 || iD == 18 ) {
      backgroundImagePath = 'images/villagebackground.png';
    } else if (iD == 5 || iD == 7 || iD >= 19 || iD == 22) {
      backgroundImagePath = 'images/deathscreen.jpg';
    }
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.home),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.5, 0.5),
                    child: MaterialButton(
                      onPressed: () {
                        yesHandler();
                      },
                      color: Color(0xFF000000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      textColor: Color(0xfffffdfd),
                      height: 40,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.0, 0.5),
                    child: MaterialButton(
                      onPressed: () {
                        noHandler();
                      },
                      color: Color(0xFF000000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      textColor: const Color(0xfffffdfd),
                      height: 40,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.5, 0.5),
                    child: MaterialButton(
                      onPressed: () {
                        maybeHandler();
                      },
                      color: Color(0xFF000000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      textColor: const Color(0xfffffdfd),
                      height: 40,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        "MAYBE",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.0, -0.3),
                    child: Text(
                      question,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 56,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}