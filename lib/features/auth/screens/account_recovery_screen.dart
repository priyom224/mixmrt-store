import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/auth/domain/models/account_recovery_model.dart';
import 'package:sixam_mart_store/features/auth/widgets/condition_check_box_widget.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/widgets/base_card_widget.dart';
import 'package:sixam_mart_store/features/business/widgets/package_card_widget.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/store_body_model.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/auth/widgets/custom_time_picker_widget.dart';
import 'package:sixam_mart_store/features/auth/widgets/pass_view_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/select_location_module_view_widget.dart';

class AccountRecoveryScreen extends StatefulWidget {
  const AccountRecoveryScreen({super.key});

  @override
  State<AccountRecoveryScreen> createState() => _AccountRecoveryScreenState();
}

class _AccountRecoveryScreenState extends State<AccountRecoveryScreen> with TickerProviderStateMixin {

  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _registrationNoController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _addressFocus = [];
  final FocusNode _taxIdFocus = FocusNode();
  final FocusNode _registrationNoFocus = FocusNode();
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  List<AccTranslations>? translations;

  final ScrollController _scrollController = ScrollController();
  String? _countryDialCode;
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs =[];

  GlobalKey<FormState>? _formKeyLogin;
  GlobalKey<FormState>? _formKeySecond;

