import 'dart:convert'; // jsonEncode를 쓰기 위해 필요해요!
import 'package:http/http.dart' as http; // http 통신을 위해 필요해요!
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MobiusService {
  // 이제 직접 주소를 안 적고, 비밀 수첩(.env)에서 꺼내옵니다!
  // 만약 값이 없으면 뒤에 적은 "http://..."가 기본값으로 쓰여요.

  final String baseUrl = dotenv.env['MOBIUS_BASE_URL'] ?? "";
  final String aeName = dotenv.env['AE_NAME'] ?? "";

  // 1. AE(이름표) 생성 함수
  Future<void> createAE() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl), // "http://AWS_IP:7577/Mobius" 주소로 편지를 보냅니다.
        headers: {
          'X-M2M-Origin': 'SOrigin', // X-M2M-Origin은 누가 보냈는가를 뜻한다. SOrigin은 임시 신분증(아직 정식 ID가 없기에 사용)
          'Content-Type': 'application/json;ty=2', // Content-Type은 편지 안에 어떤 내용이 들어있는 지 뜻함
          //ty=2는 AE(Application Entity)를 뜻함, 지금 앱 등록하러 왔다는 뜻
          //AE는 사용자 ID
        },
        body: jsonEncode({ //서버 데이터베이스에 저장될 실제 정보
          'm2m:ae': { //AE 정보를 보낸다
            'rn': aeName, // "내 이름은 PD_GPS_App으로 등록해줘" (가장 중요!)
            'api': '0.2.481...', // 앱의 고유 아이디, 실제 서비스에서는 표준 규격 ID 쓰지만 테스트에는 아무거나 넣어도 상관 없다
            'rr': true, // "나중에 서버가 나한테 연락해도 돼(Reachability)"라는 허락
          }
        }),
      );

      if (response.statusCode == 201) { //201은 'Created(생성됨)'라는 뜻의 표준 약속이에요.
        print('✅ AE [$aeName] 생성 성공!'); //의미: "축하해! 방금 네가 요청한 이름표(AE)를 서버에 새로 만들었어."
      } else if (response.statusCode == 409) {
        print('ℹ️ AE가 이미 존재합니다.');
      } else { //상황: 404(주소 없음), 500(서버 터짐) 같은 숫자가 뜰 수 있습니다.
        print('❌ AE 생성 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 에러 발생: $e');
    }
  }

  // 2. Container(GPS 데이터 보관함) 생성 함수
  Future<void> createContainer() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$aeName'),
        headers: {
          'X-M2M-Origin': aeName,
          'Content-Type': 'application/json;ty=3', // ty=3은 Container 생성을 의미
        },
        body: jsonEncode({
          'm2m:cnt': {
            'rn': 'location', // 보관함 이름
          }
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Container [location] 생성 성공!');
      } else if (response.statusCode == 409) {
        print('ℹ️ Container가 이미 존재합니다.');
      }
    } catch (e) {
      print('❌ 에러 발생: $e');
    }
  }
}