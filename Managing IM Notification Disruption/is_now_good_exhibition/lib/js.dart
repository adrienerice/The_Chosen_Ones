import 'package:flutter_js/flutter_js.dart';

var flutterJs = getJavascriptRuntime();

String evaluate(String jsCode) {
  return flutterJs.evaluate(jsCode).stringResult;
}
