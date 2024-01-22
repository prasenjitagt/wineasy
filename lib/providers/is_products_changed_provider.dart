import 'package:flutter/material.dart';

class IsProductChangedProvider extends ChangeNotifier {
  bool isTheProductChanged = true;

  void changeIsTheProductChanged() {
    isTheProductChanged = !isTheProductChanged;
    notifyListeners();
  }
}
