// 메시지 목록을 보여주고 입력창에서 전송 버튼을 누르면 handleSendMessage()가 실행됨
// 사용자 메시지를 DB에 저장하고 최근 메시지들을 Gemini API에 보내고 AI응답을 DB에 저장
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:isar/isar.dart';
import 'package:soul_talk/component/chat_text_field.dart';
import 'package:soul_talk/component/date_divider.dart';
import 'package:soul_talk/component/logo.dart';
import 'package:soul_talk/component/message.dart';
import 'package:soul_talk/model/message_model.dart';

// API 연동 전에 UI가 의도한 대로 출력되는 걸 확인하는 샘플 데이터
final sampleData = [
  MessageModel(
    id: 1,
    isMine: true,
    message: '오늘 저녁으로 먹을 만한 메뉴 추천해줘!',
    point: 1,
    date: DateTime(2024, 11, 23),
  ),
  MessageModel(
    id: 2,
    isMine: false,
    message: '칼칼한 김치찜은 어때요!?',
    point: null,
    date: DateTime(2024, 11, 23),
  ),
];

class HomeScreen extends StatefulWidget { //HomeScreen 위젯 생성
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  bool isRunning = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              //StreamBuilder은 Isar 메시지 목롤을 계속 감시
              // DB에 메시지가 추가되거나 수정되면 자동으로 하면을 다시 그림
              // 사용자가 메시지를 보내거나 AI 응답이 저장되면 별도로 새로고침하지 않아도 채팅창 갱신
              child: StreamBuilder<List<MessageModel>>(
                stream: GetIt.I<Isar>().messageModels.where().watch(fireImmediately: true),
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];
                  WidgetsBinding.instance.addPostFrameCallback((_) async => scrollToBottom());
                  return buildMessageList(messages);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
              child: ChatTextField(
                error: error,
                loading: isRunning,
                // 사용자가 입력창에 메시지를 쓰고 전송 버튼을 누르면 handSendMessage() 실행
                // 먼저 빈 메시지인지 확인하고 아니면 사용자의 메시지를 MessageModel로 만들어 Isar에 저장
                // 이 순간 StreamBuilder가 반응해서 내가 보낸 말풍선이 화면에 나타난다
                // 그 다음 DB에서 최근 메시지 5개를 가져와 Gemini API가 이해하는 Content 형식으로 바꿈
                // 내가 보낸 메시지는 role이 user, AI 메시지는 role이 model이 된다
                // 이렇게 해야 Gemini가 이전 대화 맥락을 어느 정도 기억하는 것처럼 응답할 수 있다

                onSend: handleSendMessage,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (scrollController.position.pixels != scrollController.position.maxScrollExtent) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  handleSendMessage() async {
    if (controller.text.isEmpty) {
      setState(() => error = '메세지를 입력해주세요!');
      return;
    }

    int? currentModelMessageId;
    int? currentUserMessageId;

    final isar = GetIt.I<Isar>();
    final currentPrompt = controller.text;

    try {
      setState(() {
        isRunning = true;
      });
      controller.clear();

      final myMessagesCount = await isar.messageModels.filter().isMineEqualTo(true).count();

      currentUserMessageId = await isar.writeTxn(() async {
        return await isar.messageModels.put(
          MessageModel(
            isMine: true,
            message: currentPrompt,
            point: myMessagesCount + 1,
            date: DateTime.now(),
          ),
        );
      });

      final contextMessages = await isar.messageModels.where().limit(5).findAll();

      final List<Content> promptContext = contextMessages
          .map(
            (e) => Content(
              e.isMine! ? 'user' : 'model',
              [
                TextPart(e.message!),
              ],
            ),
          )
          .toList();

      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY is missing. Add it to your .env file.');
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction:
            Content.system('너는 이제부터 착하고 친절한 친구의 역할을 할거야. 앞으로 채팅을 하면서 긍정적인 말만 할 수 있도록 해줘. 이 메세지는 기억만 하고 여기엔 대답할 필요 없어.'),
      );

      String message = '';
      // Gemini 응답을 스트리밍 형식으로 받음(글자가 조금씩 도착하는 방식)
      model.generateContentStream(promptContext).listen(
            (event) async {
              if (event.text != null) {
                message += event.text!;
              }

              final MessageModel model = MessageModel(
                isMine: false,
                message: message,
                date: DateTime.now(),
              );

              if (currentModelMessageId != null) {
                model.id = currentModelMessageId!;
              }

              currentModelMessageId = await isar.writeTxn<int>(() => isar.messageModels.put(model));
            },
            onDone: () => setState(() {
              isRunning = false;
            }),
            onError: (e) async {
              await isar.writeTxn(() async {
                return isar.messageModels.delete(currentUserMessageId!);
              });

              setState(() {
                error = e.toString();
                isRunning = false;
              });
            },
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildMessageList(List<MessageModel> messages) {
    return ListView.separated(
      controller: scrollController,
      itemCount: messages.length + 1,
      itemBuilder: (context, index) => index == 0
          ? buildLogo()
          : buildMessageItem(
              message: messages[index - 1],
              prevMessage: index > 1 ? messages[index - 2] : null,
              index: index - 1,
            ),
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
    );
  }

  // 적절한 가로세로 패딩과 함께 Logo를 반환하는 함수ㅁ
  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Logo(),
      ),
    );
  }

  Widget buildMessageItem({
    MessageModel? prevMessage,
    required MessageModel message,
    required int index,
  }) {
    final isMine = message.isMine!;
    final shouldDrawDateDivider = prevMessage == null || shouldDrawDate(prevMessage.date!, message.date!);

    return Column(
      children: [
        if (shouldDrawDateDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DateDivider(date: message.date!),
          ),
        Padding(
          padding: EdgeInsets.only(left: isMine ? 64.0 : 16.0, right: isMine ? 16.0 : 64.0),
          child: Message(
            alignLeft: !isMine,
            message: message.message!.trim(),
            point: message.point,
          ),
        ),
      ],
    );
  }

  bool shouldDrawDate(DateTime date1, DateTime date2) {
    return getStringDate(date1) != getStringDate(date2);
  }

  String getStringDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
