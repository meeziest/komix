import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_view.dart';
import 'package:simple_manga_translation/presentation/utils/custom_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  doWhenWindowReady(() async {
    await DesktopWindow.setMinWindowSize(const Size(940, 670));
    appWindow.show();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DataScope? dataScope;

  @override
  Widget build(BuildContext context) {
    return DataScopeWidget(
      dataScope: dataScope,
      child: Builder(builder: (context) {
        dataScope = DataScopeWidget.of(context);
        return MaterialApp(
          title: 'Mizus app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: const TextTheme(
            bodyText1: TextStyle(
                color: AppColors.textColor, fontFamily: 'Ubuntu', fontWeight: FontWeight.w600),
            bodyText2: TextStyle(
                color: AppColors.textColor, fontFamily: 'Ubuntu', fontWeight: FontWeight.w600),
          )),
          // theme: ThemeData.dark(),
          home: InitialScreen(dataScope: dataScope),
        );
      }),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({
    Key? key,
    required this.dataScope,
  }) : super(key: key);

  final DataScope? dataScope;

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void didChangeDependencies() {
    dataScope.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>?>(
      stream: widget.dataScope!.initialScreenStream.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) return Container();
        List<UserData> users = snapshot.data;
        if (users.isEmpty) {
          return const AuthenticationScreen();
        } else {
          return const MainScreen();
        }
      },
    );
  }
}
