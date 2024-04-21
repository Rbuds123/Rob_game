import 'package:hive/hive.dart';
part 'node.g.dart';



@HiveType(typeId: 0)
class Node{
  @HiveField(0)
  int iD;
  @HiveField(1)
  int yesID;
  @HiveField(2)
  int noID;
  @HiveField(3)
  int maybeID;
  @HiveField(4)
  String question ;

  Node(this.iD, this.yesID, this.noID, this.maybeID, this.question);

}