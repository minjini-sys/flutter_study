import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MobiusService {
  final String baseUrl = dotenv.env['MOBIUS_BASE_URL'] ?? "";
  final String aeName = dotenv.env['AE_NAME'] ?? "";

  // 1. AE(이름표) 생성 함수
  Future<void> createAE() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'X-M2M-RI': 'req${DateTime.now().millisecondsSinceEpoch}', // 일련번호 추가 (필수!)
          'X-M2M-Origin': 'admin', // 관리자 권한으로 생성 시도
          'Content-Type': 'application/json;ty=2',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'm2m:ae': {
            'rn': aeName,
            'api': '0.2.481.2.0001.001.000111',
            'rr': true, // 문자열 'true'가 아니라 불리언 true여야 할 수도 있습니다.
          }
        }),
      );

      print('응답 상태 코드: ${response.statusCode}'); // 상태 코드 확인용
      print('응답 바디: ${response.body}'); // 에러 원인 확인용

      if (response.statusCode == 201) {
        print('✅ AE [$aeName] 생성 성공!');
      } else if (response.statusCode == 409) {
        print('ℹ️ AE가 이미 존재합니다.');
      } else {
        print('❌ AE 생성 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 에러 발생: $e');
    }
  }

  // 2. Container 생성 함수도 동일하게 RI를 추가해야 합니다.
  Future<void> createContainer() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$aeName'),
        headers: {
          'X-M2M-RI': 'req${DateTime.now().millisecondsSinceEpoch}', // 일련번호 추가
          'X-M2M-Origin': aeName,
          'Content-Type': 'application/json;ty=3',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'm2m:cnt': {
            'rn': 'location',
          }
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Container [location] 생성 성공!');
      } else if (response.statusCode == 409) {
        print('ℹ️ Container가 이미 존재합니다.');
      } else {
        print('❌ Container 생성 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 에러 발생: $e');
    }
  }
}