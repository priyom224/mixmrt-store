class StoreBodyModel {
  String? translation;
  String? tax;
  String? minDeliveryTime;
  String? maxDeliveryTime;
  String? lat;
  String? lng;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? zoneId;
  String? moduleId;
  String? deliveryTimeType;
  String? taxID;
  String? registerNo;

  StoreBodyModel({
    this.translation,
    this.tax,
    this.minDeliveryTime,
    this.maxDeliveryTime,
    this.lat,
    this.lng,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.password,
    this.zoneId,
    this.moduleId,
    this.deliveryTimeType,
    this.taxID,
    this.registerNo
  });

  StoreBodyModel.fromJson(Map<String, dynamic> json) {
    translation = json['translations'];
    tax = json['tax'];
    minDeliveryTime = json['min_delivery_time'];
    maxDeliveryTime = json['max_delivery_time'];
    lat = json['lat'];
    lng = json['lng'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    deliveryTimeType = json['delivery_time_type'];
    taxID = json['tax_id'];
    registerNo = json['register_no'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['translations'] = translation!;
    data['tax'] = tax!;
    data['minimum_delivery_time'] = minDeliveryTime!;
    data['maximum_delivery_time'] = maxDeliveryTime!;
    data['latitude'] = lat!;
    data['longitude'] = lng!;
    data['f_name'] = fName!;
    data['l_name'] = lName!;
    data['phone'] = phone!;
    data['email'] = email!;
    data['password'] = password!;
    data['zone_id'] = zoneId!;
    data['module_id'] = moduleId!;
    data['delivery_time_type'] = deliveryTimeType!;
    data['tax_id'] = taxID!;
    data['register_no'] = registerNo!;
    return data;
  }
}