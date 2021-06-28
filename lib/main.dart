import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myclock/common/channel/native_method_channel.dart';
import 'package:myclock/common/constant/app_colors.dart';
import 'package:myclock/config/app_config.dart';
import 'package:myclock/ui/page/app_about_page.dart';
import 'package:myclock/ui/page/brightness_settings.dart';
import 'package:myclock/ui/page/countdown_page.dart';
import 'package:myclock/ui/page/countdown_settings.dart';
import 'package:myclock/ui/page/language_settings.dart';
import 'package:myclock/ui/page/pomodoro_page.dart';
import 'package:myclock/ui/page/pomodoro_settings.dart';
import 'package:myclock/ui/page/timer_page.dart';
import 'package:myclock/ui/page/timer_settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'common/utils/config_storage.dart';
import 'generated/l10n.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.AppName,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.PRIMARY_MAIN_COLOR,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MyRootPage(),
        '/pomodoro_settings': (BuildContext context) => PomodoroSettingsPage(),
        '/timer_settings': (BuildContext context) => TimerSettingsPage(),
        '/countdown_settings': (BuildContext context) =>
            CountdownSettingsPage(),
        '/app_about': (BuildContext context) => AppAbout(),
        '/brightness_settings': (BuildContext context) => BrightnessSettings(),
        '/language_settings': (BuildContext context) => LanguageSettings(),
      },
    );
  }
}

class MyRootPage extends StatefulWidget {
  @override
  _MyRootPageState createState() => _MyRootPageState();
}

class _MyRootPageState extends State<MyRootPage> {
  int _currentIndex = 0;
  final List item_colors = [
    AppColors.PRIMARY_MAIN_COLOR,
    AppColors.TIMER_MAIN_COLOR,
    AppColors.COUNTDOWN_MAIN_COLOR,
    AppColors.ME_MAIN_COLOR
  ];

  @override
  void initState() {
    super.initState();
    //push
    _initLanguageSettings();
    _configureLocalTimeZone();
    NativeChannel.idleTimerDisabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PomodoroPage(),
          TimerPage(),
          CountdownPagee(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: item_colors[_currentIndex],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_on),
            activeIcon: Icon(Icons.alarm),
            label: S.of(context).pomodoro,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            activeIcon: Icon(Icons.timelapse),
            label: S.of(context).countdown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            activeIcon: Icon(Icons.date_range),
            label: S.of(context).tasks,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.account_circle_outlined),
          //   activeIcon: Icon(Icons.account_circle),
          //   label: S.of(context).about_me,
          // ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _initLanguageSettings() {
    AppStorage.getString(AppStorage.K_STRING_LANGUAGE_SETTINGS).then((value) {
      if(value != null) {
        setState(() {
          if (value == "zh") S.load(Locale('zh', ''));
          if (value == "en") S.load(Locale('en', 'US'));
        });
      }
    });
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // showDialog(
    //   context: context,
    //   builder: (_) => new AlertDialog(
    //     title: new Text('Notification'),
    //     content: new Text('$payload'),
    //   ),
    // );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await NativeChannel.timeZone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}
