import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/question.dart';

class QuestionsProvider with ChangeNotifier{
  String? _userId;
  String? token;

  List<Questions> _items =[
    
  ];

  List<dynamic> _mainItems = [];

  List<Questions> getItems(){
    return [..._items];
  }

  List<String> _itemsAll = [];

  List<String> getItemsAll(){
    return [..._itemsAll];
  }

  List<Questions> mainItems(){
    return [..._mainItems];
  }
  int curr = 0;
  void next (){
    curr++;
  }

  void test(){
    print("last");
  }

  //////////////////////DATABASE HELPER///////////////////////////////////////////////////////////////
  Future<void> getData() async{

    final url = Uri.https('quissezz-default-rtdb.firebaseio.com', '/questions.json');
  
    final response = await http.get(url); 
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<String> loadedQuestions = [];

    extractedData.forEach((dataID,data) async{
      loadedQuestions.add(dataID);
    });
 
    _itemsAll = loadedQuestions.toList();
    notifyListeners();
  }

  Future<void> add(Questions questions, List<Answer> answer, String title) async{
    var _params = {
      'auth' : token
    };
    final url = Uri.https(
      'quissezz-default-rtdb.firebaseio.com', '/questions/$title.json');
    try{
      final response = await http.post(
        url,
        body: json.encode({
          'judul' : title,
          'soal' : questions.soal,
          'answer': answer.map((e) => {
            'text' : e.text.toString(),
            'isCorrect' : e.isCorrect
          }).toList()
        })  
      );

      final _newData = Questions(
        judul: questions.judul.toString(),
        soal: questions.soal.toString(), 
        answer: answer,
      );

      _items.add(_newData);
     
      notifyListeners();
    } catch(error){
      rethrow;
    }
  }
}