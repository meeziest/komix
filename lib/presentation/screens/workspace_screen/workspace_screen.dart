import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_scaffold.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_presenter.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';
import 'package:simple_manga_translation/presentation/widgets/custom_progress_indicator.dart';
import 'package:simple_manga_translation/presentation/widgets/custom_reordable_list.dart';
import 'package:simple_manga_translation/presentation/widgets/multiplier.dart';

class WorkSpaceScreen extends StatefulWidget {
  const WorkSpaceScreen({Key? key, required this.projectCode, this.model}) : super(key: key);

  final WorkSpaceViewModel? model;
  final String projectCode;

  @override
  State<WorkSpaceScreen> createState() => _WorkSpaceScreenState();
}

class _WorkSpaceScreenState extends State<WorkSpaceScreen> with BaseView {
  late WorkSpacePresenter _presenter;

  int firstBlock = 30;
  int secondBlock = 100;
  int thirdBlock = 40;

  Positioned? menuWidget;

  @override
  void initState() {
    if (widget.model != null) {
      _presenter = WorkSpacePresenter(widget.model!);
    } else {
      _presenter = WorkSpacePresenter(WorkSpaceViewModel(projectCode: widget.projectCode));
      _presenter.initPages();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _presenter.initWithContext(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: _presenter.model,
        stream: _presenter.stream,
        builder: (context, snapshot) {
          return BaseScaffold(
              topBarColor: AppColors.topBarBackgroundColor,
              backgroundColor: AppColors.backgroundColor,
              positionedWidget: menuWidget,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    menuWidget = null;
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.projectCardBackgroundColor,
                            border: Border(
                              bottom: BorderSide(color: AppColors.topBarBorderColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: AppColors.backgroundColor),
                                  onPressed: () {
                                    Navigator.pop(context, _presenter.model);
                                  },
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(color: AppColors.textColor),
                                  )),
                              buildNormalPopupMenu(menuMap: {
                                'save current': () {
                                  _presenter.download();
                                },
                                'save current as': () {},
                                'save all': () {},
                                'save all as': () {},
                                'close': () {}
                              }, buttonText: 'file'),
                              buildNormalPopupMenu(menuMap: {
                                'undo': () {},
                                'redo': () {},
                                'copy': () {},
                                'zoom out': () {}
                              }, buttonText: 'edit'),
                              buildNormalPopupMenu(menuMap: {
                                'scan current': () {},
                                'scan all': () {},
                                'clean current': () {},
                                'clean all': () {},
                                'auto-translate': () {},
                                'auto-translate all': () {},
                                're-inject current': () {},
                                're-inject all': () {}
                              }, buttonText: 'actions'),
                              buildNormalPopupMenu(menuMap: {
                                firstBlock > 2 ? 'pages bar ✓' : 'pages bar': () {
                                  setState(() {
                                    if (firstBlock > 2) {
                                      firstBlock = 2;
                                    } else {
                                      firstBlock = 30;
                                    }
                                  });
                                },
                                thirdBlock > 2 ? 'bubbles bar ✓' : 'bubbles bar': () {
                                  setState(() {
                                    if (thirdBlock > 2) {
                                      thirdBlock = 2;
                                    } else {
                                      thirdBlock = 40;
                                    }
                                  });
                                },
                                secondBlock > 2 ? 'projects bar ✓' : 'projects bar': () {},
                              }, buttonText: 'window'),
                              buildNormalPopupMenu(
                                  menuMap: {'Komix team': () {}, 'app-version': () {}},
                                  buttonText: 'help'),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 30,
                        child: Row(
                          children: [
                            Expanded(
                                flex: firstBlock,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.topBarBorderColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          child: Theme(
                                        data: ThemeData(
                                          primaryColor: Colors.white,
                                          secondaryHeaderColor: Colors.white,
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                              scrollbarTheme: ScrollbarThemeData(
                                                  thumbColor: MaterialStateProperty.all(
                                                      AppColors.iconColor))),
                                          child: CustomReorderableListView.builder(
                                              header: const Center(child: Text('Pages')),
                                              scrollController: ScrollController(),
                                              padding: const EdgeInsets.all(8),
                                              itemBuilder: (context, index) {
                                                return buildPageListTile(index);
                                              },
                                              itemCount: _presenter.model.currentPages.length,
                                              onReorder: _presenter.onReorder),
                                        ),
                                      )),
                                      SizedBox(
                                          width: 17,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (firstBlock == 30) {
                                                  firstBlock = 2;
                                                } else {
                                                  firstBlock = 30;
                                                }
                                              });
                                            },
                                            child: HoverContainer(
                                              hoverColor: AppColors.backgroundColor,
                                              color: AppColors.backgroundColor.withOpacity(0.5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    firstBlock == 30
                                                        ? 'assets/icons/keyboard_double_arrow_left.svg'
                                                        : 'assets/icons/keyboard_double_arrow_right.svg',
                                                    color: AppColors.iconColor,
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: secondBlock,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        border: Border(
                                            bottom: BorderSide(
                                          width: 1,
                                          color: AppColors.topBarBorderColor,
                                        )),
                                      ),
                                      child: Row(
                                        children: [
                                          if (_presenter.model.currentPages.isNotEmpty)
                                            buildButton(
                                              onPressed: () {
                                                _presenter.toggleCurrentPages(PageType.Original);
                                              },
                                              active: true,
                                              onIconPressed: () {
                                                Popups.showPopup(
                                                    context: context,
                                                    buttonText: 'Save',
                                                    secondButtonText: 'Don\'t save',
                                                    cancelButtonText: 'Cancel');
                                              },
                                              center: true,
                                              assetSvgPath: 'assets/icons/multiply-circle.svg',
                                              text: _presenter.model.originalPages.isNotEmpty
                                                  ? _presenter
                                                      .model
                                                      .originalPages[_presenter.pageViewIndex]
                                                      .pageType
                                                      .string
                                                  : '',
                                            ),
                                          if (_presenter.model.cleanedPages.isNotEmpty)
                                            buildButton(
                                              onPressed: () {
                                                _presenter.toggleCurrentPages(PageType.Cleaned);
                                              },
                                              active: true,
                                              onIconPressed: () {
                                                Popups.showPopup(
                                                    context: context,
                                                    buttonText: 'Save',
                                                    secondButtonText: 'Don\'t save',
                                                    cancelButtonText: 'Cancel');
                                              },
                                              center: true,
                                              assetSvgPath: 'assets/icons/multiply-circle.svg',
                                              text: _presenter.model.cleanedPages.isNotEmpty
                                                  ? _presenter
                                                      .model
                                                      .cleanedPages[_presenter.pageViewIndex]
                                                      .pageType
                                                      .string
                                                  : widget.projectCode,
                                            ),
                                          if (_presenter.model.translatedPages.isNotEmpty)
                                            buildButton(
                                              onPressed: () {
                                                _presenter.toggleCurrentPages(PageType.Translated);
                                              },
                                              active: true,
                                              onIconPressed: () {
                                                Popups.showPopup(
                                                    context: context,
                                                    buttonText: 'Save',
                                                    secondButtonText: 'Don\'t save',
                                                    cancelButtonText: 'Cancel');
                                              },
                                              center: true,
                                              assetSvgPath: 'assets/icons/multiply-circle.svg',
                                              text: _presenter.model.cleanedPages.isNotEmpty
                                                  ? _presenter
                                                      .model
                                                      .translatedPages[_presenter.pageViewIndex]
                                                      .pageType
                                                      .string
                                                  : widget.projectCode,
                                            ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          if (_presenter.model.isLoading)
                                            const CustomProgressIndicator(
                                                color: AppColors.iconColor, height: 15, width: 15),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        color: AppColors.projectCardBackgroundColor,
                                        child: InteractiveViewer(
                                          child: _presenter.model.currentPages.isNotEmpty
                                              ? _presenter
                                                      .model
                                                      .currentPages[_presenter.pageViewIndex]
                                                      .filePath
                                                      .isNotEmpty
                                                  ? Image.file(File(_presenter
                                                      .model
                                                      .currentPages[_presenter.pageViewIndex]
                                                      .filePath))
                                                  : Image.network(_presenter
                                                      .model
                                                      .currentPages[_presenter.pageViewIndex]
                                                      .urlPath)
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: thirdBlock,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.topBarBorderColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 17,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (thirdBlock == 40) {
                                                  thirdBlock = 2;
                                                } else {
                                                  thirdBlock = 40;
                                                }
                                              });
                                            },
                                            child: HoverContainer(
                                              hoverColor: AppColors.backgroundColor,
                                              color: AppColors.backgroundColor.withOpacity(0.5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    thirdBlock == 40
                                                        ? 'assets/icons/keyboard_double_arrow_right.svg'
                                                        : 'assets/icons/keyboard_double_arrow_left.svg',
                                                    color: AppColors.iconColor,
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            if (_presenter.model.cleanedPages.isNotEmpty)
                                              Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: buildButton2(
                                                      onPressed: () {
                                                        _presenter.scanBubbles();
                                                      },
                                                      text: 'SCAN',
                                                      active: true,
                                                      isLoading: false,
                                                      center: true)),
                                            if (_presenter.model.cleanedPages.isEmpty)
                                              Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: buildButton2(
                                                      onPressed: () {
                                                        _presenter.getCleanedPages();
                                                      },
                                                      text: 'CLEAR',
                                                      active: true,
                                                      isLoading: false,
                                                      center: true)),
                                            if (_presenter.model.bubbleFields.isNotEmpty)
                                              Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: buildButton2(
                                                      onPressed: () {
                                                        _presenter.reInject();
                                                      },
                                                      text: 'RE-INJECT',
                                                      active: true,
                                                      isLoading: false,
                                                      center: true)),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Visibility(
                                                  visible: thirdBlock == 40,
                                                  child: _presenter.model.isLoading
                                                      ? const Center(
                                                          child: CustomProgressIndicator(
                                                              color: AppColors.iconColor,
                                                              height: 200,
                                                              width: 200),
                                                        )
                                                      : Theme(
                                                          data: ThemeData(
                                                              scrollbarTheme: ScrollbarThemeData(
                                                                  thumbColor:
                                                                      MaterialStateProperty.all(
                                                                          AppColors.iconColor))),
                                                          child: ListView.separated(
                                                            scrollDirection: Axis.vertical,
                                                            itemBuilder: (context, index) {
                                                              String key = _presenter
                                                                  .model.bubbleFields.keys
                                                                  .elementAt(index);
                                                              return Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 15),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(5),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              buildTextField(
                                                                                  enabled: false,
                                                                                  controller: _presenter
                                                                                      .model
                                                                                      .bubbleFields[
                                                                                          key]
                                                                                      ?.originalTextController),
                                                                              const Divider(),
                                                                              buildTextField(
                                                                                  controller: _presenter
                                                                                      .model
                                                                                      .bubbleFields[
                                                                                          key]
                                                                                      ?.translationTextController),
                                                                            ],
                                                                          ),
                                                                          Positioned(
                                                                            right: 0,
                                                                            top: 0,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                _presenter.model
                                                                                    .bubbleFields
                                                                                    .remove(key);
                                                                                _presenter
                                                                                    .updateView();
                                                                              },
                                                                              child:
                                                                                  MultiplierOnHover(
                                                                                multiplier: 1.09,
                                                                                child: SvgPicture
                                                                                    .asset(
                                                                                  'assets/icons/multiply-circle.svg',
                                                                                  color: AppColors
                                                                                      .topBarBackgroundColor,
                                                                                  width: 20,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            itemCount: _presenter
                                                                .model.bubbleFields.length,
                                                            separatorBuilder:
                                                                (BuildContext context, int index) {
                                                              return const Divider(
                                                                height: 40,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ))
                  ],
                ),
              ));
        });
  }

