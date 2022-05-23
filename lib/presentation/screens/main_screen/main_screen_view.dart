import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainScreenModel>(
        initialData: _presenter.model,
        stream: _presenter.stream,
        builder: (context, snapshot) {
          return BaseScaffold(
            topBarColor: AppColors.topBarBackgroundColor,
            backgroundColor: AppColors.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70, bottom: 5, right: 100, left: 100),
                    child: _presenter.model.currentSection == Sections.profile
                        ? buildProfileSection(context)
                        : buildHomeSection(
                            scrollController: _presenter.scrollController,
                            onPressed: _presenter.addProject),
                  ),
                ),
                SizedBox(
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
                                      text: 'profile',
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
                                      text: 'projects',
                                      active: _presenter.model.currentSection == Sections.projects,
                                      onPressed: () {
                                        _presenter.selectSection(Sections.projects);
                                      }),
                                  multiplier: 1.03,
                                ),
                                const SizedBox(height: 50),
                                MultiplierOnHover(
                                  child: buildButton(
                                      assetSvgPath: 'assets/icons/setting.svg',
                                      text: 'settings',
                                      active: false,
                                      onPressed: () {}),
                                  multiplier: 1.03,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          );
        });
  }
}

buildHomeSection({required ScrollController scrollController, required Function onPressed}) {
  return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            collapsedHeight: 70,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Row(
                      children: [
                        MultiplierOnHover(
                            child: SvgPicture.asset(
                          'assets/icons/folder.svg',
                        )),
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
              padding: EdgeInsets.only(bottom: 30),
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
      body: buildProjectsSection(scrollController: scrollController, onPressed: onPressed));
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
                    CustomFormField(widthMagnifier: 50, text: 'username'),
                    CustomFormField(widthMagnifier: 50, text: 'First Name'),
                    CustomFormField(widthMagnifier: 50, text: 'Last Name'),
                    CustomFormField(widthMagnifier: 50, text: 'birth-date'),
                    CustomFormField(widthMagnifier: 50, text: 'password'),
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
                  return const MultiplierOnHover(
                    multiplier: 1.03,
                    child: CustomCard(
                      projectName: 'OnePunchMan',
                      creationDate: "01.05.2001",
                      progress: 10,
                    ),
                  );
                }, childCount: 10),
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
