import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quissezz/models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class quissSessions with ChangeNotifier{
  List<Questions> _items = [];

  List<Questions> getItems(){
    return [..._items];
  }
  
  Future<void> getQuestion() async{
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('session');
    print(data);
    final url = Uri.https('quissezz-default-rtdb.firebaseio.com', '/questions/$data.json');

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == ''){
      return;
    }
    final List<Questions> loadedData = [];
    print(extractedData);
    
    extractedData.forEach((key, value) {
      loadedData.add(
        Questions(
          judul: value['judul'], 
          soal: value['soal'], 
          answer: (value['answer'] as List<dynamic>).map((e) => Answer(
            text: e['text'], 
            isCorrect: e['isCorrect']),
          ).toList(),
          id: key
        )
      );
    });

    print(loadedData);
    
    _items = loadedData.toList();

    notifyListeners();
  }
}