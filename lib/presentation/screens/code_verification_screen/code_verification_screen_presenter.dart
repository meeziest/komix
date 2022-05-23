import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_manga_translation/data/repository/authentication_repository.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/request/request_exception.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/code_verification_screen/code_verification_view_model.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';

class CodeVerificationPresenter extends BasePresenter<CodeVerificationViewModel> {
  CodeVerificationPresenter(CodeVerificationViewModel model) : super(model);

  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode codeFocus = FocusNode();

  String? initCode;

  String? email;

  bool codeIsDone = false;

  @override
  void onInitWithContext() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      codeFocus.requestFocus();
      if (initCode != null) {
        codeController.text = initCode!;
        onContinueClick();
      }
    });
  }

  void onCodeChanged(String code) {
    String check = code.replaceAll('-', '').replaceAll(' ', '');
    if (check.length == 8) {
      codeIsDone = true;
    } else {
      codeIsDone = false;
    }
    updateView();
  }

  void onContinueClick() async {
    startLoading();
    if (email != null) {
      try {
        await AuthenticationRepository().register(
            email!, passwordController.text, confirmPasswordController.text, codeController.text);
      } catch (e) {
        String message = 'Internal error';
        if (e is RequestException) {
          if (e.code == RequestExceptionCode.forbidden ||
              e.code == RequestExceptionCode.badRequest) {
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
      Utils.clearRouteStack(context);
      dataScope.rebuild();
      endLoading();
    }
  }
}

bool isValidCode(String code) {
  return code.replaceAll('-', '').length == 8;
}
