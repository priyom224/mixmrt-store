import 'dart:convert';

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
  String? businessPlan;
  String? packageId;
  List<String>? pickUpZoneIds;
  int? isForResubmit;
  int? storePreviousId;
  int? vendorPreviousId;

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
    this.registerNo,
    this.businessPlan,
    this.packageId,
    this.pickUpZoneIds,
    this.isForResubmit,
    this.storePreviousId,
    this.vendorPreviousId,
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
    businessPlan = json['business_plan'];
    packageId = json['package_id'];
    if (json['pickup_zone_id'] != null) {
      pickUpZoneIds = json['pickup_zone_id'].cast<String>();
    }
    isForResubmit = json['is_for_resubmit'];
    storePreviousId = json['store_previous_id'];
    vendorPreviousId = json['vendor_previous_id'];
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
    data['business_plan'] = businessPlan ?? '';
    data['package_id'] = packageId!;
    if (pickUpZoneIds != null) {
      data['pickup_zone_id'] = json.encode(pickUpZoneIds);
    }
    data['is_for_resubmit'] = isForResubmit.toString();
    data['store_previous_id'] = storePreviousId.toString();
    data['vendor_previous_id'] = vendorPreviousId.toString();
    return data;
  }
}