import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


void showBottomSheetWebView(BuildContext context,Widget widget) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return widget;
    },
  );
}