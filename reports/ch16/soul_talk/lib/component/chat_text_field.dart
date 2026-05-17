import 'package:flutter/material.dart';
// 디자인 요소
// TextFField에 입력된 값을 받아올 수 있도록 controller 입력 받고
// 메시지 전송 버튼을 눌렀을 때 함수를 실행할 수 있도록 onSend 입력
// 에러 메시지를 화면에 출력할 수 있도록 error 입력
// 제미나이가 답변을 생성하는 동안 추가로 메시지를 보낼 수 없도록 loading 파라미터 입력
class ChatTextField extends StatelessWidget {
  // 입력값 추출을 위해 외부에서 controller 직접 입력 받기
  final TextEditingController controller;
  // 전송 버튼 눌렀을 때 실행할 함수 입력받기
  final VoidCallback onSend;
  // 에러 메시지가 있을 경우 입력받기
  final String? error;
  // 로딩 중일 경우 전송 버튼 디자인 회색으로 변경 및 비활성화
  final bool loading;

  const ChatTextField({
    super.key,
    this.error,
    this.loading = false,
    required this.onSend,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // 커서 파란색으로 변경
      cursorColor: Colors.blueAccent,
      // 텍스트 필드 새로 중앙 정렬
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        errorText: error,
        // 텍스트 필드 전송 버튼
        suffixIcon: IconButton(
          onPressed: loading ? null : onSend,
          icon: Icon(
            Icons.send_outlined,
            color: loading ? Colors.grey : Colors.blueAccent,
          ),
        ),
        // 테두리 둥근 형태로 변형하기
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        // 텍스트 필드 선택되어 있는 경우 파란색으로 테두리 변경
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        hintText: '메세지를 입력해주세요!',
      ),
    );
  }
}
