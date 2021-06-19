import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'attendance.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

class Schedule extends StatefulWidget {
  final Map<String, dynamic> sharedData;
  Schedule({this.sharedData});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final Map<String, dynamic> sharedData;

  _ScheduleState ({this.sharedData});
    void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  TextEditingController _eventController = new TextEditingController();

  List _selectedEvents;
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<Map<dynamic, dynamic>>> _events = new Map();
  Future getData() async{
    final response = await http.get('http://10.0.2.2:8081/events');
    Map responseMap = json.decode(response.body);

    Map<String,dynamic> newMap = responseMap["_embedded"]["events"];

    setState(() {
      newMap.forEach((key,value) {
        _events[DateTime.parse(key)] = List<Map<dynamic, dynamic>>.from(newMap[key]);
      });
    }
    );
  }

  @override
   void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule'),
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
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                  events: _events,
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  showArrows: true,
                  showTodayIcon: true,
                  eventDoneColor: Colors.green,
                  eventColor: Colors.grey
                  ),
            ),
          _buildEventList()
        ]
        )
      ),
        floatingActionButton: FloatingActionButton (
          child: Icon(Icons.add),
          onPressed: _showAddDialog,
          ),
      );
  }
  
  Widget _buildEventList() {
     _selectedEvents = _events[_selectedDay] ?? [];
     debugPrint(_events.toString());
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) { 
          return Dismissible (
            key: new Key(_selectedEvents[index]['name'].toString()), 
            onDismissed: (direction) {
              _selectedEvents.removeAt (index);
              Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Item Dismissed"),));
              updateEvents();
            },
            child: new Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.black12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                child: ListTile(
                  title: Text(_selectedEvents[index]['name'].toString()),
                  onTap: () {},
                ),
              )
            ); 
        },
        itemCount: _selectedEvents.length,
      ),
    );
  }
updateEvents() async {
  Map bodyMap = new Map<String, dynamic>();

  bodyMap["date"] = DateFormat('yyyy-MM-dd').format(_selectedDay);
  bodyMap["events"] = _selectedEvents; // _eventController.text.trim();
  debugPrint(bodyMap.toString());

  await http.post('http://10.0.2.2:8081/events', body: json.encode(bodyMap), headers: {
    "Content-Type": "application/json"
  });
  Navigator.of(context, rootNavigator: true).pop();
  await getData();
}
_showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: () async {
              Map<dynamic, dynamic> entry = new Map();
              entry["name"] = _eventController.text.trim();
              entry["isDone"] = false;
               _selectedEvents.add(entry);
               await updateEvents();
            }
          )
        ]
      )
    );
  }
}
