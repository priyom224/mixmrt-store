class WidthDrawMethodModel {
  int? id;
  String? methodName;
  List<MethodFieldsModel>? methodFields;
  int? isDefault;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  WidthDrawMethodModel({
    this.id,
    this.methodName,
    this.methodFields,
    this.isDefault,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  WidthDrawMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    if (json['method_fields'] != null) {
      methodFields = <MethodFieldsModel>[];
      json['method_fields'].forEach((v) {
        methodFields!.add(MethodFieldsModel.fromJson(v));
      });
    }
    isDefault = json['is_default'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['method_name'] = methodName;
    if (methodFields != null) {
      data['method_fields'] = methodFields!.map((v) => v.toJson()).toList();
    }
    data['is_default'] = isDefault;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MethodFieldsModel {
  String? inputType;
  String? inputName;
  String? placeholder;
  int? isRequired;
  String? value;

  MethodFieldsModel({this.inputType, this.inputName, this.placeholder, this.isRequired, this.value});

  MethodFieldsModel.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    inputName = json['input_name'];
    placeholder = json['placeholder'];
    isRequired = json['is_required'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input_type'] = inputType;
    data['input_name'] = inputName;
    data['placeholder'] = placeholder;
    data['is_required'] = isRequired;
    data['value'] = value;
    return data;
  }
}