import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatefulWidget {
  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: LoadingIndicator(
      indicatorType: Indicator.ballClipRotateMultiple,
      colors: [Color.fromRGBO(0, 57, 255, 0.8)],
      strokeWidth: 20,
    ));
  }
}
