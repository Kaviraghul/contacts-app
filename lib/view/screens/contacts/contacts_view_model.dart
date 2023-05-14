import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/base/base_view_model.dart';
import 'package:contacts_app/view/common/freezed_data_classes.dart';

class ContactViewModel extends BaseViewModel
    with ContactViewModelInputs, ContactViewModelOutputs {
  /// defining all the stream controllers
  final StreamController _contacIdStreamController =
      StreamController<int>.broadcast();
  final StreamController _contacNameStreamController =
      StreamController<int>.broadcast();
  final StreamController _contactPhoneNumberStreamController =
      StreamController<int>.broadcast();
  final StreamController _isAllfieldsValidStreamController =
      StreamController<int>.broadcast();

  /// --------------------------------------------------------------------------------------------------------------------------

  ContactObject contactObject = ContactObject(id: 0, name: '', phoneNumber: 0);

  /// --------------------------------------------------------------------------------------------------------------------------
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = UserPreferences.getUserId();

  @override
  void start() async {}

  @override
  void dispose() {
    _contacNameStreamController.close();
    _contactPhoneNumberStreamController.close();
    _isAllfieldsValidStreamController.close();
    _contacIdStreamController.close();
  }

  ///defining all the sink getters

  @override
  Sink get inputContactId => _contacIdStreamController.sink;

  @override
  Sink get inputContactName => _contacNameStreamController.sink;

  @override
  Sink get inputContactPhoneNumber => _contactPhoneNumberStreamController.sink;

  @override
  Sink get isAllfieldsValid => _isAllfieldsValidStreamController.sink;

  ///defining all the Stream getters

  @override
  Stream get outputContactId =>
      _contacIdStreamController.stream.map((id) => setContactId(id));

  @override
  Stream get outputContactName =>
      _contacNameStreamController.stream.map((name) => setContactName(name));

  @override
  Stream get outputContactPhoneNumber =>
      _contactPhoneNumberStreamController.stream
          .map((phoneNumber) => setContactPhoneNumber(phoneNumber));

  @override
  Stream get outputIsAllfieldsValid =>
      _isAllfieldsValidStreamController.stream.map((_) => _isAllfieldsValid());

  ///defining all the validators

  _validate() {
    isAllfieldsValid.add(true);
  }

  bool _isContactIdValid(int id) {
    return id.toString().isNotEmpty;
  }

  bool _isContactNameValid(String name) {
    return name.isNotEmpty;
  }

  bool _isContactPhoneNumberValid(int phoneNumber) {
    return phoneNumber.toString().isNotEmpty;
  }

  bool _isAllfieldsValid() {
    return _isContactIdValid(contactObject.id) &&
        _isContactNameValid(contactObject.name) &&
        _isContactPhoneNumberValid(contactObject.phoneNumber);
  }

  ///defining all the setters

  @override
  setContactId(int id) {
    inputContactId.add(id);
    contactObject = contactObject.copyWith(id: id);
    _validate();
  }

  @override
  setContactName(String name) {
    inputContactName.add(name);
    contactObject = contactObject.copyWith(name: name);
    _validate();
  }

  @override
  setContactPhoneNumber(int phoneNumber) {
    inputContactPhoneNumber.add(phoneNumber);
    contactObject = contactObject.copyWith(phoneNumber: phoneNumber);
    _validate();
  }

  //defining all the crud operations

  @override
  void addNewContact(String contactName, String phoneNumber) async {
    CollectionReference contactsCollection =
        firestore.collection('users').doc(userId).collection('contacts');

    print(userId);

    await contactsCollection.add({
      'id': phoneNumber,
      'name': contactName,
      'phoneNumber': phoneNumber,
    });
  }

  @override
  delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  late Stream<QuerySnapshot> contactsStream;

  @override
  read() async {
    contactsStream = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots();
  }

  @override
  Future<void> update(
      String documentId, String newName, String newPhoneNumber) async {
    print(newName);
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('contacts')
          .doc(documentId)
          .update({
        'name': newName,
        'phoneNumber': newPhoneNumber,
      });
      print("Contact updated successfully");
    } catch (error) {
      print("Error updating contact: $error");
    }
  }
}

abstract class ContactViewModelInputs {
  addNewContact(String contactName, String phoneNumber);
  read();
  update(String documentId, String newName, String newPhoneNumber);
  delete();

  setContactId(int id);
  setContactName(String name);
  setContactPhoneNumber(int phoneNumber);

  Sink get inputContactId;
  Sink get inputContactName;
  Sink get inputContactPhoneNumber;
  Sink get isAllfieldsValid;
}

abstract class ContactViewModelOutputs {
  Stream get outputContactId;
  Stream get outputContactName;
  Stream get outputContactPhoneNumber;
  Stream get outputIsAllfieldsValid;
}

class Contact {
  final int id;
  final String name;
  final int phoneNumber;

  Contact({required this.name, required this.phoneNumber, required this.id});
}
