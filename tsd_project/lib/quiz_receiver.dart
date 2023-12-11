import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tsd_project/screen/quiz_page.dart';

//The model that is used to store the quiz
class QuizModel {
  final int questionId;
  final String question;
  final List<AnswerModel> answers;

  QuizModel(
      {required this.questionId,
      required this.question,
      required this.answers});
}

//The model that stores the answers
class AnswerModel {
  final int answerId;
  final String answer;
  final String mark;

  AnswerModel({
    required this.answerId,
    required this.answer,
    required this.mark,
  });
}

class Quiz_Receiver extends StatefulWidget {
  @override
  State<Quiz_Receiver> createState() => _Quiz_ReceiverState();
}

class _Quiz_ReceiverState extends State<Quiz_Receiver> {
  //This is the list that stores the quiz
  List<QuizModel> receivedQuiz = [];

  //Declaring the secure storage where we stored the token in the login page
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  //Creating the function to request the quiz
  Future<void> requestQuiz() async {
    await Future.delayed(Duration(seconds: 2));

    String? token = await secureStorage.read(key: 'token');

    //If the token is not null continue with the process
    if (token != null) {
      // Obtaining the URL to a variable
      final String apiUrl = 'http://10.0.2.2:8000/quiz_send/';

      //Converting the url to uri
      Uri uri = Uri.parse(apiUrl);

      //Requesting the quiz
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      //Returning an output according to the status code
      if (response.statusCode == 200) {
        try {
          //Decode the received quiz and store in the quiz model
          final data = json.decode(response.body);

          //Storing the decode data in the model instance we created at the beginning
          receivedQuiz =
              List.from(data['questions_and_answers']).map<QuizModel>((item) {
            return QuizModel(
              questionId: item['id'],
              question: item['question'],
              answers: List.from(item['answers']).map<AnswerModel>((answer) {
                return AnswerModel(
                    answerId: answer['id'],
                    answer: answer['answer'],
                    mark: answer['mark']);
              }).toList(),
            );
          }).toList();

          print(receivedQuiz);

          //Redirecting to the quiz page
          Navigator.push(
              context,
              (MaterialPageRoute(
                  builder: (context) => QuizPage(
                        quiz: receivedQuiz,
                      ))));
        } catch (e) {
          print('Error converting to JSON : $e');
        }
      } else {
        print('unable to receive data: ${response.body}');
      }
    } else {
      print("The token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: requestQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: const Color(0xE51FC0E7),
              child: const Center(
                child: SizedBox(
                    height: 12.0,
                    width: 200.0,
                    child: LinearProgressIndicator(
                        color: Color.fromRGBO(0, 57, 255, 0.8))),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return Container();
          }
        });
  }
}
