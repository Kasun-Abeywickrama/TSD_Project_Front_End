import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultCalculation extends StatelessWidget {
  final Map<int, double> answerPointsMap;

  final int noOfQuestions;

  final int noOfDays;

  ResultCalculation(this.answerPointsMap, this.noOfDays, this.noOfQuestions);

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
    double testScore;
    String depressionLevel;
    String finalResult;

    //Calculating testScore
    //Adding all the values of the answerPoints map together and dividing the sum by the no.of questions
    testScore = double.parse(
        ((answerPointsMap.values.fold(0.0, (prev, element) => prev + element)) /
                noOfQuestions)
            .toStringAsFixed(2));

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

      finalResult =
          'You had these effects for only $noOfDays days. Therefore we cannot give you a conclusion about your state. Please take this test again on $nextTestDate, then we will give you a conclusion about your state';
    } else {
      if (depressionLevel == 'Minimal') {
        finalResult =
            'You have very few/none depression symptoms. There is nothing to worry about';
      } else if (depressionLevel == 'Mild') {
        finalResult =
            'Some mild symptoms are present, which might be distressing, but manageble';
      } else if (depressionLevel == 'Moderate') {
        finalResult =
            'Moderate Symptoms are present. Please seek professional help before this affects your general life';
      } else if (depressionLevel == 'Moderately Severe') {
        finalResult =
            'Depression is already impacted daily life. Please seek to professional help immediately';
      } else {
        finalResult =
            'Symptoms are severe, professional care is needed urgently';
      }
    }

    Map<String, dynamic> resultMap = {
      'test_score': testScore,
      'depression_level': depressionLevel,
      'no_of_days': noOfDays,
      'final_result': finalResult,
    };

    return resultMap;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
