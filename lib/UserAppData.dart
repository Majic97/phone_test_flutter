import 'package:phone_test/pages/main_page/main_page_states.dart';

class UserAppData {
  final bool isInited;
  List<BestSeller> cart = [];
  List<int> likedGoods = [];
  Map<String, String> filterProperties = {};

  static UserAppData appData = UserAppData._();

  UserAppData._() : isInited = true;

  factory UserAppData() {
    return appData;
  }
}
