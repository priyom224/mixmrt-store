import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/auth/domain/models/account_recovery_model.dart';
import 'package:sixam_mart_store/features/business/controllers/business_controller.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}){
    _notification = authServiceInterface.isNotificationActive();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _notification = true;
  bool get notification => _notification;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  final List<String?> _deliveryTimeTypeList = ['minute', 'hours', 'days'];
  List<String?> get deliveryTimeTypeList => _deliveryTimeTypeList;

  int _deliveryTimeTypeIndex = 0;
  int get deliveryTimeTypeIndex => _deliveryTimeTypeIndex;

  int _vendorTypeIndex = 0;
  int get vendorTypeIndex => _vendorTypeIndex;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  double _storeStatus = 0.4;
  double get storeStatus => _storeStatus;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  String? _subscriptionType;
  String? get subscriptionType => _subscriptionType;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  String? _expiredToken;
  String? get expiredToken => _expiredToken;

  XFile? _pickedTax;
  XFile? _pickedRegistration;
  XFile? _pickedAgreement;
  XFile? get pickedTax => _pickedTax;
  XFile? get pickedRegistration => _pickedRegistration;
  XFile? get pickedAgreement => _pickedAgreement;

  bool _acceptTerms = true;
  bool get acceptTerms => _acceptTerms;

  bool _isAgreement = true;
  bool get isAgreement => _isAgreement;

  bool _isPrivacyPolicy = true;
  bool get isPrivacyPolicy => _isPrivacyPolicy;

  bool _notificationLoading = false;
  bool get notificationLoading => _notificationLoading;

  AccountRecoveryModel? _accountRecoveryModel;
  AccountRecoveryModel? get accountRecoveryModel => _accountRecoveryModel;

  void setMinTime(String time) {
    _storeMinTime = time;
  }

  void setMaxTime(String time) {
    _storeMaxTime = time;
  }

  void setSelectedDurationInitData(String unit){
    _storeTimeUnit = unit;
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleAgreement() {
    _isAgreement = !_isAgreement;
    update();
  }

  void togglePrivacyPolicy() {
    _isPrivacyPolicy = !_isPrivacyPolicy;
    update();
  }

  Future<ResponseModel?> login(String? email, String password, String type) async {
    _isLoading = true;
    update();
    Response response = await authServiceInterface.login(email, password, type);
    if(response.statusCode == 420){
      _accountRecoveryModel = AccountRecoveryModel.fromJson(response.body);
    }
    ResponseModel? responseModel = await authServiceInterface.manageLogin(response, type);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForReg(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }


  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void changeVendorType(int index, {bool isUpdate = true}){
    _vendorTypeIndex = index;
    if(isUpdate) {
      update();
    }
  }

  Future<bool> clearSharedData() async {
    Get.find<SplashController>().setModule(null, null);
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String type) {
    authServiceInterface.saveUserNumberAndPassword(number, password, type);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }
  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }
  String getUserType() {
    return authServiceInterface.getUserType();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<bool> setNotificationActive(bool isActive) async {
    _notificationLoading = true;
    update();
    _notification = isActive;
    await authServiceInterface.setNotificationActive(isActive);
    _notificationLoading = false;
    update();
    return _notification;
  }


  Future<void> toggleStoreClosedStatus() async {
    bool isSuccess = await authServiceInterface.toggleStoreClosedStatus();
    if (isSuccess) {
      if(getModuleType() == 'rental'){
        await Get.find<TaxiProfileController>().getProfile();
      }else{
        Get.find<ProfileController>().getProfile();
      }
    }
    update();
  }

  Future<void> registerStore(Map<String, String> data) async {
    _isLoading = true;
    update();

    Response response = await authServiceInterface.registerRestaurant(data, _pickedLogo, _pickedCover, _pickedTax, _pickedRegistration);

    if(response.statusCode == 200){
      int? storeId = response.body['store_id'];
      int? packageId = response.body['package_id'];

      if(packageId == null) {
        Get.find<BusinessController>().submitBusinessPlan(storeId: storeId!, packageId: null);
      }else{
        Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(storeId: storeId, packageId: packageId));
      }
    }

    _isLoading = false;
    update();
  }

  void setDeliveryTimeTypeIndex(String? type, bool notify) {
    _deliveryTimeTypeIndex = _deliveryTimeTypeList.indexOf(type);
    if(notify) {
      update();
    }
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}){
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

  Future<bool> saveIsStoreRegistrationSharedPref(bool status) async {
    return await authServiceInterface.saveIsStoreRegistration(status);
  }

  bool getIsStoreRegistrationSharedPref() {
    return authServiceInterface.getIsStoreRegistration();
  }

  void pickTax() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles( type: FileType.custom, allowedExtensions: ['png','jpg','jpeg','pdf','doc','docx','gif','txt','pptx','xlsx']);
    if (result != null) {
      _pickedTax = XFile(result.files.single.path!);
    }
    update();
  }

  void pickRegistration() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles( type: FileType.custom, allowedExtensions: ['png','jpg','jpeg','pdf','doc','docx','gif','txt','pptx','xlsx']);
    if (result != null) {
      _pickedRegistration = XFile(result.files.single.path!);
    }
    update();
  }

  void pickAgreement() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles( type: FileType.custom, allowedExtensions: ['png','jpg','jpeg','pdf','doc','docx','gif','txt','pptx','xlsx']);
    if (result != null) {
      _pickedAgreement = XFile(result.files.single.path!);
    }
    update();
  }

  void initData() {
    _pickedTax = null;
    _pickedRegistration = null;
    _pickedAgreement = null;
  }

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  int _businessIndex = 0;
  int get businessIndex => _businessIndex;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  void changeFirstTimeStatus() {
    _isFirstTime = !_isFirstTime;
  }

  void resetBusiness(){
    _businessIndex = (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    _isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? 0 : 1;
  }

  Future<void> getPackageList({bool isUpdate = true, int? moduleId}) async {
    _packageModel = await authServiceInterface.getPackageList(moduleId: moduleId);
    if(isUpdate) {
      update();
    }
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }

  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  void setBusinessIndex(String businessType){
    businessType == 'commission' ? _businessIndex = 0 : _businessIndex = 1;
  }

  void setAccRecActiveSubscriptionIndex(int? id) {
    int index0 = 0;
    for(int index=0; index<_packageModel!.packages!.length; index++) {
      if(_packageModel!.packages?[index].id == id) {
        index0 = index;
        break;
      }
    }
    _activeSubscriptionIndex = index0;
  }

  String getModuleType() {
    return authServiceInterface.getModuleType();
  }

  void setModuleType(String type){
    authServiceInterface.setModuleType(type);
  }

  Future<XFile?> urlToXFile(String imageUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${imageUrl.split('/').last}';

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return XFile(filePath);
      } else {
        showCustomSnackBar('${'Failed to download file'.tr} ${response.statusCode}');
        return null;
      }
    } catch (e) {
      showCustomSnackBar('Error occurred while converting URL to XFile: $e');
      return null;
    }
  }

  void saveLogoImage(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _pickedLogo = xFile;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearLogoImage() {
    _pickedLogo = null;
  }

  void saveCoverImage(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _pickedCover = xFile;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearCoverImage() {
    _pickedCover = null;
  }

  void saveTaxImage(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _pickedTax = xFile;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearTaxImage() {
    _pickedTax = null;
  }

  void saveRegistrationImage(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _pickedRegistration = xFile;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearRegistrationImage() {
    _pickedRegistration = null;
  }

}