/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'home.dart';
import 'question.dart';

class CheckAnswersPage extends StatelessWidget {
  static final String path = "lib/src/pages/quiz_app/check_answers.dart";
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage(
      {Key key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Check Answers'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Colors.deepPurple),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return RaisedButton(
        child: Text("Done"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => QuizHomePage()));
        },
      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Question: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: question.question)
              ]),
              style: TextStyle(fontSize: 16.0),
            ),
            // Text(
            //   question.question,
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.w500,
            //       fontSize: 16.0),
            // ),
            SizedBox(height: 25.0),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Your answer: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: answers[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: correct ? Colors.green : Colors.red))
              ]),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "Correct answer: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: question.correctAnswer,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  ),

            SizedBox(height: 5.0),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Dificulty: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: question.difficulty == Difficulty.easy
                        ? "easy"
                        : question.difficulty == Difficulty.medium
                            ? "medium"
                            : "hard",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent,
                        fontStyle: FontStyle.italic))
              ]),
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
