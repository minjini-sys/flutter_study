// const, screen 폴더에 들어있는 dart 파일 가져오기
//material.dart는 플러터의 가장 기본적인 UI 부품 담고 있는 상자
import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/const/colors.dart';
import 'package:random_dice/screen/root_screen.dart';

// 앱이 실행될 때 가장 먼저 읽어들이는 파일

void main() {
  runApp( //MaterialApp 설계도를 바탕으로 실제 앱을 구동시키는 명령어
    MaterialApp(
      debugShowCheckedModeBanner: false, //화면 오른쪽 상단에 뜨는 빨간색 DEBUG를 없앰
      // 우리가 작업하는 모드는 디버그 모드로 실제 배포용 앱보다 드리다 릴리즈 모드(구글 플레이 스토어에 올릴 때) 이 띠가 자동으로 삭제된다.
      theme: ThemeData( // 앱 전체에 적용되는 교복을 정하는 곳
        scaffoldBackgroundColor: backgroundColor, //colors.dart에서 정의한 어두운 색으로 통일
        sliderTheme: SliderThemeData(  // Slider 위젯 관련(설정 화면)
          thumbColor: primaryColor,    // 동그라미 색
          activeTrackColor: primaryColor,  // 이동한 트랙 색

          // 아직 이동하지 않은 트랙 색
          inactiveTrackColor: primaryColor.withOpacity(0.3),         ),
        // BottomNavigationBar 위젯 관련
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,     // 선택 상태 색
          unselectedItemColor: secondaryColor, // 비선택 상태 색
          backgroundColor: backgroundColor,    // 배경 색
        ),
      ),
      home: RootScreen(),
    ),
  );
}
