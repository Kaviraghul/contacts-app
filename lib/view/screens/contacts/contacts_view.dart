import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/app/peferences/user_preferences.dart';
import 'package:contacts_app/view/screens/contacts/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: _getContactsList(),
      bottomNavigationBar: MyBottomNavigationBar(
        onAddPressed: _showAddContactDialog,
        onLogoutPresed: _showLogoutDialog,
      ),
    );
  }

  Widget _getContactsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('vyVv55U8AjSO2GBYgzzeszp3aEx1')
          .collection('contacts')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView(
            children: documents
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Dismissible(
                    background: Container(
                      color: Colors.green,
                    ),
                    key: ValueKey<String>(data['id']),
                    onDismissed: (DismissDirection direction) {
                      String documentId = document.id;
                      print(documentId);
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc('vyVv55U8AjSO2GBYgzzeszp3aEx1')
                          .collection('contacts')
                          .doc(documentId)
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );
                    },
                    child: ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['phoneNumber']),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditContactDialog(
                                document.id, data['name'], data['phoneNumber']);
                          },
                        )),
                  );
                })
                .toList()
                .cast());
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
          title: const Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
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
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
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
          title: const Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
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
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                    onPressed: () {
                      UserPreferences.setLoggedIn(false);
                      context.go('/');
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
              ]);
        });
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
  final VoidCallback onLogoutPresed;

  const MyBottomNavigationBar(
      {Key? key, required this.onAddPressed, required this.onLogoutPresed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        if (index == 1) {
          onAddPressed();
        } else if (index == 2) {
          onLogoutPresed();
        }
      },
    );
  }
}
