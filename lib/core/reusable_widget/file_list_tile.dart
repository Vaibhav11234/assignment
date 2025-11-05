import 'package:assignment/core/constants/app_color.dart';
import 'package:assignment/core/enums/app_enums.dart';
import 'package:assignment/core/model/file_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({super.key, required this.file, required this.onPressed});

  final FileModel file;
  final Function(FileModel)? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(file.name),
      subtitle: file.status == UploadStatus.uploading
          ? LinearProgressIndicator(
              borderRadius: BorderRadiusGeometry.circular(100),
              color: AppColor.primary,
              value: file.uploadValue.toDouble(),
            )
          : null,
      leading: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(9),
          color: file.fileColor,
        ),
        alignment: Alignment.center,
        child: Text(
          file.extension,
          style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      trailing: CupertinoButton(
        onPressed: () {
          onPressed?.call(file);
        },
        sizeStyle: CupertinoButtonSize.small,
        padding: EdgeInsets.zero,
        child: Icon(
          file.status == UploadStatus.success
              ? LucideIcons.cloudCheck
              : file.status == UploadStatus.uploading
              ? Icons.clear
              : file.status == UploadStatus.pending
              ? LucideIcons.upload
              : file.status == UploadStatus.failed
              ? LucideIcons.rotateCcw
              : LucideIcons.play,
          color: file.status == UploadStatus.success
              ? Colors.lightGreen
              : file.status == UploadStatus.uploading
              ? AppColor.grey
              : file.status == UploadStatus.pending
              ? AppColor.primary
              : file.status == UploadStatus.failed
              ? Colors.redAccent
              : Colors.lightGreen,
        ),
      ),
    );
  }
}
