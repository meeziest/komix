import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_manga_translation/data/repository/authentication_repository.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/code_verification_screen/code_veriification_screen.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';

class AuthenticationScreenPresenter extends BasePresenter<AuthenticationScreenModel> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthenticationScreenPresenter(AuthenticationScreenModel model) : super(model);

  @override
  void onInitWithContext() {}

  void auth() {
    if (model.authSection == AuthSection.login) {
      login();
    } else {
      requestRegister();
    }
  }

  void requestRegister() async {
    startLoading();
    try {
      await AuthenticationRepository().requestToken(emailController.text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodeVerificationScreen(email: emailController.text)));
    } catch (e) {
      String message = 'Internal error';
      if (e is RequestException) {
        if (e.code == RequestExceptionCode.forbidden || e.code == RequestExceptionCode.badRequest) {
          try {
            message = json.decode(e.message)['error'];
          } catch (e) {
            message = RequestException(code: RequestExceptionCode.internal).message;
          }
        } else {
          message = e.message;
        }
      }
      Popups.showPopup(title: message, buttonText: 'Ok', context: context);
    }
    endLoading();
  }

  void login() async {
    startLoading();
    await AuthenticationRepository().logIn(emailController.text, passwordController.text);
    dataScope.rebuild();
    endLoading();
  }

  toggleAuthSection() {
    if (model.authSection == AuthSection.login) {
      model.authSection = AuthSection.register;
    } else {
      model.authSection = AuthSection.login;
    }
    updateView();
  }
}

enum AuthSection {
  login,
  register,
}
