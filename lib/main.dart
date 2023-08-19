import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quissezz/providers/auth_provider.dart';
import 'package:quissezz/providers/quissSessionProvider.dart';
import 'package:quissezz/screens/auth_screen.dart';

import './screens/main_screen.dart';
import './screens/quizz_screen.dart';
import './providers/questionsProvider.dart';
import './screens/splashScreen.dart';
import './screens/addQuestion_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: QuestionsProvider()),
          ChangeNotifierProvider.value(value: AuthProvider()),
          ChangeNotifierProvider.value(value: quissSessions())
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, value, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            home: value.isAuth ? const MainScreen() : 
            FutureBuilder(
              future: value.autoLogin(),
              builder: (ctx, snap) =>snap.connectionState == ConnectionState.waiting?
                  const SplashScreen(): AuthScreen()
            ),
            routes: {
              QuizzScreen.routeName : ((context) => const QuizzScreen()),
              AddQuestion.routeName : ((context) =>  AddQuestion())
            },
          ),
        ),
      ),
    );
  }
}

