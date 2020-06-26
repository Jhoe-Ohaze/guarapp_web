import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

class PreLoadTicketScreen extends StatefulWidget
{
  final DateTime selectedDate;
  PreLoadTicketScreen(this.selectedDate);
  @override
  _PreLoadTicketScreenState createState() => _PreLoadTicketScreenState(selectedDate);
}

class _PreLoadTicketScreenState extends State<PreLoadTicketScreen>
{
  final DateTime selectedDate;
  _PreLoadTicketScreenState(this.selectedDate);
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
              return TicketScreen(docList, selectedDate);
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
  final DateTime selectedDate;
  TicketScreen(this.docList, this.selectedDate);
  @override
  _TicketScreenState createState() => _TicketScreenState(docList, selectedDate);
}

class _TicketScreenState extends State<TicketScreen>
{
  final List<DocumentSnapshot> _productList;
  final DateTime selectedDate;
  _TicketScreenState(this._productList, this.selectedDate);
  bool isWeekend;
  List<bool> visible = [];

  @override
  void initState()
  {
    super.initState();
    isWeekend = (selectedDate.weekday == 6 || selectedDate.weekday == 7);
    for(int i = 0; i < _productList.length; i++)
    {
      visible.add(false);
    }
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
              checker ? portraitBuild():landscapeBuild()
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
        physics: ClampingScrollPhysics(),
        itemCount: _productList.length,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
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
    bool checker = 1.6*height>width;
    bool checker2 = 1.25*height>width;
    return SingleChildScrollView
    (
      physics: ClampingScrollPhysics(),
      child: Column
      (
        children:
        [
          Container
            (
            padding: EdgeInsets.only(top: 40, left: checker ? 100 : 150,
                right: checker ? 100 : 150, bottom: 40),
            child: Text('Escolha seu pacote', style: TextStyle(fontSize: checker ?
              (checker2 ? width/15:width/20):width/25,
                color: Colors.grey[700], fontFamily: 'Fredoka')),
          ),
          GridView.builder
            (
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _productList.length,
              padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                (mainAxisSpacing: width/25, crossAxisSpacing: width/25,
                  crossAxisCount: checker ? (checker2 ? 2 : 3): 4),
              itemBuilder: (context, index)
              {
                Map data = _productList.elementAt(index).data;
                return productCard(data, index, false);
              }
          ),
        ],
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
                  child: ClipRRect
                  (
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(isWeekend ? data['mask_weekend']:data['mask_week']),
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
                    hoverColor: Colors.transparent,
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
      preferredSize: Size.fromHeight(95),
      child: Container
        (
        width: width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(80, 10, 30, 10),
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

