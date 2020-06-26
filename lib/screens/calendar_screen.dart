import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget 
{
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> 
{
  CalendarController _calendarController;
  DateTime selectedDate, startDay;
  bool active = false;

  @override
  void initState()
  {
    _calendarController = CalendarController();
    startDay = DateTime.now().hour > 14 ? DateTime.now():DateTime.now().add(Duration(days: 1));
    super.initState();
  }

  @override
  void dispose()
  {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return OrientationBuilder
      (
        builder: (context, orientation)
        {
          bool isPortrait = orientation == Orientation.portrait;
          return Scaffold
          (
            appBar: appBar(orientation),
            body: Stack
            (
              children:
              [
                backgroundWidget(orientation),
                isPortrait ? SingleChildScrollView
                (
                  physics: ClampingScrollPhysics(),
                  child: Column
                  (
                    children:
                    [
                      Container
                      (
                        padding: EdgeInsets.only(top: 40, bottom: 5, left: 20, right: 20),
                        child: Text('Selecione uma data', style: TextStyle(color: Colors.grey[700],
                            fontSize: 35, fontFamily: 'Fredoka')),
                      ),
                      calendar(orientation),
                    ],
                  ),
                ):
                SingleChildScrollView
                (
                  scrollDirection: Axis.horizontal,
                  child: Row
                  (
                    children:
                    [
                      Container(alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/6),
                        width: 400,
                        height: 500,
                        child: calendar(orientation),),
                      Column
                        (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Container
                            (
                            width: MediaQuery.of(context).size.width/4,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 60),
                            child: Text('Calendário de funcionamento do Parque', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue[600],
                                    fontSize: 25, fontFamily: 'Fredoka')),
                          ),
                          Container
                            (
                            width: MediaQuery.of(context).size.width/4,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration
                              (
                                border: Border(top: BorderSide(color: Colors.grey[800], width: 2))
                            ),
                          ),
                          Container
                            (
                            width: MediaQuery.of(context).size.width/4,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/4),
                            child: Text('Selecione a data em que você deseja visitar o parque', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[900],
                                    fontSize: 30, fontFamily: 'Fredoka')),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]
            ),
          );
        }
    );
  }
  
  Widget calendar(orientation)
  {
    double width = MediaQuery.of(context).size.width;
    bool checker = orientation == Orientation.portrait;

    void _onDaySelected(DateTime day, List events)
    {
      if(day.isAfter(startDay)) setState(() => selectedDate = day);
      active = true;
    }

    Widget portraitCalendar()
    {
      return Container
        (
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: checker ? width/6: width/7),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2),
            color: Colors.white
        ),
        child: TableCalendar
          (
          locale: 'pt_BR',
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          startDay: startDay,
          endDay: DateTime(2020, 12, 31),
          calendarStyle: CalendarStyle
          (
            selectedColor: Colors.green[400],
            todayColor: Colors.transparent,
            markersColor: Colors.brown[700],
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
      );
    }

    Widget landscapeCalendar()
    {
      return Container
      (
        alignment: Alignment.topLeft,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2),
            color: Colors.white
        ),
        child: TableCalendar
          (
          locale: 'pt_BR',
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          startDay: startDay,
          endDay: DateTime(2020, 12, 31),
          calendarStyle: CalendarStyle(
            selectedColor: Colors.green[400],
            todayColor: Colors.transparent,
            markersColor: Colors.brown[700],
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(formatButtonVisible: false, centerHeaderTitle: true),
          onDaySelected: _onDaySelected,
        ),
      );
    }

    return checker ? portraitCalendar():landscapeCalendar();
  }

  Widget appBar(orientation)
  {
    bool isPortrait = orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;
    return PreferredSize
      (
      preferredSize: Size.fromHeight(95),
      child: Container
        (
          width: width,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
              Image.asset('lib/assets/img/logo_full.png', height: 120),
              Expanded(child: Container()),
              FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.blue, child: Container(height: 60, alignment: Alignment.center,
                      child: Text("Voltar", style: TextStyle(color: Colors.white,
                          fontFamily: 'Fredoka', fontSize: 30))), onPressed: () =>
                      Navigator.of(context).pop()),
            ],
          )
      ),
    );
  }

  Widget backgroundWidget(orientation)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack
      (
      children:
      [
        Container
          (
          alignment: Alignment.topCenter,
          child: Row
            (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              [
                Image.asset('lib/assets/img/bg_01.png', height: height,
                    width: orientation == Orientation.portrait ? 100:200, fit: BoxFit.fill),
                Expanded(child: Container())
              ]
          ),
        ),
        Container
          (
            alignment: Alignment.topCenter,
            child: Row
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Expanded(child: Container()),
                  Image.asset('lib/assets/img/bg_02.png', height: 200,
                    width: orientation == Orientation.portrait ? width/6:width/8, fit: BoxFit.fill,),
                ]
            )
        )
      ],
    );
  }
}
