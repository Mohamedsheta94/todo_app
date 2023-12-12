import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 12,),
                Text(message),
              ],
            ),
          );
        }
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showMessage(BuildContext context, String message, {
    String title = "title",
    String? posActionName,
    VoidCallback? posAction,
    String? negActionName,
    VoidCallback? negAction
  }) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            posAction?.call();
          },
          child: Text(posActionName, style: Theme
              .of(context)
              .textTheme
              .titleSmall,)
      )
      );
    }
    if (negActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            negAction?.call();
          },
          child: Text(negActionName, style: Theme
              .of(context)
              .textTheme
              .titleSmall,)
      )
      );
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message, style: Theme
                .of(context)
                .textTheme
                .titleSmall,),
            title: Text(title),
            actions: actions,
          );
        }
    );
  }
}