  buildPageListTile(int index) {
    return GestureDetector(
      key: ValueKey(index),
      onTap: () {
        _presenter.onPageTap(index);
      },
      child: MultiplierOnHover(
        multiplier: 1.03,
        child: Column(
          children: [
            Text(_presenter.model.currentPages[index].order.toString()),
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _presenter.model.currentPages[index].filePath.isNotEmpty
                    ? FileImage(File(_presenter.model.currentPages[index].filePath))
                    : NetworkImage(_presenter.model.currentPages[index].urlPath) as ImageProvider,
              )),
            ),
          ],
        ),
      ),
    );
  }

  buildNormalPopupMenu({required Map<String, Function> menuMap, required String buttonText}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.3, //                   <--- border width here
        ),
      ),
      child: PopupMenuButton(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 250),
        tooltip: 'show menu',
        offset: const Offset(0, 21),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        color: AppColors.topBarBackgroundColor,
        enabled: true,
        itemBuilder: (context) {
          List<PopupMenuItem> items = [];
          menuMap.forEach((key, value) {
            items.add(PopupMenuItem(
                height: 30,
                onTap: () {
                  value();
                },
                child: Text(
                  key,
                  style: const TextStyle(color: AppColors.textColor),
                )));
          });
          return items;
        },
        child: ElevatedButton(
            style: TextButton.styleFrom(backgroundColor: AppColors.projectCardBackgroundColor),
            onPressed: null,
            child: Text(
              buttonText,
              style: const TextStyle(color: AppColors.textColor),
            )),
      ),
    );
  }

  buildTextField({bool? enabled, TextEditingController? controller}) {
    // create the illusion of a beautifully scrolling text box
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.justWhite,
      ),
      padding: const EdgeInsets.all(7.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: 55.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          // here's the actual text box
          child: TextField(
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            enabled: enabled,
            //grow automatically
            focusNode: FocusNode(),
            controller: controller ?? TextEditingController(),
            decoration: const InputDecoration.collapsed(
              hintText: 'Please enter a lot of text',
            ),
          ),
          // ends the actual text box
        ),
      ),
    );
  }
}

