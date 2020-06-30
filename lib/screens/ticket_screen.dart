import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarappweb/screens/product_screen.dart';
import 'package:guarappweb/widgets/app_bar.dart';
import 'package:guarappweb/widgets/background_widget.dart';
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
  ScrollController scrollController = ScrollController();

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return OrientationBuilder
    (
      builder: (context, orientation)
      {
        bool isPortrait = orientation == Orientation.portrait;

        return Scaffold
        (
          backgroundColor: Colors.white,
          appBar: appBar(width, context),
          body: Stack
          (
            children:
            [
              backgroundWidget(height, isPortrait),
              isPortrait ? portraitBuild(width, height) : landscapeBuild(width, height)
            ],
          ),
        );
      },
    );
  }

  Widget portraitBuild(width, height)
  {
    bool sizeChecker = height>1.2*width;
    return GridView.builder
      (
        physics: BouncingScrollPhysics(),
        itemCount: _productList.length,
        padding: EdgeInsets.fromLTRB(75, 10, 75, 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
          (mainAxisSpacing: width/20, crossAxisSpacing: width/20, crossAxisCount: sizeChecker ? 1:2),
        itemBuilder: (context, index)
        {
          Map data = _productList.elementAt(index).data;
          return productCard(data, index, true);
        }
    );
  }

  Widget landscapeBuild(width, height)
  {
    bool sizeChecker = 1.6*height>width;
    bool sizeChecker2 = 1.25*height>width;
    return Scrollbar
    (
      isAlwaysShown: true,
      controller: scrollController,
      child: SingleChildScrollView
      (
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        child: Column
          (
          children:
          [
            Container
            (
              padding: EdgeInsets.only(top: 40, left: 400,
                  right: sizeChecker ? 100 : 150, bottom: 40),
              child: Text('Escolha seu pacote', style: TextStyle(fontSize: sizeChecker ?
              (sizeChecker2 ? width/15:width/20):width/25,
                  color: Colors.grey[700], fontFamily: 'Fredoka')),
            ),
            GridView.builder
              (
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _productList.length,
                padding: EdgeInsets.fromLTRB(400, 10, 150, 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                  (mainAxisSpacing: width/40, crossAxisSpacing: width/40,
                    crossAxisCount: sizeChecker ? (sizeChecker2 ? 2 : 3): 4),
                itemBuilder: (context, index)
                {
                  Map data = _productList.elementAt(index).data;
                  return productCard(data, index, false);
                }
            ),
          ],
        ),
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
                    child: isWeekend ? Image.network(data['mask_weekend']) : Image.network(data['mask_week']),
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
                    onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(data, selectedDate)));},
                    hoverColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

