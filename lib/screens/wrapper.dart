import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zokkyapp/screens/authenticate/authenticate.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:zokkyapp/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
