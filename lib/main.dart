import 'package:flutter/material.dart';
import 'package:guarappweb/screens/calendar_screen.dart';
import 'package:guarappweb/screens/ticket_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Guarapp Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold
      (
        body: CalendarScreen(),
      ),
    );
  }
}
