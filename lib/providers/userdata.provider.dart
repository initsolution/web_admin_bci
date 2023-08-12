import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_ptb/constants/values.dart';

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(UserData('-','-'));
  var _token = '';
  var _username = '';

  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    _username = sharedPref.getString(StorageKeys.username) ?? '';
    _token = sharedPref.getString(StorageKeys.token) ?? '';

    state = UserData(_username, _token);
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
      state = UserData(_username, _token);
      debugPrint('shouldnotify');
    }
  }

  Future<void> clearUserDataAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    await sharedPref.remove(StorageKeys.username);
    await sharedPref.remove(StorageKeys.token);

    _username = '';
    _token = '';

    state = UserData(_username, _token);
  }

  bool isUserLoggedIn() {
    return _username.isNotEmpty;
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier,UserData>((ref) => UserDataNotifier());