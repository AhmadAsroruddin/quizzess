import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quissezz/models/question.dart';
import 'package:quissezz/providers/questionsProvider.dart';
import 'package:quissezz/providers/quissSessionProvider.dart';
import './answer_widget.dart';

class QuestionBar extends StatelessWidget {
  int currentQuestionIndex;
  PageController page;
  QuestionBar({required this.currentQuestionIndex, required this.page});
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    List<Questions> questionList = Provider.of<quissSessions>(context).getItems();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: Text(
            "Soal ${currentQuestionIndex+1}/${questionList.length.toString()}",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height *0.05),
        Container(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.height * 0.3,
            minHeight: mediaQuery.height * 0.1
          ),
          alignment: Alignment.center,
          width: mediaQuery.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )]
          ),
          child: SingleChildScrollView(
            child: Text(
              questionList[currentQuestionIndex].soal!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height *0.05),
        AnswerBar(
          listA: questionList[currentQuestionIndex].answer, 
          page: page,
        ),
      ],
    );
  }
}