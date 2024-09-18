import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/offline_method_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class PaymentRepositoryInterface implements RepositoryInterface {
  Future<dynamic> requestWithdraw(Map<String?, String> data);
  Future<dynamic> getWithdrawMethodList();
  Future<dynamic> getWalletPaymentList();
  Future<dynamic> makeWalletAdjustment();
  Future<dynamic> makeCollectCashPayment(double amount, String paymentGatewayName);
  Future<List<OfflineMethodModel>?> getOfflineMethodList();
  Future<ResponseModel> saveOfflineInfo(String data);
  Future<Response> getOfflineList();
}