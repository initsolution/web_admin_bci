import 'package:flutter/widgets.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  var _token = '';
  var _username = '';

  String get token => _token;

  String get username => _username;

  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    _username = sharedPref.getString(StorageKeys.username) ?? '';
    _token = sharedPref.getString(StorageKeys.token) ?? '';

    notifyListeners();
  }

  Future<void> setUserDataAsync({
    String? token,
    String? username,
  }) async {
    final sharedPref = await SharedPreferences.getInstance();
    var shouldNotify = false;

    if (token != null && token != _token) {
      _token = token;

      await sharedPref.setString(StorageKeys.token, _token);

      shouldNotify = true;
    }

    if (username != null && username != _username) {
      _username = username;

      await sharedPref.setString(StorageKeys.username, _username);

      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> clearUserDataAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    await sharedPref.remove(StorageKeys.username);
    await sharedPref.remove(StorageKeys.token);

    _username = '';
    _token = '';

    notifyListeners();
  }

  bool isUserLoggedIn() {
    return _username.isNotEmpty;
  }
}
