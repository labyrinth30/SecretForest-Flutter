import 'package:flutter/material.dart';

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
        title: const Center(
          child: Text(
            '비밀의숲 관리자 페이지',
          ),
        ),
      ),
    );
  }
}
