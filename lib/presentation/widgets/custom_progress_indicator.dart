import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final double strokeWidth;
  final double? value;

  const CustomProgressIndicator(
      {Key? key,
      required this.color,
      required this.height,
      required this.width,
      this.strokeWidth = 2,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        value: value,
      ),
      width: width,
      height: height,
    );
  }
}
