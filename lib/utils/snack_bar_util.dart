import 'package:flutter/material.dart';

class SnackBarUtil {
  infoAlert(BuildContext context, {required String message}) {
    double width = MediaQuery.of(context).size.width;
    double w;
    if (width < 720) {
      w = width - 32;
    } else {
      w = width - 32;
      if (w > 500) {
        w = 500;
      }
    }
    SnackBar snackBar = SnackBar(
      width: w,
      content: Text(message),
      backgroundColor: Colors.cyan,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Tutup',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  successAlert(
    BuildContext context, {
    required String message,
    String? label,
    Function()? action,
  }) {
    double width = MediaQuery.of(context).size.width;
    double w;
    if (width < 720) {
      w = width - 32;
    } else {
      w = width - 32;
      if (w > 500) {
        w = 500;
      }
    }
    SnackBar snackBar = SnackBar(
      width: w,
      content: Text(message),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: label ?? 'Tutup',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: action ??
            () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  warningAlert(BuildContext context, {required String message}) {
    double width = MediaQuery.of(context).size.width;
    double w;
    if (width < 720) {
      w = width - 32;
    } else {
      w = width - 32;
      if (w > 500) {
        w = 500;
      }
    }
    SnackBar snackBar = SnackBar(
      width: w,
      content: Text(message),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Tutup',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  errorAlert(BuildContext context, {required String message}) {
    double width = MediaQuery.of(context).size.width;
    double w;
    if (width < 720) {
      w = width - 32;
    } else {
      w = width - 32;
      if (w > 500) {
        w = 500;
      }
    }
    SnackBar snackBar = SnackBar(
      width: w,
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Tutup',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  comingSoonAlert(BuildContext context) {
    warningAlert(context, message: "Fitur akan segera hadir");
  }
}
