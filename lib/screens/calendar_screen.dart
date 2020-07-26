import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guarappweb/screens/ticket_screen.dart';
import 'package:guarappweb/widgets/app_bar.dart';
import 'package:guarappweb/widgets/background_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget 
{
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> 
{
  ValueNotifier<int> disp = ValueNotifier<int>(0);
  CalendarController _calendarController;
  DateTime selectedDate, startDay, currentDate;

  @override
  void initState()
  {
    currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    _calendarController = CalendarController();
    startDay = currentDate.isAfter(DateTime(2020,07,11)) ? currentDate.hour < 15 ? currentDate : currentDate.add(Duration(days: 1)): DateTime(2020, 07, 11);
    selectedDate = startDay;
    super.initState();
  }

  @override
  void dispose()
  {
    _calendarController.dispose();
    super.dispose();
  }

  void openTicketScreen(DateTime selectedDate)
  {
    Navigator.of(context).push(MaterialPageRoute
      (builder: (context) => PreLoadTicketScreen(selectedDate)));
  }
  
  Widget calendar(isPortrait, width)
  {
    void _onDaySelected(DateTime day, List events)
    {
      setState(() {selectedDate = day; disp.value = 0;});
    }

    return Container
    (
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration
      (
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 2),
        color: Colors.white
      ),
      child: SingleChildScrollView
        (
        child: TableCalendar
          (
          availableGestures: AvailableGestures.horizontalSwipe,
          locale: 'pt_BR',
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          startDay: startDay,
          endDay: DateTime(2020, 12, 31),
          initialSelectedDay: startDay,
          calendarStyle: CalendarStyle
            (
            selectedColor: Colors.blue[400],
            markersColor: Colors.red[700],
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle
            (
            centerHeaderTitle: true,
            titleTextStyle: TextStyle(fontSize: 20, fontFamily: 'Fredoka'),
            formatButtonVisible: false,
          ),
          onDaySelected: _onDaySelected,
        ),
      )
    );
  }

  Future<int> getLimit() async
  {
    String day = selectedDate.day < 10 ? "0${selectedDate.day}":selectedDate.day.toString();
    String month = selectedDate.month < 10 ? "0${selectedDate.month}":selectedDate.month.toString();
    String year = selectedDate.year.toString();

    DocumentSnapshot snap =  await Firestore.instance
        .collection("limits").document("years").collection(year)
          .document("months").collection(month).document(day).get();

    try
    {
      if(snap.exists)
      {
        int total = snap.data['limit'];
        int expected = snap.data['expected'];
        disp.value = total - expected;
        return disp.value >= 0 ? disp.value : 0;
      }
      else {disp.value = 150; return 150;}
    }
    catch(e){print(e);}
  }

  Widget portraitBuild(isPortrait, width)
  {
    return SingleChildScrollView
    (
      child: Column
      (
        children:
        [
          Container
          (
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: Text('Selecione a data de entrada', style: TextStyle
              (fontSize: 35, fontFamily: 'Fredoka', color: Colors.grey[600]),
                textAlign: TextAlign.center,),
          ),
          Container
          (
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: calendar(isPortrait, width),
          ),
          Container
          (
            height: 40,
            width: width,
            margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration
              (
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.white
            ),
            child: Row
            (
              children:
              [
                Text("Ingressos disponíveis:"),
                Expanded(child: Container()),
                FutureBuilder
                (
                  future: getLimit(),
                  builder: (context, snapshot)
                  {
                    switch(snapshot.connectionState)
                    {
                      case ConnectionState.done:
                        return Text(snapshot.data.toString());
                      default:
                        return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ),
          ValueListenableBuilder
          (
            valueListenable: disp,
            child: Container(),
            builder: (context, value, child)
            {
              return Container
              (
                alignment: Alignment.center,
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                child: FlatButton
                (
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue[100], width: 2)),
                  color: Colors.blue,
                  disabledColor: Colors.blueGrey[100],
                  onPressed: value > 0 ? () => openTicketScreen(selectedDate) : null,
                  child: Container
                  (
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    height: 45,
                    width: width,
                    child: Row
                      (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [
                        Container(child: Text('Continuar', style: TextStyle
                          (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                        Expanded(child: Container()),
                        Container(child: Icon(Icons.chevron_right, size: 30, color: Colors.white))
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget landscapeBuild(isPortrait, width)
  {
    double sized = 30;
    double height = MediaQuery.of(context).size.height - 90;
    double padding = 10;
    return Padding
    (
      padding: EdgeInsets.fromLTRB(250, 25, padding, 25),
      child: SingleChildScrollView
      (
        physics: BouncingScrollPhysics(),
        child: Row
          (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Container
              (
              alignment: Alignment.centerRight,
              width: width/2 - 200 - sized,
              height: height,
              child: calendar(isPortrait, width),
            ),
            SizedBox(width: 60),
            Container
              (
              alignment: Alignment.centerRight,
              width: width/3 - padding - sized,
              height: height,
              child: Column
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  Text('Selecione a data de entrada', style: TextStyle
                    (fontSize: 40, fontFamily: 'Fredoka', color: Colors.grey[700]),
                      textAlign: TextAlign.center),
                  Divider(thickness: 2),
                  Text('Clique na data desejada em nosso calendário para '
                      'prosseguir com a compra', style: TextStyle
                    (fontSize: 25, fontFamily: 'Fredoka', color: Colors.blueGrey[500]),
                      textAlign: TextAlign.center),
                  Divider(thickness: 2),
                  Container
                    (
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row
                      (
                      children:
                      [
                        Container
                          (
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple[100]),
                          height: 40,
                          width: 40,
                        ),
                        Container
                          (
                          padding: EdgeInsets.only(left: 10),
                          child: Text("=  Data de hoje", style: TextStyle(fontFamily: 'Fredoka')),
                        )
                      ],
                    ),
                  ),
                  Container
                    (
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row
                      (
                      children:
                      [
                        Container
                          (
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                          height: 40,
                          width: 40,
                        ),
                        Container
                          (
                          padding: EdgeInsets.only(left: 10),
                          child: Text("=  Data Selecionada", style: TextStyle(fontFamily: 'Fredoka')),
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 2),
                  Container
                  (
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration
                    (
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 2),
                      color: Colors.white
                    ),
                    child: Row
                    (
                      children:
                      [
                        Text("Ingressos disponíveis:"),
                        Expanded(child: Container()),
                        FutureBuilder
                        (
                          future: getLimit(),
                          builder: (context, snapshot)
                          {
                            switch(snapshot.connectionState)
                            {
                              case ConnectionState.done:
                              {
                                return Text(snapshot.data.toString());
                              }
                              default:
                                return CircularProgressIndicator();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder
                  (
                    valueListenable: disp,
                    child: Container(),
                    builder: (context, value, child)
                    {
                      return FlatButton
                        (
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        disabledColor: Colors.blueGrey[100],
                        color: Colors.blue,
                        onPressed: value > 0 ? () => openTicketScreen(selectedDate) : null,
                        child: Container
                          (
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          height: 45,
                          width: (width/2) - 112,
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                            [
                              Container(child: Text('Continuar', style: TextStyle
                                (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                              Expanded(child: Container()),
                              Container(child: Icon(Icons.chevron_right, size: 30, color: Colors.white))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return OrientationBuilder
      (
        builder: (context, orientation)
        {
          bool isPortrait = orientation == Orientation.portrait;
          return Stack
          (
            children: 
            [
              backgroundWidget(height, isPortrait),
              Scaffold
              (
                backgroundColor: Colors.transparent,
                appBar: appBar(width, context),
                body: isPortrait ? portraitBuild(isPortrait, width) : landscapeBuild(isPortrait, width),
              )
            ],
          );
        }
    );
  }
}
