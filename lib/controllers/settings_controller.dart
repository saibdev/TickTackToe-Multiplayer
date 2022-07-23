import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late final SharedPreferences _prefs;
  String nickName = 'player1';
  String theme = 'Default';

  @override
  void onInit() async {
    super.onInit();

    _prefs = await SharedPreferences.getInstance();
      

      String? prefNickname = _prefs.getString('nickname');
      String? prefTheme = _prefs.getString('theme');

      if (prefNickname == null) {
        _prefs.setString('nickname', 'player1');
      } else {
        nickName = prefNickname;
        update();
      }

      if (prefTheme == null) {
        _prefs.setString('theme', 'Default');
      } else {
        theme = prefTheme;
        update();
      }

  }

  Future setNickname(String newName) async {
    bool res = await _prefs.setString('nickname', newName);
    if (res == true) {
      nickName = newName;
      update();
    }
  
    return res;
  }

  Future setTheme(String newTheme) async {
    bool res = await _prefs.setString('theme', newTheme);
    if (res == true) {
      theme = newTheme;
      update();
    }
  
    return res;
  }

}