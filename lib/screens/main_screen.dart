import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quissezz/models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/drawer.dart';
import '../screens/quizz_screen.dart';
import '../providers/questionsProvider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future future;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<QuestionsProvider>(context, listen: false).getData();
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Quissezz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: "Terlusuri...",
                suffixIcon: const Icon(Icons.search)
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              height: 200,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder:((context, index) => 
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              width: MediaQuery.of(context).size.width*(40/100),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey
                              ),
                              child: const Center(child: Text("Category", style: TextStyle(fontSize: 23),),),
                            ),
                          ),
                        )
                      )
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Consumer<QuestionsProvider>(
              builder: (ctx, data, ch) => Expanded(
                child: ListView.builder(
                  itemCount: data.getItemsAll().length,
                  itemBuilder: ((context, index) => 
                    Card(
                      child: ListTile(
                        title: Text(data.getItemsAll()[index].toString()),
                        onTap:()async{
                          final id = data.getItemsAll()[index].toString();
                          final pref = await SharedPreferences.getInstance();
                          pref.setString('session', id);

                          Navigator.of(context).pushNamed(QuizzScreen.routeName());
                         
                        },
                      ),
                    )
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}