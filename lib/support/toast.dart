import 'package:fluttertoast/fluttertoast.dart';

void showmessage(String message) {
  Fluttertoast.showToast(
                      msg: message,
                      toastLength: Toast.LENGTH_SHORT,
                 );
}