import 'package:flutter/material.dart';

void main() {
  runApp(SplashScreen()); //SplashScreen을 첫 화면으로 지정
}

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) { //build 함수를 오버라이드
    return MaterialApp(
      home: Scaffold( //Scaffold 위젯을 기본 제공
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF99231) // 배경색을 주황색으로 설정
          ),
          child: Column( //세로로 가운데 정렬을 할 계획
            //Center는 child 위젯을 하나만 받을 수 있지만 Row 또는 Column 위젯은
            //children 매개변수에 리스트로 원하는 만큼 위젯을 추가할 수 있다.
            //Center과 달리 화면 위에 로고 위치
            mainAxisAlignment: MainAxisAlignment.center,
            //가운데 정렬 MainAxisAlignment라는 enum값이 들어감
            children:[
            Image.asset(
            'asset/logo.png', // asset 파일에 있는 로고 이미지를 화면 중앙에 표시'
          ),
            CircularProgressIndicator(), //애니메이션 위젯 동그라미 형태로 로딩 애니메이션 실행
            ],
          ),
        ),
      ),
    );
  }
}

