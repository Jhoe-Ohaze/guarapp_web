import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:table_calendar/table_calendar.dart';

class PreLoadTicketScreen extends StatefulWidget
{
  @override
  _PreLoadTicketScreenState createState() => _PreLoadTicketScreenState();
}

class _PreLoadTicketScreenState extends State<PreLoadTicketScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: FutureBuilder<QuerySnapshot>
      (
        future: Firestore.instance.collection('products').orderBy('position').getDocuments(),
        builder: (context, snapshot)
        {
          switch(snapshot.connectionState)
          {
            case ConnectionState.none:
            case ConnectionState.done:
              List<DocumentSnapshot> docList = snapshot.data.documents.toList();
              return TicketScreen(docList);
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class TicketScreen extends StatefulWidget
{
  final List<DocumentSnapshot> docList;
  TicketScreen(this.docList);
  @override
  _TicketScreenState createState() => _TicketScreenState(docList);
}

class _TicketScreenState extends State<TicketScreen>
{
  final List<DocumentSnapshot> _productList;
  _TicketScreenState(this._productList);

  List<bool> visible = [];
  CalendarController _calendarController;
  DateTime selectedDate, startDay;

  @override
  void initState()
  {
    super.initState();
    _calendarController = CalendarController();
    startDay = DateTime.now().hour > 14 ? DateTime.now():DateTime.now().add(Duration(days: 1));
    for(int i = 0; i < _productList.length; i++)
    {
      visible.add(false);
    }
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
        bool checker = orientation == Orientation.portrait;

        return Scaffold
        (
          backgroundColor: Colors.white,
          appBar: appBar(orientation),
          body: Stack
          (
            children:
            [
              backgroundWidget(orientation),
              checker ? ListView
              (
                physics: ClampingScrollPhysics(),
                children:
                [
                  calendar(orientation),
                  AnimatedSwitcher
                  (
                    transitionBuilder: (Widget child, Animation<double> animation)
                    {
                      final  offsetAnimation = Tween<Offset>
                        (begin: Offset(0.0, 2.0), end: Offset(0.0, 0.0)).animate(animation);
                      return SlideTransition(child: child, position: offsetAnimation,);
                    },
                    duration: Duration(milliseconds: 1000),
                    child: selectedDate == null ?
                    Container() : portraitBuild(),
                  )
                ],
              ) : Stack
              (
                alignment: Alignment.topLeft,
                children:
                [
                  AnimatedSwitcher
                    (
                    transitionBuilder: (Widget child, Animation<double> animation)
                    {
                      final  offsetAnimation = Tween<Offset>
                        (begin: Offset(0.0, 2.0), end: Offset(0.0, 0.0)).animate(animation);
                      return SlideTransition(child: child, position: offsetAnimation,);
                    },
                    duration: Duration(milliseconds: 1000),
                    child: selectedDate == null ?
                    Container() : Container(alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width,child:landscapeBuild()),
                  ),
                  calendar(orientation)
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget portraitBuild()
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool checker = height>1.4*width;
    return GridView.builder
      (
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _productList.length,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: checker ? width/4: width/5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
          (mainAxisSpacing: width/25, crossAxisSpacing: width/20, crossAxisCount: checker ? 1:2),
        itemBuilder: (context, index)
        {
          Map data = _productList.elementAt(index).data;
          return productCard(data, index, true);
        }
    );
  }

  Widget landscapeBuild()
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool checker = 1.3*height>width;
    return Scaffold
    (
      backgroundColor: Colors.transparent,
      appBar: PreferredSize
      (
        preferredSize: Size.fromHeight(200),
        child: Container
        (
          padding: EdgeInsets.only(top: 50, bottom: 50, left: 500, right: width/16),
          child: Text('Escolha seu pacote', style: TextStyle(fontSize: 50,
              color: Colors.grey[700], fontFamily: 'Fredoka')),
        ),
      ),
      body: GridView.builder
        (
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _productList.length,
          padding: EdgeInsets.only(left: width/2.5, right: width/16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
            (mainAxisSpacing: 20, crossAxisSpacing:20, crossAxisCount: checker ? 3:4),
          itemBuilder: (context, index)
          {
            Map data = _productList.elementAt(index).data;
            return productCard(data, index, false);
          }
      ),
    );
  }

  Widget productCard(Map data, int index, bool isPortrait)
  {
    return Container
      (
        alignment: Alignment.center,
        child: Container
        (
          decoration: new BoxDecoration
          (
            boxShadow:
            [
              new BoxShadow
                (
                color: Colors.black38,
                offset: Offset(-10, 10),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Stack
          (
            children:
            [
              Center(child: CircularProgressIndicator()),
              AspectRatio
              (
                aspectRatio: 1,
                child: ClipRRect
                (
                  borderRadius: BorderRadius.circular(4),
                  child: FadeInImage.memoryNetwork
                  (
                    placeholder: kTransparentImage,
                    image: data['url'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              AnimatedOpacity
                (
                opacity: visible[index]? 1.0 : (isPortrait ? 1.0 : 0.0),
                duration: Duration(milliseconds: 200),
                child: AspectRatio
                  (
                  aspectRatio: 1,
                  child: Container
                  (
                    decoration: BoxDecoration
                    (
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0x4400FF00),
                    ),
                  ),
                ),
              ),
              AspectRatio
              (
                aspectRatio: 1,
                child: Material
                (
                  color: Colors.transparent,
                  child: InkWell
                  (
                    borderRadius: BorderRadius.circular(4),
                    onHover: (hover)
                    {
                      setState(() => visible[index] = !visible[index]);
                    },
                    onTap: (){html.window.location.href = 'http://guarapark.com';},
                    hoverColor: Color(0x4400AAFF),
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }

  Widget appBar(orientation)
  {
    bool isPortrait = orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;
    return PreferredSize
    (
      preferredSize: Size.fromHeight(isPortrait? 80 : 100),
      child: Container
        (
        width: width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(width/10, 10, width/20, 10),
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
            isPortrait?
              Image.asset('lib/assets/img/logo_reduced.png', height: 120):
              Image.asset('lib/assets/img/logo_full.png', height: 120),
            Expanded(child: Container()),
            FlatButton
            (
              shape: isPortrait?
                      CircleBorder(): RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              color: Colors.blue,
              onPressed: () => html.window.location.href = 'http://guarapark.com',
              child: Container(height: 50, alignment: Alignment.center,
                child: orientation == Orientation.portrait?
                  Icon(Icons.home, size: 30, color: Colors.white):
                  Text('Voltar para a página inicial', style: TextStyle
                        (color: Colors.white, fontFamily: 'Fredoka', fontSize: 20))),
            )
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

  Widget calendar(orientation)
  {
    double width = MediaQuery.of(context).size.width;
    bool checker = orientation == Orientation.portrait;

    void _onDaySelected(DateTime day, List events)
    {
      print('CALLBACK: _onDaySelected');
      if(day.isAfter(startDay)) setState(() => selectedDate = day);
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
            border: Border.all(color: Colors.blue, width: 2)
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
          headerStyle: HeaderStyle
            (
            formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration
              (
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onDaySelected: _onDaySelected,
        ),
      );
    }

    Widget landscapeCalendar()
    {
      return Container
        (
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: width/16),
        padding: EdgeInsets.all(10),
        height: 300,
        width: 300,
        decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2)
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
          headerStyle: HeaderStyle
            (
            formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration
              (
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onDaySelected: _onDaySelected,
        ),
      );
    }

    return checker ? portraitCalendar():landscapeCalendar();
  }
}

