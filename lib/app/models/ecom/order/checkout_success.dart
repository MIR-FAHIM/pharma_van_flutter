class CheckoutSuccessResponse {
  final String? status;
  final String? message;
  final CheckoutSuccessData? checkoutData;

  CheckoutSuccessResponse({
    this.status,
    this.message,
    this.checkoutData,
  });

  factory CheckoutSuccessResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      checkoutData: _parseCheckoutData(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': checkoutData?.toJson(),
    };
  }

  bool get isSuccess {
    return status?.toLowerCase().trim() == 'success';
  }

  /*
    Compatibility getter for your current CheckoutSuccessView.

    Your UI uses:
    checkout.data!.isEmpty
    checkout.data!.first
    checkout.data![index]
  */
  List<CheckoutSuccessOrder>? get data {
    return checkoutData?.orders ?? [];
  }

  String get paymentGroupId {
    return checkoutData?.paymentGroupId ?? '';
  }

  List<int> get orderIds {
    return checkoutData?.orderIds ?? [];
  }

  int get totalOrders {
    return checkoutData?.totalOrders ?? data?.length ?? 0;
  }

  double get grandSubtotal {
    if (checkoutData?.subtotal != null) {
      return checkoutData!.subtotal!;
    }

    return data?.fold<double>(
      0,
          (sum, order) => sum + (order.subtotal),
    ) ??
        0;
  }

  double get grandShippingFee {
    if (checkoutData?.shippingFee != null) {
      return checkoutData!.shippingFee!;
    }

    return data?.fold<double>(
      0,
          (sum, order) => sum + (order.shippingFee),
    ) ??
        0;
  }

  double get grandDiscount {
    return data?.fold<double>(
      0,
          (sum, order) => sum + (order.discount),
    ) ??
        0;
  }

  double get grandTotal {
    if (checkoutData?.totalPayable != null) {
      return checkoutData!.totalPayable!;
    }

    return data?.fold<double>(
      0,
          (sum, order) => sum + (order.total),
    ) ??
        0;
  }

  CheckoutSms? get sms {
    return checkoutData?.sms;
  }

  static CheckoutSuccessData? _parseCheckoutData(dynamic rawData) {
    if (rawData == null) return null;

    if (rawData is Map<String, dynamic>) {
      return CheckoutSuccessData.fromJson(rawData);
    }

    if (rawData is Map) {
      return CheckoutSuccessData.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    }

    /*
      Fallback for old response format where data was directly a list.
    */
    if (rawData is List) {
      return CheckoutSuccessData(
        orders: rawData
            .whereType<Map>()
            .map(
              (item) => CheckoutSuccessOrder.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList(),
      );
    }

    return null;
  }
}

class CheckoutSuccessData {
  final String? paymentGroupId;
  final List<int> orderIds;
  final int? totalOrders;

  final double? subtotal;
  final double? shippingFee;
  final double? totalPayable;

  final CheckoutSms? sms;
  final List<CheckoutSuccessOrder> orders;

  CheckoutSuccessData({
    this.paymentGroupId,
    this.orderIds = const [],
    this.totalOrders,
    this.subtotal,
    this.shippingFee,
    this.totalPayable,
    this.sms,
    this.orders = const [],
  });

  factory CheckoutSuccessData.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessData(
      paymentGroupId: json['payment_group_id']?.toString(),
      orderIds: json['order_ids'] is List
          ? (json['order_ids'] as List)
          .map((item) => _toInt(item))
          .whereType<int>()
          .toList()
          : [],
      totalOrders: _toInt(json['total_orders']),
      subtotal: _toDouble(json['subtotal']),
      shippingFee: _toDouble(json['shipping_fee']),
      totalPayable: _toDouble(json['total_payable']),
      sms: json['sms'] is Map
          ? CheckoutSms.fromJson(
        Map<String, dynamic>.from(json['sms']),
      )
          : null,
      orders: json['orders'] is List
          ? (json['orders'] as List)
          .whereType<Map>()
          .map(
            (item) => CheckoutSuccessOrder.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_group_id': paymentGroupId,
      'order_ids': orderIds,
      'total_orders': totalOrders,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'total_payable': totalPayable,
      'sms': sms?.toJson(),
      'orders': orders.map((item) => item.toJson()).toList(),
    };
  }
}

class CheckoutSms {
  final String? status;
  final String? message;
  final String? receiver;

  CheckoutSms({
    this.status,
    this.message,
    this.receiver,
  });

  factory CheckoutSms.fromJson(Map<String, dynamic> json) {
    return CheckoutSms(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      receiver: json['receiver']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'receiver': receiver,
    };
  }

  bool get isSuccess {
    return status?.toLowerCase().trim() == 'success';
  }
}

class CheckoutSuccessOrder {
  final int? userId;
  final String? orderNumber;
  final String? paymentGroupId;
  final String? statusValue;
  final String? paymentStatusValue;

  final String? customerNameValue;
  final String? customerPhoneValue;
  final String? shippingAddressValue;

  final String? zoneValue;
  final String? district;
  final int? userAddressId;
  final String? area;
  final double? lat;
  final double? lon;

  final double? subtotalValue;
  final double? shippingFeeValue;
  final double? discountValue;
  final double? totalValue;

