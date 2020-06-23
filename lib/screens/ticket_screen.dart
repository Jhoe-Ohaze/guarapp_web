import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: OrientationBuilder
      (
        builder: (context, orientation)
        {
          bool isPortrait = orientation == Orientation.portrait;
          return isPortrait ? portraitBuild():landscapeBuild();
        },
      ),
    );
  }

  Widget portraitBuild()
  {
    return ListView.builder
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
                onTap: ()
                {
                  DateTime now = DateTime.now();
                  String id = '';
                  Map<String, dynamic> checkoutMap =
                  {
                    "OrderNumber":id,
                    "SoftDescriptor":"",
                    "Cart":{
                      "Discount":{
                        "Type":"Percent",
                        "Value":00
                      },
                      "Items":
                      [
                        {
                          "Name":"Ingresso infantil",
                          "Description":"",
                          "UnitPrice":100*kidPrice.toInt(),
                          "Quantity":kidAmount,
                          "Type":"Asset",
                          "Sku":"ABC001",
                          "Weight":0
                        },
                      ]
                    },
                    "Shipping":{
                      "SourceZipCode":"",
                      "TargetZipCode":"",
                      "Type":"WithoutShippingPickUp",
                      "Services":[],
                      "Address":{
                        "Street":"",
                        "Number":"",
                        "Complement":"",
                        "District":"",
                        "City":"",
                        "State":""
                      }
                    },
                    "Payment":{
                      "BoletoDiscount":0,
                      "DebitDiscount":0,
                      "Installments":null,
                      "MaxNumberOfInstallments": null
                    },
                    "Customer":{
                      "Identity":"",
                      "FullName":"",
                      "Email":"",
                      "Phone":""
                    },
                    "Options":{
                      "AntifraudEnabled":true,
                      "ReturnUrl": ""
                    },
                    "Settings":null
                  };
                },
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
    );
  }

  Widget landscapeBuild()
  {
    return Container(color: Colors.red);
  }
}

