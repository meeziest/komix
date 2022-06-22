import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_manga_translation/data/repository/authentication_repository.dart';
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/code_verification_screen/code_veriification_screen.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';

class AuthenticationScreenPresenter extends BasePresenter<AuthenticationScreenModel> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;

  final SharedPreferencesRepository _spRepo = SharedPreferencesRepository();

  AuthenticationScreenPresenter(AuthenticationScreenModel model) : super(model);

  @override
  void onInitWithContext() {
    usernameFocusNode = FocusNode(onKey: _handleKeyPress);
    passwordFocusNode = FocusNode(onKey: _handleKeyPress);
  }

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
      if (e is RequestException) {
        Popups.showPopup(title: e.message, buttonText: 'Ok', context: context);
      }
    }
    endLoading();
  }

  void onVersionMultipleClick() async {
    final result = await Popups.showPopup(
      context: context,
      serverPopup: true,
      serverUrlText: _spRepo.getServerUrl() ?? '',
      buttonText: 'Apply',
    );
    if (result is String) {
      _spRepo.setServerUrl(result);
      updateView();
    }
  }

  void login() async {
    if (emailController.text.length < 3 && passwordController.text.length < 3) {
      Popups.showPopup(context: context, title: 'Empty fields', buttonText: 'Ok');
      return;
    }
    startLoading();
    try {
      await AuthenticationRepository().logIn(emailController.text, passwordController.text);
      dataScope.rebuild();
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

  KeyEventResult _handleKeyPress(FocusNode focusNode, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (event is RawKeyDownEvent) {
        auth();
      }
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
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
