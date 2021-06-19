import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samplecode/schedule.dart';
import 'dart:async';
import 'dart:convert';
import 'attendance.dart';
import 'grades.dart';
import 'login.dart';
import 'schedule.dart';
import 'classdashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> sharedData = new Map();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(sharedData: sharedData),
      routes: <String, WidgetBuilder>{
        '/AttendancePage': (context) => AttendancePage(sharedData: sharedData),
        '/HomePage': (context) => HomePage(sharedData: sharedData,),
        '/grades': (context) => grades(sharedData: sharedData),
        '/schedule': (context) => Schedule(sharedData: sharedData),
        '/ClassDashboard': (context) => ClassDashboard(sharedData: sharedData),
      },
    );
  }
}

class HomePage extends StatefulWidget {

  final Map<String, dynamic> sharedData;

  HomePage({this.sharedData});

  @override
  _HomePageState createState() => _HomePageState(sharedData: sharedData);

}

class _HomePageState extends State<HomePage> {

  TextEditingController _classController = new TextEditingController();

  List<dynamic> classes = new List();

  final Map<String, dynamic> sharedData;

  _HomePageState({this.sharedData});

  var _newColor;
  var _shape;
  var _shapei;
  var _margin;
  var _margini;
  var _img;
  var _imgi;
  double _height;
  double _heighti;


  @override
  Widget build(BuildContext context) {
    classes = sharedData["user"]["classes"];


    setState(() {
      _img = Image.network(
        'https://bitterwinter.org/wp-content/uploads/2019/02/Islamic-books.jpg',
        fit: BoxFit.fill,
      );
      _shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      );
      _margin = EdgeInsets.all(10);
      _height = 135;
    });


    setState(() {
      _imgi = Image.network(
        'https://www.quranicconnection.tv/wp-content/uploads/2019/02/UnderstandQuran.jpg',
        fit: BoxFit.fill,
      );
      _shapei = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      );
      _margini = EdgeInsets.all(10);
      _heighti = 135;
    });

    return Scaffold(
        appBar: AppBar(title: Text('IABA Madressa'),
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/HomePage');
                },
              ),
              new ListTile(
                title: Text('Attendance'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/AttendancePage');
                },
              ),
              new ListTile(
                title: Text('Scoring'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/grades');
                },
              ),
            ],
          ),
        ),
        body:
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Hi ${sharedData["user"]["givenName"]}",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: "Poppins-Bold",
                        fontSize: 40,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: TextField(
                                  controller: _classController,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text("Add Class"),
                                      onPressed: () async {
                                        //  Map bodyMap = new Map<String, dynamic>();
                                        //  bodyMap["Code"] = "${_classController.text.trim()}";

                                        http.Response response = await http.get(
                                            'http://10.0.2.2:8081/classes?code=' +
                                                _classController.text.trim(),
                                            headers: {
                                              "Content-Type": "application/json"
                                            });
                                        debugPrint(
                                            response.statusCode.toString());
                                        if (response.statusCode == 200) {
                                          var user = json.decode(response.body);
                                          sharedData["Class"] = user;
                                          myClass();
                                        }
                                      }
                                  )
                                ],
                              );
                            }
                        );
                      }
                  ),

                  Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: ListView.builder(
                          itemCount: classes == null ? 0 : classes.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (classes == null || classes.length == 0) {
                              Text("You Have No Classes",
                                style: TextStyle(fontSize: 40),);
                            }
                            debugPrint(classes[index].toString());
                            bool isQuranClass = classes[index]["sessionType"] ==
                                "QA";
                            return new GestureDetector(
                              onTap: () {
                                Navigator.pushNamed<dynamic>(
                                    context, '/ClassDashboard',
                                    arguments: classes[index]);
                              },
                              child: new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  height: isQuranClass ? _height : _heighti,
                                  child: isQuranClass ? _img : _imgi,
                                ),
                                shape: isQuranClass ? _shape : _shapei,
                                elevation: 5,
                                margin: isQuranClass ? _margin : _margini,
                              ),
                            );
                          }
                      )
                  ),

                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                          "Your Topic for the upcoming week is $_selectedEvents",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins-Bold",
                              fontSize: 20)
                      )
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: RaisedButton(
                      color: _newColor,
                      child: Container(
                        color: _newColor,
                        child: Text("Schedule",
                          style: TextStyle(
                              fontSize: 36,
                              fontFamily: "Poppins-Bold"),),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/schedule');
                      },
                    ),
                  )
                ]
            )
        )
    );
  }

  Map _event;
  List _selectedEvents;

  Future eventData() async {
    final response = await http.get('http://10.0.2.2:8081/events');
    _event = json.decode(response.body);
    setState(() {
      _selectedEvents = _event["_embedded"]["events"][DateFormat('yyyy-MM-dd').format(
          DateTime.now())];
    }
    );
  }

  myClass() async {
    Map<String, String> myclass = new Map();

    myclass["sessionType"] = sharedData["Class"]["sessionType"];
    myclass["sessionDetails"] = sharedData["Class"]["sessionDetails"];

    classes.add(myclass);

    Map<String, dynamic> map = new Map();
    map["teacherId"] = sharedData["user"]["id"];
    map["classes"] = classes;

    await http.post(
        'http://10.0.2.2:8081/classes', body: json.encode(map), headers: {
      "Content-Type": "application/json"
    });
  }

} 

