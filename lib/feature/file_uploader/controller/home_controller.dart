import 'dart:io';

import 'package:assignment/core/enums/app_enums.dart';
import 'package:assignment/core/model/file_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  UploadMode mode = UploadMode.base64;
  FileSelector fileSelectionMode = FileSelector.single;

  List<FileModel> selectedFiles = [];

  void changeMode() {
    mode = mode == UploadMode.base64 ? UploadMode.multipart : mode == UploadMode.multipart ? UploadMode.zip : UploadMode.base64;
    update();
  }

  void changeFileSelection() {
    fileSelectionMode = fileSelectionMode == FileSelector.single ? FileSelector.multiple : FileSelector.single;
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

  Future<void> uploadFile(FileModel file) async {
    file.status = UploadStatus.uploading;
    update();
    switch (mode) {
      case UploadMode.base64:
        break;
      case UploadMode.multipart:
        break;
      case UploadMode.zip:
        break;
    }
    update();
  }
}
