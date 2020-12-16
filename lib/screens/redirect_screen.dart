import 'package:flutter/material.dart';
import 'package:guarappweb/widgets/app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class RedirectScreen extends StatefulWidget
{
  final Map<String, dynamic> checkoutMap;
  RedirectScreen(this.checkoutMap);

  @override
  _RedirectScreenState createState() => _RedirectScreenState(checkoutMap);
}

class _RedirectScreenState extends State<RedirectScreen>
{
  final Map<String, dynamic> checkoutMap;
  _RedirectScreenState(this.checkoutMap);

  Future<Map<String, dynamic>> getPage() async
  {
    http.Response response;

    String url = 'https://cors-anywhere.herokuapp.com/https://cieloecommerce.cielo.com.br/api/public/v1/orders';
    String jsonMap = jsonEncode(checkoutMap);
    Map<String, String> headers =
    {
      'Content-Type': 'application/json',
      'MerchantId' : ''
    };

    response = await http.post(url, headers: headers, body: jsonMap);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    return Scaffold
    (
      appBar: appBar(width, context),
      body: FutureBuilder
      (
        future: getPage(),
        builder: (context, snapshot)
        {
          if(snapshot.data != null)
          {
            String url = snapshot.data["settings"]["checkoutUrl"];
            html.window.location.href = url;
          }
          return Container
          (
            width: width,
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text("Você será redirecionado à pagina de pagamento...",
                      style: TextStyle(fontSize: 25, fontFamily: 'Fredoka'),
                      textAlign: TextAlign.center),
                ),
                Center(child: CircularProgressIndicator())
              ],
            ),
          );
        },
      ),
    );
  }
}
