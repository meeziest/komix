import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_scaffold.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/widgets/custom_card.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/widgets/custom_form_field.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';
import 'package:simple_manga_translation/presentation/widgets/multiplier.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with BaseView {
  late final MainScreenPresenter _presenter;

  @override
  void initState() {
    _presenter = MainScreenPresenter(MainScreenModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _presenter.initWithContext(context);
    super.didChangeDependencies();
  }

  Widget getCurrentSection() {
    switch (_presenter.model.currentSection) {
      case Sections.projects:
        return buildHomeSection(
            scrollController: _presenter.scrollController, onPressed: _presenter.addProject);
      case Sections.profile:
        return buildProfileSection(context);
      case Sections.settings:
        return buildSettingsSection(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainScreenModel>(
        initialData: _presenter.model,
        stream: _presenter.stream,
        builder: (context, snapshot) {
          bool isScreenWideEnough = MediaQuery.of(context).size.width >= 900;
          return BaseScaffold(
            topBarColor: AppColors.topBarBackgroundColor,
            backgroundColor: AppColors.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 5, right: 100, left: 100),
                      child: getCurrentSection()),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 270,
                    child: Material(
                        elevation: 8,
                        color: AppColors.backgroundColor,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 50,
                              left: 50,
                              child: GestureDetector(
                                onTap: () {
                                  _presenter.logOut();
                                },
                                child: MultiplierOnHover(
                                  child: SvgPicture.asset(
                                    'assets/icons/logout.svg',
                                    color: AppColors.iconColor,
                                    width: 35,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MultiplierOnHover(
                                    child: buildButton(
                                        assetSvgPath: 'assets/icons/users.svg',
                                        text: isScreenWideEnough ? 'profile' : '',
                                        active: _presenter.model.currentSection == Sections.profile,
                                        onPressed: () {
                                          _presenter.selectSection(Sections.profile);
                                        }),
                                    multiplier: 1.03,
                                  ),
                                  const SizedBox(height: 50),
                                  MultiplierOnHover(
                                    child: buildButton(
                                        assetSvgPath: 'assets/icons/project.svg',
                                        text: isScreenWideEnough ? 'projects' : '',
                                        active:
                                            _presenter.model.currentSection == Sections.projects,
                                        onPressed: () {
                                          _presenter.selectSection(Sections.projects);
                                        }),
                                    multiplier: 1.03,
                                  ),
                                  const SizedBox(height: 50),
                                  MultiplierOnHover(
                                    child: buildButton(
                                        assetSvgPath: 'assets/icons/setting.svg',
                                        text: isScreenWideEnough ? 'settings' : '',
                                        active: false,
                                        onPressed: () {
                                          _presenter.selectSection(Sections.settings);
                                        }),
                                    multiplier: 1.03,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  buildProfileSection(BuildContext context) {
    Widget avatarButton = buildButton(
        onPressed: () {},
        width: 200,
        height: 200,
        center: true,
        iconSize: 150,
        assetSvgPath: 'assets/icons/plus-rectangle.svg');
    bool isScreenWideEnough = MediaQuery.of(context).size.width >= 1000;
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 0,
            child: Row(
              children: [
                buildButton(
                  active: true,
                  width: 120,
                  height: 50,
                  assetSvgPath: 'assets/icons/assignment.svg',
                  text: 'Save',
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                buildButton(
                  active: false,
                  width: 120,
                  height: 50,
                  assetSvgPath: 'assets/icons/book-remove.svg',
                  text: 'Cancel',
                  onPressed: () {},
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isScreenWideEnough)
                    Padding(padding: const EdgeInsets.only(top: 100), child: avatarButton),
                  if (isScreenWideEnough && false)
                    const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                          'https://slovnet.ru/wp-content/uploads/2018/12/1-66.jpg',
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isScreenWideEnough) avatarButton,
                      if (isScreenWideEnough && false)
                        const CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                            'https://slovnet.ru/wp-content/uploads/2018/12/1-66.jpg',
                          ),
                        ),
                      CustomFormField(
                          widthMagnifier: 50,
                          text: 'Username',
                          svgIconAsset: 'assets/icons/mail.svg',
                          labelText: dataScope.dataCore.userData.userId,
                          textController: _presenter.usernameController),
                      CustomFormField(
                          widthMagnifier: 50,
                          text: 'Password',
                          svgIconAsset: 'assets/icons/whistle.svg',
                          labelText: 'hidden...',
                          textController: _presenter.usernameController),
                      CustomFormField(
                          widthMagnifier: 50,
                          text: 'First Name',
                          textController: _presenter.firstNameController),
                      CustomFormField(
                          widthMagnifier: 50,
                          text: 'Last Name',
                          textController: _presenter.lastNameController),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildHomeSection({required ScrollController scrollController, required Function onPressed}) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 150,
              collapsedHeight: 130,
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SvgPicture.asset(
                              'assets/icons/LOGO.svg',
                              width: 90,
                            ),
                          ),
                          const Text(
                            AppDictionary.appTitle,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MultiplierOnHover(
                            child: PopupMenuButton(
                                tooltip: 'projects directory',
                                offset: const Offset(-20, 20),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                color: AppColors.projectCardBackgroundColor,
                                child: SvgPicture.asset('assets/icons/folder.svg'),
                                enabled: true,
                                onSelected: (value) async {
                                  switch (value) {
                                    case 1:
                                      _presenter.openSaveDirectory();
                                      break;
                                    case 2:
                                      _presenter.selectSection(Sections.settings);
                                      break;
                                  }
                                },
                                itemBuilder: (context) {
                                  return const [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "projects directory",
                                        style: TextStyle(color: AppColors.textColor),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text(
                                        "change path",
                                        style: TextStyle(color: AppColors.textColor),
                                      ),
                                    )
                                  ];
                                }),
                          ),
                          const SizedBox(width: 30),
                          MultiplierOnHover(
                              child: SvgPicture.asset(
                            'assets/icons/more_vert.svg',
                          ))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30, left: 40),
                child: Text(
                  'Projects:',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textActiveColor,
                  ),
                ),
              ),
            )
          ];
        },
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: buildProjectsSection(scrollController: scrollController, onPressed: onPressed),
        ));
  }

  buildSettingsSection(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 0,
            child: Row(
              children: [
                buildButton(
                  active: true,
                  width: 120,
                  height: 50,
                  assetSvgPath: 'assets/icons/assignment.svg',
                  text: 'Save',
                  onPressed: () {
                    _presenter.onSettingsSave();
                  },
                ),
                const SizedBox(width: 20),
                buildButton(
                  active: false,
                  width: 120,
                  height: 50,
                  assetSvgPath: 'assets/icons/arrow-back-circle.svg',
                  text: 'Reset',
                  onPressed: () {
                    _presenter.onReset();
                  },
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomFormField(
                          widthMagnifier: 100,
                          customFunction: _presenter.pickSaveDirectory,
                          buttonSvgAsset: 'assets/icons/folder.svg',
                          isEditable: true,
                          text: 'Projects directory',
                          textController: _presenter.directoryTextController),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildProjectsSection({required ScrollController scrollController, required Function onPressed}) {
    final List<ProjectModel> projects =
        _presenter.model.projectModels.values.toList().reversed.toList();
    projects.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    return Theme(
      data: ThemeData(
          scrollbarTheme:
              ScrollbarThemeData(thumbColor: MaterialStateProperty.all(AppColors.iconColor))),
      child: Scrollbar(
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == 0) {
                      return buildButton(
                          assetSvgPath: 'assets/icons/plus-rectangle.svg',
                          center: true,
                          iconSize: MediaQuery.of(context).size.width * 1 / 9,
                          onPressed: () {
                            onPressed();
                          });
                    }
                    return MultiplierOnHover(
                      multiplier: 1.03,
                      child: GestureDetector(
                        onDoubleTap: () {
                          _presenter.openProjectWorkspace(projects[index - 1].code);
                        },
                        child: CustomCard(
                          iconOnClick: () {
                            _presenter.onProjectDelete(projects[index - 1].code);
                          },
                          extraIconAsset: 'assets/icons/book-remove.svg',
                          projectName: projects[index - 1].title,
                          creationDate: DateFormat('yyyy-MM-dd – kk:mm')
                              .format(projects[index - 1].creationDate)
                              .toString(),
                          progress: 10,
                        ),
                      ),
                    );
                  }, childCount: projects.length + 1),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 50,
                  )),
            ),
          ],
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
              if (text != null) const SizedBox(width: 20),
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
