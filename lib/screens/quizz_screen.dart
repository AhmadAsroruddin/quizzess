import 'package:flutter/material.dart';
import 'package:quissezz/models/question.dart';
import 'package:provider/provider.dart';

import 'package:quissezz/providers/questionsProvider.dart';
import 'package:quissezz/providers/quissSessionProvider.dart';
import '../widgets/quiss_widget/question_widget.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({Key? key}) : super(key: key);
  static const routeName = '/QuizzScreen';

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  final controller = PageController(initialPage: 0);
  late Future future;
  @override
  void initState() {
    // TODO: implement initState
    future =Provider.of<quissSessions>(context, listen: false).getQuestion();
    
    super.initState();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final List<Questions> list = Provider.of<quissSessions>(context).getItems();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 251, 252, 1),
      body: FutureBuilder(
        future: future,
        builder: (context, snap) =>snap.connectionState == ConnectionState.waiting ? 
          const Center(child: CircularProgressIndicator(),)
        :
         Padding(
          padding: EdgeInsets.symmetric(vertical: mediaQuery.height*0.05, horizontal: mediaQuery.width*0.02),
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            itemCount: list.length,
            itemBuilder: (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuestionBar(
                  currentQuestionIndex: index,
                  page: controller,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed:(){controller.previousPage(
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.easeIn,);
                      },
                      child: const Text("Previous")
                    ),
                    ElevatedButton(
                      onPressed: index+1 == list.length ?
                        Provider.of<QuestionsProvider>(context).test
                      :
                        null,
                      child: const Text("Submit")
                    ),
                    ElevatedButton(
                      onPressed:(){controller.nextPage(
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.easeIn);
                      },
                      child: const Text("Next")
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}