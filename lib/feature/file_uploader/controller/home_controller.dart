import 'dart:io';

import 'package:assignment/core/enums/app_enums.dart';
import 'package:assignment/core/model/file_model.dart';
import 'package:assignment/core/repository/app_repository.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  UploadMode mode = UploadMode.base64;
  FileSelector fileSelectionMode = FileSelector.single;

  List<FileModel> selectedFiles = [];

  void changeMode() {
    mode = mode == UploadMode.base64
        ? UploadMode.multipart
        : mode == UploadMode.multipart
        ? UploadMode.zip
        : UploadMode.base64;
    update();
  }

  void changeFileSelection() {
    fileSelectionMode = fileSelectionMode == FileSelector.single
        ? FileSelector.multiple
        : FileSelector.single;
    update();
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: fileSelectionMode == FileSelector.multiple,
      dialogTitle: "Please select a file to upload it on server",
    );

    if (result != null) {
      for (var file in result.files) {
        selectedFiles.add(
          FileModel(
            name: file.name,
            path: file.path!,
            extension: file.extension!,
            file: File(file.path!),
            status: UploadStatus.pending,
          ),
        );
      }

      update();
    }
  }

  Future<void> uploadFile(FileModel fileModel) async {
    if (fileModel.status == UploadStatus.uploading) {
      fileModel.cancelToken?.cancel();
      fileModel.status = UploadStatus.cancelled;
      update();
      return;
    } else if (fileModel.status == UploadStatus.success) {
      return;
    }

    fileModel.cancelToken = CancelToken();
    fileModel.status = UploadStatus.uploading;
    update();
    switch (mode) {
      case UploadMode.base64:
        AppRepository.uploadFilesUsingBase64(fileModel: fileModel).then(
          (value) {
            if (value != null) {
              onSuccess(fileModel);
            }
          },
          onError: (err) {
            onFailure(fileModel, err);
          },
        );
        break;
      case UploadMode.multipart:
        AppRepository.uploadFilesUsingMultipart(fileModel: fileModel).then(
          (value) {
            if (value != null) {
              onSuccess(fileModel);
            }
          },
          onError: (err) {
            onFailure(fileModel, err);
          },
        );
        break;
      case UploadMode.zip:
        AppRepository.uploadFilesUsingZip(fileModel: fileModel).then(
          (value) {
            if (value != null) {
              onSuccess(fileModel);
            }
          },
          onError: (err) {
            onFailure(fileModel, err);
          },
        );
        break;
    }
  }

  void onSuccess(FileModel fileModel) {
    fileModel.status = UploadStatus.success;
    update();
    Get.showSnackbar(
      GetSnackBar(
        message: "File uploaded successfully",
        backgroundColor: Colors.lightGreen,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void onFailure(FileModel fileModel, Exception err) {
    Get.showSnackbar(
      GetSnackBar(
        message: "$err",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ),
    );
    fileModel.status = UploadStatus.failed;
    update();
  }
}
