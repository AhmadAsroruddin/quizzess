import 'package:flutter/material.dart';

class Questions{
  String? judul;
  String? soal;
  List<Answer> answer;
  String? id;

  Questions({
    required this.judul,
    required this.soal,
    required this.answer,
    this.id
  });
}
class quissSoal{
  String? judul;
  List<Questions> questions;

  quissSoal({
    required this.judul,
    required this.questions
  });
}
class Answer{
  String text;
  bool isCorrect;

  Answer({
    required this.text,
    required this.isCorrect
  });
}