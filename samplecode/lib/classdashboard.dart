import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';

class ClassDashboard extends StatefulWidget {
  final Map<String, dynamic> sharedData;
  ClassDashboard({this.sharedData});
  @override
  _ClassDashboardState createState() => _ClassDashboardState();
}

class _ClassDashboardState extends State<ClassDashboard> {
  final Map<String, dynamic> sharedData;
  _ClassDashboardState({this.sharedData});
  
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    debugPrint("Args: " + args.toString());

    return Scaffold(
      appBar: AppBar(title: Text('IABA Madressa'),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new ListTile(
              title: Text('Home'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/HomePage');
              },
                ),
                new ListTile(
                  title: Text('Attendance'),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/AttendancePage');
                  },
                ),
                new ListTile(
                  title: Text('Scoring'),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/grades');
                  },
                ),
              ],
            ),
          ),
          body: 
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: RaisedButton(
                        color: Colors.white,
                        child: Container(
                        child: Text("Attendance",
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: "Poppins-Bold"
                        ),
                        ),
                        color: Colors.white,             
                        ),
                        onPressed:(){ Navigator.pushNamed(context, '/AttendancePage');}
                      ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(16),
                      child: RaisedButton(
                        color: Colors.white,
                        child:Container(
                          color: Colors.white,
                          child: Text("Scoring",
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: "Poppins-Bold" ),),
                        ),
                          onPressed: (){Navigator.pushNamed(context, '/grades');}
                        ),
                      ),
                    ],)
                ],)
    );
  }
}