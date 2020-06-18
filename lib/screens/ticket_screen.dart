import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              return Container();
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
          return Image.network(data['url'], width: MediaQuery.of(context).size.width,);
        }
      ),
    );
  }
}
