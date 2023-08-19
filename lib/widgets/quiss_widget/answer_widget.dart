import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:quissezz/models/question.dart';
import '../../providers/questionsProvider.dart';

class AnswerBar extends StatefulWidget {
  AnswerBar({Key? key, required this.listA, required this.page}) : super(key: key);

  final List<Answer> listA;
  PageController page;
  @override
  State<AnswerBar> createState() => _AnswerBarState();
}

class _AnswerBarState extends State<AnswerBar> {
  Answer? selectedAnswer;

  Widget _answerButton(Answer answer){
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.green : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: (){
          setState(() {
            selectedAnswer = answer;
          });
          widget.page.nextPage(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn
          );
          widget.listA.shuffle();
        },
        
        child: Text(answer.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return Column(
      children: widget.listA.map(
        (e) => _answerButton(e)
      ).toList()
    );
  }
}