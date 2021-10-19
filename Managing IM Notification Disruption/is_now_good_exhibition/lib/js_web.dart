@JS()
library js;

import 'package:js/js.dart';

@JS('window.eval')
external dynamic eval(dynamic arg);

String evaluate(String jsCode) {
  return eval(jsCode).toString();
}
