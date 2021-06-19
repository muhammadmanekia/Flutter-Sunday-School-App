import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'attendance.dart';

class grades extends StatefulWidget {
    final Map<String, dynamic> sharedData;
    grades({this.sharedData});

  @override
  _gradesState createState() => _gradesState(sharedData: sharedData);
}

class _gradesState extends State<grades> {
  
  final Map<String, dynamic> sharedData;
  _gradesState({this.sharedData});
  
  List data;
  List userData;

  Future getData() async {
    debugPrint(sharedData["classSelection"].toString());

    http.Response response; 
    Map<String, dynamic> selectedClass = sharedData["Class"];

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
    super.initState();
    getData();
  }


  final List<String> items = <String>['0','1','2','3','4','5','6','7','8','9','10'];
  final Map<int, String> selectedItem = new Map();
  
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
        title: Text("Scoring"),
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
        ),
      ),

      body:
      ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index){
              return Row (
                children: [
                  Container(
                    child: Text("${userData[index]["givenName"]}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ))
                  ),
                  // Container(
                  //   margin: EdgeInsets.all(20.0),
                  //   width: 100,
                  //   child:  TextField(
                  //     decoration: InputDecoration(
                  //       hintText: "Classwork"
                  //     ),
                  //   )
                  // ),
                  // Container(
                  //   margin: EdgeInsets.all(2.0),
                  //   width: 100,
                  //   child:  TextField(
                  //     decoration: InputDecoration(
                  //       hintText: "Homework"
                  //     ),
                  //   )
                  // ),
                  DropdownButton(
                      value: selectedItem[index],
                      onChanged: (String string) { 
                        setState(() { 
                          selectedItem[index] = string;
                          });
                          },
                      selectedItemBuilder: (BuildContext context) {
                           return items.map<Widget>((String item) {
                           return Text(item);
                         }).toList();
                          },
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              child: Text(item),
                              value: item,
                           );
                         }).toList(),
            
                       ),
                      ]
                     );
                    }
                  )
                );
              }
            }