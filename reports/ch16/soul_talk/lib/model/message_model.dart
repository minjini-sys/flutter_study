// 채팅 메시지 데이터의 형태를 정의
// 메시지는 id, isMine, message, point, date를 가진다
// isMine이 true면 내가 보낸 메시지, false이면 AI가 보낸 메시지
//@collection이 붙어서 Isar DB에 저장 가능한 모델이 된다

import 'package:isar/isar.dart';

part 'message_model.g.dart';
// 제미나이와 사용자가 채팅을 하면 결괏값을 MessageModel의 규격에 맞게 저장
//MessageModel은 고유 식별값인 ID값,
// 내가 보낸 메시지인지 확인할 수 있는 isMine 파라미터, 주고 받은 메시지를 저장하는 message 파라미터,
// 적립된 포인트를 알 수 있는 point 파라미터 그리고 생성된 날짜를 저장하는 date 파라미터가 있다.
@collection
class MessageModel {
  // 메시지 ID
  Id id = Isar.autoIncrement;
  // true: 내가 보낸 메시지, false: AI가 보낸 메시지
  bool isMine;
  // 메시지 내용
  String message;
  // 포인트 (AI 메시지이면 null)
  int? point;
  // 메시지 전송 날짜
  DateTime date;

  MessageModel({
    required this.isMine,
    required this.message,
    required this.date,
    this.id = Isar.autoIncrement,
    this.point,
  });
}
