import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatefulWidget {
  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
        child: SizedBox(
          height: screenHeight * 0.15,
          width: screenHeight * 0.15,
          child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Color.fromRGBO(0, 57, 255, 0.8)],
                strokeWidth: 30,
              ),
        ));
  }
}
