import 'dart:io';
/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'category.dart';
import 'demo_values.dart';
import 'question.dart';
import 'quiz_page.dart';
import 'dart:math';

class QuizOptionsDialog extends StatefulWidget {
  static final String path = "lib/src/pages/quiz_app/quiz_options.dart";
  final Category category;

  const QuizOptionsDialog({Key key, this.category}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int _noOfQuestions;
  String _difficulty;
  bool processing;

  List<Question> easyQuestions = [];
  List<Question> mediumQuestions = [];
  List<Question> hardQuestions = [];

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.category.name,
              style: Theme.of(context).textTheme.title.copyWith(),
            ),
          ),
          SizedBox(height: 10.0),
          Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("10"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 10
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: Text("20"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: Text("30"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: Text("40"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 40
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: Text("50"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 50
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("Any"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == null
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty(null),
                ),
                ActionChip(
                  label: Text("Easy"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "easy"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: Text("Medium"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "medium"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: Text("Hard"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "hard"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text("Start Quiz"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _startQuiz,
                ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void sortByDifficulty(List<Question> questions) {
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].difficulty == Difficulty.easy) {
        easyQuestions.add(questions[i]);
      } else if (questions[i].difficulty == Difficulty.medium) {
        mediumQuestions.add(questions[i]);
      } else if (questions[i].difficulty == Difficulty.hard) {
        hardQuestions.add(questions[i]);
      }
    }
  }

  List<Question> randomQuestions(List<Question> questions) {
    List<Question> selectedQuestions = [];
    Random random = new Random();

    int requiredLength = questionStructure[_difficulty]["hard"];
    while (selectedQuestions.length != requiredLength) {
      int random_index = random.nextInt(hardQuestions.length);
      Question randomQuestion = hardQuestions[random_index];
      if (!selectedQuestions.contains(randomQuestion)) {
        selectedQuestions.add(randomQuestion);
      }
    }

    requiredLength += questionStructure[_difficulty]["medium"];
    while (selectedQuestions.length != requiredLength) {
      int random_index = random.nextInt(mediumQuestions.length);
      Question randomQuestion = mediumQuestions[random_index];
      if (!selectedQuestions.contains(randomQuestion)) {
        selectedQuestions.add(randomQuestion);
      }
    }

    requiredLength += questionStructure[_difficulty]["easy"];
    while (selectedQuestions.length != requiredLength) {
      int random_index = random.nextInt(easyQuestions.length);
      Question randomQuestion = easyQuestions[random_index];
      if (!selectedQuestions.contains(randomQuestion)) {
        selectedQuestions.add(randomQuestion);
      }
    }
    return selectedQuestions;
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });

    sortByDifficulty(demoQuestions);
    List<Question> questions = randomQuestions(demoQuestions);
    questions.shuffle();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => QuizPage(
                  questions: questions,
                  category: widget.category,
                )));
    setState(() {
      processing = false;
    });
  }
}
