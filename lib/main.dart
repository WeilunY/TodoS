import 'package:flutter/material.dart';
import './views/home/home.dart';
import './views/home/task_page.dart';
import './views/login/login.dart';
import './views/login/register.dart';
import './views/login/splash.dart';
import 'style.dart';
import 'package:camera/camera.dart';
import './views/home/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: bottomBarColor,
       
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



