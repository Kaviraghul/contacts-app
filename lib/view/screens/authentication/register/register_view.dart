import 'package:contacts_app/view/screens/authentication/register/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final RegisterViewModel _viewModel = RegisterViewModel();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register screen')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<Object>(
                    stream: _viewModel.outputIsUserEmailValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _userEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {},
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<Object>(
                    stream: _viewModel.outputIsUserPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _userPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {},
                        onSaved: (value) {},
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     labelText: 'Confirm Password',
              //     border: OutlineInputBorder(),
              //   ),
              //   obscureText: true,
              //   validator: (value) {},
              //   onSaved: (value) {},
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text('Sign up'),
                  onPressed: () => _viewModel.register(
                      _userEmailController.text,
                      _userPasswordController.text,
                      context),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an accout?",
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () => context.go("/"),
                child: const Text('Sign in'),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
