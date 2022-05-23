import 'package:flutter/material.dart';

class MultiplierOnHover extends StatefulWidget {
  final double multiplier;
  final Widget child;
  const MultiplierOnHover({Key? key, required this.child, this.multiplier = 1.3}) : super(key: key);

  @override
  _MultiplierOnHoverState createState() => _MultiplierOnHoverState();
}

class _MultiplierOnHoverState extends State<MultiplierOnHover> {
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouseEnter(true),
      onExit: (e) => _mouseEnter(false),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 100),
        tween: Tween<double>(begin: 1.0, end: scale),
        builder: (BuildContext context, double value, _) {
          return Transform.scale(scale: value, child: widget.child);
        },
      ),
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      if (hover) {
        scale = scale * widget.multiplier;
      } else {
        scale = 1.0;
      }
    });
  }
}
