import 'dart:io';

import 'package:assignment/core/enums/app_enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:assignment/core/constants/app_color.dart';

class FileModel {
  String name;
  String path;
  String extension;
  File file;
  UploadStatus status;
  Color fileColor;
  num uploadValue;
  num totalValue;
  CancelToken? cancelToken;

  FileModel({
    required this.name,
    required this.path,
    required this.extension,
    required this.file,
    required this.status,
    Color? fileColor,
    this.uploadValue = 0,
    this.totalValue = 0,
    this.cancelToken,
  }) : fileColor = fileColor ?? AppColor.randomColor;
}