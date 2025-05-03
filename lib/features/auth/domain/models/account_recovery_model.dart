import 'dart:convert';

class AccountRecoveryModel {
  List<Errors>? errors;
  Vendor? vendor;
  Stores? store;

  AccountRecoveryModel({this.errors, this.vendor, this.store});

  AccountRecoveryModel.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    store = json['store'] != null ? Stores.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class Errors {
  String? code;
  String? message;

  Errors({this.code, this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Vendor {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? holderName;
  String? accountNo;
  String? image;
  int? status;
  String? firebaseToken;
  String? imageFullUrl;
  List<Stores>? stores;

  Vendor({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.bankName,
    this.branch,
    this.holderName,
    this.accountNo,
    this.image,
    this.status,
    this.firebaseToken,
    this.imageFullUrl,
    this.stores,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    image = json['image'];
    status = json['status'];
    firebaseToken = json['firebase_token'];
    imageFullUrl = json['image_full_url'];
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['image'] = image;
    data['status'] = status;
    data['firebase_token'] = firebaseToken;
    data['image_full_url'] = imageFullUrl;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logo;
  String? latitude;
  String? longitude;
  String? address;
  String? footerText;
  int? minimumOrder;
  double? comission;
  bool? scheduleOrder;
  int? status;
  int? vendorId;
  String? createdAt;
  String? updatedAt;
  bool? freeDelivery;
  List<int>? rating;
  String? coverPhoto;
  bool? delivery;
  bool? takeAway;
  bool? itemSection;
  int? tax;
  int? zoneId;
  bool? reviewsSection;
  bool? active;
  String? offDay;
  int? selfDeliverySystem;
  bool? posSystem;
  int? minimumShippingCharge;
  String? deliveryTime;
  int? veg;
  int? nonVeg;
  int? orderCount;
  int? totalOrder;
  int? moduleId;
  int? orderPlaceToScheduleInterval;
  int? featured;
  int? perKmShippingCharge;
  bool? prescriptionOrder;
  String? slug;
  String? taxId;
  String? registerNo;
  String? taxDocument;
  int? perKgCharge;
  int? selfParcelDelivery;
  String? storeType;
  String? registrationDocument;
  String? storeBusinessModel;
  String? reason;
  int? packageId;
  List<String>? pickupZoneId;
  bool? gstStatus;
  String? gstCode;
  String? logoFullUrl;
  String? coverPhotoFullUrl;
  String? taxDocumentFullUrl;
  String? registrationDocumentFullUrl;
  String? metaImageFullUrl;
  List<AccTranslations>? translations;

  Stores({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.logo,
    this.latitude,
    this.longitude,
    this.address,
    this.footerText,
    this.minimumOrder,
    this.comission,
    this.scheduleOrder,
    this.status,
    this.vendorId,
    this.createdAt,
    this.updatedAt,
    this.freeDelivery,
    this.rating,
    this.coverPhoto,
    this.delivery,
    this.takeAway,
    this.itemSection,
    this.tax,
    this.zoneId,
    this.reviewsSection,
    this.active,
    this.offDay,
    this.selfDeliverySystem,
    this.posSystem,
    this.minimumShippingCharge,
    this.deliveryTime,
    this.veg,
    this.nonVeg,
    this.orderCount,
    this.totalOrder,
    this.moduleId,
    this.orderPlaceToScheduleInterval,
    this.featured,
    this.perKmShippingCharge,
    this.prescriptionOrder,
    this.slug,
    this.taxId,
    this.registerNo,
    this.taxDocument,
    this.perKgCharge,
    this.selfParcelDelivery,
    this.storeType,
    this.registrationDocument,
    this.storeBusinessModel,
    this.reason,
    this.packageId,
    this.pickupZoneId,
    this.gstStatus,
    this.gstCode,
    this.logoFullUrl,
    this.coverPhotoFullUrl,
    this.taxDocumentFullUrl,
    this.registrationDocumentFullUrl,
    this.metaImageFullUrl,
    this.translations,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    footerText = json['footer_text'];
    minimumOrder = json['minimum_order'];
    comission = json['comission'];
    scheduleOrder = json['schedule_order'];
    status = json['status'];
    vendorId = json['vendor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    rating = json['rating'].cast<int>();
    coverPhoto = json['cover_photo'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    itemSection = json['item_section'];
    tax = json['tax'];
    zoneId = json['zone_id'];
    reviewsSection = json['reviews_section'];
    active = json['active'];
    offDay = json['off_day'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    minimumShippingCharge = json['minimum_shipping_charge'];
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    orderCount = json['order_count'];
    totalOrder = json['total_order'];
    moduleId = json['module_id'];
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    featured = json['featured'];
    perKmShippingCharge = json['per_km_shipping_charge'];
    prescriptionOrder = json['prescription_order'];
    slug = json['slug'];
    taxId = json['tax_id'];
    registerNo = json['register_no'];
    taxDocument = json['tax_document'];
    perKgCharge = json['per_kg_charge'];
    selfParcelDelivery = json['self_parcel_delivery'];
    storeType = json['store_type'];
    registrationDocument = json['registration_document'];
    storeBusinessModel = json['store_business_model'];
    reason = json['reason'];
    packageId = json['package_id'];
    List<dynamic> parsedList = jsonDecode(json['pickup_zone_id']);
    pickupZoneId = json['pickup_zone_id'] != null ? parsedList.map((e) => e.toString()).toList() : [];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    logoFullUrl = json['logo_full_url'];
    coverPhotoFullUrl = json['cover_photo_full_url'];
    taxDocumentFullUrl = json['tax_document_full_url'];
    registrationDocumentFullUrl = json['registration_document_full_url'];
    metaImageFullUrl = json['meta_image_full_url'];
    if (json['translations'] != null) {
      translations = <AccTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(AccTranslations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['footer_text'] = footerText;
    data['minimum_order'] = minimumOrder;
    data['comission'] = comission;
    data['schedule_order'] = scheduleOrder;
    data['status'] = status;
    data['vendor_id'] = vendorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['rating'] = rating;
    data['cover_photo'] = coverPhoto;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['item_section'] = itemSection;
    data['tax'] = tax;
    data['zone_id'] = zoneId;
    data['reviews_section'] = reviewsSection;
    data['active'] = active;
    data['off_day'] = offDay;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['delivery_time'] = deliveryTime;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['order_count'] = orderCount;
    data['total_order'] = totalOrder;
    data['module_id'] = moduleId;
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    data['featured'] = featured;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['prescription_order'] = prescriptionOrder;
    data['slug'] = slug;
    data['tax_id'] = taxId;
    data['register_no'] = registerNo;
    data['tax_document'] = taxDocument;
    data['per_kg_charge'] = perKgCharge;
    data['self_parcel_delivery'] = selfParcelDelivery;
    data['store_type'] = storeType;
    data['registration_document'] = registrationDocument;
    data['store_business_model'] = storeBusinessModel;
    data['reason'] = reason;
    data['package_id'] = packageId;
    data['pickup_zone_id'] = pickupZoneId;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['logo_full_url'] = logoFullUrl;
    data['cover_photo_full_url'] = coverPhotoFullUrl;
    data['tax_document_full_url'] = taxDocumentFullUrl;
    data['registration_document_full_url'] = registrationDocumentFullUrl;
    data['meta_image_full_url'] = metaImageFullUrl;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccTranslations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  AccTranslations({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  AccTranslations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
