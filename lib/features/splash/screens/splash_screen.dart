import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({super.key, required this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    _checkAndSetBaseUrl().then((_) {
      bool firstTime = true;
      _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if(!firstTime) {
          bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
          isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
              isNotConnected ? 'no_connection' : 'connected',
              textAlign: TextAlign.center,
            ),
          ));
          if(!isNotConnected) {
            _route();
          }
        }
        firstTime = false;
      });

      Get.find<SplashController>().initSharedData();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }


  /// Check if the country is saved, otherwise detect or prompt for selection
  Future<void> _checkAndSetBaseUrl() async {
    String? savedCountryCode = await getSelectedCountry();
    if (savedCountryCode != null) {
      _setBaseUrl(savedCountryCode);
      _route();
    } else {
      String? detectedCountryCode = await _detectCountry();
      if (detectedCountryCode == null || !_isSupportedCountry(detectedCountryCode)) {
        _showCountrySelectionPopup();
      } else {
        _setBaseUrl(detectedCountryCode);
        await saveSelectedCountry(detectedCountryCode);
        _route();
      }
    }
  }

  /// Method to detect the country based on IP
  Future<String?> _detectCountry() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print('Country detected: ${data['countryCode']}');
        }
        return data['countryCode'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting country: $e');
      }
    }
    return null;
  }

  /// Check if the country is supported (Malawi, Tanzania, Zambia)
  bool _isSupportedCountry(String countryCode) {
    return ['MW', 'TZ', 'ZM'].contains(countryCode);
  }

  /// Set the base URL based on the detected or selected country
  void _setBaseUrl(String countryCode) {
    switch (countryCode) {
      case 'MW':
        AppConstants.setBaseUrl('https://mixmrt.com/mw');
        break;
      case 'TZ':
        AppConstants.setBaseUrl('https://mixmrt.com/tz');
        break;
      case 'ZM':
      default:
        AppConstants.setBaseUrl('https://mixmrt.com/zm');
    }

    Get.find<ApiClient>().updateBaseUrl(AppConstants.baseUrl);

    if (kDebugMode) {
      print('Base URL set to: ${AppConstants.baseUrl}');
    }
  }

  /// Show country selection popup if the detected country is not supported
  Future<void> _showCountrySelectionPopup() async {
    String selectedCountry = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'select_your_country'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              InkWell(
                onTap: () => Navigator.pop(context, 'ZM'),
                child: Icon(Icons.close, color: Theme.of(context).disabledColor),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildCountryTile(
                countryName: 'Malawi',
                dialCode: '+265',
                flagUrl: 'https://www.countryflags.com/wp-content/uploads/malawi-flag-png-large.png',
                countryCode: 'MW',
              ),
              const Divider(),

              _buildCountryTile(
                countryName: 'Tanzania',
                dialCode: '+255',
                flagUrl: 'https://www.countryflags.com/wp-content/uploads/tanzania-flag-png-large.png',
                countryCode: 'TZ',
              ),
              const Divider(),

              _buildCountryTile(
                countryName: 'Zambia',
                dialCode: '+260',
                flagUrl: 'https://www.countryflags.com/wp-content/uploads/zambia-flag-png-large.png',
                countryCode: 'ZM',
              ),
            ],
          ),
        );
      },
    ) ?? 'ZM'; // Default to Zambia if no selection is made

    _setBaseUrl(selectedCountry);
    await saveSelectedCountry(selectedCountry);
    _route();
  }

  Widget _buildCountryTile({required String countryName, required String dialCode, required String flagUrl, required String countryCode}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Rounded flag images
        child: CustomImageWidget(
          image: flagUrl,
          height: 30,
          width: 40,
        ),
      ),
      title: Row(
        children: [
          Text('$dialCode ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          Text(countryName, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => Navigator.pop(context, countryCode),
    );
  }

  /// Save selected country to SharedPreferences
  Future<void> saveSelectedCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', countryCode);
  }

  /// Get the saved country from SharedPreferences
  Future<String?> getSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_country');
  }


  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if(GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if(AppConstants.appVersion < minimumVersion! || Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.appVersion < minimumVersion));
          }else{
            if(widget.body != null){
              if (widget.body!.notificationType == NotificationTypeModel.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.body!.orderId, fromNotification: true));
              }else if(widget.body!.notificationType == NotificationTypeModel.general){
                Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
              } else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationId: widget.body!.conversationId, fromNotification: true));
              }
            }else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<ProfileController>().getProfile();
                Get.offNamed(RouteHelper.getInitialRoute());
              } else {
                /*if(AppConstants.languages.length > 1 && Get.find<SplashController>().showIntro()) {
                  Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                }else {
                  Get.offNamed(RouteHelper.getSignInRoute());
                }*/
                Get.offNamed(RouteHelper.getSignInRoute());
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(Images.logo, width: 200),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text('suffix_name'.tr, style: robotoMedium, textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}