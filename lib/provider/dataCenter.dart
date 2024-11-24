

import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:TerraViva/models/Category.dart';

// import '../models/Object3d.dart';

class DataCenter with ChangeNotifier {
  
  late Category currentCategory = Category.defaultConstructor();
  late Category currentSubCategory = Category.defaultConstructor();

  // late Object3d currentObject3d = Object3d.defaultConstructor();
  late ThreeDObject currentObject3d = ThreeDObject.defaultConstructor();

  void setCurretntCategory(Category selectedCategory) {
    currentCategory = selectedCategory;
    notifyListeners();
  }

  void setCurretntSubCategory(Category selectedSubCategory) {
    currentSubCategory = selectedSubCategory;
    notifyListeners();
  }

  void setCurretntObject3d(ThreeDObject selectedObject3d) {
    currentObject3d = selectedObject3d;
    notifyListeners();
  }
  void setSaved() {
    notifyListeners();
  }
}
