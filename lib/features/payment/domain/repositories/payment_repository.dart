import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/payment/domain/models/wallet_payment_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/withdraw_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/offline_method_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository_interface.dart';

class PaymentRepository implements PaymentRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PaymentRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<bool> update(Map<String, dynamic> body) async {
    Response response = await apiClient.putData(AppConstants.updateBankInfoUri, body);
    return (response.statusCode == 200);
  }

  @override
  Future<List<WithdrawModel>?> getList() async {
    List<WithdrawModel>? withdrawList = [];
    Response response = await apiClient.getData(AppConstants.withdrawListUri);
    if (response.statusCode == 200) {
      response.body.forEach((withdraw) {
        WithdrawModel withdrawModel = WithdrawModel.fromJson(withdraw);
        withdrawList.add(withdrawModel);
      });
    }
    return withdrawList;
  }

  @override
  Future<bool> requestWithdraw(Map<String?, String> data) async {
    Response response = await apiClient.postData(AppConstants.withdrawRequestUri, data);
    return (response.statusCode == 200);
  }

  @override
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    List<WidthDrawMethodModel>? widthDrawMethods;
    Response response = await apiClient.getData(AppConstants.withdrawRequestMethodUri);
    if(response.statusCode == 200) {
      widthDrawMethods = [];
      response.body.forEach((method) {
        WidthDrawMethodModel withdrawMethod = WidthDrawMethodModel.fromJson(method);
        widthDrawMethods!.add(withdrawMethod);
      });
    }
    return widthDrawMethods;
  }

  @override
  Future<List<Transactions>?> getWalletPaymentList() async {
    List<Transactions>? transactions;
    Response response = await apiClient.getData(AppConstants.walletPaymentListUri);
    if(response.statusCode == 200) {
      transactions = [];
      WalletPaymentModel walletPaymentModel = WalletPaymentModel.fromJson(response.body);
      transactions.addAll(walletPaymentModel.transactions!);
    }
    return transactions;
  }

  @override
  Future<bool> makeWalletAdjustment() async {
    Response response = await apiClient.postData(AppConstants.makeWalletAdjustmentUri, {'token': Get.find<AuthController>().getUserToken()});
    return (response.statusCode == 200);
  }

  @override
  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.makeCollectedCashPaymentUri,
      {
        "amount": amount,
        "payment_gateway": paymentGatewayName,
        "callback": RouteHelper.success,
        "token": Get.find<AuthController>().getUserToken(),
      },
    );
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {
        // html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(null, redirectUrl, null, false));
      }
      responseModel = ResponseModel(true, response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<OfflineMethodModel>?> getOfflineMethodList() async{
    Response response = await apiClient.getData(AppConstants.offlineMethodListUri);
    List<OfflineMethodModel>? offlineMethodList;
    if(response.statusCode == 200) {
      offlineMethodList = [];
      response.body.forEach((method) {
        OfflineMethodModel offlineMethod = OfflineMethodModel.fromJson(method);
        offlineMethodList!.add(offlineMethod);
      });
    }
    log('offlineMethodList: ${offlineMethodList?.length}');
    return offlineMethodList;
  }

  @override
  Future<ResponseModel> saveOfflineInfo(String data) async{
    Response response = await apiClient.postData(AppConstants.makeCollectedCashPaymentUriOffline, jsonDecode(data));
    if(response.statusCode == 200){
      return ResponseModel(true, response.body.toString());
    }else{
      return ResponseModel(false, response.statusText);
    }

  }

  @override
  Future<Response> getOfflineList() async{
    return await apiClient.getData(AppConstants.offlineMethodVendorListUri);
  }

}