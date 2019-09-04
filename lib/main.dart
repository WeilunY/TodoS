import 'package:flutter/material.dart';
import './views/home.dart';
import './views/task_page.dart';
import './views/login.dart';
import './views/register.dart';
import './views/splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Home'),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/task': (BuildContext context) => TaskPage(),
        '/home': (BuildContext context) => MyHomePage(title: 'Home'),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      }
    );
    
  }
}



