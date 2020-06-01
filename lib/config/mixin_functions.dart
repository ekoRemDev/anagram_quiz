import 'package:fluttertoast/fluttertoast.dart';

import 'config.dart';

mixin MixinFunctions {
  void showToastMessages(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: toastBackground,
        textColor: toastFont,
        fontSize: 22.0
    );
  }





  DateTime currentBackPressTime;

  Future<bool> doubleTapToQuit() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(
          msg: "Please Double Tap to Quit!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: toastBackground,
          textColor: toastFont,
          fontSize: 22.0
      );



      return Future.value(false);
    }
    return Future.value(true);
  }



}