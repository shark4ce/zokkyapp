import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:zokkyapp/screens/wrapper.dart';
import 'package:zokkyapp/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          hintColor: Colors.grey[400],
          primaryColor: Colors.grey[600],
          canvasColor: Colors.transparent
        ),
        home: Wrapper(),
      ),
    );
  }
}