// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question.dart';
import '../providers/questionsProvider.dart';

class AddQuestion extends StatefulWidget {
  static const routeName = '/addQuiss';
  int numberOfQuestion = 0;

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  Answer? option1;
  Answer? option2;
  Answer? option3;
  Answer? option4;
  String? soal;
  String? judul;

  var data = Questions(
    judul:  '',
    soal: '', 
    answer: [], 
    id: '');

  @override
  void initState() {
    widget.numberOfQuestion++;
    // TODO: implement initState
    super.initState();
  }
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final mediaQuery =  MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            widget.numberOfQuestion++;
          });
        }
      ),
      body:Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.height * 0.05,),
              TextFormField(
                decoration: const InputDecoration(labelText: "Title..."),
                onChanged: (newValue) {
                  judul = newValue;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.numberOfQuestion,
                  itemBuilder: ((context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    width: mediaQuery.width * 0.5,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Tulis soal"),
                            onChanged: (newValue) {
                              soal = newValue;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Option 1 (jawaban yang benar)"),
                            onChanged: (newValue) {
                              option1 = Answer(text: newValue, isCorrect: true);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Option 2"),
                            onChanged: (newValue) {
                              option2 = Answer(text: newValue, isCorrect: false);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Option 3"),
                            onChanged: (newValue) {
                              option3 = Answer(text: newValue, isCorrect: false);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Option 4"),
                            onChanged: (newValue) {
                              option4 = Answer(text: newValue, isCorrect: false);
                            },
                          ),
                          ElevatedButton(
                            onPressed: (){
                              data = Questions(
                                judul : judul!,
                                soal: soal!, 
                                answer: [
                                  option1!,
                                  option2!,
                                  option3!,
                                  option4!,
                                ], 
                                
                              );
                              Provider.of<QuestionsProvider>(context, listen:false).add(data, data.answer, judul!);
                            }, 
                            child: const Text("Submit")
                          )
                        ],
                      ),
                    ),
                  )
                ))
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}