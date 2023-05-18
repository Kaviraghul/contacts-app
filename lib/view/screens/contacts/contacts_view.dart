import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/app/services/firebase_services.dart';
import 'package:contacts_app/view/resources/appStrings.dart';
import 'package:contacts_app/view/screens/contacts/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ContactViewModel _viewModel = ContactViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContactsList(),
      bottomNavigationBar: MyBottomNavigationBar(
        onAddPressed: _showAddContactDialog,
      ),
    );
  }

  Widget _getContactsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseServices.readAllContacts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<DocumentSnapshot> documents = snapshot.data!.docs;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
              children: documents
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Dismissible(
                        background: Container(
                          color: Colors.green,
                        ),
                        key: ValueKey<String>(data['id']),
                        onDismissed: (DismissDirection direction) {
                          String documentId = document.id;
                          print(documentId);
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(UserPreferences.getUserId())
                              .collection('contacts')
                              .doc(documentId)
                              .delete()
                              .then(
                                (doc) => print("Document deleted"),
                                onError: (e) =>
                                    print("Error updating document $e"),
                              );
                        },
                        child: ListTile(
                            tileColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(data['name']),
                            subtitle: Text(data['phoneNumber']),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditContactDialog(document.id,
                                    data['name'], data['phoneNumber']);
                              },
                            )),
                      ),
                    );
                  })
                  .toList()
                  .cast()),
        );
      },
    );
  }

  void _showEditContactDialog(
      String documentId, String name, String phoneNumber) {
    // Populate the text fields with the existing contact details
    _nameController.text = name;
    _phoneNumberController.text = phoneNumber;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.editContacts),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: AppStrings.phoneNumber,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform contact update logic here
                final String newName = _nameController.text;
                final String newPhoneNumber = _phoneNumberController.text;
                // Update the contact using the provided data
                _viewModel.update(documentId, newName, newPhoneNumber);
                Navigator.pop(context);
              },
              child: const Text(AppStrings.update),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.add),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: AppStrings.phoneNumber,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform contact addition logic here
                final String name = _nameController.text;
                final String phoneNumber = _phoneNumberController.text;
                // Add the contact using the provided data
                _viewModel.addNewContact(name, phoneNumber);
                Navigator.pop(context);
              },
              child: const Text(AppStrings.add),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final VoidCallback onAddPressed;

  const MyBottomNavigationBar({Key? key, required this.onAddPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: AppStrings.add,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: AppStrings.logout,
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        if (index == 1) {
          onAddPressed();
        } else if (index == 2) {
          UserPreferences.setLoggedIn(false);
          UserPreferences.setUserId('');
          context.go('/');
          // print(UserPreferences.getUserId());
        }
      },
    );
  }
}
