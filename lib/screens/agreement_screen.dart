import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guarappweb/screens/calendar_screen.dart';
import 'package:guarappweb/widgets/background_widget.dart';

class AgreementScreen extends StatefulWidget
{
  @override
  _AgreementScreenState createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen>
{
  String terms = '    Eu, ao aceitar este termo, declaro para os devidos fins que, ao ingressar nas'
      ' dependências do Guará Acqua Park – Parque Aquático e Restaurante, estou ciente de'
      ' todas as recomendações e orientações dos órgãos de saúde federal e estadual, e';
  String termsBold = ' me responsabilizo';
  String terms2 =   ', sobre minha pessoa e de meus convidados, com a utilização de'
      ' máscaras e manutenção de distanciamento social mínimo de 1,5 m (um metro e'
      ' cinquenta centímetros) entre pessoas de grupos familiares diversos.\n';
  String terms3 = '  Declaro, ainda, que utilizei, assim como meus convidados, a câmara de'
      ' higienização disponibilizada na entrada do estabelecimento, bem como estou ciente que'
      ' as demais medidas sanitárias de prevenção, tais como lavar as mãos e utilizar álcool em'
      ' gel, são imprescindíveis para evitar a proliferação do novo coronavírus.';
  bool isActive = false;
  ScrollController scrollController = ScrollController();
  ScrollController foregroundController = ScrollController();

  void openCalendarScreen()
  {
    Navigator.of(context).push(MaterialPageRoute
      (builder: (context) => CalendarScreen()));
  }

  Widget foreground()
  {
    return CupertinoScrollbar
    (
      controller: foregroundController,
      isAlwaysShown: true,
      child: SingleChildScrollView
      (
        controller: foregroundController,
        child: Column
          (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
          [
            Container
              (
              margin: EdgeInsets.all(50),
              alignment: Alignment.center,
              child: Text('TERMO DE RESPONSABILIDADE', style: TextStyle
                (fontSize: 40, fontFamily: 'Fredoka', color: Colors.grey[700]),
                  textAlign: TextAlign.center),
            ),
            Container
              (
                margin: EdgeInsets.symmetric(horizontal: 75),
                height: MediaQuery.of(context).size.height - 320,
                decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 2),
                    color: Colors.white
                ),
                child: CupertinoScrollbar
                  (
                  controller: scrollController,
                  isAlwaysShown: true,
                  child: SingleChildScrollView
                    (
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Container
                        (
                          padding: EdgeInsets.all(15),
                          child: RichText
                            (
                            textAlign: TextAlign.justify,
                            text: TextSpan
                              (
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                children: <TextSpan>
                                [
                                  TextSpan(text: terms, style: TextStyle
                                    (fontSize: 20, color: Colors.black)),
                                  TextSpan(text: termsBold, style: TextStyle
                                    (fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                                  TextSpan(text: terms2, style: TextStyle
                                    (fontSize: 20, color: Colors.black)),
                                  TextSpan(text: terms3, style: TextStyle
                                    (fontSize: 20, color: Colors.black))
                                ]
                            )
                            ,
                          ))
                  ),
                )
            ),
            Padding
              (
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 75),
              child: CheckboxListTile
                (
                title: Text('Eu aceito o termo de responsabilidade acima', style:
                TextStyle(fontSize: 14, fontFamily: 'Fredoka', color: Colors.black),
                    textAlign: TextAlign.right),
                onChanged: (value)
                {
                  setState(() => isActive = value);
                },
                value: isActive,
              ),
            ),
            Container
              (
              padding: EdgeInsets.symmetric(horizontal: 75),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              child: FlatButton
                (
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                disabledColor: Colors.blueGrey[100],
                color: Colors.blue,
                onPressed: isActive ? () => openCalendarScreen() : null,
                child: Container
                  (
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  height: 45,
                  child: Container(child: Text('Avançar', style: TextStyle
                    (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: Stack
      (
        children:
        [
          backgroundWidget(MediaQuery.of(context).size.height, true),
          foreground()
        ],
      ),
    );
  }
}
