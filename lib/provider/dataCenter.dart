

import 'package:flutter/cupertino.dart';
import 'package:my_app/models/Category.dart';

import '../models/Object3d.dart';

class DataCenter with ChangeNotifier {
  
  late Category currentCategory = Category.defaultConstructor();
  late Object3d currentObject3d = Object3d.defaultConstructor();
  
  void setCurretntCategory(Category selectedCategory) {
    currentCategory = selectedCategory;
    notifyListeners();
  }

  void setCurretntObject3d(Object3d selectedObject3d) {
    currentObject3d = selectedObject3d;
    notifyListeners();
  }
  void setSaved() {
    notifyListeners();
  }
}
