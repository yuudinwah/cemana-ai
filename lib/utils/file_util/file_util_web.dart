// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously

import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cemana/utils/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:html' as html;

class FileUtil {
  Future<dynamic> saveFileFromBytes(BuildContext context,
      {required Uint8List bytes,
      String? dir,
      String? name,
      bool notif = true}) async {
    try {
      SnackBarUtil().infoAlert(context, message: "Download dimulai");

      final content = base64Encode(bytes);
      const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
      kIsWeb
          ? (html.AnchorElement(
              href:
                  "data:application/octet-stream;charset=utf-16le;base64,$content")
            ..setAttribute("download", name ?? "unnamed")
            ..click())
          : null;

      SnackBarUtil().infoAlert(context, message: "Download berhasil");
    } catch (e) {
      log(e.toString());
      SnackBarUtil().errorAlert(context,
          message: "Download gagal, silahkan coba lagi nanti");
    }
  }
}
