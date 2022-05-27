import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

class CustomFormField extends StatefulWidget {
  final double widthMagnifier;
  final double maxHeight;
  final TextEditingController textController;
  final bool isWithButton;
  final bool isEditable;
  final String labelText;
  final String text;
  final String hintText;
  final String? svgIconAsset;
  final bool disableAutoFocus;
  final Function? customFunction;
  final String? buttonSvgAsset;
  final bool obscureText;

  const CustomFormField(
      {Key? key,
      this.widthMagnifier = 250,
      this.maxHeight = 100,
      this.disableAutoFocus = false,
      required this.textController,
      this.obscureText = false,
      this.buttonSvgAsset,
      this.svgIconAsset,
      this.text = '',
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
  late bool _edit;

  @override
  void didChangeDependencies() {
    _edit = widget.isEditable;
    if (_edit || widget.disableAutoFocus == true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!widget.disableAutoFocus) {
          _focusNode.requestFocus();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 1 / 5;
    return Column(
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
                obscureText: widget.obscureText,
                controller: widget.textController,
                readOnly: !_edit,
                enabled: _edit || widget.customFunction != null,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  prefixIcon: widget.svgIconAsset != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            widget.svgIconAsset!,
                            color: AppColors.iconColor,
                            width: 20,
                          ),
                        )
                      : null,
                  prefixIconColor: AppColors.iconColor,
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
                    assetSvgPath: widget.buttonSvgAsset ?? 'assets/icons/pencil.svg',
                    onPressed: () async {
                      if (widget.customFunction != null) {
                        String? newPath = await widget.customFunction!();
                        if (newPath != null) {
                          setState(() {
                            widget.textController.text = newPath;
                          });
                        }
                      } else {
                        setState(() {
                          _edit = !_edit;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          if (_edit) {
                            _focusNode.requestFocus();
                          } else {
                            widget.textController.clear();
                          }
                        });
                      }
                    },
                    center: true),
              )
          ],
        ),
      ],
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
