import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String userId = UserPreferences.getUserId();

class FirebaseServices {
  // user sign in
  static Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // user sign up
  static Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // new contact addition
  static void addNewContact(String phoneNumber, String contactName) async {
    CollectionReference contactsCollection =
        _firestore.collection('users').doc(userId).collection('contacts');
    await contactsCollection.add({
      'id': phoneNumber,
      'name': contactName,
      'phoneNumber': phoneNumber,
    });
  }

  // read all contacts
  static Stream<QuerySnapshot> readAllContacts() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots();
  }
}
