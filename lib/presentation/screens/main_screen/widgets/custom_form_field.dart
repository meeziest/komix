import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

class CustomFormField extends StatefulWidget {
  final double widthMagnifier;
  final double maxHeight;
  final String text;
  final bool isWithButton;
  final bool isEditable;
  final String labelText;
  final String hintText;
  final Function? customFunction;

  const CustomFormField(
      {Key? key,
      this.widthMagnifier = 250,
      this.maxHeight = 100,
      required this.text,
      this.labelText = '',
      this.hintText = '',
      this.isEditable = false,
      this.customFunction,
      this.isWithButton = true})
      : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  late bool _edit;

  @override
  void didChangeDependencies() {
    _edit = widget.isEditable;
    if (_edit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _focusNode.requestFocus();
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 1 / 5;
    return GestureDetector(
      onTap: () {
        if (widget.customFunction != null) {
          widget.customFunction!();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: const TextStyle(color: AppColors.textActiveColor),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight,
                  maxWidth: maxWidth + widget.widthMagnifier,
                ),
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: textController,
                  readOnly: !_edit,
                  enabled: _edit,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: const TextStyle(color: AppColors.textColor),
                    hintStyle: const TextStyle(color: AppColors.textColor),
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.projectIconColor)),
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                  ),
                ),
              ),
              if (widget.isWithButton)
                SizedBox(
                  width: 55,
                  height: 55,
                  child: buildButton(
                      active: _edit,
                      assetSvgPath: 'assets/icons/pencil.svg',
                      onPressed: () {
                        setState(() {
                          _edit = !_edit;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          if (_edit) {
                            _focusNode.requestFocus();
                          } else {
                            textController.clear();
                          }
                        });
                      },
                      center: true),
                )
            ],
          ),
        ],
      ),
    );
  }

  buildButton(
      {required String assetSvgPath,
      String text = '',
      required Function onPressed,
      bool center = false,
      double iconSize = 25,
      bool active = false}) {
    return MaterialButton(
      color: active ? AppColors.topBarBackgroundColor : null,
      hoverColor: AppColors.topBarBackgroundColor,
      textColor: AppColors.textColor,
      highlightColor: AppColors.topBarBackgroundColor,
      elevation: 0,
      splashColor: AppColors.backgroundColor,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            assetSvgPath,
            color: active ? AppColors.iconActiveColor : AppColors.iconColor,
            width: iconSize,
          ),
          if (text.isNotEmpty) const SizedBox(width: 20),
          Text(text, maxLines: 1, overflow: TextOverflow.clip)
        ],
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