buildButton(
    {String? assetSvgPath,
    String? text,
    required Function onPressed,
    double width = double.infinity,
    double height = double.infinity,
    Function? onIconPressed,
    FocusNode? focusNode,
    bool center = false,
    double iconSize = 35,
    bool active = false}) {
  return Container(
    constraints: BoxConstraints(maxHeight: height, maxWidth: width),
    width: width != double.infinity ? width : null,
    height: height != double.infinity ? height : null,
    decoration: BoxDecoration(
      color: AppColors.topBarBackgroundColor,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        MaterialButton(
          color: active ? AppColors.topBarBackgroundColor : null,
          hoverColor: AppColors.topBarBackgroundColor,
          focusNode: focusNode,
          textColor: AppColors.textColor,
          highlightColor: AppColors.topBarBackgroundColor,
          elevation: 0,
          splashColor: AppColors.backgroundColor,
          height: 60,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  if (text != null && !center) const SizedBox(width: 20),
                  if (text != null) Text(text, maxLines: 1, overflow: TextOverflow.clip),
                ],
              ),
            ],
          ),
          onPressed: () {
            onPressed();
          },
        ),
        if (assetSvgPath != null)
          GestureDetector(
            onTap: () {
              if (onIconPressed != null) {
                onIconPressed();
              }
            },
            child: MultiplierOnHover(
              multiplier: 1.05,
              child: SvgPicture.asset(
                assetSvgPath,
                color: AppColors.iconColor,
                width: iconSize,
              ),
            ),
          ),
      ],
    ),
  );
}

buildButton2(
    {String? assetSvgPath,
    String? text,
    required Function onPressed,
    double width = double.infinity,
    double height = double.infinity,
    bool center = false,
    bool isLoading = false,
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
      child: isLoading
          ? const Center(
              child: CustomProgressIndicator(
                width: 50,
                height: 50,
                color: AppColors.iconColor,
              ),
            )
          : Stack(
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
