import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';
import 'package:simple_manga_translation/presentation/widgets/window_button.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackgroundImage;
  final Color backgroundColor;
  final Color topBarColor;
  final AppBar? appBar;
  final List<Widget>? desktopTitleBarWidget;
  final Widget? drawer;
  final GlobalKey? scaffoldKey;

  const BaseScaffold({
    Key? key,
    required this.child,
    this.showBackgroundImage = false,
    this.backgroundColor = Colors.white,
    this.topBarColor = Colors.white,
    this.appBar,
    this.desktopTitleBarWidget,
    this.drawer,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: topBarColor,
      child: Column(
        children: [
          Material(
            color: AppColors.topBarBackgroundColor,
            child: WindowBorder(
              color: AppColors.topBarBorderColor,
              child: WindowTitleBarBox(
                child: MoveWindow(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              AppDictionary.appTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.topBarTextColor,
                              ),
                            ),
                          ),
                          if (desktopTitleBarWidget != null)
                            Expanded(
                              child: Row(
                                children: desktopTitleBarWidget!,
                              ),
                            )
                          else
                            const Spacer(),
                          WindowsButtons(isMaximized: appWindow.isMaximized),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                key: scaffoldKey,
                appBar: appBar,
                endDrawer: drawer,
                backgroundColor: backgroundColor,
                body: Stack(
                  children: [
                    if (showBackgroundImage)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Container(),
                      ),
                    child
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WindowsButtons extends StatelessWidget {
  const WindowsButtons({Key? key, required this.isMaximized}) : super(key: key);
  final bool isMaximized;

  @override
  Widget build(BuildContext context) {
    final colors = CustomWindowButtonColors(
        mouseOver: AppColors.MONO_GAY,
        mouseDown: AppColors.MONO_KARKA,
        iconMouseOver: AppColors.MONO_WHITE,
        iconNormal: AppColors.topBarTextColor);

    final _defaultCloseButtonColors = CustomWindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: AppColors.topBarTextColor,
        iconMouseOver: Colors.white);

    return Row(
      children: [
        CustomMinimizeWindowButton(
          colors: colors,
        ),
        isMaximized
            ? CustomRestoreWindowButton(
                colors: colors,
                onPressed: () {
                  appWindow.restore();
                },
              )
            : CustomMaximizeWindowButton(
                colors: colors,
                onPressed: () {
                  appWindow.maximize();
                },
              ),
        CustomCloseWindowButton(
          colors: _defaultCloseButtonColors,
          onPressed: () {
            appWindow.close();
          },
        ),
      ],
    );
  }
}
