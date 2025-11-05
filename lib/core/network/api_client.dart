import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'interceptor/logger_interceptor.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();

  static ApiClient get instance => _instance;

  final _dio = Dio()
    ..options = BaseOptions(
      baseUrl: "http://173.249.24.68:8252/api",
      contentType: Headers.jsonContentType,
      // headers: {"AUTHORIZATION": "<YOUR-ACCESS-TOKEN>"},
    )
    ..interceptors.add(LoggingInterceptor());

  Future<dynamic> multipart({
    String endpoint = "/upload",
    Map<String, String> body = const {},
    Map<String, String> files = const {},
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> request = {};

      if (body.isNotEmpty) request.addAll(body);

      if (files.isNotEmpty) {
        for (MapEntry element in files.entries) {
          request[element.key] = await MultipartFile.fromFile(
            element.value,
            filename: element.value.toString().split("/").last,
          );
        }
      }

      var form = FormData.fromMap(request);

      final response = await _dio.post(
        endpoint,
        data: form,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> base64({
    String endpoint = "/upload",
    required File file,
    Map<String, dynamic> body = const {},
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      final data = {"fileName": file.path.split("/").last, "fileData": base64String, ...body};

      final response = await _dio.post(
        endpoint,
        data: data,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> uploadZip({
    String endpoint = "/upload",
    required List<File> files,
    Map<String, dynamic> body = const {},
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final archive = Archive();

      for (var file in files) {
        final fileBytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(file.path.split("/").last, fileBytes.length, fileBytes));
      }

      final tempDir = await getTemporaryDirectory();
      final zipFilePath = '${tempDir.path}/upload_${DateTime.now().millisecondsSinceEpoch}.zip';
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(ZipEncoder().encode(archive));

      final request = FormData.fromMap({
        ...body,
        'file': await MultipartFile.fromFile(zipFile.path, filename: 'upload.zip'),
      });

      final response = await _dio.post(
        endpoint,
        data: request,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      return response.data;
    } catch (e) {
      return _handleError(e);
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
          return Future.error(
            response['message'] ??
                "Moved Permanently: The resource has been permanently moved to a new location.",
          );
        case 400:
          return Future.error(
            response['error'] ??
                "Bad Request: The request contains bad syntax or cannot be fulfilled.",
          );
        case 401:
          return Future.error(
            response['error'] ??
                "Unauthorized: Authentication is required and has failed or has not yet been provided.",
          );
        case 403:
          return Future.error(
            response['error'] ?? "Forbidden: You don't have permission to access this resource.",
          );
        case 404:
          return Future.error(
            response['error'] ?? "Not Found: The requested resource could not be found.",
          );

        case 500:
          return Future.error(
            response['message'] ??
                "Internal Server Error: The server has encountered an unexpected condition. Please try again later.",
          );
        case 502:
          return Future.error(
            response['message'] ??
                "Bad Gateway: The server received an invalid response from an upstream server.",
          );
        case 503:
          return Future.error(
            response['message'] ??
                "Service Unavailable: The server is not ready to handle the request. Please try again after some time.",
          );
        case 504:
          return Future.error(
            response['message'] ??
                "Gateway Timeout: The server, while acting as a gateway, did not get a response in time from the upstream server.",
          );

        default:
          return Future.error(response['message'] ?? 'Something went wrong.Please Try Again');
      }
    } else {
      return Future.error("Something went wrong.Please Try Again");
    }
  }
}
