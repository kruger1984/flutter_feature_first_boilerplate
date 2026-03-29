import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:zvychka/screens/login_screen.dart';
import 'package:zvychka/services/auth.dart';

import '../../config.dart';
import '../../helpers/log.dart';

final dio =
    Dio(
        BaseOptions(
          baseUrl: 'https://app.zvychka.app/api/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 60),
          headers: {"Accept": "application/json", 'Content-Type': 'application/json'},
        ),
      )
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            try {
              final String token = await Auth.getToken();

              if (token.isNotEmpty) {
                options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
              } else {
                Log.log("⚠️ Внимание: Токен пустой!");
              }
            } catch (e) {
              Log.log("❌ Ошибка при получении токена: $e");
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) {
            if (e.response?.statusCode == 401) {
              Log.log("😶‍🌫️  DioException e, handler Auth.forget()");
              Auth.forget();

              Config.navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
            }
            return handler.next(e);
          },
        ),

        TalkerDioLogger(
          talker: Log.talker,
          settings: const TalkerDioLoggerSettings(printRequestHeaders: true, printResponseData: true, printResponseHeaders: false, printErrorData: true),
        ),
      ]);

class Api {
  static Future<dynamic> get({required String method, Map<String, dynamic>? queryParameters}) async {
    return _request(() => dio.get(method, queryParameters: queryParameters));
  }

  static Future<dynamic> put({required String method, Map<String, dynamic>? queryParameters}) async {
    return _request(() => dio.put(method, data: queryParameters));
  }

  static Future<dynamic> patch({required String method, Map<String, dynamic>? queryParameters}) async {
    return _request(() => dio.patch(method, data: queryParameters));
  }

  static Future<dynamic> delete({required String method, Map<String, dynamic>? queryParameters}) async {
    return _request(() => dio.delete(method, data: queryParameters));
  }

  static Future<dynamic> post({required String method, Map<String, dynamic>? queryParameters, File? file}) async {
    dynamic data = queryParameters;

    if (file != null) {
      String fileName = file.path.split('/').last;
      data = FormData.fromMap({...?queryParameters, "images": await MultipartFile.fromFile(file.path, filename: fileName)});
    }

    return _request(() => dio.post(method, data: data));
  }

  static Future<dynamic> _request(Future<Response> Function() httpRequest) async {
    try {
      final response = await httpRequest();

      return response.data;
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map ? (e.response?.data['message'] ?? e.response?.data['error']) : null;

      throw ApiException(serverMessage ?? e.message, e.response?.statusCode);
    } catch (e, st) {
      Log.talker.handle(e, st, 'Unexpected API Error');
      throw ApiException(e.toString(), 0);
    }
  }
}

class ApiException implements Exception {
  final dynamic message;
  final dynamic code;

  ApiException(this.message, this.code);

  @override
  String toString() => 'ApiException: $message (code: $code)';
}
