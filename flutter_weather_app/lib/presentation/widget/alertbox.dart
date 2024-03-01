import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme_config.dart';

class AlertBox {
  static Future<bool?> showAlertDialog(
      {required BuildContext context,
      required String title,
      required Widget child,
      required List<Widget>? actions,
      bool isDismissible = true}) async {
    bool? pop = await showDialog<bool?>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => isDismissible,
          child: AlertDialog(
            title: Text(
              title,
              style: ThemeConfig.styles.style16,
            ),
            content: child,
            actions: actions,
          ),
        );
      },
    );
    return pop ?? false;
  }
}
