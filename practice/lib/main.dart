import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'mobius_service.dart';
import 'gps_service.dart'; // ✅ 새로 만든 파일 불러오기

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const GPSHomePage());
  }//'home' 설정은 "앱이 켜지자마자 보여줄 첫 화면은 GPSHomePage다!"라는 뜻이다
}

class GPSHomePage extends StatefulWidget {
  const GPSHomePage({super.key});
  @override
  State<GPSHomePage> createState() => _GPSHomePageState();
}

class _GPSHomePageState extends State<GPSHomePage> {
  final MobiusService _mobiusService = MobiusService();
  final GPSService _gpsService = GPSService(); // ✅ GPS 서비스 소환
  String _locationMessage = "GPS 데이터를 가져오는 중...";

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // 1. 서버 준비: 내 이름표(AE)와 바구니(Container)를 만듭니다.
    // await는 "서버에서 응답이 올 때까지 다음 줄로 가지 말고 기다려!"라는 뜻입니다.
    await _mobiusService.createAE();
    await _mobiusService.createContainer();

    // 2. GPS 권한 확인 및 추적 시작
    bool hasPermission = await _gpsService.handleLocationPermission();
    if (hasPermission) {
      // getPositionStream은 "위치 데이터를 물 흐르듯이 계속 가져오기" 시작합니다.
      _gpsService.getPositionStream().listen((Position position) {
        // ⭐ 가장 중요한 부분! setState()
        // "데이터가 바뀌었으니 화면을 새로 그려!"라고 플러터에게 명령합니다.
        setState(() {
          _locationMessage = "위도: ${position.latitude}\n경도: ${position.longitude}";
        });
        // 3. 나중에 여기서 서버로 전송!
        // _mobiusService.sendGPSData(position.latitude, position.longitude);
      });
    }
  }

  //"화면을 어떤 모양으로 만들 건데?"에 대한 설계도
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mobius Tracker")),
      body: Center(child: Text(_locationMessage, textAlign: TextAlign.center)),
    );
  }
}