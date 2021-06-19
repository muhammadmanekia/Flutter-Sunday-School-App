import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';

class AttendancePage extends StatefulWidget {
  final Map<String, dynamic> sharedData;
  AttendancePage({this.sharedData});
  @override
  _AttendancePageState createState() => _AttendancePageState(sharedData: sharedData);
}

class _AttendancePageState extends State<AttendancePage> {
  final Map<String, dynamic> sharedData;
  _AttendancePageState({this.sharedData});

  List<bool> _isSelected = List.generate(3, (index) => false);

  List data;
  List userData;

  Future getData() async {
    debugPrint(sharedData["classSelection"].toString());

    http.Response response; 

    Map<String, dynamic> selectedClass = sharedData["class"];

    if (selectedClass["sessionType"] == "QA") {
      response = await http.get("http://10.0.2.2:8081/students/?quranlevel="+selectedClass["sessionDetails"]); 
    } else {
      response = await http.get("http://10.0.2.2:8081/students/?islamic="+selectedClass["sessionDetails"]); 
    }

    data = json.decode(response.body);
    setState(() {
    userData = data;
    }
    );
  }

  @override
  void initState() {
    _isSelected = [true,false,false];
    super.initState();
    getData();
  }


  DateTime _currentdate = new DateTime.now();
  DateFormat _currentDateFormat;

  Future<Null> _selectdate(BuildContext context) async{
      final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2021),
        builder: (context,child) {
          return SingleChildScrollView(child: child,);
        }
      );
      if(_seldate!=null) {
        setState(() {
          _currentdate = _seldate;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    String _currentDateFormat =  DateFormat('MMM-dd-yy').format(_currentdate);
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          new Text('$_currentDateFormat'),
          IconButton(onPressed: (){
            _selectdate(context);
            },
            icon: Icon(Icons.calendar_today),),
        ],
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
          ]
        )
      ),

      body:
      ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index){
              return Row (
                children: [
                Container(
                    child: Text("${userData[index]["givenName"]}"),
                ),
                new SizedBox(
                  width: 50,
                child: FlatButton(
                  child: Text('P', style: const TextStyle(color: Colors.red)),
                  onPressed: (){
                    Map bodyMap = new Map<String, dynamic>();
                    bodyMap["name"] = "${userData[index]["givenName"]}";
                    bodyMap["attendance"] = "P";
                    bodyMap["date"] = "$_currentDateFormat";

                    http.post('http://10.0.2.2:8081/attendance/', body: json.encode(bodyMap), headers: {
                      "Content-Type": "application/json"
                    });

                    debugPrint("${userData[index]["givenName"]} is Present");
                  }
                ),
                ),
              new SizedBox(
               child:ToggleButtons(
                borderWidth: .7,
                selectedBorderColor: Colors.black,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(0),
                children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'P',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'A',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'L',
                        style: TextStyle(fontSize: 16),
                    ),
                    )
                  ],
                  isSelected: _isSelected,
                  onPressed: (int index) {
                    setState(() {
                      _isSelected = [false,false,false];
                      _isSelected[index] = !_isSelected[index];
                    });
                },
              )
              ),
                // child: FlatButton(
                //   child: Text('A', style: const TextStyle(color: Colors.red)),
                //   onPressed: (){ 
                //     Map bodyMap = new Map<String, dynamic>();
                //     debugPrint("${userData[index]["givenName"]} is Absent");
                //     bodyMap["name"] = "${userData[index]["givenName"]}";
                //     bodyMap["attendance"] = "A";
                //     bodyMap["date"] = "$_currentDateFormat";

                //     http.post('http://10.0.2.2:8081/attendance/', body: json.encode(bodyMap), headers: {
                //       "Content-Type": "application/json"
                //     });
                //   }
                // ),
                //),
                new SizedBox(
                  width: 50,
                child: FlatButton(
                  child: Text('L', style: const TextStyle(color: Colors.red)),
                  onPressed: (){
                    Map bodyMap = new Map<String, dynamic>();
                    debugPrint("${userData[index]["givenName"]} is Late");
                    bodyMap["name"] = "${userData[index]["givenName"]}";
                    bodyMap["attendance"] = "L";
                    bodyMap["date"] = "$_currentDateFormat";

                    http.post('http://10.0.2.2:8081/attendance/', body: json.encode(bodyMap), headers: {
                      "Content-Type": "application/json"
                    }
                  );
                }
              )
             )
            ]
          );
          }
      )
    );
  }
}