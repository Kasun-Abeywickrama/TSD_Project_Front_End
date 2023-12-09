import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsd_project/screen/quiz_page.dart';

class ResultCalculation extends StatelessWidget {
  final List<QuizResultModel> answerPoints;

  final int noOfQuestions;

  final int noOfDays;

  ResultCalculation(this.answerPoints, this.noOfDays, this.noOfQuestions);

  //Function created to get the current date
  DateTime getCurrentDate() {
    DateTime today = DateTime.now().toLocal();
    return DateTime(today.year, today.month, today.day);
  }

  //Function that adds a given no.of days to the current date
  DateTime addDaysToCurrentDate(int daysCount) {
    return getCurrentDate().add(Duration(days: daysCount));
  }

  Map<String, dynamic> resultMapGenerator() {
    double testScore = 0.0;
    String depressionLevel;
    String conclusion;

    //Calculating testScore
    //Adding all the values of the answerPoints map together and dividing the sum by the no.of questions
    for (int i = 0; i < answerPoints.length; i++) {
      testScore = testScore + answerPoints[i].mark;
    }

    testScore = testScore / noOfQuestions;

    //Determining the depression level
    if (testScore <= 19.00) {
      depressionLevel = 'Minimal';
    } else if (testScore <= 39.0) {
      depressionLevel = 'Mild';
    } else if (testScore <= 59.0) {
      depressionLevel = 'Moderate';
    } else if (testScore <= 79.0) {
      depressionLevel = 'Moderately Severe';
    } else {
      depressionLevel = 'Severe';
    }

    //Determining the final result
    if (noOfDays < 14) {
      String nextTestDate =
          DateFormat('yyyy-MM-dd').format(addDaysToCurrentDate(14 - noOfDays));

      conclusion =
          'You had these effects for only $noOfDays days. Therefore we cannot give you a conclusion about your state. Please take this test again on $nextTestDate, then we will give you a conclusion about your state';
    } else {
      if (depressionLevel == 'Minimal') {
        conclusion =
            'You have very few/none depression symptoms. There is nothing to worry about';
      } else if (depressionLevel == 'Mild') {
        conclusion =
            'Some mild symptoms are present, which might be distressing, but manageble';
      } else if (depressionLevel == 'Moderate') {
        conclusion =
            'Moderate Symptoms are present. Please seek professional help before this affects your general life';
      } else if (depressionLevel == 'Moderately Severe') {
        conclusion =
            'Depression is already impacted daily life. Please seek to professional help immediately';
      } else {
        conclusion =
            'Symptoms are severe, professional care is needed urgently';
      }
    }

    Map<String, dynamic> resultMap = {
      'test_score': testScore,
      'depression_level': depressionLevel,
      'no_of_days': noOfDays,
      'conclusion': conclusion,
    };

    return resultMap;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
