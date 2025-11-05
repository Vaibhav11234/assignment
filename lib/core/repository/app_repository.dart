import 'package:assignment/core/model/file_model.dart';
import 'package:assignment/core/network/api_client.dart';
import 'package:assignment/feature/file_uploader/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRepository {
  AppRepository._();

  static Future<dynamic> uploadFilesUsingBase64({required FileModel fileModel}) async {
    try {
      final response = await ApiClient.instance.base64(
        file: fileModel.file,
        cancelToken: fileModel.cancelToken,
        onSendProgress: (count, total) {
          fileModel.uploadValue = count;
          fileModel.totalValue = total;
          Get.find<HomeController>().update();
        },
      );
      return response;
    } catch (e) {
      debugPrint("$e");
      return Future.error(e);
    }
  }

  static Future<dynamic> uploadFilesUsingMultipart({required FileModel fileModel}) async {
    try {
      final response = await ApiClient.instance.multipart(
        files: {'file': fileModel.path},
        cancelToken: fileModel.cancelToken,
        onSendProgress: (count, total) {
          fileModel.uploadValue = count;
          fileModel.totalValue = total;
          Get.find<HomeController>().update();
        },
      );
      return response;
    } catch (e) {
      debugPrint("$e");
      return Future.error(e);
    }
  }

  static Future<dynamic> uploadFilesUsingZip({required FileModel fileModel}) async {
    try {
      final response = await ApiClient.instance.uploadZip(
        files: [fileModel.file],
        cancelToken: fileModel.cancelToken,
        onSendProgress: (count, total) {
          fileModel.uploadValue = count;
          fileModel.totalValue = total;
          Get.find<HomeController>().update();
        },
      );
      return response;
    } catch (e) {
      debugPrint("$e");
      return Future.error(e);
    }
  }
}
