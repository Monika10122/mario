import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JumpingMario extends StatelessWidget {
  final direction;
  final size;
 
  const JumpingMario({required key, this.direction, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == 'right') {
      return Container(
        width: size,
        height: size,
        child: SvgPicture.asset('assets/2.svg'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: size,
          height: size,
          child: SvgPicture.asset('assets/2.svg'),
        ),
      );
    }
  }
}


class MyMario extends StatelessWidget {
  final direction ;
  final midrun;
  final size ;

  const MyMario({required key, this.direction, this.midrun, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == 'right') {
      return Container(
        width: size,
        height: size,
        child: midrun
            ? SvgPicture.asset('assets/1.svg')
            : SvgPicture.asset('assets/3.svg'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: size,
          height: size,
          child: midrun
              ? SvgPicture.asset('assets/1.svg')
              : SvgPicture.asset('assets/3.svg'),
        ),
      );
    }
  }
}

