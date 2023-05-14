import 'package:contacts_app/view/screens/authentication/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LoginViewModel _viewModel = LoginViewModel();

  void _bind() {
    _viewModel.start();
    _userEmailController
        .addListener(() => _viewModel.setUserEmail(_userEmailController.text));
    _userPasswordController.addListener(
        () => _viewModel.setUserPassword(_userPasswordController.text));
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loginScreen();
  }

  Widget _loginScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Login screen')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<bool>(
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
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsUserPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _userPasswordController,
                        decoration: InputDecoration(
                          labelText: 'password',
                          errorText: (snapshot.data ?? true)
                              ? null
                              : "password incorrect",
                          border: const OutlineInputBorder(),
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
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsAllInputsValid,
                  builder: (context, snapshot) {
                    final isValid = snapshot.data ?? false;
                    return ElevatedButton(
                        onPressed:
                            isValid ? () => _viewModel.login(context) : null,
                        child: const Text("Login"));
                  },
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
                "Don't have an account?",
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () => context.go("/userRegister"),
                child: const Text('Sign up'),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
