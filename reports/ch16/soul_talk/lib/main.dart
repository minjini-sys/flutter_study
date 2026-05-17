// 앱의 시작점 .env 파일을 먼저 읽고 앱 저장소 경로를 찾은 다음
// Isar 데이터 베이스를 연다
//GetIt라는 전역 보관함에 Isar를 등록해서 다른 파일에서 쉽게 꺼내쓰게 한다.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soul_talk/model/message_model.dart';
import 'package:soul_talk/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MessageModelSchema],
    directory: dir.path,
  );

  GetIt.I.registerSingleton<Isar>(isar);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
