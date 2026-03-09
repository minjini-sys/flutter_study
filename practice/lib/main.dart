// 'package:flutter/material.dart'는 구글에서 만든 '머티리얼 디자인' UI 부품(버튼, 텍스트 등)들을
// 사용하기 위해 반드시 가져와야 하는 핵심 라이브러리입니다.
import 'package:flutter/material.dart';

// 2. main 함수: 앱의 시작점입니다.
// 앱이 실행되면 가장 먼저 이 main() 함수 안에 있는 코드가 실행됩니다.
// runApp(const MyApp())은 "나 이제 MyApp이라는 위젯으로 앱을 시작할 거야!"라고 선언하는 것입니다.
void main() {
  runApp(const MyApp()); //MyApp은 메인 페이지이다
}

// 3. stless (StatelessWidget): "상태가 없는" 위젯을 만드는 단축어입니다.
// 화면이 한 번 그려지면 중간에 데이터가 바뀌어도 화면이 알아서 다시 그려지지 않는 정적인 위젯입니다.
// stless를 누르면 아래와 같은 기본 구조가 자동으로 생성됩니다.
class MyApp extends StatelessWidget {
  // 생성자(Constructor): 위젯을 만들 때 필요한 설정을 담는 부분입니다.
  const MyApp({Key? key}) : super(key: key);

  // build 함수: 이 위젯이 화면에 어떻게 보일지 설계도를 그리는 곳입니다.
  // 이 함수가 return(반환)하는 것이 실제 화면에 그려집니다.
  @override
  Widget build(BuildContext context) {
    // Placeholder()는 아직 내용을 채우기 전일 때 임시로 사각형 박스를 보여주는 위젯입니다.
    // 보통은 여기서 MaterialApp()이나 Scaffold()를 반환하며 앱 화면을 구성합니다.
    return MaterialApp(
      home: Container( width: 50, height: 50, color: Colors.blue)
    );
  }
}