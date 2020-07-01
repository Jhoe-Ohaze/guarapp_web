import 'package:flutter/material.dart';
import 'package:guarappweb/screens/calendar_screen.dart';
import 'package:guarappweb/widgets/background_widget.dart';

class AgreementScreen extends StatefulWidget
{
  @override
  _AgreementScreenState createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen>
{
  String terms = '';
  bool isActive = false;

  void openCalendarScreen()
  {
    Navigator.of(context).push(MaterialPageRoute
      (builder: (context) => CalendarScreen()));
  }

  Widget foreground()
  {
    return Column
      (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
      [
        Container
          (
          margin: EdgeInsets.all(50),
          alignment: Alignment.center,
          child: Text('Termos e condições', style: TextStyle
            (fontSize: 40, fontFamily: 'Fredoka', color: Colors.grey[700]),
              textAlign: TextAlign.center),
        ),
        Container
          (
            margin: EdgeInsets.symmetric(horizontal: 75),
            height: MediaQuery.of(context).size.height - 320,
            decoration: BoxDecoration
              (
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.white
            ),
            child: SingleChildScrollView
              (
                physics: BouncingScrollPhysics(),
                child: Container(child: Text(terms, style: TextStyle
                  (fontSize: 14, fontFamily: 'Fredoka', color: Colors.black),
                    textAlign: TextAlign.center))
            )
        ),
        Padding
          (
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 75),
          child: CheckboxListTile
            (
            title: Text('Concordo com os termos e condições citados acima', style:
            TextStyle(fontSize: 14, fontFamily: 'Fredoka', color: Colors.black),
                textAlign: TextAlign.right),
            onChanged: (value)
            {
              setState(() => isActive = value);
            },
            value: isActive,
          ),
        ),
        Container
        (
          padding: EdgeInsets.symmetric(horizontal: 75),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerRight,
          child: FlatButton
          (
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            disabledColor: Colors.blueGrey[100],
            color: Colors.blue,
            onPressed: isActive ? () => openCalendarScreen() : null,
            child: Container
              (
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              height: 45,
              child: Container(child: Text('Avançar', style: TextStyle
                (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: Stack
      (
        children:
        [
          backgroundWidget(MediaQuery.of(context).size.height, true),
          foreground()
        ],
      ),
    );
  }
}
