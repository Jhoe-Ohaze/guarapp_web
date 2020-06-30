import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guarappweb/screens/redirect_screen.dart';
import 'package:guarappweb/widgets/app_bar.dart';
import 'package:guarappweb/widgets/background_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductScreen extends StatefulWidget
{
  final Map data;
  final DateTime selectedDate;
  ProductScreen(this.data, this.selectedDate);

  @override
  _ProductScreenState createState() => _ProductScreenState(data, selectedDate);
}

class _ProductScreenState extends State<ProductScreen>
{
  final Map<String, dynamic> data;
  final DateTime selectedDate;
  _ProductScreenState(this.data, this.selectedDate);

  int day, month, year;
  String milisec, selectedDayString, checkoutID;
  bool isWeekend;

  Map<String, dynamic> checkoutMap;

  @override
  void initState()
  {
    day = selectedDate.day; month = selectedDate.month; year = selectedDate.year;
    selectedDayString = '${day < 10 ? '0$day' : day}/${month < 10 ? '0$month' : month}/$year';
    milisec = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    isWeekend = (selectedDate.weekday == 6 || selectedDate.weekday == 7);

    checkoutID = '$year${month < 10 ? '0$month' : month}${day < 10 ? '0$day' : day}'
        '${data['position']}${data['amount_adult']}${data['amount_kid']}$milisec';

    checkoutMap = {
      "OrderNumber": checkoutID,
      "SoftDescriptor": "",
      "Cart":{
        "Discount":{
          "Type":"Percent",
          "Value":00
        },
        "Items":
        [
          {
            "Name": data['name'],
            "Description": data['description'],
            "UnitPrice": isWeekend ? data['price_weekend'] : data['price_week'],
            "Quantity": 1,
            "Type":"Asset",
            "Sku":"",
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
  }

  void openPaymentScreen(checkoutMap)
  {
    Navigator.of(context).push(MaterialPageRoute
      (builder: (context) => RedirectScreen(checkoutMap)));
  }

  Widget buildPortrait(height, width)
  {
    return Container
      (
      height: height,
      padding: EdgeInsets.only(left: 75, top: 25, right: 75),
      child: SingleChildScrollView
        (
        physics: BouncingScrollPhysics(),
        child: Column
          (
          children:
          [
            Container
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
                    alignment: Alignment.center,
                    children:
                    [
                      Center(child: CircularProgressIndicator()),
                      AspectRatio
                        (
                        aspectRatio: 6/5,
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
                    ],
                  ),
                )
            ),
            Padding
              (
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Text('Pacote ${data['name']}', style: TextStyle(fontSize: 35, fontFamily:
                'Fredoka', color: Colors.grey[600]), textAlign: TextAlign.center)
            ),
            Text(data['description'], style: TextStyle(fontSize: 25, fontFamily:
            'Fredoka', color: Colors.blueGrey[300]), textAlign: TextAlign.center),
            Padding
              (
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Text('Dia escolhido: $selectedDayString', style: TextStyle(fontSize: 25, fontFamily:
              'Fredoka', color: Colors.amber[600]), textAlign: TextAlign.center),
            ),
            FlatButton
              (
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              disabledColor: Colors.blueGrey[100],
              color: Colors.blue,
              onPressed: () => openPaymentScreen(checkoutMap),
              child: Container
                (
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                height: 45,
                width: width - 150,
                child: Row
                  (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Container(child: Text('Confirmar  ', style: TextStyle
                      (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                    Container(child: Icon(Icons.check, size: 30, color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLandscape(isPortrait, width)
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
              child: Container
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
                      alignment: Alignment.center,
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
                      ],
                    ),
                  )
              ),
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
                  Padding
                    (
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text('Pacote ${data['name']}', style: TextStyle(fontSize: 40, fontFamily:
                      'Fredoka', color: Colors.grey[600]), textAlign: TextAlign.center)
                  ),
                  Text(data['description'], style: TextStyle(fontSize: 25, fontFamily:
                  'Fredoka', color: Colors.blueGrey[300]), textAlign: TextAlign.center),
                  Padding
                    (
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Text('Dia escolhido: $selectedDayString', style: TextStyle(fontSize: 25, fontFamily:
                    'Fredoka', color: Colors.amber[600]), textAlign: TextAlign.center),
                  ),
                  FlatButton
                    (
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    disabledColor: Colors.blueGrey[100],
                    color: Colors.blue,
                    onPressed: () => openPaymentScreen(checkoutMap),
                    child: Container
                      (
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      height: 45,
                      width: width - 150,
                      child: Row
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Container(child: Text('Confirmar  ', style: TextStyle
                            (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                          Container(child: Icon(Icons.check, size: 30, color: Colors.white))
                        ],
                      ),
                    ),
                  )
                ]
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold
      (
        appBar: appBar(width, context),
        body: OrientationBuilder
          (
          builder: (context, orientation)
          {
            bool isPortrait = orientation == Orientation.portrait;
            return Stack
              (
              children:
              [
                backgroundWidget(height, isPortrait),
                isPortrait ? buildPortrait(height, width) : buildLandscape(isPortrait, width)
              ],
            );
          },
        )
    );
  }
}
