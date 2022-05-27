import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_view.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/widgets/custom_form_field.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

import '../widgets/custom_progress_indicator.dart';

class Popups {
  static Future<dynamic> showPopup({
    required BuildContext context,
    String? description,
    String? title,
    String? buttonText,
    String? cancelButtonText,
    Color? buttonColor,
    bool canPopWithProjectData = false,
    Color? textColor,
    String? secondButtonText,
    bool isLoading = false,
  }) async {
    TextEditingController projectTitle = TextEditingController();
    TextEditingController projectDescription = TextEditingController();
    List<File> imageFiles = [];

    return await showDialog(
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
                  if (canPopWithProjectData)
                    Column(
                      children: [
                        CustomFormField(
                            widthMagnifier: 35,
                            text: 'Project title',
                            textController: projectTitle,
                            isWithButton: false,
                            disableAutoFocus: true,
                            isEditable: true),
                        CustomFormField(
                            widthMagnifier: 35,
                            textController: projectDescription,
                            text: 'Project description',
                            disableAutoFocus: true,
                            isWithButton: false,
                            isEditable: true),
                        const SizedBox(height: 10),
                        const Align(
                          child: Text(
                            'Pick images',
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        buildButton(
                            text: 'Pick files',
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['jpg', 'png', 'jpeg'],
                              );
                              if (result != null) {
                                List<File> files = result.paths.map((path) => File(path!)).toList();
                                imageFiles = files;
                              }
                            },
                            assetSvgPath: 'assets/icons/folder.svg'),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: isLoading
                        ? const CustomProgressIndicator(
                            color: AppColors.ACCENT_BLUKA,
                            height: 50,
                            width: 50,
                          )
                        : buttonText != null
                            ? _buildButtonForPopups(
                                textForButton: buttonText,
                                context: context,
                                textColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                                buttonColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                                isColorFilled: true,
                                onPressed: () {
                                  pop(context, PopupsResult.ok);
                                },
                              )
                            : const SizedBox(),
                  ),
                  if (secondButtonText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _buildButtonForPopups(
                        textForButton: secondButtonText,
                        context: context,
                        textColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                        buttonColor: buttonColor ?? AppColors.ACCENT_BLUKA,
                        isColorFilled: true,
                        onPressed: () {
                          if (canPopWithProjectData && imageFiles.isNotEmpty) {
                            popWithFile(
                                context,
                                ProjectModel(
                                  code: [
                                    DataScopeWidget.of(context).dataCore.userData.userId,
                                    projectTitle.text
                                  ].join('-'),
                                  title: projectTitle.text,
                                  description: projectDescription.text,
                                  pageFiles: imageFiles,
                                ));
                          } else if (projectTitle.text.isEmpty) {
                            pop(context, PopupsResult.noTitle);
                          } else {
                            pop(context, PopupsResult.emptyFiles);
                          }
                        },
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
  }

  static void pop(BuildContext context, PopupsResult result) => Navigator.of(context).pop(result);

  static void popWithFile(BuildContext context, ProjectModel result) =>
      Navigator.of(context).pop(result);

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
  emptyFiles,
  noTitle,
}
