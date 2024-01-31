import 'package:flutter/material.dart';

class SocketDataProvider extends ChangeNotifier {
  List<dynamic> socketData = [];

  void setSocketData(List<dynamic> data) {
    final index = socketData.length;
    socketData.add(data);
    notifyListeners();
  }
}
