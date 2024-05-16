import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/core/values/light_theme.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/voiseServices.dart';
import 'package:SoloLife/app/modules/detail/manager.dart';
import 'package:SoloLife/app/modules/detail/view_solo.dart';
import 'package:SoloLife/app/modules/detail/voltageView.dart';
import 'package:SoloLife/app/modules/home/loading_Screen.dart';
import 'package:SoloLife/app/modules/report/invintory.dart';
import 'package:SoloLife/app/modules/report/shop.dart';
import 'package:SoloLife/app/modules/report/viewAchivments.dart';
import 'package:SoloLife/app/settings/password.dart';
import 'package:SoloLife/app/settings/profileImagePlus.dart';
import 'package:SoloLife/app/settings/profile_edit.dart';
import 'package:SoloLife/app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:SoloLife/app/data/services/storage/services.dart';
import 'package:SoloLife/app/modules/home/binding.dart';
import 'package:SoloLife/app/modules/home/view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';



void main() async {
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  Get.put<DailyTasks>(DailyTasks());
  runApp(ChangeNotifierProvider(
      create: (_) => ImageData(),child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
   build(BuildContext context) {
    bool them = ThemeProvider().loadTheme();
    return GetMaterialApp(
      theme:them? ThemeData.dark() : lightTheme,
       routes: {
        "commandPage" :(context) => const CommandPage(),
        "soloDetails" :(context) => SoloDetail(),
        "HomePage" :(context) =>  HomePage(),
        "manager" :(context) => const BudgetManager(),
        "achievements" :(context) => const AchievementsPage(),
        "volt": (context) => const VoltageView(),
        "Shop": (context) => const Shop(),
        "Inventory": (context) => const Inventory(),
        "ProfileInformation": (context) => ProfileInformation(),
        "Settings": (context) => const Settings(),
        "Password": (context) => const Password()
      },
      title: 'Todo list',
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
