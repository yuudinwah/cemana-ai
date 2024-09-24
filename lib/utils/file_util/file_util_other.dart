// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cemana/utils/snack_bar_util.dart';
import 'package:cemana/utils/file_util/file_util_android.dart' as fua;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileUtil {
  Future<dynamic> saveFileFromBytes(BuildContext context,
      {required Uint8List bytes,
      String? dir,
      String? name,
      bool notif = true}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await fua.FileUtil().saveFileFromBytes(
        context,
        bytes: bytes,
        dir: dir,
        name: name,
        notif: notif,
      );
    }
    try {
      SnackBarUtil().infoAlert(context, message: "Download dimulai");

      await FileSaver.instance.saveFile(
        name: name ?? "untitled",
        bytes: bytes,
        filePath: dir,
        mimeType: MimeType.other,
      );

      SnackBarUtil().infoAlert(context, message: "Download berhasil");
    } catch (e) {
      log(e.toString());
      SnackBarUtil().errorAlert(context,
          message: "Download gagal, silahkan coba lagi nanti");
    }
  }
}
