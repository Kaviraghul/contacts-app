import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed_data_classes.freezed.dart';

@freezed
class LoginObject with _$LoginObject {
  factory LoginObject({required String email, required String password}) =
      _LoginObject;
}

@freezed
class RegisterObject with _$RegisterObject {
  factory RegisterObject({required String email, required String password}) =
      _RegisterObject;
}

@freezed
class ContactObject with _$ContactObject {
  factory ContactObject({
    required int id,
    required String name,
    required int phoneNumber,
  }) = _ContactObject;
}
