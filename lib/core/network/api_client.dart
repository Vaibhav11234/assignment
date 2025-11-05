import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'interceptor/logger_interceptor.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();

  static ApiClient get instance => _instance;

  final _dio = Dio()
    ..options = BaseOptions(
      baseUrl: "<YOUR-BASE-URL>",
      headers: {
        "AUTHORIZATION": "<YOUR-ACCESS-TOKEN>"
      }
    )
    ..interceptors.add(LoggingInterceptor());

  void updateDioHeader(Map<String, dynamic>? headers) {
    _dio.options.headers = headers;
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic> query = const {},
        CancelToken? cancelToken,
        Map<String, dynamic>? data,
        Options? options,
        Function(int, int)? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: query,
        cancelToken: cancelToken,
        data: data,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> post(
      String endpoint,
      dynamic body, {
        Map<String, dynamic> query = const {},
        CancelToken? cancelToken,
        Options? options,
        Function(int, int)? onReceiveProgress,
        Function(int, int)? onSendProgress,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: jsonEncode(body),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        onSendProgress: onSendProgress,
        queryParameters: query,
      );

      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> put(
      String endpoint,
      dynamic body, {
        Map<String, dynamic> query = const {},
        CancelToken? cancelToken,
        Options? options,
        Function(int, int)? onReceiveProgress,
        Function(int, int)? onSendProgress,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: jsonEncode(body),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
        onSendProgress: onSendProgress,
        queryParameters: query,
      );
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> delete(
      String endpoint, {
        dynamic body,
        Map<String, dynamic> query = const {},
        CancelToken? cancelToken,
        Options? options,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body != null ? jsonEncode(body) : null,
        queryParameters: query,
        cancelToken: cancelToken,
        options: options,
      );
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> multipart(
      String endpoint, {
        Map<String, String> body = const {},
        Map<String, String> files = const {},
      }) async {
    try {
      Map<String, dynamic> request = {};

      if (body.isNotEmpty) request.addAll(body);

      if (files.isNotEmpty) {
        for (MapEntry element in files.entries) {
          request[element.key] = await MultipartFile.fromFile(element.value, filename: element.value.toString().split("/").last);
        }
      }

      var form = FormData.fromMap(request);

      final response = await _dio.post(endpoint, data: form);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<File?> download(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${url.split('/').last}';
      final file = File(path);

      final dio = Dio();
      dio.options.responseType = ResponseType.bytes;
      final data = await dio.get(url);
      await file.writeAsBytes(data.data);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> _handleError(dynamic e) {
    if (e is DioException) {
      var response = e.response?.data;
      if (e.type == DioExceptionType.connectionError) {
        return Future.error("Looks like you are not connected to internet.");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return Future.error("Server not reachable at this moment.Please try after sometime.");
      }
      switch (e.response?.statusCode) {
        case 301:
          return Future.error(response['message'] ?? "Moved Permanently: The resource has been permanently moved to a new location.");
        case 400:
          return Future.error(response['error'] ?? "Bad Request: The request contains bad syntax or cannot be fulfilled.");
        case 401:
          return Future.error(response['error'] ?? "Unauthorized: Authentication is required and has failed or has not yet been provided.");
        case 403:
          return Future.error(response['error'] ?? "Forbidden: You don't have permission to access this resource.");
        case 404:
          return Future.error(response['error'] ?? "Not Found: The requested resource could not be found.");

        case 500:
          return Future.error(response['message'] ?? "Internal Server Error: The server has encountered an unexpected condition. Please try again later.");
        case 502:
          return Future.error(response['message'] ?? "Bad Gateway: The server received an invalid response from an upstream server.");
        case 503:
          return Future.error(response['message'] ?? "Service Unavailable: The server is not ready to handle the request. Please try again after some time.");
        case 504:
          return Future.error(response['message'] ?? "Gateway Timeout: The server, while acting as a gateway, did not get a response in time from the upstream server.");

        default:
          return Future.error(response['message'] ?? 'Something went wrong.Please Try Again');
      }
    } else {
      return Future.error("Something went wrong.Please Try Again");
    }
  }
}