  final String? noteValue;
  final String? platform;

  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  final List<CheckoutSuccessItem> items;

  CheckoutSuccessOrder({
    this.userId,
    this.orderNumber,
    this.paymentGroupId,
    this.statusValue,
    this.paymentStatusValue,
    this.customerNameValue,
    this.customerPhoneValue,
    this.shippingAddressValue,
    this.zoneValue,
    this.district,
    this.userAddressId,
    this.area,
    this.lat,
    this.lon,
    this.subtotalValue,
    this.shippingFeeValue,
    this.discountValue,
    this.totalValue,
    this.noteValue,
    this.platform,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.items = const [],
  });

  factory CheckoutSuccessOrder.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessOrder(
      userId: _toInt(json['user_id']),
      orderNumber: json['order_number']?.toString(),
      paymentGroupId: json['payment_group_id']?.toString(),
      statusValue: json['status']?.toString(),
      paymentStatusValue: json['payment_status']?.toString(),
      customerNameValue: json['customer_name']?.toString(),
      customerPhoneValue: json['customer_phone']?.toString(),
      shippingAddressValue: json['shipping_address']?.toString(),
      zoneValue: json['zone']?.toString(),
      district: json['district']?.toString(),
      userAddressId: _toInt(json['user_address_id']),
      area: json['area']?.toString(),
      lat: _toDouble(json['lat']),
      lon: _toDouble(json['lon']),
      subtotalValue: _toDouble(json['subtotal']),
      shippingFeeValue: _toDouble(json['shipping_fee']),
      discountValue: _toDouble(json['discount']),
      totalValue: _toDouble(json['total']),
      noteValue: json['note']?.toString(),
      platform: json['platform']?.toString(),
      updatedAt: _toDateTime(json['updated_at']),
      createdAt: _toDateTime(json['created_at']),
      id: _toInt(json['id']),
      items: json['items'] is List
          ? (json['items'] as List)
          .whereType<Map>()
          .map(
            (item) => CheckoutSuccessItem.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'order_number': orderNumber,
      'payment_group_id': paymentGroupId,
      'status': statusValue,
      'payment_status': paymentStatusValue,
      'customer_name': customerNameValue,
      'customer_phone': customerPhoneValue,
      'shipping_address': shippingAddressValue,
      'zone': zoneValue,
      'district': district,
      'user_address_id': userAddressId,
      'area': area,
      'lat': lat,
      'lon': lon,
      'subtotal': subtotalValue,
      'shipping_fee': shippingFeeValue,
      'discount': discountValue,
      'total': totalValue,
      'note': noteValue,
      'platform': platform,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  /*
    Safe getters for your current UI.
    Your CheckoutSuccessView uses non-null String and num values.
  */

  String get orderNumberText {
    return orderNumber ?? '';
  }

  String get status {
    return statusValue ?? '';
  }

  String get paymentStatus {
    return paymentStatusValue ?? '';
  }

  String get customerName {
    return customerNameValue ?? '';
  }

  String get customerPhone {
    return customerPhoneValue ?? '';
  }

  String get shippingAddress {
    return shippingAddressValue ?? '';
  }

  String get zone {
    final value = zoneValue ?? '';

    if (value == '[object Object]') return '';

    return value;
  }

  String get note {
    return noteValue ?? '';
  }

  double get subtotal {
    return subtotalValue ?? 0;
  }

  double get shippingFee {
    return shippingFeeValue ?? 0;
  }

  double get discount {
    return discountValue ?? 0;
  }

  double get total {
    return totalValue ?? 0;
  }

  /*
    This getter keeps your existing UI working because your page uses:
    order.orderNumber
  */
  String get orderNumberSafe {
    return orderNumber ?? '';
  }
}

class CheckoutSuccessItem {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? shopId;

  final String? productNameValue;
  final String? sku;

  final double? unitPriceValue;
  final int? qtyValue;
  final double? lineTotalValue;

  final String? statusValue;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CheckoutSuccessItem({
    this.id,
    this.orderId,
    this.productId,
    this.shopId,
    this.productNameValue,
    this.sku,
    this.unitPriceValue,
    this.qtyValue,
    this.lineTotalValue,
    this.statusValue,
    this.createdAt,
    this.updatedAt,
  });

  factory CheckoutSuccessItem.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      shopId: _toInt(json['shop_id']),
      productNameValue: json['product_name']?.toString(),
      sku: json['sku']?.toString(),
      unitPriceValue: _toDouble(json['unit_price']),
      qtyValue: _toInt(json['qty']),
      lineTotalValue: _toDouble(json['line_total']),
      statusValue: json['status']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'shop_id': shopId,
      'product_name': productNameValue,
      'sku': sku,
      'unit_price': unitPriceValue,
      'qty': qtyValue,
      'line_total': lineTotalValue,
      'status': statusValue,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get productName {
    return productNameValue ?? '';
  }

  double get unitPrice {
    return unitPriceValue ?? 0;
  }

  int get qty {
    return qtyValue ?? 0;
  }

  double get lineTotal {
    return lineTotalValue ?? 0;
  }

  String get status {
    return statusValue ?? '';
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();

  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();

  return double.tryParse(value.toString());
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  final String text = value.toString().trim();

  if (text.isEmpty) return null;

  return DateTime.tryParse(text);
}