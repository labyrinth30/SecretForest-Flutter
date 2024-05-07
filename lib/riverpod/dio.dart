import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/common/data.dart';
import 'package:secret_forest_flutter/models/auth.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final authState = ref.watch(authProvider);
  dio.interceptors.add(CustomInterceptor(
    ref: ref,
    authState: authState,
  ));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final Ref ref;
  final Auth authState;

  CustomInterceptor({
    required this.ref,
    required this.authState,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final accessToken = authState.accessToken;

      options.headers.addAll({'Authorization': 'Bearer $accessToken'});

      return super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 403에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final isStatus403 = err.response?.statusCode == 403;
    final isPathRefresh = err.requestOptions.path == 'auth/token/access';

    if (isStatus403 && !isPathRefresh) {
      final dio = Dio();

      try {
        final response = await dio.post(
          '$authIp/auth/token/access',
        );
        final newAccessToken = response.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({
          'Authorization': 'Bearer $newAccessToken',
        });

        ref.read(authProvider.notifier).updateUser(
              accessToken: newAccessToken,
            );
        final resp = await dio.fetch(options);

        return handler.resolve(resp);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
