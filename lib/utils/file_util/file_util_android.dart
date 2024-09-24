// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:cemana/utils/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  Future<String?> saveFileFromBytes(BuildContext context,
      {required Uint8List bytes,
      String? dir,
      String? name,
      bool notif = true}) async {
    try {
      // bool isGranted = await PermissionUtil().storage(context);
      // if (!isGranted) throw '';

      if (notif) {
        SnackBarUtil().infoAlert(context, message: "Download dimulai");
      }
      // final directory = Directory("/storage/emulated/0/Cemana");
      Directory directory = await getApplicationSupportDirectory();
      final path = directory.path;
      // final file = File('$path/$dir/${name ?? "download${DateTimeUtils.dateFormat(DateTime.now(), format: "yyyyMMdd-hh:mm:dd")}"}');
      File file = File("${directory.path}/${name ?? "${DateTime.now()}"}");
      // String content = base64Encode(byte);
      try {
        file.writeAsBytes(bytes);
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "Cemana/${dir ?? ""}";
        await MediaStore()
            .saveFile(
              tempFilePath: file.path,
              dirType: DirType.download,
              dirName: DirType.download.defaults,
            )
            .then((value) => null);
        // await file.writeAsBytes(bytes);
        // debugPrint('file berhasil disimpan');
      } catch (e) {
        if (!(await directory.exists())) {
          await directory.create();
        }
        if (e.toString().contains('No such file or directory')) {
          String p = path;
          for (String d in (dir ?? "").split("/")) {
            p += '/$d';
            if (!(await Directory(p).exists())) {
              await Directory(p).create();
            }
          }
          await file.writeAsBytes(bytes);
          // debugPrint('file berhasil disimpan');
        } else {
          throw '$e';
        }
      }
      if (notif) {
        SnackBarUtil().infoAlert(context,
            message:
                "Download berhasil, file disimpan di Download/Cemana/${dir ?? ""}");
      }
      return file.path;
    } catch (e) {
      // log(e);
      if (notif) {
        SnackBarUtil().errorAlert(context,
            message: "Download gagal, silahkan coba lagi nanti, $e");
      }
      return null;
    }
  }
}
