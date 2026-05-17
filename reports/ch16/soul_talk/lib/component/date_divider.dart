import 'package:flutter/material.dart';
// 날짜를 입력받고 화면에 출력하는 위젯
class DateDivider extends StatelessWidget {
  final DateTime date;

  const DateDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${date.year}년 ${date.month}월 ${date.day}일',
      style: TextStyle(color: Colors.black54, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
