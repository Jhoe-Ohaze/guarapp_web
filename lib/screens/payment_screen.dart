import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget
{
  final Map<String, dynamic> checkoutMap;

  PaymentScreen(this.checkoutMap);

  @override
  _PaymentScreenState createState() => _PaymentScreenState(checkoutMap);
}

class _PaymentScreenState extends State<PaymentScreen>
{
  final Map<String, dynamic> checkoutMap;
  _PaymentScreenState(this.checkoutMap);

  Future<Map> _getPage() async
  {
    http.Response response;
    String url = "https://cieloecommerce.cielo.com.br/api/public/v1/orders";
    
    response = await http.post(url,
      headers: <String, String>
      {
        'Content-Type': 'application/json',
        'MerchantId' : '8df7525e-666d-4c23-bd49-3a4496f3dfb0'
      },
      body: jsonEncode(checkoutMap));

    print(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text("Finalizar compra", style: TextStyle(fontFamily: "Fredoka")),
        centerTitle: true,
      ),
      body: FutureBuilder
      (
        future: _getPage(),
        builder: (context, snapshot)
        {
          switch(snapshot.connectionState)
          {
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              String url = snapshot.data["settings"]["checkoutUrl"];
              html.window.location.href = url;
              return Scaffold
              (
                body: Column
                (
                  children: <Widget>
                  [
                    Container(margin: EdgeInsets.all(10),
                        child: Text("Você será redirecionado para a página de pagamento...")),
                    MaterialButton
                      (
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: Colors.redAccent,
                      child: Text("Voltar", style: TextStyle(color: Colors.white)),
                      onPressed: (){Navigator.of(context).pop(); Navigator.of(context).pop();},
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
