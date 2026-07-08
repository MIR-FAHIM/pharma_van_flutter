class CheckoutSuccessResponse {
  final String? status;
  final String? message;
  final List<CheckoutSuccessOrder>? data;

  CheckoutSuccessResponse({
     this.status,
     this.message,
     this.data,
  });

  bool get isSuccess => status!.toLowerCase() == 'success';

  int get totalOrders => data!.length;

  num get grandTotal {
    return data!.fold<num>(0, (sum, order) => sum + order.total);
  }

  num get grandSubtotal {
    return data!.fold<num>(0, (sum, order) => sum + order.subtotal);
  }

  num get grandShippingFee {
    return data!.fold<num>(0, (sum, order) => sum + order.shippingFee);
  }

  num get grandDiscount {
    return data!.fold<num>(0, (sum, order) => sum + order.discount);
  }

  String get firstOrderNumber {
    if (data!.isEmpty) return '';
    return data!.first.orderNumber;
  }

  factory CheckoutSuccessResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
          .map((e) => CheckoutSuccessOrder.fromJson(
        Map<String, dynamic>.from(e),
      ))
          .toList()
          : <CheckoutSuccessOrder>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class CheckoutSuccessOrder {
  final int id;
  final String userId;
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
  final List<CheckoutSuccessItem> items;

  CheckoutSuccessOrder({
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
  });

  factory CheckoutSuccessOrder.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessOrder(
      id: _toInt(json['id']),
      userId: json['user_id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      shippingAddress: json['shipping_address']?.toString() ?? '',
      zone: json['zone']?.toString() ?? '',
      district: json['district']?.toString(),
      area: json['area']?.toString(),
      lat: json['lat']?.toString(),
      lon: json['lon']?.toString(),
      subtotal: _toNum(json['subtotal']),
      shippingFee: _toNum(json['shipping_fee']),
      discount: _toNum(json['discount']),
      total: _toNum(json['total']),
      note: json['note']?.toString() ?? '',
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      items: json['items'] is List
          ? (json['items'] as List)
          .map((e) => CheckoutSuccessItem.fromJson(
        Map<String, dynamic>.from(e),
      ))
          .toList()
          : <CheckoutSuccessItem>[],
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
    };
  }
}

class CheckoutSuccessItem {
  final int id;
  final int orderId;
  final int productId;
  final int shopId;
  final String productName;
  final String? sku;
  final num unitPrice;
  final int qty;
  final num lineTotal;
  final String status;
  final int isSettleWithSeller;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CheckoutSuccessItem({
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
  });

  factory CheckoutSuccessItem.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      shopId: _toInt(json['shop_id']),
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      unitPrice: _toNum(json['unit_price']),
      qty: _toInt(json['qty']),
      lineTotal: _toNum(json['line_total']),
      status: json['status']?.toString() ?? '',
      isSettleWithSeller: _toInt(json['is_settle_with_seller']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
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
  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}