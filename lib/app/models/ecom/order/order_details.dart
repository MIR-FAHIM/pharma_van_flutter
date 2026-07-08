import 'dart:convert';

OrderDetailsResponse orderDetailsResponseFromJson(String str) {
  return OrderDetailsResponse.fromJson(json.decode(str));
}

String orderDetailsResponseToJson(OrderDetailsResponse data) {
  return json.encode(data.toJson());
}

class OrderDetailsResponse {
  final String status;
  final String message;
  final OrderDetailsData? data;

  OrderDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] == null
          ? null
          : OrderDetailsData.fromJson(
        Map<String, dynamic>.from(json['data']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class OrderDetailsData {
  final int id;
  final int userId;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final String zone;
  final String? district;
  final String? area;
  final String? lat;
  final String? lon;
  final num subtotal;
  final num shippingFee;
  final num discount;
  final num total;
  final String note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderDetailsItem> items;
  final OrderDeliveryAssignment? deliveryMan;

  OrderDetailsData({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.zone,
    required this.district,
    required this.area,
    required this.lat,
    required this.lon,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.deliveryMan,
  });

  bool get hasDeliveryMan {
    return deliveryMan?.deliveryMan != null;
  }

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      orderNumber: json['order_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      shippingAddress: json['shipping_address']?.toString() ?? '',
      zone: json['zone']?.toString() ?? '',
      district: _toNullableString(json['district']),
      area: _toNullableString(json['area']),
      lat: _toNullableString(json['lat']),
      lon: _toNullableString(json['lon']),
      subtotal: _toNum(json['subtotal']),
      shippingFee: _toNum(json['shipping_fee']),
      discount: _toNum(json['discount']),
      total: _toNum(json['total']),
      note: json['note']?.toString() ?? '',
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      items: json['items'] is List
          ? (json['items'] as List)
          .map(
            (e) => OrderDetailsItem.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList()
          : <OrderDetailsItem>[],
      deliveryMan: json['delivery_man'] == null
          ? null
          : OrderDeliveryAssignment.fromJson(
        Map<String, dynamic>.from(json['delivery_man']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'status': status,
      'payment_status': paymentStatus,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'shipping_address': shippingAddress,
      'zone': zone,
      'district': district,
      'area': area,
      'lat': lat,
      'lon': lon,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'discount': discount,
      'total': total,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'delivery_man': deliveryMan?.toJson(),
    };
  }
}

class OrderDetailsItem {
  final int id;
  final int orderId;
  final int productId;
  final int? shopId;
  final String productName;
  final String? sku;
  final num unitPrice;
  final int qty;
  final num lineTotal;
  final String status;
  final int isSettleWithSeller;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic shop;

  OrderDetailsItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.sku,
    required this.unitPrice,
    required this.qty,
    required this.lineTotal,
    required this.status,
    required this.isSettleWithSeller,
    required this.createdAt,
    required this.updatedAt,
    required this.shop,
  });

  factory OrderDetailsItem.fromJson(Map<String, dynamic> json) {
    return OrderDetailsItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      shopId: json['shop_id'] == null ? null : _toInt(json['shop_id']),
      productName: json['product_name']?.toString() ?? '',
      sku: _toNullableString(json['sku']),
      unitPrice: _toNum(json['unit_price']),
      qty: _toInt(json['qty']),
      lineTotal: _toNum(json['line_total']),
      status: json['status']?.toString() ?? '',
      isSettleWithSeller: _toInt(json['is_settle_with_seller']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      shop: json['shop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'shop_id': shopId,
      'product_name': productName,
      'sku': sku,
      'unit_price': unitPrice,
      'qty': qty,
      'line_total': lineTotal,
      'status': status,
      'is_settle_with_seller': isSettleWithSeller,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'shop': shop,
    };
  }
}

class OrderDeliveryAssignment {
  final int id;
  final int deliveryManId;
  final int orderId;
  final String status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DeliveryManUser? deliveryMan;

  OrderDeliveryAssignment({
    required this.id,
    required this.deliveryManId,
    required this.orderId,
    required this.status,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryMan,
  });

  factory OrderDeliveryAssignment.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryAssignment(
      id: _toInt(json['id']),
      deliveryManId: _toInt(json['delivery_man_id']),
      orderId: _toInt(json['order_id']),
      status: json['status']?.toString() ?? '',
      note: _toNullableString(json['note']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      deliveryMan: json['delivery_man'] == null
          ? null
          : DeliveryManUser.fromJson(
        Map<String, dynamic>.from(json['delivery_man']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_man_id': deliveryManId,
      'order_id': orderId,
      'status': status,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'delivery_man': deliveryMan?.toJson(),
    };
  }
}

class DeliveryManUser {
  final int id;
  final dynamic referredBy;
  final dynamic provider;
  final dynamic providerId;
  final String userType;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? deviceToken;
  final String? avatar;
  final String? avatarOriginal;
  final String address;
  final String country;
  final String state;
  final String city;
  final String? postalCode;
  final String phone;
  final num balance;
  final int banned;
  final String? referralCode;
  final dynamic customerPackageId;
  final int remainingUploads;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeliveryManUser({
    required this.id,
    required this.referredBy,
    required this.provider,
    required this.providerId,
    required this.userType,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.deviceToken,
    required this.avatar,
    required this.avatarOriginal,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.balance,
    required this.banned,
    required this.referralCode,
    required this.customerPackageId,
    required this.remainingUploads,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryManUser.fromJson(Map<String, dynamic> json) {
    return DeliveryManUser(
      id: _toInt(json['id']),
      referredBy: json['referred_by'],
      provider: json['provider'],
      providerId: json['provider_id'],
      userType: json['user_type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      emailVerifiedAt: _toDate(json['email_verified_at']),
      deviceToken: _toNullableString(json['device_token']),
      avatar: _toNullableString(json['avatar']),
      avatarOriginal: _toNullableString(json['avatar_original']),
      address: json['address']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postalCode: _toNullableString(json['postal_code']),
      phone: json['phone']?.toString() ?? '',
      balance: _toNum(json['balance']),
      banned: _toInt(json['banned']),
      referralCode: _toNullableString(json['referral_code']),
      customerPackageId: json['customer_package_id'],
      remainingUploads: _toInt(json['remaining_uploads']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referred_by': referredBy,
      'provider': provider,
      'provider_id': providerId,
      'user_type': userType,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'device_token': deviceToken,
      'avatar': avatar,
      'avatar_original': avatarOriginal,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'postal_code': postalCode,
      'phone': phone,
      'balance': balance,
      'banned': banned,
      'referral_code': referralCode,
      'customer_package_id': customerPackageId,
      'remaining_uploads': remainingUploads,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

num _toNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  return num.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String? _toNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }

  return text;
}