import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isPasswordHidden = true;

  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @computed
  bool get isEmailValid =>
      RegExp('^[a-z0-9.]+@[a-z0-9]+.[a-z]+.([a-z]+)?').hasMatch(email);

  @computed
  bool get isPasswordValid => password.length > 6;

  @computed
  Function? get loginOnPressed =>
      (isEmailValid && isPasswordValid && !isLoading) ? login : null;

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
  }

  @action
  Future<void> login() async {
    try {
      isLoading = true;
      await Future.delayed(const Duration(seconds: 4));
      isLoggedIn = true;

      email = '';
      password = '';
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    try {
      isLoading = true;
      await Future.delayed(const Duration(seconds: 1));
      isLoggedIn = false;
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
    }
  }
}
