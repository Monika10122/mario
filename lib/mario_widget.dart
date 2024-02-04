import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'function_jump.dart';


class Mushroom extends StatelessWidget {
  double x;
  final double y;
  final double initialX;
  final double initialY;
  final double movementDistance = 0.1; 

  Mushroom({required this.x, required this.y})
      : initialX = x,
        initialY = y;

  void update() {
    double time = DateTime.now().millisecondsSinceEpoch / 1000;
    x = initialX + movementDistance * sin(time);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x * MediaQuery.of(context).size.width,
      bottom: y * MediaQuery.of(context).size.height,
      child: Container(
        width: 30.0,
        height: 30.0,
        color: Colors.red,
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin {
  static double marioX = 0;
  static double marioY = 1;
  double marioSize = 50;
  double mushroomX = 0.5;
  double mushroomY = 1;
  double time = 0;
  double height = 0;
  double initalHeight = marioY;
  String direction = 'right';
  bool midrun = false;
  bool midjump = false;
  bool isButtonPressed = false;

  late AnimationController mushroomController;
  late Mushroom mushroom;

@override
void initState() {
  super.initState();
  mushroom = Mushroom(x: 0.5, y: 0.5); // Початкові координати гриба
  mushroomController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 5),
  )..addListener(() {
      mushroom.update();
      setState(() {});
    });

  mushroomController.forward(); // Додано цей виклик
  mushroomController.repeat();
}

  void checkIfAteMushroom() {
    if ((marioX - mushroomX).abs() < 0.05 &&
        (marioY - mushroomY).abs() < 0.05) {
      setState(() {
        marioSize = 100;
        // if eaten, move the mushroom off the screen
        mushroomX = 2;
      });
    }
  }

  void preJump() {
    time = 0;
    initalHeight = marioY;
  }
  void jump() {
    if (!midjump) {
      midjump = true;
      preJump();
      Timer.periodic(Duration(milliseconds: 50), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

       if (initalHeight - height > 1) {
      midjump = false;
      timer.cancel();
      setState(() {
        marioY = 1;
      });

      if (marioY > mushroom.y && marioY < mushroom.y + 0.1 && (marioX - mushroom.x).abs() < 0.1) {
        mushroom = Mushroom(x: 1.0, y: 1.0,); 
      }
    } else {
      setState(() {
        marioY = initalHeight - height;
      });
    }
  });
    }
  }


 void moveRight() {
  direction = 'right';

  Timer.periodic(Duration(milliseconds: 50), (timer) {
    checkIfAteMushroom();
    if (isButtonPressed && marioX + 0.02 < 1) {
      setState(() {
        marioX += 0.02;
        midrun = !midrun;
      });
    } else {
      timer.cancel();
    }
  });
}

void moveLeft() {
  checkIfAteMushroom();
  direction = 'left';

  Timer.periodic(Duration(milliseconds: 50), (timer) {
    checkIfAteMushroom();
    if (isButtonPressed && marioX - 0.02 > -1) {
      setState(() {
        marioX -= 0.02;
        midrun = !midrun;
      });
    } else {
      timer.cancel();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.blue,
                  child: AnimatedContainer(
                    alignment: Alignment(marioX, marioY),
                    duration: Duration(milliseconds: 1),
                    child: midjump
                        ? JumpingMario(
                            direction: direction,
                            size: marioSize, key: null,
                          )
                        : MyMario(
                            direction: direction,
                            midrun: midrun,
                            size: marioSize, key: null,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment(mushroomX, mushroomY),
                  child: Text('Mushroom'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'MARIO',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            '0', // TODO money.toString()
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'WORLD',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            '1-1', // TODO 1-5 lvl
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            'TIME',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            '9999', //TODO time
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PixelifySans',
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
          height: 10,
          color: Colors.green,
        ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        startMushroomAnimation(); 
                      },
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: moveLeft,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: jump,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: moveRight,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }
  void startMushroomAnimation() {
    mushroomController.forward();
  }

}
