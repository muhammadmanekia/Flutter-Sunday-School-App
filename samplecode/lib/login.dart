import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';

class Post {
  final int id;
  final String lastName;
  final String givenName;

  Post({this.id, this.lastName, this.givenName});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      lastName: json['lastName'],
      givenName: json['givenName'],
    );
  }
}

class login extends StatefulWidget {

  final Map<String, dynamic> sharedData;
  login({this.sharedData});

  @override
  _loginState createState() => _loginState(sharedData: sharedData);
}

TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class _loginState extends State<login> {

    final Map<String, dynamic> sharedData;
  _loginState({this.sharedData});


final usernameField = TextFormField(
  controller: usernameController,
  style: TextStyle(
    fontSize: 18,
    fontFamily: "Poppins-Medium",),
  decoration: InputDecoration(
    hintText: "Username"
),
);

final passwordField = TextFormField(
  controller: passwordController,
    obscureText: true,
    style: TextStyle(
      fontSize: 18,
      fontFamily: "Poppins-Medium",),
    decoration: InputDecoration(
      hintText: "Password"
  ),
);

final GlobalKey<ScaffoldState>_scaffoldKey = new GlobalKey<ScaffoldState>();
 _showSnackBar (){
   print("Invalid");
   final snackBar = new SnackBar(
     content: new Text("Invalid"),
     duration: new Duration(seconds: 3),
     action: new SnackBarAction(label: 'ok',onPressed: (){
       print("invalid");
     },),
   );
   _scaffoldKey.currentState.showSnackBar(snackBar);
 } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: 
          EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
              height: 80,
              child: Text("Login",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins-Bold",
              ),
              ),
              ),
              new Form(
              child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  child: usernameField
                    ),
              Container(
                height: 40,
                child: passwordField
              ),
              Container(
                child: new MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text("Sign In"),
                  onPressed: () async {                    
                    Map bodyMap = new Map<String, dynamic>();
                    bodyMap["Username"] = "${usernameController.text.trim()}";
                    bodyMap["Password"] = "${passwordController.text.trim()}";

                    http.Response response = await http.post('http://10.0.2.2:8081/login/', body: json.encode(bodyMap), headers: {
                      "Content-Type": "application/json"
                    });
                    debugPrint(response.statusCode.toString());
                    if (response.statusCode == 200) {
                      var user = json.decode(response.body);
                      sharedData["user"] =  user;
                      Navigator.pushNamed(context, '/HomePage');                      
                    } else { 
                      _showSnackBar();
                      }                               
                    debugPrint("${passwordController.text}");
                    },
                )
              )
              ]
              )
              ),
            ],
          ),
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15.0,
              )
            ]
          ),
        ),
      )
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
}