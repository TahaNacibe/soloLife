import 'package:SoloLife/app/core/values/dark_theme.dart';
import 'package:SoloLife/app/core/values/light_theme.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/settings/welcome_page.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/voiseServices.dart';
import 'package:SoloLife/app/modules/detail/manager.dart';
import 'package:SoloLife/app/modules/detail/view_dream.dart';
import 'package:SoloLife/app/modules/detail/view_solo.dart';
import 'package:SoloLife/app/modules/detail/viewtask.dart';
import 'package:SoloLife/app/modules/detail/voltageView.dart';
import 'package:SoloLife/app/modules/home/loading_Screen.dart';
import 'package:SoloLife/app/modules/report/invintory.dart';
import 'package:SoloLife/app/modules/report/shop.dart';
import 'package:SoloLife/app/modules/report/viewAchievements.dart';
import 'package:SoloLife/app/settings/password.dart';
import 'package:SoloLife/app/settings/profile_edit.dart';
import 'package:SoloLife/app/settings/settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:SoloLife/app/data/services/storage/services.dart';
import 'package:SoloLife/app/modules/home/binding.dart';
import 'package:SoloLife/app/modules/home/view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  AwesomeNotifications().initialize(
      // set the icon to null to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  // the authorization for the notification
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  // Initialize Alarm Manager
  await AndroidAlarmManager.initialize();
  // initialize the ads 
  await MobileAds.instance.initialize();
  Get.put<DailyTasks>(DailyTasks());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  build(BuildContext context) {
    Profile user = ProfileProvider().readProfile();
    bool them = ThemeProvider().loadTheme();
    return GetMaterialApp(
      // theme for the app
      theme: them ? darkTheme : lightTheme,
      // routes map
      routes: {
        "commandPage": (context) => const CommandPage(),
        "soloDetails": (context) => SoloDetail(),
        "HomePage": (context) => HomePage(),
        "manager": (context) => const BudgetManager(),
        "achievements": (context) => const AchievementsPage(),
        "volt": (context) => const VoltageView(),
        "Shop": (context) => const Shop(),
        "Inventory": (context) => const Inventory(),
        "ProfileInformation": (context) => ProfileInformation(),
        "Settings": (context) => const Settings(),
        "DetailPage": (context) => DetailPage(),
        "DreamPage": (context) => DreamPage(),
        "WelcomePage": (context) => WelcomePage(),
        "Password": (context) => const Password()
      },
      title: 'SLife',
      debugShowCheckedModeBanner: false,
      home: user.haveMessage ? WelcomePage() : LoadingPage(),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
