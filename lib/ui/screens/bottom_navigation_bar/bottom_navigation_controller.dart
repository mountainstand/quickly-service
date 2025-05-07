import 'package:get/get.dart' show GetxController, IntExtension;

enum BottomBarEnum {
  home,
  speedTest,
  subscriptionPlan,
  menu;

  int get value {
    switch (this) {
      case BottomBarEnum.home:
        return 0;
      case BottomBarEnum.speedTest:
        return 1;
      case BottomBarEnum.subscriptionPlan:
        return 2;
      case BottomBarEnum.menu:
        return 3;
    }
  }
}

/// Initialised in [BottomNavigationBarScreen]
class BottomNavigationController extends GetxController {
  final _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void updateIndex(BottomBarEnum index) {
    _selectedIndex.value = index.value;
  }
}
