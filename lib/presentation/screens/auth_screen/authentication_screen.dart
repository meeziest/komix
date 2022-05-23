import 'package:flutter/material.dart';
import 'package:simple_manga_translation/presentation/base_components/base_scaffold.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_presenter.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late AuthenticationScreenPresenter _presenter;

  @override
  void initState() {
    _presenter = AuthenticationScreenPresenter(AuthenticationScreenModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _presenter.initWithContext(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationScreenModel>(
        initialData: _presenter.model,
        stream: _presenter.stream,
        builder: (context, snapshot) {
          return BaseScaffold(
            backgroundColor: AppColors.backgroundColor,
            topBarColor: AppColors.topBarBackgroundColor,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'Komix',
                              style: TextStyle(
                                  color: AppColors.justWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _presenter.model.authSection == AuthSection.register
                                  ? 'Login'
                                  : 'Register',
                              style: const TextStyle(color: AppColors.textColor, fontSize: 20),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            cursorColor: Colors.deepOrange,
                            controller: _presenter.emailController,
                            style: const TextStyle(color: AppColors.justWhite),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepOrange),
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: AppColors.textColor),
                                floatingLabelStyle: TextStyle(color: Colors.deepOrange)),
                          ),
                        ),
                        if (_presenter.model.authSection == AuthSection.login)
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(
                              obscureText: true,
                              cursorColor: Colors.deepOrange,
                              style: const TextStyle(color: AppColors.justWhite),
                              controller: _presenter.passwordController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(color: AppColors.textColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepOrange),
                                  ),
                                  labelText: 'Password',
                                  floatingLabelStyle: TextStyle(color: Colors.deepOrange)),
                            ),
                          ),
                        if (_presenter.model.authSection == AuthSection.login)
                          TextButton(
                            onPressed: () {
                              //forgot password screen
                            },
                            child: const Text(
                              'Forgot a password',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                              ),
                              child: Text(_presenter.model.authSection == AuthSection.login
                                  ? 'Login'
                                  : 'Register'),
                              onPressed: () {
                                _presenter.auth();
                              },
                            )),
                        Row(
                          children: <Widget>[
                            if (_presenter.model.authSection == AuthSection.login)
                              const Text(
                                'Does not have account?',
                                style: TextStyle(color: Colors.white60),
                              ),
                            TextButton(
                              child: Text(
                                _presenter.model.authSection == AuthSection.register
                                    ? 'login'
                                    : 'register',
                                style: const TextStyle(color: Colors.orange, fontSize: 20),
                              ),
                              onPressed: () {
                                _presenter.toggleAuthSection();
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
