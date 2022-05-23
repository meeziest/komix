import 'package:flutter/material.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/widgets/custom_form_field.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

import '../widgets/custom_progress_indicator.dart';

class Popups {
  static Future<PopupsResult?> showPopup({
    required BuildContext context,
    String? description,
    String? title,
    String? buttonText,
    String? cancelButtonText,
    Color? buttonColor,
    Color? textColor,
    String? secondButtonText,
    bool isLoading = false,
  }) =>
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    if (title != null)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.textColor,
                        ),
                      ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          description,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    CustomFormField(
                        widthMagnifier: 35,
                        text: 'Project title',
                        isWithButton: false,
                        isEditable: true),
                    CustomFormField(
                        widthMagnifier: 35,
                        text: 'Project description',
                        isWithButton: false,
                        isEditable: true),
                    CustomFormField(
                        widthMagnifier: 35,
                        text: 'Project path',
                        isWithButton: false,
                        isEditable: true),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: isLoading
                          ? const CustomProgressIndicator(
                              color: AppColors.ACCENT_BLUKA,
                              height: 50,
                              width: 50,
                            )
                          : _buildButtonForPopups(
                              textForButton: buttonText,
                              context: context,
                              textColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                              buttonColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                              isColorFilled: true,
                              onPressed: () => pop(context, PopupsResult.ok),
                            ),
                    ),
                    if (secondButtonText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _buildButtonForPopups(
                          textForButton: secondButtonText,
                          context: context,
                          buttonColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                          isColorFilled: false,
                          onPressed: () => pop(context, PopupsResult.second),
                          textColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                        ),
                      ),
                    if (cancelButtonText != null)
                      _buildCancelButton(
                        context: context,
                        textForCancel: cancelButtonText,
                      )
                    else
                      const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  static void pop(BuildContext context, PopupsResult result) => Navigator.of(context).pop(result);

  static Widget _buildButtonForPopups({
    required VoidCallback onPressed,
    required String? textForButton,
    required BuildContext context,
    required Color buttonColor,
    required Color textColor,
    required bool isColorFilled,
  }) =>
      SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: onPressed,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 3.0, color: buttonColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: textForButton == null
                ? null
                : Text(
                    textForButton,
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: isColorFilled ? AppColors.MONO_WHITE : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          color: isColorFilled ? buttonColor : Colors.transparent,
        ),
      );

  static Widget _buildCancelButton({
    required String textForCancel,
    required BuildContext context,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 38, top: 10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 53, minWidth: double.infinity),
          child: OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              overlayColor: MaterialStateProperty.all(AppColors.ADDONS_AGTUNG.withOpacity(0.2)),
              side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: AppColors.ADDONS_AGTUNG.withOpacity(0.2))),
            ),
            onPressed: () => pop(context, PopupsResult.cancel),
            child: Text(
              textForCancel,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.ADDONS_AGTUNG,
              ),
            ),
          ),
        ),
      );
}

enum PopupsResult {
  ok,
  cancel,
  second,
}
