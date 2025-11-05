import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:developer';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('REQUEST URL =>  ${options.uri}', name: 'onRequest');
    _printFormattedJson(options.data.toString(), "onRequest");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE URI [${response.statusCode}] => ${response.requestOptions.uri}', name: 'onResponse');
    _printFormattedJson(response.data, "onResponse");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR URI [${err.response?.statusCode}] => ${err.requestOptions.uri}', name: 'onError');
    log('Error Message: ${err.message}', name: 'onError');
    _printFormattedJson(err.response?.data, "onError");
    super.onError(err, handler);
  }

  void _printFormattedJson(dynamic jsonData, String name) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(jsonData);
    log(prettyJson, name: name);
  }
}
