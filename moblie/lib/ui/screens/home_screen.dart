import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
//  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Text('Hello mobx^^'),
        ),
      ),
    );
  }
}