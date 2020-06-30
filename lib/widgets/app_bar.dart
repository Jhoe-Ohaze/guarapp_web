import 'package:flutter/material.dart';

Widget appBar(width, context)
{
  return PreferredSize
    (
    preferredSize: Size.fromHeight(60),
    child: Container
      (
        width: width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(50, 5, 30, 5),
        decoration: BoxDecoration
          (
          color: Colors.white,
          boxShadow:
          [
            BoxShadow
              (
              color: Colors.black38,
              offset: Offset(0, 10),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Row
          (
          children:
          [
            Image.asset('lib/assets/img/logo_full.png',),
            Expanded(child: Container()),
            FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.red[300], child: Container(height: 60, alignment: Alignment.center,
                    child: Text("Voltar", style: TextStyle(color: Colors.white,
                        fontFamily: 'Fredoka', fontSize: 25))), onPressed: () =>
                    Navigator.of(context).pop()),
          ],
        )
    ),
  );
}