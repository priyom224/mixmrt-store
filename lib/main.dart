import 'dart:async';
import 'dart:io';
import 'package:sixam_mart_store/features/home/widgets/trial_widget.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/notification_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/theme/dark_theme.dart';
import 'package:sixam_mart_store/theme/light_theme.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if(!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Detect and set base URL based on the country
  await AppConstants.setBaseUrlBasedOnCountry();

  Map<String, Map<String, String>> languages = await di.init();

  if(GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDwdLNqrd8Is1i_q8BQWxXVbJshwHzAdsg",
        authDomain: "secret-lambda-403915.firebaseapp.com",
        projectId: "secret-lambda-403915",
        storageBucket: "secret-lambda-403915.appspot.com",
        messagingSenderId: "215254213048",
        appId: "1:215254213048:web:57383bb9db3677c6556f4d",
        measurementId: "G-R8QTGD955W",
      ),
    );
  }else {
    await Firebase.initializeApp();
  }

  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(_) {}

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          theme: themeController.darkTheme ? dark : light,
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
          initialRoute: RouteHelper.getSplashRoute(body),
          getPages: RouteHelper.routes,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 500),
          builder: (BuildContext context, widget) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: Material(
              child: Stack(children: [
                widget!,

                GetBuilder<ProfileController>(builder: (profileController) {
                  bool canShow = profileController.profileModel != null && profileController.profileModel!.subscription != null
                      && profileController.profileModel!.subscription!.isTrial == 1 && profileController.profileModel!.subscription!.status == 1
                      && DateConverterHelper.differenceInDaysIgnoringTime(DateTime.parse(profileController.profileModel!.subscription!.expiryDate!), null) > 0;

                  return canShow && !profileController.trialWidgetNotShow ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: TrialWidget(subscription: profileController.profileModel!.subscription!),
                    ),
                  ) : const SizedBox();
                }),

              ]),
            ));
          },
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}