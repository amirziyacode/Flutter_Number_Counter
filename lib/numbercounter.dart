import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';


class NumberCounter extends StatefulWidget {


  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<NumberCounter>
    with SingleTickerProviderStateMixin {
 late AnimationController _controller;

  var _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  final _spring = const SpringDescription(
     // set up for animation
    mass: 9,
    stiffness: 250, // duration
    damping: 0.7,
  );

  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizedVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );
    return -normalizedVelocity.distance;
  }

  void _runAnimation(Offset velocity, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final simulation =
    SpringSimulation(_spring, 0.0, 1.0, _normalizeVelocity(velocity, size));

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _dragAlignment = _animation.value));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int  number = 1; // number of circle ;;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12.withOpacity(0.2),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 250,
          height: 300,
          child: Stack(
            children: [
              Align(
                  alignment: _dragAlignment,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xff8639FB),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff8639FB).withOpacity(0.7),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child:  Center(
                      child: FittedBox(
                        child: Text(
                          '$number'.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 85,
                          ),
                        ),
                      ),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 95) ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          _controller.stop(canceled: true);
                          setState(() {
                            number++;
                          });
                          setState(() {
                            _dragAlignment += const Alignment(
                                0.0 , 0.1
                            );
                            _runAnimation( Offset(size.width * 90  , size.height * 90)   , size);
                          });

                        },
                        icon: const Icon(Icons.expand_less_outlined,size: 45,color: Colors.white,)
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                    IconButton(
                        onPressed: (){
                          _controller.stop(canceled: true);
                          setState(() {
                            number--;
                          });
                          setState(() {
                            _dragAlignment -= const Alignment(
                                0.004 ,  0.1
                            );
                          });
                          _runAnimation( Offset(size.width * 90  , size.height * 90) , size);
                        },
                        icon: const Icon(Icons.expand_more_outlined,size: 45,color: Colors.white,)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}