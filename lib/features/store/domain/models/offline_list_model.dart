import 'dart:convert';

class OfflineListModel {
  int? id;
  PaymentInfoModel? paymentInfo;
  String? status;
  String? note;
  List<MethodFields?>? methodFields;
  String? createdAt;
  String? updatedAt;
  int? storeId;
  double? amount;
  String? type;

  OfflineListModel(
      {this.id,
        this.paymentInfo,
        this.status,
        this.note,
        this.methodFields,
        this.createdAt,
        this.updatedAt,
        this.storeId,
        this.amount,
        this.type});

  OfflineListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['payment_info'] != null){
      paymentInfo = PaymentInfoModel.fromJson(jsonDecode(json['payment_info']));
    }
    status = json['status'];
    note = json['note'];
    if (json['method_fields'] != null) {
      methodFields = [];
      List<dynamic> methodFieldsJson = jsonDecode(json['method_fields']);
      for (var json in methodFieldsJson) {
        methodFields?.add(MethodFields.fromJson(json));
      }
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storeId = json['store_id'];
    amount = json['amount'].toDouble();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_info'] = paymentInfo;
    data['status'] = status;
    data['note'] = note;
    data['method_fields'] = methodFields;
    if (methodFields != null) {
      data['method_fields'] = methodFields!.map((v) => v?.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['store_id'] = storeId;
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }

}

class PaymentInfoModel {
  String? methodId;
  String? methodName;
  String? name;
  String? date;
  String? transactionId;

  PaymentInfoModel(
      {this.methodId,
        this.methodName,
        this.name,
        this.date,
        this.transactionId});

  PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    methodId = json['method_id'];
    methodName = json['method_name'];
    name = json['name'];
    date = json['date'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method_id'] = methodId;
    data['method_name'] = methodName;
    data['name'] = name;
    data['date'] = date;
    data['transaction_id'] = transactionId;
    return data;
  }
}

class MethodFields {
  String? inputName;
  String? inputData;

  MethodFields({this.inputName, this.inputData});

  MethodFields.fromJson(Map<String, dynamic> json) {
    inputName = json['input_name'];
    inputData = json['input_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_name'] = inputName;
    data['input_data'] = inputData;
    return data;
  }
}