  @override
  void initState() {
    super.initState();
    AuthController authController = Get.find<AuthController>();
    AccountRecoveryModel? accountRecoveryModel = authController.accountRecoveryModel;

    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    translations = accountRecoveryModel?.store?.translations;

    _splitPhone(accountRecoveryModel?.store?.phone);

    for(int index=0; index<_languageList.length; index++) {
      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _nameFocus.add(FocusNode());
      _addressFocus.add(FocusNode());

      for (var trans in translations!) {
        if(_languageList[index].key == trans.locale && trans.key == 'name') {
          _nameController[index] = TextEditingController(text: trans.value);
        }else if(_languageList[index].key == trans.locale && trans.key == 'address') {
          _addressController[index] = TextEditingController(text: trans.value);
        }
      }
    }

    if(accountRecoveryModel?.store?.logoFullUrl != null) {
      authController.clearLogoImage();
      authController.saveLogoImage(accountRecoveryModel!.store!.logoFullUrl!);
    }

    if(accountRecoveryModel?.store?.coverPhotoFullUrl != null) {
      authController.clearCoverImage();
      authController.saveCoverImage(accountRecoveryModel!.store!.coverPhotoFullUrl!);
    }

    if(accountRecoveryModel?.store?.taxDocumentFullUrl != null) {
      authController.clearTaxImage();
      authController.saveTaxImage(accountRecoveryModel!.store!.taxDocumentFullUrl!);
    }

    if(accountRecoveryModel?.store?.registrationDocumentFullUrl != null) {
      authController.clearRegistrationImage();
      authController.saveRegistrationImage(accountRecoveryModel!.store!.registrationDocumentFullUrl!);
    }

    _taxIdController.text = accountRecoveryModel?.store?.taxId ?? '';
    _registrationNoController.text = accountRecoveryModel?.store?.registerNo ?? '';
    _vatController.text = accountRecoveryModel?.store?.tax.toString() ?? '';
    _fNameController.text = accountRecoveryModel?.vendor?.fName ?? '';
    _lNameController.text = accountRecoveryModel?.vendor?.lName ?? '';
    _emailController.text = accountRecoveryModel?.vendor?.email ?? '';

    authController.storeStatusChange(0.1, isUpdate: false);
    Get.find<AddressController>().getZoneList().then((value) {
      authController.getPackageList(moduleId: accountRecoveryModel?.store?.moduleId, isUpdate: false);
      Get.find<AddressController>().setAccRecModuleIndex(accountRecoveryModel?.store?.moduleId);
      authController.setMinTime(getDeliveryData(accountRecoveryModel!.store!.deliveryTime!, 'min'));
      authController.setMaxTime(getDeliveryData(accountRecoveryModel.store!.deliveryTime!, 'max'));
      authController.setSelectedDurationInitData(getDeliveryData(accountRecoveryModel.store!.deliveryTime!, 'type'));
      authController.setBusinessIndex(accountRecoveryModel.store!.storeBusinessModel!);
      authController.setAccRecActiveSubscriptionIndex(accountRecoveryModel.store?.packageId);
      Get.find<AddressController>().setAccRecZoneIndex(accountRecoveryModel.store?.zoneId);
    });

    if(authController.showPassView){
      authController.showHidePass(isUpdate: false);
    }

    Get.find<AddressController>().setPreloadPickupZones(pickupZoneList: accountRecoveryModel?.store?.pickupZoneId);

    _formKeyLogin = GlobalKey<FormState>();
    _formKeySecond = GlobalKey<FormState>();
  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _phoneController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<AddressController>(builder: (addressController) {

        if(addressController.storeAddress != null && _languageList!.isNotEmpty){
          _addressController[0].text = addressController.storeAddress.toString();
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async{
            if(authController.storeStatus == 0.6 && firstTime){
              authController.storeStatusChange(0.1);
              firstTime = false;
            }else if(authController.storeStatus == 0.9){
              authController.storeStatusChange(0.6);
            }else {
              await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
            }
          },
          child: Scaffold(

            appBar: CustomAppBarWidget(title: 'vendor_registration'.tr, onTap: () async {
              if(authController.storeStatus == 0.6 && firstTime){
                authController.storeStatusChange(0.1);
                firstTime = false;
              }else if(authController.storeStatus == 0.9){
                authController.storeStatusChange(0.6);
              }else {
                await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
              }
            }),

            body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).colorScheme.error,
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('Reason :', style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge)),
                  Text(authController.accountRecoveryModel?.store?.reason ?? 'No reason provided',
                    style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                  ),

                ]),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    authController.storeStatus == 0.1 ? 'provide_vendor_information_to_proceed_next'.tr : authController.storeStatus == 0.6 ? 'provide_owner_information_to_confirm'.tr : 'you_are_one_step_away_choose_your_business_plan'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  LinearProgressIndicator(
                    backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                    value: authController.storeStatus,
                  ),

                ]),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                  child: Column(children: [

                    Visibility(
                      visible: authController.storeStatus == 0.1,
                      child: Form(
                        key: _formKeyLogin,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('vendor_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(children: [

                              SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TabBar(
                                    tabAlignment: TabAlignment.start,
                                    controller: _tabController,
                                    indicatorColor: Theme.of(context).primaryColor,
                                    indicatorWeight: 3,
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor: Theme.of(context).disabledColor,
                                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                    labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: _tabs,
                                    onTap: (int ? value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                child: Divider(height: 0),
                              ),

                              CustomTextFieldWidget(
                                hintText: 'write_vendor_name'.tr,
                                labelText: 'vendor_name'.tr,
                                controller: _nameController[_tabController!.index],
                                focusNode: _nameFocus[_tabController!.index],
                                nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                                inputType: TextInputType.name,
                                prefixImage: Images.shopIcon,
                                capitalization: TextCapitalization.words,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "vendor_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              Row(children: [

                                Expanded(flex: 4,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Row(children: [
                                      Text('vendor_logo'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                      Text(' (${'1:1'})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Align(alignment: Alignment.center, child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                            authController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                                          ) : Image.file(
                                            File(authController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                                          ) : SizedBox(
                                            width: 150, height: 120,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                              Icon(CupertinoIcons.photo_camera_solid, size: 30, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                child: Text(
                                                  'upload_vendor_logo'.tr,
                                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.center,
                                                ),
                                              ),

                                            ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0, right: 0, top: 0, left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickImageForReg(true, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible: authController.pickedLogo != null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 2, color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
                                  ]),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                Expanded(flex: 6,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Row(children: [
                                      Text('vendor_cover'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                      Text(' (${'3:1'})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                                            authController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                                          ) : Image.file(
                                            File(authController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                                          ) : SizedBox(
                                            width: context.width, height: 120,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                              Icon(CupertinoIcons.photo_camera_solid, size: 30, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),

                                              Text(
                                                'upload_vendor_cover'.tr,
                                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.center,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                child: Text(
                                                  'upload_jpg_png_gif_maximum_2_mb'.tr,
                                                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                            ]),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 0, right: 0, top: 0, left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickImageForReg(false, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible: authController.pickedCover != null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 3, color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white, size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),

                                  ]),
                                ),
                              ]),
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Text('location_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          addressController.zoneList != null ? SelectLocationAndModuleViewWidget(
                            fromView: true,  addressController: _addressController[0], addressFocus: _addressFocus[0],
                          ) : const Center(child: CircularProgressIndicator()),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text('vendor_preference'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(children: [

                              /* Row(
                            children: [
                              Expanded(
                                child: CustomTextFieldWidget(
                                  hintText: 'tax_id'.tr,
                                  labelText: 'tax_id'.tr,
                                  controller: _taxIdController,
                                  focusNode: _taxIdFocus,
                                  nextFocus: _registrationNoFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                ),
                              ),
                              Get.find<SplashController>().configModel?.storeAgreement == true ? const SizedBox(width: Dimensions.paddingSizeExtraLarge) : const SizedBox(),
                              Get.find<SplashController>().configModel?.storeAgreement == true ? Expanded(
                                child: CustomButtonWidget(
                                  buttonText: 'download_agreement'.tr,
                                  onPressed: () async {
                                    String? downloadFormUri = AppConstants.storeDownloadFormUri.toString();
                                    launchUrlString(downloadFormUri, mode: LaunchMode.externalApplication);
                                  },
                                ),
                              ) : const SizedBox(),
                            ],
                          ),*/

                              CustomTextFieldWidget(
                                hintText: AppConstants.baseUrl.contains('zm') ? 'tpin'.tr : 'tax_id'.tr,
                                labelText: AppConstants.baseUrl.contains('zm') ? 'tpin'.tr : 'tax_id'.tr,
                                controller: _taxIdController,
                                focusNode: _taxIdFocus,
                                nextFocus: _registrationNoFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              CustomTextFieldWidget(
                                hintText: 'registration_no'.tr,
                                labelText: 'registration_no'.tr,
                                controller: _registrationNoController,
                                focusNode: _registrationNoFocus,
                                nextFocus: _vatFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              Row(children: [
                                Expanded(flex: 10, child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      child: authController.pickedTax != null ? getFileWidget(authController.pickedTax!.path) : SizedBox(
                                        width: context.width, height: 120,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                          Icon(Icons.file_copy, size: 38, color: Theme.of(context).disabledColor),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                          Text(
                                            AppConstants.baseUrl.contains('zm') ? 'upload_tpin_document'.tr : 'upload_tax_document'.tr,
                                            style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => authController.pickTax(),
                                      child: DottedBorder(
                                        color: Theme.of(context).primaryColor,
                                        strokeWidth: 1,
                                        strokeCap: StrokeCap.butt,
                                        dashPattern: const [5, 5],
                                        padding: const EdgeInsets.all(0),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                        child: const SizedBox(),
                                      ),
                                    ),
                                  ),
                                ]),),
                              ],),  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              Row(children: [
                                Expanded(flex: 10, child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      child: authController.pickedRegistration != null ? getFileWidget(authController.pickedRegistration!.path) : SizedBox(
                                        width: context.width, height: 120,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                          Icon(Icons.file_copy, size: 38, color: Theme.of(context).disabledColor),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                          Text(
                                            'upload_registration_document'.tr,
                                            style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => authController.pickRegistration(),
                                      child: DottedBorder(
                                        color: Theme.of(context).primaryColor,
                                        strokeWidth: 1,
                                        strokeCap: StrokeCap.butt,
                                        dashPattern: const [5, 5],
                                        padding: const EdgeInsets.all(0),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                        child: const SizedBox(),
                                      ),
                                    ),
                                  ),
                                ]),),
                              ],),  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              CustomTextFieldWidget(
                                hintText: 'write_vat_tax_amount'.tr,
                                labelText: 'vat_tax'.tr,
                                controller: _vatController,
                                focusNode: _vatFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.number,
                                prefixImage: Images.vatTaxIcon,
                                isAmount: true,
                                suffixChild: CustomToolTip(
                                  message: 'please_provide_vat_tax_amount'.tr,
                                  preferredDirection: AxisDirection.down,
                                  iconColor: Theme.of(context).disabledColor,
                                ),
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "vendor_vat_tax_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              InkWell(
                                onTap: () {
                                  Get.dialog(const CustomTimePickerWidget());
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                      child: Row(children: [
                                        Expanded(child: Text(
                                          '${authController.storeMinTime} : ${authController.storeMaxTime} ${authController.storeTimeUnit}',
                                          style: robotoMedium,
                                        )),
                                        Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,)
                                      ]),
                                    ),

                                    Positioned(
                                      left: 10, top: -15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text('select_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),

                        ]),
                      ),
                    ),

                    Visibility(
                      visible: authController.storeStatus == 0.6,
                      child: Form(
                        key: _formKeySecond,
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                          Row(children: [
                            Text('owner_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            CustomToolTip(
                              message: 'this_info_will_need_for_vendor_app_and_panel_login'.tr,
                              preferredDirection: AxisDirection.down,
                              iconColor: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              CustomTextFieldWidget(
                                hintText: 'write_first_name'.tr,
                                controller: _fNameController,
                                focusNode: _fNameFocus,
                                nextFocus: _lNameFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                iconSize: 25,
                                required: true,
                                labelText: 'first_name'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'write_last_name'.tr,
                                controller: _lNameController,
                                focusNode: _lNameFocus,
                                nextFocus: _phoneFocus,
                                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                iconSize: 25,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                required: true,
                                labelText: 'last_name'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'enter_phone_number'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _emailFocus,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                    : Get.find<LocalizationController>().locale.countryCode,
                                required: true,
                                labelText: 'phone'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, null),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'write_email'.tr,
                                controller: _emailController,
                                focusNode: _emailFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                iconSize: 25,
                                required: true,
                                labelText: 'email'.tr,
                                validator: (value) => ValidateCheck.validateEmail(value),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              GetBuilder<AuthController>(builder: (authController) {
                                return Column(children: [
                                  CustomTextFieldWidget(
                                    hintText: '8+characters'.tr,
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    nextFocus: _confirmPasswordFocus,
                                    inputType: TextInputType.visiblePassword,
                                    prefixIcon: Icons.lock,
                                    iconSize: 25,
                                    isPassword: true,
                                    onChanged: (value){
                                      if(value != null && value.isNotEmpty){
                                        if(!authController.showPassView){
                                          authController.showHidePass();
                                        }
                                        authController.validPassCheck(value);
                                      }else{
                                        if(authController.showPassView){
                                          authController.showHidePass();
                                        }
                                      }
                                    },
                                    required: true,
                                    labelText: 'password'.tr,
                                    validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                                  ),
                                  authController.showPassView ? const PassViewWidget() : const SizedBox(),

                                ]);
                              }),

                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: '8+characters'.tr,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                inputType: TextInputType.visiblePassword,
                                inputAction: TextInputAction.done,
                                prefixIcon: Icons.lock,
                                iconSize: 25,
                                isPassword: true,
                                required: true,
                                labelText: 'confirm_password'.tr,
                                validator: (value) => ValidateCheck.validateConfirmPassword(value, _passwordController.text),
                              ),
                              // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ConditionCheckBoxWidget(authController: authController, isAgreement: true),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ConditionCheckBoxWidget(authController: authController),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ConditionCheckBoxWidget(authController: authController, isPrivacyPolicy: true),

                        ]),
                      ),
                    ),

                    Visibility(
                      visible: authController.storeStatus == 0.9,
                      child: Column(children: [

                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtremeLarge),
                          child: Center(child: Text('choose_your_business_plan'.tr, style: robotoBold)),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Row(children: [

                            Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
                              child: BaseCardWidget(authController: authController, title: 'commission_base'.tr,
                                index: 0, onTap: ()=> authController.setBusiness(0),
                              ),
                            ) : const SizedBox(),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0 ? Expanded(
                              child: BaseCardWidget(authController: authController, title: 'subscription_base'.tr,
                                index: 1, onTap: ()=> authController.setBusiness(1),
                              ),
                            ) : const SizedBox(),

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        authController.businessIndex == 0 ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Text(
                            "${'vendor_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                          ),
                        ) : Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            child: Text(
                              'run_vendor_by_purchasing_subscription_packages'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          SizedBox(
                            height: 440,
                            child: authController.packageModel != null ? authController.packageModel!.packages!.isNotEmpty ? Swiper(
                              itemCount: authController.packageModel!.packages!.length,
                              viewportFraction: 0.65,
                              itemBuilder: (context, index) {

                                Packages package = authController.packageModel!.packages![index];

                                bool isRentalModule = addressController.moduleList != null && addressController.selectedModuleIndex != -1 &&
                                    addressController.moduleList![addressController.selectedModuleIndex!].moduleType == 'rental';

                                return PackageCardWidget(
                                  currentIndex: authController.activeSubscriptionIndex == index ? index : null,
                                  package: package, isRental: isRentalModule,
                                );
                              },
                              onIndexChanged: (index) {
                                authController.selectSubscriptionCard(index);
                              },

                            ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('no_package_available'.tr, style: robotoMedium),
                                ]),
                            ) : const Center(child: CircularProgressIndicator()),
                          ),

                        ]),

                      ]),
                    ),

                  ]),
                ),
              ),

              !authController.isLoading ? Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                ),
                child: CustomButtonWidget(
                  buttonText: 'submit'.tr,
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  onPressed: (!authController.acceptTerms || !authController.isAgreement || !authController.isPrivacyPolicy) ? null : () async{
                    bool defaultNameNull = false;
                    bool defaultAddressNull = false;
                    for(int index=0; index<_languageList.length; index++) {
                      if(_languageList[index].key == 'en') {
                        if (_nameController[index].text.trim().isEmpty) {
                          defaultNameNull = true;
                        }
                        if(_addressController[index].text.trim().isEmpty){
                          defaultAddressNull = true;
                        }
                        break;
                      }
                    }
                    String taxId = _taxIdController.text.trim();
                    String regiNo = _registrationNoController.text.trim();
                    String vat = _vatController.text.trim();
                    String minTime = authController.storeMinTime;
                    String maxTime = authController.storeMaxTime;
                    String fName = _fNameController.text.trim();
                    String lName = _lNameController.text.trim();
                    String phone = _phoneController.text.trim();
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirmPassword = _confirmPasswordController.text.trim();
                    String phoneWithCountryCode = _countryDialCode! + phone;
                    bool valid = false;
                    bool isRentalModule = addressController.moduleList != null && addressController.selectedModuleIndex != -1 &&
                        addressController.moduleList![addressController.selectedModuleIndex!].moduleType == 'rental';

                    try {
                      double.parse(maxTime);
                      double.parse(minTime);
                      valid = true;
                    } on FormatException {
                      valid = false;
                    }

                    if(authController.storeStatus == 0.1 || authController.storeStatus == 0.6){
                      if(authController.storeStatus == 0.1){
                        if(_formKeyLogin!.currentState!.validate()){
                          if(defaultNameNull) {
                            showCustomSnackBar('enter_vendor_name'.tr);
                          }else if(authController.pickedLogo == null) {
                            showCustomSnackBar('select_vendor_logo'.tr);
                          }else if(authController.pickedCover == null) {
                            showCustomSnackBar('select_vendor_cover_photo'.tr);
                          }else if(addressController.selectedModuleIndex == -1) {
                            showCustomSnackBar('please_select_module_first'.tr);
                          }else if(isRentalModule && addressController.pickupZoneIdList.isEmpty) {
                            showCustomSnackBar('please_select_pickup_zone'.tr);
                          }else if(defaultAddressNull) {
                            showCustomSnackBar('enter_vendor_address'.tr);
                          }else if(addressController.selectedZoneIndex == -1) {
                            showCustomSnackBar('please_select_zone'.tr);
                          }else if(vat.isEmpty) {
                            showCustomSnackBar('enter_vat_amount'.tr);
                          }else if(minTime.isEmpty) {
                            showCustomSnackBar('enter_minimum_delivery_time'.tr);
                          }else if(maxTime.isEmpty) {
                            showCustomSnackBar('enter_maximum_delivery_time'.tr);
                          }else if(!valid) {
                            showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
                          }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                            showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                          }else if(addressController.restaurantLocation == null) {
                            showCustomSnackBar('set_vendor_location'.tr);
                          }else{
                            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            authController.storeStatusChange(0.6);
                            firstTime = true;
                          }
                        }
                      }else if(authController.storeStatus == 0.6){
                        if(_formKeySecond!.currentState!.validate()){
                          if(fName.isEmpty) {
                            showCustomSnackBar('enter_your_first_name'.tr);
                          }else if(lName.isEmpty) {
                            showCustomSnackBar('enter_your_last_name'.tr);
                          }else if(phone.isEmpty) {
                            showCustomSnackBar('enter_phone_number'.tr);
                          }else if(email.isEmpty) {
                            showCustomSnackBar('enter_email_address'.tr);
                          }else if(!GetUtils.isEmail(email)) {
                            showCustomSnackBar('enter_a_valid_email_address'.tr);
                          }else if(password.isEmpty) {
                            showCustomSnackBar('enter_password'.tr);
                          }else if(password.length < 6) {
                            showCustomSnackBar('password_should_be'.tr);
                          }else if(password != confirmPassword) {
                            showCustomSnackBar('confirm_password_does_not_matched'.tr);
                          }else {
                            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            authController.storeStatusChange(0.9);
                          }
                        }
                      }else{
                        authController.storeStatusChange(0.9);
                      }
                    }else{
                      List<Translation> translation = [];
                      for(int index=0; index<_languageList.length; index++) {
                        translation.add(Translation(
                          locale: _languageList[index].key, key: 'name',
                          value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim()
                              : _nameController[0].text.trim(),
                        ));
                        translation.add(Translation(
                          locale: _languageList[index].key, key: 'address',
                          value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim()
                              : _addressController[0].text.trim(),
                        ));
                      }

                      Map<String, String> data = {};

                      data.addAll(StoreBodyModel(
                        translation: jsonEncode(translation), tax: vat, minDeliveryTime: minTime,
                        maxDeliveryTime: maxTime, lat: addressController.restaurantLocation!.latitude.toString(), email: email,
                        lng: addressController.restaurantLocation!.longitude.toString(), fName: fName, lName: lName, phone: phoneWithCountryCode,
                        password: password, zoneId: addressController.zoneList![addressController.selectedZoneIndex!].id.toString(),
                        moduleId: addressController.moduleList![addressController.selectedModuleIndex!].id.toString(),
                        deliveryTimeType: authController.deliveryTimeTypeList[authController.deliveryTimeTypeIndex],
                        taxID: taxId, registerNo: regiNo,
                        businessPlan: authController.businessIndex == 0 ? 'commission' : 'subscription',
                        packageId: authController.packageModel!.packages != null && authController.packageModel!.packages!.isNotEmpty ? authController.packageModel!.packages![authController.activeSubscriptionIndex].id!.toString() : '',
                        pickUpZoneIds: addressController.pickupZoneIdList.map((e) => e.toString()).toList(),
                        isForResubmit: 1, storePreviousId: authController.accountRecoveryModel?.store?.id, vendorPreviousId: authController.accountRecoveryModel?.vendor?.id,
                      ).toJson());

                      authController.registerStore(data);
                    }

                  },
                ),
              ) : const Center(child: CircularProgressIndicator()),

            ]),
          ),
        );
      });
    });
  }

  dynamic getDeliveryData(String deliveryTime, String type) {
    RegExp regExp = RegExp(r'(\d+)-(\d+) (hours|days|minute)');
    RegExpMatch? match = regExp.firstMatch(deliveryTime);

    if (match != null) {
      switch (type) {
        case 'min':
          return match.group(1)!;
        case 'max':
          return match.group(2)!;
        case 'type':
          return match.group(3)!;
        default:
          throw ArgumentError('Invalid type requested');
      }
    } else {
      throw const FormatException('Invalid delivery time format');
    }
  }

  Future<void> _showBackPressedDialogue(String title) async {
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
    ), useSafeArea: false);
  }

  /// Returns a widget corresponding to the file type based on the file extension.
  Widget getFileWidget(String filePath) {
    String fileName = filePath.split('/').last; // Extracting file name
    String extension = fileName.split('.').last.toLowerCase(); // Extracting file extension
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(filePath), width: context.width, height: 120, fit: BoxFit.cover),
            Text(fileName), // Displaying file name
          ],
        );
      case 'pdf':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.picture_as_pdf, size: 120, color: Colors.red)), // PDF icon
            Text(fileName), // Displaying file name
          ],
        );
      case 'doc':
      case 'docx':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.description, size: 120, color: Colors.blue)), // Word document icon
            Text(fileName), // Displaying file name
          ],
        );
      case 'txt':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.text_snippet, size: 120, color: Colors.orange)), // Text file icon
            Text(fileName), // Displaying file name
          ],
        );
      case 'pptx':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.slideshow, size: 120, color: Colors.deepPurple)), // PowerPoint icon
            Text(fileName), // Displaying file name
          ],
        );
      case 'xlsx':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.table_chart, size: 120, color: Colors.green)), // Excel icon
            Text(fileName), // Displaying file name
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.file_copy, size: 120, color: Colors.grey)), // Default file icon
            Text(fileName), // Displaying file name
          ],
        );
    }
  }

}