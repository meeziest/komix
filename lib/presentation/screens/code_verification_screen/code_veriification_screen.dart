import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_scaffold.dart';
import 'package:simple_manga_translation/presentation/screens/code_verification_screen/code_verification_screen_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/code_verification_screen/code_verification_view_model.dart';
import 'package:simple_manga_translation/presentation/utils/code_formatter.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';
import 'package:simple_manga_translation/presentation/widgets/custom_progress_indicator.dart';
import 'package:simple_manga_translation/presentation/widgets/multiplier.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({Key? key, this.code, required this.email}) : super(key: key);

  final String email;
  final String? code;

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final CodeVerificationPresenter _presenter =
      CodeVerificationPresenter(CodeVerificationViewModel(ScreenState.none));

  @override
  void didChangeDependencies() {
    _presenter.initCode = widget.code;
    _presenter.email = widget.email;
    _presenter.initWithContext(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CodeVerificationViewModel>(
        stream: _presenter.stream,
        builder: (context, snapshot) {
          return BaseScaffold(
            topBarColor: AppColors.topBarBackgroundColor,
            backgroundColor: AppColors.backgroundColor,
            child: Stack(
              children: [
                Positioned(
                  child: buildButton(
                      onPressed: () {
                        _presenter.goBack();
                      },
                      assetSvgPath: 'assets/icons/keyboard_arrow_left.svg',
                      center: true,
                      height: 70,
                      width: 70),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      width: 600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 25),
                            child: Text(
                              'Komix',
                              style: TextStyle(color: AppColors.projectIconColor),
                            ),
                          ),
                          const Text(
                            'Enter code',
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Enter 8 digit code',
                              style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextField(
                              autocorrect: false,
                              inputFormatters: [
                                CodeFormatter(),
                              ],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 5,
                                  color: AppColors.justWhite),
                              textAlign: TextAlign.center,
                              cursorColor: AppColors.projectIconColor,
                              autofocus: true,
                              cursorHeight: 20,
                              controller: _presenter.codeController,
                              focusNode: _presenter.codeFocus,
                              onChanged: _presenter.onCodeChanged,
                              onSubmitted: (_) {
                                _presenter.onContinueClick();
                              },
                              cursorWidth: 1.5,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.topBarBorderColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                hintText: 'code',
                                hintStyle: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.iconColor),
                              ),
                            ),
                          ),
                          buildPasswordField(_presenter.passwordController, 'Create password'),
                          buildPasswordField(
                              _presenter.confirmPasswordController, 'Confirm password'),
                          const SizedBox(height: 20),
                          MultiplierOnHover(
                              multiplier: 1.01,
                              child: buildButton(
                                  onPressed: () {
                                    _presenter.onContinueClick();
                                  },
                                  text: 'Confirm',
                                  active: true,
                                  center: true)),
                          if (_presenter.model.state == ScreenState.loading)
                            const Center(
                              child: CustomProgressIndicator(
                                height: 40,
                                width: 40,
                                color: AppColors.iconActiveColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildPasswordField(TextEditingController controller, String labelText) => Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextField(
          obscureText: true,
          cursorColor: Colors.deepOrange,
          style: const TextStyle(color: AppColors.justWhite),
          controller: controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(color: AppColors.textColor),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
              labelText: labelText,
              floatingLabelStyle: const TextStyle(color: Colors.deepOrange)),
        ),
      );

  buildButton(
      {String? assetSvgPath,
      String? text,
      required Function onPressed,
      double width = double.infinity,
      double height = double.infinity,
      bool center = false,
      double iconSize = 35,
      bool active = false}) {
    return Container(
      constraints: BoxConstraints(maxHeight: height, maxWidth: width),
      width: width != double.infinity ? width : null,
      height: height != double.infinity ? height : null,
      child: MaterialButton(
        color: active ? AppColors.topBarBackgroundColor : null,
        hoverColor: AppColors.topBarBackgroundColor,
        textColor: AppColors.textColor,
        highlightColor: AppColors.topBarBackgroundColor,
        elevation: 0,
        splashColor: AppColors.backgroundColor,
        height: 60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (assetSvgPath != null)
                  SvgPicture.asset(
                    assetSvgPath,
                    color: active ? AppColors.iconActiveColor : AppColors.iconColor,
                    width: iconSize,
                  ),
                if (text != null && assetSvgPath != null) const SizedBox(width: 20),
                if (text != null) Text(text, maxLines: 1, overflow: TextOverflow.clip)
              ],
            ),
          ],
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
