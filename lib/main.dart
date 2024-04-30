import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Forest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  Future<void> sendPostRequest() async {
    // 변경해야 할 부분: 서버의 URL
    String url = 'http://localhost:3001/auth/login/email';

    // POST 요청에 포함될 데이터
    Map<String, dynamic> data = {
      'email': 'ayeon0@naver.com',
      'password': 'Password123!',
    };

    // JSON 데이터를 포함한 POST 요청 보내기
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );

    // 서버 응답 확인
    if (response.statusCode == 201) {
      // 응답이 성공적이라면, 응답 본문을 출력
      print('Response data: ${response.body}');
    } else {
      // 요청 실패 시 에러 로그
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hello, World!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '당신이 버튼을 누른 횟수:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendPostRequest,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
