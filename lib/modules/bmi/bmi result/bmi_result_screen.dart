import 'package:flutter/material.dart';

class BmiResultScreen extends StatelessWidget {
  final bool isMale;
  final int age;
  final double height;
  final int weight;
  final int result;
  BmiResultScreen({
    @required this.age,
    @required this.height,
    @required this.isMale,
    @required this.result,
    @required this.weight,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'BMI RESULT',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gender : ${isMale ? 'Male' : 'Female'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            Text(
              'Age : $age',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            Text(
              'Height : ${height.round()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            Text(
              'Weight : $weight',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            Text(
              'Result : $result',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ],
        ),
      ),
    );
  }
}
