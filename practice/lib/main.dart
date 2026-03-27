// 'package:flutter/material.dart'는 구글에서 만든 '머티리얼 디자인' UI 부품(버튼, 텍스트 등)들을
// 사용하기 위해 반드시 가져와야 하는 핵심 라이브러리입니다.
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

// 3. stless (StatelessWidget): "상태가 없는" 위젯을 만드는 단축어입니다.
// 화면이 한 번 그려지면 중간에 데이터가 바뀌어도 화면이 알아서 다시 그려지지 않는 정적인 위젯입니다.
// stless를 누르면 아래와 같은 기본 구조가 자동으로 생성됩니다.
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
//const MyApp({super.key}); 이거는 최신 버전인데 SDK 버전에 따라 안될 수 있기에 구버전 사용
  // MyApp 클래스가 만든 생성자이다 Key값으로 생성된 위젯 객체를 구분한다 그 생성자로 생성된 객체를 부모 생성자에게 넘긴다
  // 이 함수가 return(반환)하는 것이 실제 화면에 그려집니다.
  @override
  Widget build(BuildContext context) {
    // Placeholder()는 아직 내용을 채우기 전일 때 임시로 사각형 박스를 보여주는 위젯입니다.
    // 보통은 여기서 MaterialApp()이나 Scaffold()를 반환하며 앱 화면을 구성합니다.
    return MaterialApp(
      home: Image.asset('flutter-logo-sharing.webp')
    );
  }
}