import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/wallet_payment_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:sixam_mart_store/features/payment/domain/models/withdraw_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/offline_method_model.dart';

abstract class PaymentServiceInterface {
  Future<bool> updateBankInfo(Map<String, dynamic> body);
  Future<List<WithdrawModel>?> getWithdrawList();
  Future<bool> requestWithdraw(Map<String?, String> data);
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList();
  Future<List<Transactions>?> getWalletPaymentList();
  Future<bool> makeWalletAdjustment();
  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName);
  double pendingWithdraw(List<WithdrawModel>? withdrawList);
  double withdrawn(List<WithdrawModel>? withdrawList);
  Future<List<OfflineMethodModel>?> getOfflineMethodList();
  Future<ResponseModel> saveOfflineInfo(String data);
  Future<Response> getOfflineList();
}