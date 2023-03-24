import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/control_panel.dart';
import 'package:snake_game/piece.dart';
import 'package:snake_game/direction.dart';
class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step=30;
  int length=5;
  int score=0;
  double speed=0.5;
  late Offset foodPosition=getRandomPosition();
  late Piece food;
  List<Offset> positions=[];
  Direction direction=Direction.right;
   late Timer timer = Timer(Duration(milliseconds: 200~/speed), () { }, );

  void changeSpeed(){
    if(timer.isActive){
      timer.cancel();
    }
    timer=Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {

      });
    });
  }
  Widget getControl(){
    return ControlPanel(onTaped: (Direction newDirection){
      direction=newDirection;
    }
    );
  }

  Direction getRandomDirection(){
    int val=Random().nextInt(4);
    direction=Direction.values[val];
    return direction;
  }

  void restart(){
     length=5;
     score=0;
     speed=0.5;
     positions=[];
     direction=getRandomDirection();
     changeSpeed();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restart();
  }

  int getNearest(int num){
    int output;
    output=(num~/step)*step;
    if(output==0){
      output+=step;
    }
    return output;
  }
  Offset getRandomPosition(){
    Offset position;
    int posX=Random().nextInt(upperBoundX)+lowerBoundX;
    int posY=Random().nextInt(upperBoundY)+lowerBoundY;
    position=Offset(getNearest(posX).toDouble(), getNearest(posY).toDouble());
    return position;
  }
  void draw()async{
    if(positions.length==0){
      positions.add(getRandomPosition());
    }
    while(length>positions.length){
      positions.add(positions[positions.length-1]);
    }

    for(var i= positions.length-1; i>0; i--){
      positions[i]=positions[i-1];
    }
    positions[0]=await getNextPosition(positions[0]);
  }
  Future<Offset> getNextPosition(Offset position)async{
    Offset nextPosition=Offset(position.dx+step, position.dy);

    if(direction==Direction.right) {
      nextPosition=Offset(position.dx+step, position.dy);
    } else if(direction==Direction.left) {
      nextPosition=Offset(position.dx-step, position.dy);
    } else if(direction==Direction.up) {
      nextPosition=Offset(position.dx, position.dy-step);
    } else if(direction==Direction.down) {
      nextPosition=Offset(position.dx+step, position.dy+step);
    }

    if(collisionDetection(position)==true){
      if(timer!=null && timer.isActive){
        timer.cancel();
      }
     await Future.delayed(Duration(milliseconds: 200), ()=>showGameOverDialogue());
    }
    return nextPosition;
  }

  void drawFood(){
    if(foodPosition==null){
      foodPosition=getRandomPosition();
    }
    if(foodPosition==positions[0]){
      length++;
      score=score+5;
      speed=speed+.25;
      foodPosition=getRandomPosition();
    }
    food=Piece(
        posX: foodPosition.dx.toInt(),
        posY: foodPosition.dy.toInt(),
        size: step,
        color: Colors.red,
        isAnimated: true,
    );
  }
  List<Piece>getPieces(){
    final pieces=<Piece>[];
    draw();
    drawFood();
    for(var i=0; i<length; ++i){
      if(i>=positions.length){
        continue;
      }
      pieces.add(Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: i.isEven?Colors.red:Colors.green,
          isAnimated: false,
        ),
      );
    }

    return pieces;
  }

  bool collisionDetection(Offset position){
   if(position.dx>=upperBoundX && direction==Direction.right){
     return true;
   }else if(position.dx<=lowerBoundX && direction==Direction.left){
     return true;
   }else if(position.dy>=upperBoundY && direction==Direction.down){
     return true;
   }else if(position.dy<=lowerBoundY && direction==Direction.up){
     return true;
   }
    return false;
  }
void showGameOverDialogue(){
    showDialog(
        barrierDismissible: false,
        context: context, builder: (ctx){
          return AlertDialog(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: Text(
              "Game Over",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            content: Text(
              "Your game is over but you played well. Your Score is "+score.toString(),
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            actions: [
              TextButton(onPressed: () async{
                Navigator.of(context).pop();
                restart();
              }, child: Text(
                "Restart",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ))
            ],
          );
    }
    );
}
  
  Widget getScore(){
    return Positioned(
        top: 80,
        right: 50,
        child: Text(
          "Score :"+score.toString(),
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    screenWidth=MediaQuery.of(context).size.width;
    lowerBoundX=step;
    lowerBoundY=step;

    upperBoundY=getNearest(screenHeight.toInt()-step);
    upperBoundX=getNearest(screenWidth.toInt()-step);

    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControl(),
            food,
            getScore(),
          ],
        ),
      ),
    );
  }
}


