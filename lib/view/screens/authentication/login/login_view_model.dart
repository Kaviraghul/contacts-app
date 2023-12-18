import 'dart:async';

import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/app/services/firebase_services.dart';
import 'package:contacts_app/view/base/base_view_model.dart';
import 'package:contacts_app/view/common/freezed_data_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userEmailStreamController =
      StreamController<String>.broadcast();
  final StreamController _userPasswordStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputsValidStreamController =
      StreamController<bool>.broadcast();

  var loginObject = LoginObject(email: '', password: '');

  @override
  Future<String?> login(BuildContext context) async {
    try {
      Future<UserCredential> result =
          FirebaseServices.signIn(loginObject.email, loginObject.password);
      UserCredential userCredential = await result;
      User? user = userCredential.user;

      if (user != null) {
        UserPreferences.setUserId(user.uid);
        UserPreferences.setLoggedIn(true);
        context.go('/contactsScreen');
      }
    } catch (error) {
      print('Login failed. Error: $error');
    }

    return null;
  }

  @override
  void start() {}

  @override
  void dispose() {
    _userEmailStreamController.close();
    _userPasswordStreamController.close();
    _isAllInputsValidStreamController.close();
  }

  @override
  setUserPassword(String password) {
    inputUserPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _validate();
  }

  @override
  setUserEmail(String email) {
    inputUserEmail.add(email);
    loginObject = loginObject.copyWith(email: email);
    _validate();
  }

  _validate() {
    inputIsAllInputsValid.add(true);
  }

  @override
  Sink get inputUserEmail => _userEmailStreamController.sink;

  @override
  Sink get inputUserPassword => _userPasswordStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputsValidStreamController.sink;

  @override
  Stream<bool> get outputIsUserEmailValid => _userEmailStreamController.stream
      .map((email) => _isUserEmailValid(email));

  @override
  Stream<bool> get outputIsUserPasswordValid =>
      _userPasswordStreamController.stream
          .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserEmailValid(String email) {
    return email.isNotEmpty;
  }

  bool _isAllInputValid() {
    return _isUserEmailValid(loginObject.email) &&
        _isPasswordValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setUserEmail(String email);
  setUserPassword(String password);
  login(BuildContext context);

  Sink get inputUserEmail;
  Sink get inputUserPassword;
  Sink get inputIsAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUserEmailValid;
  Stream<bool> get outputIsUserPasswordValid;
  Stream<bool> get outputIsAllInputsValid;
}
