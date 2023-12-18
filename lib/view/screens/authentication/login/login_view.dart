import 'package:contacts_app/view/resources/appStrings.dart';
import 'package:contacts_app/view/screens/authentication/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_jcikwtux.json'),
            Form(
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
                              labelText: AppStrings.email,
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {},
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<bool>(
                        stream: _viewModel.outputIsUserPasswordValid,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: _userPasswordController,
                            decoration: const InputDecoration(
                              labelText: AppStrings.password,
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
                      stream: _viewModel.outputIsAllInputsValid,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data ?? false;
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            onPressed: isValid
                                ? () => _viewModel.login(context)
                                : null,
                            child: const Text(AppStrings.login));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.noAccount,
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () => context.go("/userRegister"),
                child: const Text(AppStrings.signUp),
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
