import 'package:assignment/core/constants/app_color.dart';
import 'package:assignment/core/enums/app_enums.dart';
import 'package:assignment/core/model/file_model.dart';
import 'package:assignment/core/reusable_widget/file_list_tile.dart';
import 'package:assignment/feature/file_uploader/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("File Uploader"),
            foregroundColor: AppColor.white,
            backgroundColor: AppColor.primary,
          ),
          body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Selected Files",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          controller.changeMode();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            side: BorderSide(color: AppColor.primary, width: 3),
                          ),
                          side: BorderSide(color: AppColor.primary, width: 1.5),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          controller.mode == UploadMode.base64
                              ? "base64"
                              : controller.mode == UploadMode.multipart
                              ? "multipart"
                              : "zip",
                          style: TextStyle(color: AppColor.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: controller.selectedFiles.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final file = controller.selectedFiles[index];
                      return FileListTile(
                        file: file,
                        onPressed: (f) {
                          controller.uploadFile(f);
                        },
                      );
                    },
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Icon(LucideIcons.info, color: AppColor.grey, size: 12),
                    Text(
                      controller.fileSelectionMode == FileSelector.single
                          ? "You can select single file at a time"
                          : "You can select multiple files at a time",
                      style: TextStyle(fontSize: 12, color: AppColor.grey),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 5,
                      child: FilledButton(
                        onPressed: () {
                          controller.selectFile();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [Icon(Icons.file_open_outlined), Text("Select File")],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          controller.changeFileSelection();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            side: BorderSide(color: AppColor.primary, width: 3),
                          ),
                          side: BorderSide(color: AppColor.primary, width: 1.5),
                          padding: EdgeInsets.zero,
                        ),
                        child: Icon(
                          controller.fileSelectionMode == FileSelector.single
                              ? LucideIcons.file
                              : LucideIcons.files,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

