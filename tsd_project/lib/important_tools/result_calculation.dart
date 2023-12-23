import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsd_project/screen/quiz_page.dart';

class ResultCalculation extends StatelessWidget {
  final List<QuizResultModel> qandAData;

  final int noOfQuestions;

  final int noOfDays;

  ResultCalculation(this.qandAData, this.noOfDays, this.noOfQuestions);

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
    double score = 0.0;
    String dpLevel;
    String conclusion;
    int counselor_or_not;

    //Calculating testScore
    //Adding all the values of the answerPoints map together and dividing the sum by the no.of questions
    for (int i = 0; i < qandAData.length; i++) {
      score = score + qandAData[i].mark;
    }

    score = score / noOfQuestions;

    //Determining the depression level
    if (score <= 19.00) {
      dpLevel = 'Minimal';
    } else if (score <= 39.0) {
      dpLevel = 'Mild';
    } else if (score <= 59.0) {
      dpLevel = 'Moderate';
    } else if (score <= 79.0) {
      dpLevel = 'Moderately Severe';
    } else {
      dpLevel = 'Severe';
    }

    //Determining the final result
    if (noOfDays < 14) {
      String nextTestDate =
          DateFormat('yyyy-MM-dd').format(addDaysToCurrentDate(14 - noOfDays));

      counselor_or_not = 0;

      conclusion =
          'You had these effects for only $noOfDays days. Therefore we cannot give you a conclusion about your state. Please take this test again on $nextTestDate, then we will give you a conclusion about your state';
    } else {
      if (dpLevel == 'Minimal') {
        counselor_or_not = 0;
        conclusion =
            'You have very few/none depression symptoms. There is nothing to worry about';
      } else if (dpLevel == 'Mild') {
        counselor_or_not = 0;
        conclusion =
            'Some mild symptoms are present, which might be distressing, but manageble';
      } else if (dpLevel == 'Moderate') {
        counselor_or_not = 1;
        conclusion =
            'Moderate Symptoms are present. Please seek professional help before this affects your general life';
      } else if (dpLevel == 'Moderately Severe') {
        counselor_or_not = 1;
        conclusion =
            'Depression is already impacted daily life. Please seek to professional help immediately';
      } else {
        counselor_or_not = 1;
        conclusion =
            'Symptoms are severe, professional care is needed urgently';
      }
    }

    Map<String, dynamic> quizResultMap = {
      'score': score,
      'dp_level': dpLevel,
      'no_of_days': noOfDays,
      'conclusion': conclusion,
      'counselor_or_not': counselor_or_not
    };

    return quizResultMap;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
