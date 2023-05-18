import 'dart:async';

import 'package:contacts_app/view/base/base_view_model.dart';
import 'package:contacts_app/view/common/freezed_data_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController<String> _userEmailStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _userPasswordStreamController =
      StreamController<String>.broadcast();
  final StreamController<String> _userConfirmPasswordStreamController =
      StreamController<String>.broadcast();
  final StreamController<bool> _isAllInputsValidStreamController =
      StreamController<bool>.broadcast();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var registerObject = RegisterObject(
    email: '',
    password: '',
  );
  var confirmPwd = '';

  @override
  void start() {}

  @override
  void dispose() {
    inputUserEmail.close();
    inputUserPassword.close();
    inputUserConfirmPassword.close();
    inputIsAllInputsValid.close();
  }

  @override
  setUserEmail(String email) {
    inputUserEmail.add(email);
    registerObject = registerObject.copyWith(email: email);
    _validate();
  }

  @override
  setUserPassword(String password) {
    inputUserPassword.add(password);
    registerObject = registerObject.copyWith(password: password);
    _validate();
  }

  @override
  setUserConfirmPassword(String confirmPassword) {
    inputUserConfirmPassword.add(confirmPassword);
    confirmPwd = confirmPassword;
    _validate();
  }

  _validate() {
    inputIsAllInputsValid.add(true);
  }

  @override
  register(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      print('User registered: ${user?.uid}');
      context.go('/');
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  @override
  Sink<String> get inputUserEmail => _userEmailStreamController.sink;

  @override
  Sink<String> get inputUserPassword => _userPasswordStreamController.sink;

  @override
  Sink<String> get inputUserConfirmPassword =>
      _userConfirmPasswordStreamController.sink;

  @override
  Sink<bool> get inputIsAllInputsValid =>
      _isAllInputsValidStreamController.sink;

  @override
  Stream<bool> get outputIsUserEmailValid => _userEmailStreamController.stream
      .map((email) => _isUserEmailValid(email));

  @override
  Stream<bool> get outputIsUserPasswordValid =>
      _userPasswordStreamController.stream
          .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserConfirmPasswordValid =>
      _userConfirmPasswordStreamController.stream.map((confirmPassword) =>
          _isConfirmPasswordValid(confirmPwd, registerObject.password));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserEmailValid(String password) {
    return password.isNotEmpty;
  }

  bool _isConfirmPasswordValid(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool _isAllInputValid() {
    return _isUserEmailValid(registerObject.email) &&
        _isConfirmPasswordValid(confirmPwd, registerObject.password);
  }
}

abstract class RegisterViewModelInputs {
  setUserEmail(String email);
  setUserPassword(String password);
  setUserConfirmPassword(String confirmPassword);
  register(String email, String password, BuildContext context);

  Sink get inputUserEmail;
  Sink get inputUserPassword;
  Sink get inputUserConfirmPassword;
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputIsUserEmailValid;
  Stream<bool> get outputIsUserPasswordValid;
  Stream<bool> get outputIsUserConfirmPasswordValid;
}
