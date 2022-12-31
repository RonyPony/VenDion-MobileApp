// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env_config.dart';

class NetworkUtil {
  static const String? AUTH_TOKEN_KEY = 'authTokenKey';
  static const String? AUTH_TOKEN_DATE = 'authTokenKeyDate';
  static const String? TEMP_USER_KEY = 'temporaryUserKeyToRegiste';
  static Dio getClientWithAuthorization(String? username, String? password) {
    final Dio dio = _createTokenClient();
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    dio.interceptors.add(
        _RequestInterceptor(dio: dio, username: username, password: password));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }

  static Dio getClient() {
    final Dio dio = _createClient();
    dio.options.followRedirects = true;
    dio.options.connectTimeout = 5000;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }

  static Dio getTokenClient() {
    final Dio dio = _createTokenClient();
    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    dio.interceptors.add(_RequestInterceptor(dio: dio, password: '', username: ''));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }

  static Dio _createClient() {
    String? apiName = EnvConfig.configs['serverurl'];
    Dio dio = Dio();
    dio.options.baseUrl = '${apiName}';
    dio.options.connectTimeout = 20 * 3000;
    dio.options.receiveTimeout = 30 * 3000;
    dio.options.followRedirects = false;
    return dio;
  }

  static Dio _createTokenClient() {
    String? apiName = EnvConfig.configs['serverurl'];
    Dio dio = Dio();
    dio.options.baseUrl = '${apiName}api/';
    dio.options.connectTimeout = 20 * 3000;
    dio.options.receiveTimeout = 30 * 3000;
    dio.options.followRedirects = false;
    return dio;
  }
}

class _RequestInterceptor extends InterceptorsWrapper {
  final Dio dio;
  String? username;
  String? password;

  _RequestInterceptor({required this.dio, required this.username, required this.password});

  @override
  Future InterceptorsWrapper(RequestOptions options) async {
    dio.lock();
    final token = await _getApiToken();
    options.headers['Authorization'] = 'Bearer $token';
    options.headers['Accept'] = 'application/json';
    dio.unlock();
    return options;
  }

  Future<String?> _getApiToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(NetworkUtil.AUTH_TOKEN_KEY!);
    final dateStr = sharedPreferences.getString(NetworkUtil.AUTH_TOKEN_DATE!);
    if (token == null && dateStr == null) {
      throw new PlatformException(message: 'Token expired', code: '401');
    }

    final date = DateTime.parse(dateStr!);
    final difference = date.difference(DateTime.now()).inDays;
    if (difference > 2 || difference < -1)
      throw new PlatformException(message: 'Token expired', code: '401');

    return token;
  }
}
