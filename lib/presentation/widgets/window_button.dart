import 'dart:io' show Platform;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

typedef WindowButtonIconBuilder = Widget Function(WindowButtonContext buttonContext);
typedef WindowButtonBuilder = Widget Function(WindowButtonContext buttonContext, Widget icon);

class WindowButtonContext {
  BuildContext context;
  MouseState mouseState;
  Color? backgroundColor;
  Color iconColor;

  WindowButtonContext(
      {required this.context,
      required this.mouseState,
      this.backgroundColor,
      required this.iconColor});
}

class CustomWindowButtonColors {
  late Color normal;
  late Color mouseOver;
  late Color mouseDown;
  late Color iconNormal;
  late Color iconMouseOver;
  late Color iconMouseDown;

  CustomWindowButtonColors(
      {Color? normal,
      Color? mouseOver,
      Color? mouseDown,
      Color? iconNormal,
      Color? iconMouseOver,
      Color? iconMouseDown}) {
    this.normal = normal ?? _defaultButtonColors.normal;
    this.mouseOver = mouseOver ?? _defaultButtonColors.mouseOver;
    this.mouseDown = mouseDown ?? _defaultButtonColors.mouseDown;
    this.iconNormal = iconNormal ?? _defaultButtonColors.iconNormal;
    this.iconMouseOver = iconMouseOver ?? _defaultButtonColors.iconMouseOver;
    this.iconMouseDown = iconMouseDown ?? _defaultButtonColors.iconMouseDown;
  }
}

final _defaultButtonColors = CustomWindowButtonColors(
    normal: Colors.transparent,
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFF404040),
    mouseDown: const Color(0xFF202020),
    iconMouseOver: const Color(0xFFFFFFFF),
    iconMouseDown: const Color(0xFFF0F0F0));

class WindowButton extends StatelessWidget {
  final WindowButtonBuilder? builder;
  final WindowButtonIconBuilder? iconBuilder;
  late final CustomWindowButtonColors colors;
  final bool animate;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  WindowButton(
      {Key? key,
      CustomWindowButtonColors? colors,
      this.builder,
      @required this.iconBuilder,
      this.padding,
      this.onPressed,
      this.animate = false})
      : super(key: key) {
    this.colors = colors ?? _defaultButtonColors;
  }

  Color getBackgroundColor(MouseState mouseState) {
    if (mouseState.isMouseDown) return colors.mouseDown;
    if (mouseState.isMouseOver) return colors.mouseOver;
    return colors.normal;
  }

  Color getIconColor(MouseState mouseState) {
    if (mouseState.isMouseDown) return colors.iconMouseDown;
    if (mouseState.isMouseOver) return colors.iconMouseOver;
    return colors.iconNormal;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container();
    } else {
      // Don't show button on macOS
      if (Platform.isMacOS) {
        return Container();
      }
    }
    final buttonSize = appWindow.titleBarButtonSize;
    return MouseStateBuilder(
      builder: (context, mouseState) {
        WindowButtonContext buttonContext = WindowButtonContext(
            mouseState: mouseState,
            context: context,
            backgroundColor: getBackgroundColor(mouseState),
            iconColor: getIconColor(mouseState));

        var icon = (iconBuilder != null) ? iconBuilder!(buttonContext) : Container();
        double borderSize = appWindow.borderSize;
        double defaultPadding = (appWindow.titleBarHeight - borderSize) / 3 - (borderSize / 2);
        // Used when buttonContext.backgroundColor is null, allowing the AnimatedContainer to fade-out smoothly.
        var fadeOutColor = getBackgroundColor(MouseState()..isMouseOver = true).withOpacity(0);
        var padding = this.padding ?? EdgeInsets.all(defaultPadding);
        var animationMs = mouseState.isMouseOver ? (animate ? 100 : 0) : (animate ? 200 : 0);
        Widget iconWithPadding = Padding(padding: padding, child: icon);
        iconWithPadding = AnimatedContainer(
            curve: Curves.easeOut,
            duration: Duration(milliseconds: animationMs),
            color: buttonContext.backgroundColor ?? fadeOutColor,
            child: iconWithPadding);
        var button = (builder != null) ? builder!(buttonContext, icon) : iconWithPadding;
        return SizedBox(width: buttonSize.width, height: buttonSize.height, child: button);
      },
      onPressed: () {
        if (onPressed != null) onPressed!();
      },
    );
  }
}

class CustomMinimizeWindowButton extends WindowButton {
  CustomMinimizeWindowButton(
      {Key? key, CustomWindowButtonColors? colors, VoidCallback? onPressed, bool? animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) => MinimizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.minimize());
}

class CustomMaximizeWindowButton extends WindowButton {
  CustomMaximizeWindowButton(
      {Key? key, CustomWindowButtonColors? colors, VoidCallback? onPressed, bool? animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) => MaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximize());
}

class CustomRestoreWindowButton extends WindowButton {
  CustomRestoreWindowButton(
      {Key? key, CustomWindowButtonColors? colors, VoidCallback? onPressed, bool? animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) => RestoreIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.restore());
}

final _defaultCloseButtonColors = CustomWindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: const Color(0xFFFFFFFF));

class CustomCloseWindowButton extends WindowButton {
  CustomCloseWindowButton(
      {Key? key, CustomWindowButtonColors? colors, VoidCallback? onPressed, bool? animate})
      : super(
            key: key,
            colors: colors ?? _defaultCloseButtonColors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) => CloseIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.close());
}

///MOUSE STATE

typedef MouseStateBuilderCB = Widget Function(BuildContext context, MouseState mouseState);

class MouseState {
  bool isMouseOver = false;
  bool isMouseDown = false;

  MouseState();

  @override
  String toString() {
    return 'isMouseDown: $isMouseDown - isMouseOver: $isMouseOver';
  }
}

class MouseStateBuilder extends StatefulWidget {
  final MouseStateBuilderCB builder;
  final VoidCallback? onPressed;

  const MouseStateBuilder({Key? key, required this.builder, this.onPressed}) : super(key: key);

  @override
  _MouseStateBuilderState createState() => _MouseStateBuilderState();
}

class _MouseStateBuilderState extends State<MouseStateBuilder> {
  late MouseState _mouseState;

  _MouseStateBuilderState() {
    _mouseState = MouseState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            _mouseState.isMouseOver = true;
          });
        },
        onExit: (event) {
          setState(() {
            _mouseState.isMouseOver = false;
          });
        },
        child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                _mouseState.isMouseDown = true;
              });
            },
            onTapCancel: () {
              setState(() {
                _mouseState.isMouseDown = false;
              });
            },
            onTap: () {
              setState(() {
                _mouseState.isMouseDown = false;
                _mouseState.isMouseOver = false;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              });
            },
            onTapUp: (_) {},
            child: widget.builder(context, _mouseState)));
  }
}
