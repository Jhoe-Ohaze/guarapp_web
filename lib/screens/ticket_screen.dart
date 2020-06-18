import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Firestore.instance.collection('test').add({'test' : 'ok'});
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
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              List<DocumentSnapshot> docList = snapshot.data.documents.toList();
              return TicketScreen(docList);
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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: ListView.builder
      (
        itemCount: _productList.length,
        itemBuilder: (context, index)
        {
          Map data = _productList.elementAt(index).data;
          return Container
          (
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: InkWell
            (
              onTap: (){launch("https://www.google.com.br");},
              child: Column
                (
                children:
                [
                  SizedBox
                    (
                    height: 300,
                    width: 300,
                    child: ClipRRect
                      (
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: Image.network(data['url'], fit: BoxFit.cover,
                          alignment: Alignment.center, width: 300),
                    ),
                  ),
                  Container
                    (
                    width: 300,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(color: Colors.redAccent,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Column
                      (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text(data["name"], style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(data['description'], style: TextStyle(color: Colors.white))
                      ],
                    ),
                  )
                ],
              ),
            )
          );
        }
      ),
    );
  }
}

