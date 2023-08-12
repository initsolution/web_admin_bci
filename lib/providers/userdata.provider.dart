import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_ptb/constants/values.dart';

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(UserData('-', '-'));

  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    var _username = sharedPref.getString(StorageKeys.username) ?? '';
    var _token = sharedPref.getString(StorageKeys.token) ?? '';
    state = UserData(_username, _token);
  }

  Future<void> setUserDataAsync({
    String? token,
    String? username,
  }) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(StorageKeys.token, token!);
    await sharedPref.setString(StorageKeys.username, username!);
    state = UserData(username, token);
  }

  Future<void> clearUserDataAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    await sharedPref.remove(StorageKeys.username);
    await sharedPref.remove(StorageKeys.token);

    var _username = '';
    var _token = '';

    state = UserData(_username, _token);
  }

  // bool isUserLoggedIn() {
  //   debugPrint(
  //       'isUserLogin : ${Provider((ref) => ref.watch(userDataProvider).username)}');
  //   return _username.isNotEmpty;
  // }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>(
    (ref) => UserDataNotifier());
