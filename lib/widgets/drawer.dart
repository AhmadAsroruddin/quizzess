import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quissezz/providers/questionsProvider.dart';
import 'package:quissezz/screens/addQuestion_Screen.dart';

import './drawer_header.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldmessenger = ScaffoldMessenger.of(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          MyHeaderDrawer(),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text("Riwayat"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("My Quiss"),
            onTap: () {
              Navigator.of(context).pushNamed(AddQuestion.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}