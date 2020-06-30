import 'package:flutter/material.dart';

Widget backgroundWidget(height, isPortrait)
{
  return Container
    (
    height: height,
    alignment: Alignment.topCenter,
    child: Row
      (
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
        [
          !isPortrait ? Image.asset('lib/assets/img/bg_side.png', fit: BoxFit.fill,
            width: 300,) :
          Image.asset('lib/assets/img/bg_01.png', height: height,
              width: 100, fit: BoxFit.fill),
          Expanded(child: Container()),
          Image.asset('lib/assets/img/bg_02.png', height: 300,
              width: 100, fit: BoxFit.fill),
        ]
    ),
  );
}