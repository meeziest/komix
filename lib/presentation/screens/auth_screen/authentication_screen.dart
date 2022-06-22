import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_manga_translation/presentation/base_components/base_scaffold.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_presenter.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';
import 'package:simple_manga_translation/presentation/widgets/custom_progress_indicator.dart';
import 'package:simple_manga_translation/presentation/widgets/multiplier.dart';

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
            child: Stack(
              children: [
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: GestureDetector(
                        onLongPress: () => _presenter.onVersionMultipleClick(),
                        child:
                            const Text('v.0.0.1', style: TextStyle(color: AppColors.textColor)))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _presenter.model.isLoading
                              ? const CustomProgressIndicator(
                                  color: AppColors.iconColor, height: 100, width: 100)
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            _presenter.model.authSection == AuthSection.register
                                                ? 'Register'
                                                : 'Login',
                                            style: const TextStyle(
                                                color: AppColors.textColor, fontSize: 20),
                                          )),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TextField(
                                          focusNode: _presenter.usernameFocusNode,
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
                                              floatingLabelStyle:
                                                  TextStyle(color: Colors.deepOrange)),
                                        ),
                                      ),
                                      if (_presenter.model.authSection == AuthSection.login)
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                          child: TextField(
                                            focusNode: _presenter.passwordFocusNode,
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
                                                floatingLabelStyle:
                                                    TextStyle(color: Colors.deepOrange)),
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
                                        child: MultiplierOnHover(
                                          multiplier: 1.01,
                                          child: buildButton(
                                            onPressed: _presenter.auth,
                                            text: _presenter.model.authSection == AuthSection.login
                                                ? 'Login'
                                                : 'Register',
                                            center: true,
                                            active: true,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          if (_presenter.model.authSection == AuthSection.login)
                                            const Text(
                                              'Does not have account yet?',
                                              style: TextStyle(color: Colors.white60),
                                            ),
                                          TextButton(
                                            child: Text(
                                              _presenter.model.authSection == AuthSection.register
                                                  ? 'login'
                                                  : 'register',
                                              style: const TextStyle(
                                                  color: AppColors.iconActiveColor, fontSize: 20),
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
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }
}

buildButton(
    {String? assetSvgPath,
    String? text,
    required Function onPressed,
    double width = double.infinity,
    double height = double.infinity,
    FocusNode? focusNode,
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
      focusNode: focusNode,
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
              if (text != null && !center) const SizedBox(width: 20),
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
