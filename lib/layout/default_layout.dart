import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  const DefaultLayout({
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: body,
      ),
      appBar: AppBar(
        title: Center(
          // GoRouter의 상태를 가져오는 방법
          child: Text(
            // 위젯트리로 올라가서 GoRouterState를 찾아서 가져옴
            // uri는 현재 라우팅된 path를 가져옴
            GoRouterState.of(context).uri.toString(),
          ),
        ),
      ),
    );
  }
}
